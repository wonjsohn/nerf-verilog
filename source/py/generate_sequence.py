from numpy import *

def gen(T = [0.0, 0.1, 0.9, 1.0], L = [0.0, 0.0, 200.0, 200.0], SAMPLING_RATE = 1024):
   """ f = 1.0 # in Hz, continuous freq
   T = 1.0 # Total time in sec
   BIAS = 1.0
   AMP = 0.2
   """    
   dt = 1.0 / SAMPLING_RATE # Sampling interval in seconds

   len_x = int(T[-1] * SAMPLING_RATE) + 1
   #x = zeros(len_x)
   x = []
   N = [int(t / dt) for t in T]
   print N

   for n1, l1, n2, l2 in zip(N[0:-1], L[0:-1], N[1:], L[1:]):
       n_seg = n2 - n1;
       x = x + ([l1 + i*(l2-l1)/n_seg for i in xrange(n_seg)])

   ## x_up =
   ## x_down = [L1 + 2*(max_n - i)*(L2-L1)/max_n for i in xrange(max_n) if i >= max_n / 2]

   return x


if __name__ == '__main__':
   from pylab import *
   x = gen()
   plot(x)
   show()
   print "len_x = %d" % len(x)
