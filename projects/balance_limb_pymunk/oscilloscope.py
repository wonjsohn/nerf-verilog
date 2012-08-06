"""
Simple function plotter for Python with Pygame.

Demos:
    plot.py -curvedemo       (cos, sin, polynomial)
    plot.py -complexdemo     (Mandelbrot set)

Use the mouse buttons and keyboard arrows to zoom and pan. Use keys 1-8
in the complex demo to select iteration depth for the Mandelbrot set.
Magical keys: a (show axes), g (show grid), e (show coordinates / 
refresh), h (reset view).

By Fredrik Johansson, http://fredrikj.net
"""

from pygame import *
from pygame.constants import *
from random import randint, random

import math
import sys

# -----------------------------------------------------------------
#
# Miscellaneous utilities
#
class Quit(Exception):
    pass

def frange(start, stop=None, step=1.0):
    """Identical to xrange, but for floating-point values"""
    start, step = float(start), float(step)
    if step == 0.0:
        raise ValueError, "frange() step argument must not be zero"
    if stop is None: start, stop = 0.0, start
    i = 1
    value = start
    if step > 0.0: cond = lambda: value < stop
    else:          cond = lambda: value > stop
    while cond():
        yield value
        value = start + step * i
        i += 1

def prog_chunks(width, steps=5):
    """Generate drawing chunks for progressive rendering. Returns
    (starting position, span, index) tuples. First blocks of width 2**steps are
    drawn, then 2**(steps-1), and so on until (including) width 1."""
    steps = [2**n for n in range(steps)][::-1]
    m = max(steps)
    counter = iter(xrange(width))
    for b in steps:
        for x in xrange(b%m, width, b):
            if b == m or x % (b+b):
                yield x, b, counter.next()


# -----------------------------------------------------------------
#
# Coloring
#

from colorsys import hsv_to_rgb

class Dummy: pass
palettes = Dummy()
colors = Dummy()

# Basic colors
colors.black  = 0,   0,   0
colors.red    = 255, 0,   0
colors.green  = 64,  176, 64
colors.orange = 255, 144, 0
colors.cyan   = 0,   128, 255
colors.blue   = 0,   0,   255
colors.purple = 176, 0,   255
colors.white  = 255, 255, 255

# Palettes
def huerange(start=0.0, stop=1.0, steps=256):
    r = frange(start, stop, (stop-start)/steps)
    c = [hsv_to_rgb(t, 1.0, 1.0) for t in r]
    return [(int(a*255), int(b*255), int(c*255)) for (a, b, c) in c]

palettes.rainbow = huerange(0.0, 1.0, 256)
palettes.fire    = (huerange(0.0, 0.156, 64) + huerange(0.156, 0.0, 64)) * 2
palettes.discrete = ([colors.blue, colors.red, colors.orange, \
                     colors.green, colors.cyan, colors.purple] * 100)[:256]

def safe(f):
    def foof(x):
        try:
            a = f(x)
            return a
        except:
            return 0
    return foof

def mkcol(ft):  return palettes.rainbow[min(255, max(0, int(abs(ft))))]
def mkcol2(ft): return palettes.rainbow[int(abs(ft)) % 256]

def color_abs (z, palette): pass
def color_real(z, palette): pass
def color_imag(z, palette): pass


# -----------------------------------------------------------------
#
# Plotters
#

class Plot:
    """Base class, inherited by the simple and complex plotters"""

    def __init__(self):
        self.default_colors = palettes.discrete
        self.enabled = [False] * 10
        self.show_infobox = True
        self.show_grid = True
        self.show_axes = True

    def init_display(self, w=None, h=None):
        """Initialize video"""
        self.WIDTH = w or 400
        self.HEIGHT = h or 400
        self.xmin, self.xmax = -10.0, 10.0
        self.ymin, self.ymax = -10.0, 10.0

        font.init()
        self.font = font.SysFont("arial", 12)
        display.init()
        self.screen = display.set_mode((self.WIDTH, self.HEIGHT), 0, 32)
        self.register_view_update()

    def handle_input(self):
        """Check keyboard, mouse and system events and update
        state accordingly."""

        plotkeys = [K_1, K_2, K_3, K_4, K_5, K_6, K_7, K_8, K_9]

        events = event.get()
        for ev in events:
            if ev.type == QUIT:
                raise Quit
            elif ev.type == KEYDOWN:
                k = ev.key
                if   k == K_e: self.show_infobox ^= True
                elif k == K_g: self.show_grid    ^= True
                elif k == K_a: self.show_axes    ^= True
                elif k in plotkeys:
                    i = plotkeys.index(k)
                    self.enabled = [False] * 10
                    self.enabled[i] = True
                if k in [K_e, K_g, K_a] or k in plotkeys:
                    self.force_redraw = True

        pressed = key.get_pressed()
        if pressed[K_ESCAPE]:
            raise Quit

        # Keyboard panning & position adjustment
        if   pressed[K_LEFT]:   self.pan(x=-0.02)
        elif pressed[K_RIGHT]:  self.pan(x= 0.02)
        if   pressed[K_UP]:     self.pan(y= 0.02)
        elif pressed[K_DOWN]:   self.pan(y=-0.02)

        if pressed[K_HOME] or pressed[K_h]: self.home()

        # Mouse zooming
        b1, b2, b3 = mouse.get_pressed()
        mx, my = mouse.get_pos()
        if   b1: self.zoom(0.95, self.sx2fx(mx), self.sy2fy(my))
        elif b3: self.zoom(1.05, self.sx2fx(self.WIDTH - mx),
                                 self.sy2fy(self.HEIGHT - my))


    # -----------------------------------------------------------------
    #
    # Screen/function space translation
    #

    def register_view_update(self):
        """Update some helper attributes. This must be called each time
        xmin, xmax, ymin or ymax are modified."""
        self.rwidth = self.xmax - self.xmin
        self.rheight = self.ymax - self.ymin
        self.normwidth = self.rwidth / self.WIDTH
        self.normheight = self.rheight / self.HEIGHT
        self.sorigin = (self.fx2sx(0), self.fy2sy(0))
        self.force_redraw = True
        display.set_caption("Plot: %g, %g to %g, %g" % \
            (self.xmin, self.ymin, self.xmax, self.ymax))

    def sx2fx(self, x):
        """Translate an x coordinate from screen space to function space"""
        return self.xmin + float(x)*self.normwidth

    def sy2fy(self, y):
        """Translate an y coordinate from screen space to function space"""
        return self.ymin + float(self.HEIGHT-y)*self.normheight

    def fx2sx(self, x):
        """Translate an x coordinate from function space to screen space"""
        return (float(x)-self.xmin) / self.normwidth

    def fy2sy(self, y):
        """Translate an y coordinate from function space to screen space"""
        return self.HEIGHT - (float(y)-self.ymin)/self.normheight

    def fx_visible(self, x):
        """Is the function space x coordinate on the screen?"""
        return self.xmin <= x < self.xmax

    def fy_visible(self, y):
        """Is the function space y coordinate on the screen?"""
        return self.ymin <= y < self.ymax


    # -----------------------------------------------------------------
    #
    # Changing the view
    #

    def zoom(self, factor, x, y):
        """Zoom by a relative factor, centered on the function space
        coordinates (x, y). If the factor is in the interval (0, 1),
        the view will be zoomed in. If the factor is in the interval
        (1, infinity), the view will be zoomed out. The function
        returns True if the state was changed, otherwise False."""
        assert factor > 0

        # Do nothing if scale is 1.0 or off the chart
        if (factor > 1.0 and (self.xmax - self.xmin) > 1e+200) or \
           (factor < 1.0 and (self.xmax - self.xmin) < 1e-12) or \
            factor == 1.0:
            return False

        self.xmin = x - (x - self.xmin) * factor
        self.xmax = x + (self.xmax - x) * factor
        self.ymin = y - (y - self.ymin) * factor
        self.ymax = y + (self.ymax - y) * factor
        self.register_view_update()

    def pan(self, x=0.0, y=0.0):
        """Pan the view. The x and y values are given relative to the
        current view size. For example, x=0.02 scrolls right by 2% of
        the current screen size (and x=-0.02 scrolls left)."""
        xs = self.rwidth * x
        ys = self.rheight * y
        self.xmin += xs
        self.xmax += xs
        self.ymin += ys
        self.ymax += ys
        self.register_view_update()

    def home(self):
        """Zoom and pan "home", so that the view is centered around the
        origin and the zoom level is normal."""
        self.xmin = self.ymin = -10.0
        self.xmax = self.ymax = 10.0
        self.register_view_update()


    # -----------------------------------------------------------------
    #
    # Grid drawing
    #

    def make_grid(self, surface=None, maxlines=20):
        """Draw a grid"""
        screen = surface or Surface((self.WIDTH, self.HEIGHT))
        if self.show_grid:
            self.draw_subgrids(screen, maxlines)
        if self.show_axes:
            self.mark_integers(screen)
            self.draw_axes(screen)
        return screen

    def extreme_multiples(self, scale):
        """Find the range of multiples of the given scale
        that are currently visible on the screen"""
        xmin = self.xmin - (self.xmin % scale) + scale
        xmax = self.xmax - (self.xmax % scale) + scale
        ymin = self.ymin - (self.ymin % scale) + scale
        ymax = self.ymax - (self.ymax % scale) + scale
        return xmin, xmax, ymin, ymax

    def draw_subgrid(self, surface, scale, color):
        """Draw a grid such that all lines are distanced with 'scale'
        from each other, and aligned at multiples of 'scale'."""
        ixmin, ixmax, iymin, iymax = self.extreme_multiples(scale)
        for x in frange(ixmin, ixmax, scale):
            sx = int(round(self.fx2sx(x)))
            draw.line(surface, color, (sx, 0), (sx, self.HEIGHT))
        for y in frange(iymin, iymax, scale):
            sy = int(round(self.fy2sy(y)))
            draw.line(surface, color, (0, sy), (self.WIDTH, sy))

    def draw_subgrids(self, surface=None, maxlines=20):
        """Draw multiple subgrids, appropriately scaled relative
        to the current screen size."""

        screen = surface or self.screen
        factor = 10.0    # n of subdivisions of each grid interval
        maxlines = float(maxlines) # draw grids with less than this many lines on screen
        darkest = 216.0
        light_scale = (255.0 - darkest) / maxlines

        # Function space width of top grid line distance
        step = self.sx2fx(self.WIDTH / maxlines) - self.sx2fx(0)
        # Adjust to nearest power of 'factor'
        step = factor**round(math.log(step, factor))

        while step < self.rwidth:
            c = min(255, int(darkest + (self.rwidth*light_scale)/step))
            self.draw_subgrid(screen, step, (c, c, c))
            step *= factor

    def mark_integers(self, surface=None):
        """Mark integer positions on axes"""

        screen = surface or self.screen
        fx2sx = self.fx2sx
        fy2sy = self.fy2sy

        # Pixel distance between marks; too tight?
        d = fx2sx(1.0) - fx2sx(0.0)
        if d < 5:
            return

        # Fade color to white when approaching visibility limit
        color = (max(96, 96 + int((10 - d) * (144.0 / 5.0))), ) * 3
        ixmin, ixmax, iymin, iymax = self.extreme_multiples(1.0)
        ox, oy = self.sorigin

        # Draw marks on x axis
        if self.fy_visible(0.0):
            for x in frange(ixmin, ixmax, 1.0):
                sx = int(round(fx2sx(x)))
                draw.line(screen, color, (sx, oy-4), (sx, oy+4))

        # Draw marks on y axis
        if self.fx_visible(0.0):
            for y in frange(iymin, iymax, 1.0):
                sy = int(round(fy2sy(y)))
                draw.line(screen, color, (ox-4, sy), (ox+4, sy))

    def draw_axes(self, surface=None, color=(96, 96, 96)):
        """Draw axes through the origin"""
        surface = surface or self.screen
        ox, oy = self.sorigin
        if self.fx_visible(0): draw.line(surface, color, (ox, 0), (ox, self.HEIGHT))
        if self.fy_visible(0): draw.line(surface, color, (0, oy), (self.WIDTH, oy))

    def draw_infobox(self):
        mx, my = mouse.get_pos()
        mx = self.sx2fx(mx)
        my = self.sy2fy(my)
        draw.rect(self.screen, (255, 255, 128), Rect(2, 2, 120, 40), 0)
        draw.rect(self.screen, (255, 192, 96),  Rect(2, 2, 120, 40), 1)
        self.screen.blit(self.font.render("x: %g" % mx, True, colors.black), (8, 4))
        self.screen.blit(self.font.render("y: %g" % my, True, colors.black), (8, 20))


class ComplexPlot(Plot):
    """Complex plane color plot"""

    def __init__(self):
        Plot.__init__(self)
        self.show_grid = False
        self.show_axes = False
        self.plots = []

    def add(self, func, color=None):
        self.plots.append((func, color or self.default_colors[len(self.plots)]))

    def plot_blocks(self, f, blocksize=32):
        self.screen.lock()
        yrange = [(y, self.sy2fy(y)) for y in range(0, self.HEIGHT, blocksize)]
        for sx in xrange(0, self.WIDTH, blocksize):
            rx = self.sx2fx(sx)
            for sy, fy in yrange:
                c = f(complex(rx, fy))
                draw.rect(self.screen, c, Rect(sx, sy, blocksize, blocksize), 0)
        self.screen.unlock()

    def plot_column(self, f, sx, w, yrange):
        self.screen.lock()
        fx = self.sx2fx(sx)

        if w == 1:
            for sy, fy in yrange:
                self.screen.set_at((sx, sy), f(complex(fx, fy)))
        else:
            for sy, fy in yrange:
                draw.line(self.screen, f(complex(fx, fy)), (sx, sy), (sx+w-1, sy))

        self.screen.unlock()

    def display(self, w=None, h=None):
        self.init_display(w, h)
        yrange = [(y, self.sy2fy(y)) for y in range(0, self.HEIGHT)]
        ge = prog_chunks(self.WIDTH)
        gl = list(ge)
        gli = 0
        self.enabled[0] = True
        try:
            while True:
                self.handle_input()
                if self.force_redraw:
                    yrange = [(y, self.sy2fy(y)) for y in range(0, self.HEIGHT)]
                    for i, (func, color) in enumerate(self.plots):
                        if self.enabled[i]:
                            self.plot_blocks(func)
                    self.force_redraw = False
                    gli = 0
                self.make_grid(self.screen, maxlines=10.0)
                display.flip()
                if gli < len(gl):
                    x, w, c = gl[gli]
                    gli += 1
                    for i, (func, color) in enumerate(self.plots):
                        if self.enabled[i]:
                            self.plot_column(self.plots[i][0], x, w, yrange)
        except Quit:
            return



class CurvePlot(Plot):
    """Plot y = f(x) in the Cartesian plane"""

    def __init__(self):
        Plot.__init__(self)
        self.plots = []

    def add(self, func, color=None):
        self.plots.append((func, color or self.default_colors[len(self.plots)]))

    def display(self, w=None, h=None):
        """Run loop listening to input, redrawing the curves
        when the view is changed, until a Quit exception is raised."""
        self.init_display(w, h)
        try:
            while True:
                self.handle_input()
                if self.force_redraw:
                    self.screen.fill((255, 255, 255))
                    self.make_grid(self.screen, maxlines=100.0)
                    for func, color in self.plots:
                        self.draw_curve(func, color)
                    self.force_redraw = False
                if self.show_infobox:
                    self.draw_infobox()
                display.flip()
        except Quit:
            pass

    def draw_curve(self, function, color):
        step = 2
        smaxy = sys.maxint
        sminy = ~sys.maxint
        pinf = 1e10000
        ninv = -pinf

        # Improve performance by avoiding attribute lookups
        sx2fx = self.sx2fx
        fy2sy = self.fy2sy
        drawline = draw.line
        screen = self.screen
        prev = None
        exceptions = (ArithmeticError, ValueError)
        for sx1 in xrange(0, self.WIDTH, step):
            sx2 = sx1 + step
            rx1 = sx2fx(sx1)
            rx2 = sx2fx(sx2)
            try:
                if prev is None:
                    ry1 = function(rx1)
                else:
                    ry1 = prev
                ry2 = function(rx2)
                sy1 = fy2sy(ry1)
                sy2 = fy2sy(ry2)
            # f(x) is invalid at this point
            except exceptions:
                prev = None
                continue
            if sminy < sy1 < smaxy and sminy < sy2 < smaxy:
                drawline(screen, color, (sx1, int(round(sy1))), (sx2, int(round(sy2))))


import math

try:
    import psyco
    psyco.full()
except ImportError:
    pass

if __name__ == "__main__":
    if "-curvedemo" in sys.argv:
        p = CurvePlot()
        p.add(math.cos)
        p.add(math.sin)
        p.add(lambda x: -1.6*x**4 + x**3 + 3*x**2 + x)
        p.display(w=400, h=400)
    elif "-complexdemo" in sys.argv:
        def mandelbrot(iterations, palette=palettes.rainbow):
            itrange = range(iterations)
            palette = palette
            def mandel(z):
                a = z
                abs_ = abs
                pal = palette
                for n in itrange:
                    if abs_(z) > 2:
                        return pal[n & 0xff]
                    z = z*z + a
                return (0, 0, 0)
            return mandel
        p = ComplexPlot()
        for n in [40, 128, 256, 512, 1024, 2048, 4096, 8192]:
            p.add(mandelbrot(n))
        p.display(w=400, h=400)
    else:
        print __doc__
