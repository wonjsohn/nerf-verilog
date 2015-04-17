from numpy import *
from scipy.signal import butter, filtfilt

def gen(L = [0.0, 0.0, 200.0, 200.0], SAMPLING_RATE = 1024, FILT = False):
   """ f = 1.0 # in Hz, continuous freq
   T = 1.0 # Total time in sec
   BIAS = 1.0
   AMP = 0.2
   """    
   dt = 1.0 / SAMPLING_RATE # Sampling interval in seconds

#   T = [dt*i for i in xrange(1024)]  #  1024 time regular timestamps in 1 second.
   T = [dt*i for i in xrange(2048)]  #  2048 time regular timestamps in 2 second.

   len_x = int(T[-1] * SAMPLING_RATE) + 1
   #x = zeros(len_x)
   x = []
   N = [int(t / dt) for t in T]

   for n1, l1, n2, l2 in zip(N[0:-1], L[0:-1], N[1:], L[1:]):
       n_seg = n2 - n1;
       x = x + ([l1 + i*(l2-l1)/n_seg for i in xrange(n_seg)])

   # ensure the list size to be 1024. just extending the last value
#   if len(x) < SAMPLING_RATE:  
#	tail= x[len(x)-1] 
#	#tail = x(len(x))
#	for i in xrange(SAMPLING_RATE-len(x)):
#		x.append(tail) 

   if len(x) < SAMPLING_RATE*2:  # modified for victor's input

	tail= x[len(x)-1] 
	#tail = x(len(x))
	for i in xrange(SAMPLING_RATE*2-len(x)):
		x.append(tail) 

   print len_x	

   if (FILT):
      b, a = butter(N=3, Wn=2*pi*10/SAMPLING_RATE , btype='low', analog=0, output='ba')
      x = filtfilt(b=b, a=a, x=x)
#
#   x.extend(x) # repeat 2 times in 2 seconds
   return x



if __name__ == '__main__':
   from pylab import *
   j1List=[]
   j2List=[]
   for line in open('/home/eric/wonjoon_codes/matlab_wjsohn/posAllData.txt',  "r").readlines(): 
   	j1 ,  j2,  j3,  j4,  j5,  j6= line.split('\t')
        j1 = float(j1)
        j2 = float(j2)
        j1List.append(j1)   #joint1
        j2List.append(j2)   #joint2
    
   print j1List
   x = gen(L=j1List,  FILT = False)
   #x = gen(T =  [0.0, 0.06, 0.07,  0.24,  0.26,  0.43,  0.44,  0.5, 0.5,  0.56, 0.57,  0.74,  0.76,  0.93,  0.94,  1.0],\
   #         L = [0.0,  0.0,  1.0,  1.0,  -1.0,  -1.0,  0.0,  0.0,  0.0,  0.0,  -1.0,  -1.0,  1.0,  1.0,  0.0,  0.0], FILT = True)
   plot(x)
   show()
   print "len_x = %d" % len(x)
