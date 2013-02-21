import pygame
from pygame.locals import *
from pygame.color import *
import pymunk
from pymunk import Vec2d
import math, sys, random
from Utilities import *

def to_pygame(p):
    """Small hack to convert pymunk to pygame coordinates"""
    return int(p.x), int(-p.y+600)

def main():
    pygame.init()
    screen = pygame.display.set_mode((600, 600))
    clock = pygame.time.Clock()
    running = True

    ### Physics stuff
    space = pymunk.Space(50)
    space.gravity = (0.0, -9.8 * 0.0)

    ### walls
    static_body = pymunk.Body()

    fp = [(20,-20), (-120, 0), (20,20)]
    mass = 1.52
    moment = pymunk.moment_for_poly(mass, fp)

    # left flipper
    #forearm_body = pymunk.Body(mass, moment)
    forearm_body = pymunk.Body(mass, 0.0372)
    forearm_body.position = 300, 300
    forearm_shape = pymunk.Poly(forearm_body, [(-x,y) for x,y in fp])
    space.add(forearm_body, forearm_shape)

    elbot_joint_body = pymunk.Body()
    elbot_joint_body.position = forearm_body.position
    j = pymunk.PinJoint(forearm_body, elbot_joint_body, (0,0), (0,0))
    JOINT_DAMPING_SCHEIDT2007 = 2.1
    s = pymunk.DampedRotarySpring(forearm_body, elbot_joint_body, -0.0, 0.0, JOINT_DAMPING_SCHEIDT2007)
    space.add(j, s)

    forearm_shape.group = 1
    forearm_shape.elasticity = 0.4

    while running:
        
        force0 = max(0.0, xem0.ReadFPGA(0x30, "float32")) / 128
        force1 = max(0.0, xem1.ReadFPGA(0x30, "float32")) / 128
        forearm_body.torque = (force0-force1) * -0.015
        
        #lce = 1.0
                             
        angle = ((forearm_body.angle + M_PI) % (2*M_PI)) - M_PI
        rest_len = 1.01
        lce0 = angle / (2*M_PI) * 0.5 + rest_len
        lce1 = 2.0 * rest_len - lce0
        
        # Send lce0 &lce1
        bitVal = ConvertType(lce0, fromType = 'f', toType = 'I')
        xem0.SendPara(bitVal = bitVal, trigEvent = 8)
        bitVal = ConvertType(lce1, fromType = 'f', toType = 'I')
        xem1.SendPara(bitVal = bitVal, trigEvent = 8)
        print "lce0 = %.2f :: lce1 = %.2f :: total_torque = %.2f" % (lce0, lce1, forearm_body.torque)                            
        print "force0 = %.2f :: force1 = %.2f" % (force0, force1)                            

        
        #r_flipper_body.apply_impulse(Vec2d.unit() * 40000, (force * 20,0))
        
        for event in pygame.event.get():
            if event.type == QUIT:
                running = False
            elif event.type == KEYDOWN and event.key == K_ESCAPE:
                running = False
            elif event.type == KEYDOWN and event.key == K_j:
                forearm_body.torque += 80.0
                pass
            elif event.type == KEYDOWN and event.key == K_f:
                #forearm_body.apply_force(Vec2d.unit() * -40000, (-100,0))
                forearm_body.torque -= 80.0

        ### Clear screen
        screen.fill(THECOLORS["white"])

        ### Draw stuff
        for f in [forearm_shape,]:
            ps = f.get_points()
            ps.append(ps[0])
            ps = map(to_pygame, ps)

            color = THECOLORS["red"]
            pygame.draw.lines(screen, color, False, ps)
        #if abs(flipper_body.angle) < 0.001: flipper_body.angle = 0

        ### Update physics
        dt = 1.0/60.0/5.
        for x in range(5):
            space.step(dt)

        ### Flip screen
        pygame.display.flip()
        clock.tick(50)
        pygame.display.set_caption("fps: " + str(clock.get_fps()))

if __name__ == '__main__':
    import sys
    sys.path.append('../../source/py/')
    from Fpga import Model   
    
    xem0 = Model(board=0)
    xem1 = Model(board=1)

    value = 10
    newHalfCnt = 1 * 200 * (10 **6) / SAMPLING_RATE / NUM_NEURON / (value*2) / 2 / 2
    xem0.SendPara(bitVal = newHalfCnt, trigEvent = DATA_EVT_CLKRATE)
    xem1.SendPara(bitVal = newHalfCnt, trigEvent = DATA_EVT_CLKRATE)
    
    bitVal = ConvertType(20.0, fromType = 'f', toType = 'I')
    xem0.SendPara(bitVal = bitVal, trigEvent = 1)
    xem1.SendPara(bitVal = bitVal, trigEvent = 1)
    
    sys.exit(main())
