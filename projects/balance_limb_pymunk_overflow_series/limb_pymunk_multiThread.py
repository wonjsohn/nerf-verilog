import pygame
from pygame.locals import *
from pygame.color import *
import pymunk
from pymunk import Vec2d
import math, sys, random
from pylab import *

M_PI = 3.1415926
JOINT_MIN = -1.2
JOINT_MAX = 1.2
JOINT_RANGE = JOINT_MAX - JOINT_MIN 

JOINT_DAMPING_SCHEIDT2007 = 2.1
JOINT_DAMPING = JOINT_DAMPING_SCHEIDT2007 * 0.2 #was 0.1


class armSetup:
    def __init__(self):
        pygame.init()
        self.screen = pygame.display.set_mode((700, 700))
        self.gClock = pygame.time.Clock()
        self.running = True
    
        ### Physics stuff
        self.gSpace = pymunk.Space(50)
        self.gSpace.gravity = (0.0, -9.8 * 0.0)

        ### walls
        static_body = pymunk.Body()

#        fp = [(20,-20), (-120, 0), (20,20)]
        fp_index = [(40, -5), (30, -15),  (20,-20),   (-150, -10), (-150,  10), (20,20),  (30,  15),  (40,  5)]
#        fp = [(-40, -5), (-30, -15),  (-20,-20),   (150, -10), (150,  10), (-20,20),  (-30,  15),  (-40,  5)]

        
 
        """ index finger"""
        
        mass = 1.52 # was 1.52
        moment = pymunk.moment_for_poly(mass, fp_index)

        # left flipper
        #gForearm_body = pymunk.Body(mass, moment_of_inertia)
        self.gForearm_body = pymunk.Body(mass, 0.0372)
        self.gForearm_body.position = 300, 300
        self.gForearm_shape = pymunk.Poly(self.gForearm_body, [(-x,y) for x,y in fp_index])
        
#        self.gForearm_shape.friction = 10.0
        self.gSpace.add(self.gForearm_body, self.gForearm_shape)

        self.gElbow_joint_body = pymunk.Body()
        self.gElbow_joint_body.position = self.gForearm_body.position
        j1 = pymunk.PivotJoint(self.gForearm_body,  self.gElbow_joint_body, (0,0), (0,0))
#        self.gElbow_joint_body.shape = pymunk.Circle(self.gElbow_joint_body, 250)
        
    #    j = pymunk.PinJoint(forearm_body, gElbow_joint_body, (0,0), (0,0))
        j = pymunk.RotaryLimitJoint(self.gForearm_body, self.gElbow_joint_body, JOINT_MIN, JOINT_MAX)

        pymunk.collision_slop = 0
        s = pymunk.DampedRotarySpring(a=self.gForearm_body, b=self.gElbow_joint_body, rest_angle=-0.0, stiffness=0.0, damping=JOINT_DAMPING)
        self.gSpace.add(j,  j1,  s) # 
        
        
        """ middle finger"""
#        
        fp_middle = [(x,  y)for x, y in fp_index]

        mass = 1.52 # was 1.52
        moment = pymunk.moment_for_poly(mass, fp_middle)
#
        # left flipper
        #gForearm_body = pymunk.Body(mass, moment_of_inertia)
        self.gForearm_body_middle = pymunk.Body(mass, 0.0372)
        self.gForearm_body_middle.position = 280, 250
        self.gForearm_shape_middle = pymunk.Poly(self.gForearm_body_middle, [(-x,y) for x,y in fp_middle])
#        self.gForearm_shape.friction = 10.0
        self.gSpace.add(self.gForearm_body_middle,   self.gForearm_shape_middle)

        self.gElbow_joint_body_middle = pymunk.Body()
        self.gElbow_joint_body_middle.position =  self.gForearm_body_middle.position
        j1_m = pymunk.PinJoint(self.gForearm_body_middle,  self.gElbow_joint_body_middle, (0,0), (0,0))
#        self.gElbow_joint_body_middle.shape = pymunk.Circle(self.gElbow_joint_body_middle, 250)
        
#    #    j = pymunk.PinJoint(forearm_body, gElbow_joint_body, (0,0), (0,0))
        j_m = pymunk.RotaryLimitJoint(self.gForearm_body_middle, self.gElbow_joint_body_middle, JOINT_MIN, JOINT_MAX)
#        
        s_m = pymunk.DampedRotarySpring(a=self.gForearm_body_middle, b=self.gElbow_joint_body_middle, rest_angle=-0.0, stiffness=0.0, damping=JOINT_DAMPING)
        self.gSpace.add(j_m,  j1_m,  s_m) # 
        

        """ wrist (passive spring)"""
#        

        fp_wrist = [(ceil(x/2),  ceil(y/2)) for x, y in fp_index]

        mass = 0.5 # was 1.52
        moment = pymunk.moment_for_poly(mass, fp_wrist)
#
        # left flipper
        #gForearm_body = pymunk.Body(mass, moment_of_inertia)
        self.gForearm_body_wrist = pymunk.Body(mass, 0.0372)
        self.gForearm_body_wrist.position = 280, 250
        self.gForearm_shape_wrist = pymunk.Poly(self.gForearm_body_wrist, [(-x,y) for x,y in fp_wrist])
#        self.gForearm_shape.friction = 10.0
        self.gSpace.add(self.gForearm_body_wrist,   self.gForearm_shape_wrist)

        self.gElbow_joint_body_wrist = pymunk.Body()
        self.gElbow_joint_body_wrist.position =  self.gForearm_body_wrist.position
        j1_w = pymunk.PinJoint(self.gForearm_body_wrist,  self.gElbow_joint_body_wrist, (0,0), (0,0))
#        self.gElbow_joint_body_middle.shape = pymunk.Circle(self.gElbow_joint_body_middle, 250)
        
#    #    j = pymunk.PinJoint(forearm_body, gElbow_joint_body, (0,0), (0,0))
        j_w = pymunk.RotaryLimitJoint(self.gForearm_body_wrist, self.gElbow_joint_body_wrist, JOINT_MIN, JOINT_MAX)
#        
        s_w = pymunk.DampedRotarySpring(a=self.gForearm_body_wrist, b=self.gElbow_joint_body_wrist, rest_angle=-0.0, stiffness=0.05, damping=JOINT_DAMPING)
        self.gSpace.add(j_w,  j1_w,  s_w) # 
        
        """ create arrow """
        arrow_body,arrow_shape = self.create_arrow()
        self.gSpace.add(arrow_shape)
        
        
        """    """
       

        self.gRest_joint_angle = 0.0
        
        self.data_bic = []
        self.data_tri = []
        self.start_time = time.time()
        self.pygame = pygame
        
        """ index finger"""
        self.gForearm_shape.group = 1
        self.gForearm_shape.elasticity = 1.0
        self.force_extensor = 0.0
#        self.lce_bic = 0.0
        self.lce_extensor = 0.0
        self.angle = 0.0
        self.linearV = 0.0
        
        """ middle finger """
        self.gForearm_shape_middle.group = 1
        self.gForearm_shape_middle.elasticity = 1.0
        
        self.force_middle_extensor = 0.0
        self.lce_middle_extensor = 0.0
        self.middle_angle = 0.0
        self.middle_linearV = 0.0
        
        """ wrist  """
        self.gForearm_shape_wrist.group = 1
        self.gForearm_shape_wrist.elasticity = 1.0
        
        self.force_wrist_extensor = 0.0
        self.lce_wrist_extensor = 0.0
        self.wrist_angle = 0.0
        self.wrist_linearV = 0.0

        """ """
        self.record = False
        self.mouseOn = False
        self.scale = 1.0
        self.fmax = 0.0

        self.main()
        


    def to_pygame(self,  p):
        """Small hack to convert pymunk to pygame coordinates"""
        return int(p.x), int(-p.y+600)

    def angle2length(self,  angle):
        max_length = 1.3
        length = max_length + ((2.0-max_length)-max_length) / (3.14)* (angle- JOINT_MIN)      # angle in rad 
        length = 0.3*angle+1     # was: 0.3*angle+1 / angle in rad 
        return length

    def angular2LinearV(self, angularV):
        linearV = angularV * 0.3
        return linearV
    
    def plotData(self,  data_bic,  data_tri):
        from pylab import plot, show, subplot, title
        from scipy.io import savemat, loadmat
        import numpy as np
        import time

        timeTag = time.strftime("%Y%m%d_%H%M%S")
        
        savemat(timeTag+".mat", mdict={'data_bic': data_bic,  'data_tri': data_tri})
    
    
    def create_arrow(self):
        vs = [(-30,0), (0,3), (10,0), (0,-3)]
        mass = 1
        moment = pymunk.moment_for_poly(mass, vs)
        arrow_body = pymunk.Body(mass, moment)
      
        arrow_shape = pymunk.Poly(arrow_body, vs)
        arrow_shape.friction = .5
        arrow_shape.collision_type = 1
        return arrow_body, arrow_shape
  

    def controlLoopIndexFlexor(self,  xem_muscle,  xem_spindle):
        
        while self.running:

            """   Get forces   """
            force_flexor_pre = max(0.0, xem_muscle.ReadFPGA(0x32, "float32")) / 128 #- 0.2
            spikecnt_flexor = xem_muscle.ReadFPGA(0x30, "int32")  
            emg_flexor = xem_muscle.ReadFPGA(0x20, "float32")  # EMG 
            
            """ extra data for close loop data acquisition"""  
#            Ia_afferent = xem_spindle.ReadFPGA(0x22, "float32")  # EMG 
#            II_afferent = xem_spindle.ReadFPGA(0x24, "float32")  # EMG    
#            MN1_spikes = xem_muscle.ReadFPGA(0x22, "spike32")  #             
#            MN2_spikes = xem_muscle.ReadFPGA(0x24, "spike32")  #             
#            MN3_spikes = xem_muscle.ReadFPGA(0x26, "spike32")  #             
#            MN4_spikes = xem_muscle.ReadFPGA(0x28, "spike32")  #             
#            MN5_spikes = xem_muscle.ReadFPGA(0x2A, "spike32")  #             
#            MN6_spikes = xem_muscle.ReadFPGA(0x2C, "spike32")  # 
            
    
            force_flexor = force_flexor_pre #+ pipeInData_bic[j]
            self.gForearm_body.torque = (force_flexor - self.force_extensor) * 0.03 # was 0.06
                                            
            self.angle = ((self.gForearm_body.angle + M_PI) % (2*M_PI)) - M_PI - self.gRest_joint_angle
               
#            lce_extensor = self.angle2length(angle)+ 0.02
            lce_flexor = 2.04 - self.lce_extensor 
            
            # Send lce of biceps 
            bitVal = convertType(lce_flexor, fromType = 'f', toType = 'I')
    #        bitVal2 = convertType(0.0,  fromType = 'f', toType = 'I')
    #        bitVal3 = convertType(sineBic[j],  fromType = 'I', toType = 'I')
            angularV = self.gForearm_body.angular_velocity

            self.linearV = self.angular2LinearV(angularV)
                   
#            self.linearV = 0.0
            self.scale = 30.0 #10.0   # unstable when extra cortical signal is given, 30 is for doornik data collection
            #self.linearV = min(0, self.linearV ) # testing: only vel component in afferent active when lengthing 
            
            bitVal_bic_i = convertType(-self.linearV*self.scale, fromType = 'f', toType = 'I')
#            bitVal_tri_i = convertType(self.linearV*scale, fromType = 'f', toType = 'I')
            
            xem_muscle.SendMultiPara(bitVal1 = bitVal, bitVal2 = bitVal_bic_i,  trigEvent = 9)
            xem_spindle.SendPara(bitVal = bitVal, trigEvent = 9)
                  
       
            #print "lce0 = %.2f :: lce1 = %.2f :: total_torque = %.2f" % (lce_flexor, self.lce_extensor, self.gForearm_body.torque),                           
    #        print "force0 = %.2f :: force1 = %.2f :: angle = %.2f :: gd_bic = %.2f :: angularV =%.2f" % (force_bic, self.force_extensor,  angle,  gd_bic,  angularV )                          
            currentTime = time.time()
            elapsedTime = currentTime- self.start_time
            tempData = elapsedTime,  lce_flexor, self.linearV, spikecnt_flexor, force_flexor, emg_flexor#  MN1_spikes,  MN2_spikes, MN3_spikes,  MN4_spikes,  MN5_spikes, MN6_spikes  
            self.data_bic.append(tempData)
            #r_flipper_body.apply_impulse(Vec2d.unit() * 40000, (force * 20,0))
    #      
#            time.sleep(0.07)
  
            
    def controlLoopIndexExtensor(self,  xem_muscle,  xem_spindle):     
        while self.running:
            """   Get forces   """
#            force_bic_pre = max(0.0, xem_muscle.ReadFPGA(0x32, "float32")) / 128 #- 0.2
#            emg_flexor = xem_muscle.ReadFPGA(0x20, "float32")  # EMG         
            spikecnt_extensor = xem_muscle.ReadFPGA(0x30, "int32")  
            force_extensor_pre = max(0.0, xem_muscle.ReadFPGA(0x32, "float32")) / 128 #- 2.64
            emg_extensor = xem_muscle.ReadFPGA(0x20, "float32")  # EMG
            
#            force_bic = force_bic_pre #+ pipeInData_bic[j]
            self.force_extensor = force_extensor_pre #+ pipeInData_bic[j] 
           
              
            """ extra data for close loop data acquisition"""  
#            Ia_afferent = xem_spindle.ReadFPGA(0x22, "float32")  # EMG 
#            II_afferent = xem_spindle.ReadFPGA(0x24, "float32")  # EMG    
#            MN1_spikes = xem_muscle.ReadFPGA(0x22, "spike32")  #             
#            MN2_spikes = xem_muscle.ReadFPGA(0x24, "spike32")  #             
#            MN3_spikes = xem_muscle.ReadFPGA(0x26, "spike32")  #             
#            MN4_spikes = xem_muscle.ReadFPGA(0x28, "spike32")  #             
#            MN5_spikes = xem_muscle.ReadFPGA(0x2A, "spike32")  #             
#            MN6_spikes = xem_muscle.ReadFPGA(0x2C, "spike32")  # 
###            
            
#            self.gForearm_body.torque = (self.force_bic - self.force_extensor) * 0.06
            #angle = ((self.gForearm_body.angle + M_PI) % (2*M_PI)) - M_PI - self.gRest_joint_angle
         
            self.lce_extensor = self.angle2length(self.angle)+ 0.02
            lce_flexor = 2.04 - self.lce_extensor 
            
            # Send lce of biceps 
            bitVal = convertType(lce_flexor, fromType = 'f', toType = 'I')
    #        bitVal2 = convertType(0.0,  fromType = 'f', toType = 'I')
    #        bitVal3 = convertType(sineBic[j],  fromType = 'I', toType = 'I')
     #        xem_muscle.SendPara(bitVal = bitVal, trigEvent = 9)
#            self.angularV = self.gForearm_body.angular_velocity

#            self.linearV = self.angular2LinearV(angularV)
#            self.scale = 500.0
#            bitVal_bic_i = convertType(-linearV*scale, fromType = 'f', toType = 'I')
            bitVal_tri_i = convertType(self.linearV*self.scale, fromType = 'f', toType = 'I')
            
            """ Send lce of triceps """
            bitVal = convertType(self.lce_extensor, fromType = 'f', toType = 'I')
    #        bitVal2 = convertType(1.0,  fromType = 'f', toType = 'I')
        
    #        bitVal3 = convertType(sineTri[j],  fromType = 'I', toType = 'I')
            xem_muscle.SendMultiPara(bitVal1 = bitVal, bitVal2= bitVal_tri_i,   trigEvent = 9)
            xem_spindle.SendPara(bitVal = bitVal, trigEvent = 9)
          
            
            """ Alpha-gamma coactivation """
    #        gd_tri = force_tri * ag_coact + ag_bias
    #        bitval = convertType(gd_tri, fromType = 'f', toType = 'I')
    #        xem_spindle.SendPara(bitVal = bitval,  trigEvent = 4) # 4 = Gamma_dyn
            
    #        print "lce0 = %.2f :: lce1 = %.2f :: total_torque = %.2f" % (lce_flexor, lce_extensor, gForearm_body.torque),                           
    #        print "force0 = %.2f :: force1 = %.2f :: angle = %.2f :: gd_bic = %.2f :: angularV =%.2f" % (force_bic, self.force_extensor,  angle,  gd_bic,  angularV )                          
            currentTime = time.time()
            elapsedTime = currentTime- self.start_time
            tempData = elapsedTime, self.lce_extensor, self.linearV, spikecnt_extensor,   self.force_extensor,  emg_extensor#,  MN1_spikes, MN2_spikes,  MN3_spikes,  MN4_spikes,  MN5_spikes,  MN6_spikes   
            self.data_tri.append(tempData)
            #r_flipper_body.apply_impulse(Vec2d.unit() * 40000, (force * 20,0))
#            time.sleep(0.07)
  
  

    def controlLoopMiddleFlexor(self,  xem_muscle,  xem_spindle):
        
        while self.running:

            """   Get forces   """
            force_flexor_pre = max(0.0, xem_muscle.ReadFPGA(0x32, "float32")) / 128 #- 0.2
            spikecnt_flexor = xem_muscle.ReadFPGA(0x30, "int32")  
            emg_flexor = xem_muscle.ReadFPGA(0x20, "float32")  # EMG 
            
            """ extra data for close loop data acquisition"""  
#            Ia_afferent = xem_spindle.ReadFPGA(0x22, "float32")  # EMG 
#            II_afferent = xem_spindle.ReadFPGA(0x24, "float32")  # EMG    
#            MN1_spikes = xem_muscle.ReadFPGA(0x22, "spike32")  #             
#            MN2_spikes = xem_muscle.ReadFPGA(0x24, "spike32")  #             
#            MN3_spikes = xem_muscle.ReadFPGA(0x26, "spike32")  #             
#            MN4_spikes = xem_muscle.ReadFPGA(0x28, "spike32")  #             
#            MN5_spikes = xem_muscle.ReadFPGA(0x2A, "spike32")  #             
#            MN6_spikes = xem_muscle.ReadFPGA(0x2C, "spike32")  # 
            
    
            force_flexor = force_flexor_pre #+ pipeInData_bic[j]
            self.gForearm_body_middle.torque = (force_flexor - self.force_middle_extensor) * 0.03 # was 0.06
                                            
            self.middle_angle = ((self.gForearm_body_middle.angle + M_PI) % (2*M_PI)) - M_PI - self.gRest_joint_angle
               
#            lce_extensor = self.angle2length(angle)+ 0.02
            lce_flexor = 2.04 - self.lce_middle_extensor 
            
            # Send lce of biceps 
            bitVal = convertType(lce_flexor, fromType = 'f', toType = 'I')
    #        bitVal2 = convertType(0.0,  fromType = 'f', toType = 'I')
    #        bitVal3 = convertType(sineBic[j],  fromType = 'I', toType = 'I')
            angularV = self.gForearm_body_middle.angular_velocity

            self.middle_linearV = self.angular2LinearV(angularV)
                   
#            self.linearV = 0.0
            self.scale = 30.0 #10.0   # unstable when extra cortical signal is given, 30 is for doornik data collection
            #self.linearV = min(0, self.linearV ) # testing: only vel component in afferent active when lengthing 
            
            bitVal_bic_i = convertType(-self.middle_linearV*self.scale, fromType = 'f', toType = 'I')
#            bitVal_tri_i = convertType(self.linearV*scale, fromType = 'f', toType = 'I')
            
            xem_muscle.SendMultiPara(bitVal1 = bitVal, bitVal2 = bitVal_bic_i,  trigEvent = 9)
            xem_spindle.SendPara(bitVal = bitVal, trigEvent = 9)
                  
       
            #print "lce0 = %.2f :: lce1 = %.2f :: total_torque = %.2f" % (lce_flexor, self.lce_extensor, self.gForearm_body_middle.torque),                           
    #        print "force0 = %.2f :: force1 = %.2f :: angle = %.2f :: gd_bic = %.2f :: angularV =%.2f" % (force_bic, self.force_extensor,  angle,  gd_bic,  angularV )                          
            currentTime = time.time()
            elapsedTime = currentTime- self.start_time
            tempData = elapsedTime,  lce_flexor, self.middle_linearV, spikecnt_flexor, force_flexor, emg_flexor#,  MN1_spikes,  MN2_spikes, MN3_spikes,  MN4_spikes,  MN5_spikes, MN6_spikes  
            self.data_bic.append(tempData)
            #r_flipper_body.apply_impulse(Vec2d.unit() * 40000, (force * 20,0))
    #      
#            time.sleep(0.07)
  
            
    def controlLoopMiddleExtensor(self,  xem_muscle,  xem_spindle):     
        while self.running:
            """   Get forces   """
#            force_bic_pre = max(0.0, xem_muscle.ReadFPGA(0x32, "float32")) / 128 #- 0.2
#            emg_flexor = xem_muscle.ReadFPGA(0x20, "float32")  # EMG         
            spikecnt_extensor = xem_muscle.ReadFPGA(0x30, "int32")  
            force_extensor_pre = max(0.0, xem_muscle.ReadFPGA(0x32, "float32")) / 128 #- 2.64
            emg_extensor = xem_muscle.ReadFPGA(0x20, "float32")  # EMG
            
#            force_bic = force_bic_pre #+ pipeInData_bic[j]
            self.force_middle_extensor = force_extensor_pre #+ pipeInData_bic[j] 
           
              
            """ extra data for close loop data acquisition"""  
#            Ia_afferent = xem_spindle.ReadFPGA(0x22, "float32")  # EMG 
#            II_afferent = xem_spindle.ReadFPGA(0x24, "float32")  # EMG    
#            MN1_spikes = xem_muscle.ReadFPGA(0x22, "spike32")  #             
#            MN2_spikes = xem_muscle.ReadFPGA(0x24, "spike32")  #             
#            MN3_spikes = xem_muscle.ReadFPGA(0x26, "spike32")  #             
#            MN4_spikes = xem_muscle.ReadFPGA(0x28, "spike32")  #             
#            MN5_spikes = xem_muscle.ReadFPGA(0x2A, "spike32")  #             
#            MN6_spikes = xem_muscle.ReadFPGA(0x2C, "spike32")  # 
##            
            
#            self.gForearm_body.torque = (self.force_bic - self.force_extensor) * 0.06
            #angle = ((self.gForearm_body.angle + M_PI) % (2*M_PI)) - M_PI - self.gRest_joint_angle
         
         
            self.lce_middle_extensor = self.angle2length(self.middle_angle)+ 0.02
            lce_flexor = 2.04 - self.lce_middle_extensor 
            
            # Send lce of biceps 
            bitVal = convertType(lce_flexor, fromType = 'f', toType = 'I')
    #        bitVal2 = convertType(0.0,  fromType = 'f', toType = 'I')
    #        bitVal3 = convertType(sineBic[j],  fromType = 'I', toType = 'I')
     #        xem_muscle.SendPara(bitVal = bitVal, trigEvent = 9)
#            self.angularV = self.gForearm_body.angular_velocity

#            self.linearV = self.angular2LinearV(angularV)
#            self.scale = 500.0
#            bitVal_bic_i = convertType(-linearV*scale, fromType = 'f', toType = 'I')
            bitVal_tri_i = convertType(self.middle_linearV*self.scale, fromType = 'f', toType = 'I')
            
            """ Send lce of triceps """
            bitVal = convertType(self.lce_middle_extensor, fromType = 'f', toType = 'I')
    #        bitVal2 = convertType(1.0,  fromType = 'f', toType = 'I')
        
    #        bitVal3 = convertType(sineTri[j],  fromType = 'I', toType = 'I')
            xem_muscle.SendMultiPara(bitVal1 = bitVal, bitVal2= bitVal_tri_i,   trigEvent = 9)
            xem_spindle.SendPara(bitVal = bitVal, trigEvent = 9)
          
            
            """ Alpha-gamma coactivation """
    #        gd_tri = force_tri * ag_coact + ag_bias
    #        bitval = convertType(gd_tri, fromType = 'f', toType = 'I')
    #        xem_spindle.SendPara(bitVal = bitval,  trigEvent = 4) # 4 = Gamma_dyn
            
    #        print "lce0 = %.2f :: lce1 = %.2f :: total_torque = %.2f" % (lce_flexor, lce_extensor, gForearm_body.torque),                           
    #        print "force0 = %.2f :: force1 = %.2f :: angle = %.2f :: gd_bic = %.2f :: angularV =%.2f" % (force_bic, self.force_extensor,  angle,  gd_bic,  angularV )                          
            currentTime = time.time()
            elapsedTime = currentTime- self.start_time
            tempData = elapsedTime, self.lce_middle_extensor, self.middle_linearV, spikecnt_extensor,   self.force_extensor,  emg_extensor#,  MN1_spikes, MN2_spikes,  MN3_spikes,  MN4_spikes,  MN5_spikes,  MN6_spikes   
            self.data_tri.append(tempData)
            #r_flipper_body.apply_impulse(Vec2d.unit() * 40000, (force * 20,0))
#            time.sleep(0.07)
    
    def controlLoopWristFlexor(self,  xem_muscle,  xem_spindle):
        
        while self.running:

            """   Get forces   """
            force_flexor_pre = max(0.0, xem_muscle.ReadFPGA(0x32, "float32")) / 128 #- 0.2
            spikecnt_flexor = xem_muscle.ReadFPGA(0x30, "int32")  
            emg_flexor = xem_muscle.ReadFPGA(0x20, "float32")  # EMG 
            
            """ extra data for close loop data acquisition"""  
#            Ia_afferent = xem_spindle.ReadFPGA(0x22, "float32")  # EMG 
#            II_afferent = xem_spindle.ReadFPGA(0x24, "float32")  # EMG    
#            MN1_spikes = xem_muscle.ReadFPGA(0x22, "spike32")  #             
#            MN2_spikes = xem_muscle.ReadFPGA(0x24, "spike32")  #             
#            MN3_spikes = xem_muscle.ReadFPGA(0x26, "spike32")  #             
#            MN4_spikes = xem_muscle.ReadFPGA(0x28, "spike32")  #             
#            MN5_spikes = xem_muscle.ReadFPGA(0x2A, "spike32")  #             
#            MN6_spikes = xem_muscle.ReadFPGA(0x2C, "spike32")  # 
            
    
            force_flexor = force_flexor_pre * 3 #+ pipeInData_bic[j]
            self.gForearm_body_wrist.torque = (force_flexor - self.force_wrist_extensor) * 0.03 # was 0.06
                                            
            self.wrist_angle = ((self.gForearm_body_wrist.angle + M_PI) % (2*M_PI)) - M_PI - self.gRest_joint_angle
               
#            lce_extensor = self.angle2length(angle)+ 0.02
            lce_flexor = 2.04 - self.lce_wrist_extensor 
            
            # Send lce of biceps 
            bitVal = convertType(lce_flexor, fromType = 'f', toType = 'I')
    #        bitVal2 = convertType(0.0,  fromType = 'f', toType = 'I')
    #        bitVal3 = convertType(sineBic[j],  fromType = 'I', toType = 'I')
            angularV = self.gForearm_body_wrist.angular_velocity

            self.wrist_linearV = self.angular2LinearV(angularV)
                   
#            self.linearV = 0.0
            self.scale = 30.0 #10.0   # unstable when extra cortical signal is given, 30 is for doornik data collection
            #self.linearV = min(0, self.linearV ) # testing: only vel component in afferent active when lengthing 
            
            bitVal_bic_i = convertType(-self.wrist_linearV*self.scale, fromType = 'f', toType = 'I')
#            bitVal_tri_i = convertType(self.linearV*scale, fromType = 'f', toType = 'I')
            
#            xem_muscle.SendMultiPara(bitVal1 = bitVal, bitVal2 = bitVal_bic_i,  trigEvent = 9)
#            xem_spindle.SendPara(bitVal = bitVal, trigEvent = 9)
                  
       
            #print "lce0 = %.2f :: lce1 = %.2f :: total_torque = %.2f" % (lce_flexor, self.lce_extensor, self.gForearm_body_middle.torque),                           
    #        print "force0 = %.2f :: force1 = %.2f :: angle = %.2f :: gd_bic = %.2f :: angularV =%.2f" % (force_bic, self.force_extensor,  angle,  gd_bic,  angularV )                          
            currentTime = time.time()
            elapsedTime = currentTime- self.start_time
            tempData = elapsedTime,  lce_flexor, self.wrist_linearV, spikecnt_flexor, force_flexor, emg_flexor#,  MN1_spikes,  MN2_spikes, MN3_spikes,  MN4_spikes,  MN5_spikes, MN6_spikes  
            self.data_bic.append(tempData)
            #r_flipper_body.apply_impulse(Vec2d.unit() * 40000, (force * 20,0))
    #      
#            time.sleep(0.07)

    def controlLoopWristExtensor(self,  xem_muscle,  xem_spindle):     
        while self.running:
            """   Get forces   """
#            force_bic_pre = max(0.0, xem_muscle.ReadFPGA(0x32, "float32")) / 128 #- 0.2
#            emg_flexor = xem_muscle.ReadFPGA(0x20, "float32")  # EMG         
            spikecnt_extensor = xem_muscle.ReadFPGA(0x30, "int32")  
            force_extensor_pre = max(0.0, xem_muscle.ReadFPGA(0x32, "float32")) / 128 #- 2.64
            emg_extensor = xem_muscle.ReadFPGA(0x20, "float32")  # EMG
            
#            force_bic = force_bic_pre #+ pipeInData_bic[j]
            self.force_wrist_extensor = force_extensor_pre * 3#+ pipeInData_bic[j] 
           
              
            """ extra data for close loop data acquisition"""  
#            Ia_afferent = xem_spindle.ReadFPGA(0x22, "float32")  # EMG 
#            II_afferent = xem_spindle.ReadFPGA(0x24, "float32")  # EMG    
#            MN1_spikes = xem_muscle.ReadFPGA(0x22, "spike32")  #             
#            MN2_spikes = xem_muscle.ReadFPGA(0x24, "spike32")  #             
#            MN3_spikes = xem_muscle.ReadFPGA(0x26, "spike32")  #             
#            MN4_spikes = xem_muscle.ReadFPGA(0x28, "spike32")  #             
#            MN5_spikes = xem_muscle.ReadFPGA(0x2A, "spike32")  #             
#            MN6_spikes = xem_muscle.ReadFPGA(0x2C, "spike32")  # 
##            
            
#            self.gForearm_body.torque = (self.force_bic - self.force_extensor) * 0.06
            #angle = ((self.gForearm_body.angle + M_PI) % (2*M_PI)) - M_PI - self.gRest_joint_angle
         
         
            self.lce_wrist_extensor = self.angle2length(self.wrist_angle)+ 0.02
            lce_flexor = 2.04 - self.lce_wrist_extensor 
            
            # Send lce of biceps 
            bitVal = convertType(lce_flexor, fromType = 'f', toType = 'I')
    #        bitVal2 = convertType(0.0,  fromType = 'f', toType = 'I')
    #        bitVal3 = convertType(sineBic[j],  fromType = 'I', toType = 'I')
     #        xem_muscle.SendPara(bitVal = bitVal, trigEvent = 9)
#            self.angularV = self.gForearm_body.angular_velocity

#            self.linearV = self.angular2LinearV(angularV)
#            self.scale = 500.0
#            bitVal_bic_i = convertType(-linearV*scale, fromType = 'f', toType = 'I')
            bitVal_tri_i = convertType(self.wrist_linearV*self.scale, fromType = 'f', toType = 'I')
            
            """ Send lce of triceps """
            bitVal = convertType(self.lce_wrist_extensor, fromType = 'f', toType = 'I')
    #        bitVal2 = convertType(1.0,  fromType = 'f', toType = 'I')
        
    #        bitVal3 = convertType(sineTri[j],  fromType = 'I', toType = 'I')
#            xem_muscle.SendMultiPara(bitVal1 = bitVal, bitVal2= bitVal_tri_i,   trigEvent = 9)
#            xem_spindle.SendPara(bitVal = bitVal, trigEvent = 9)
          
            
            """ Alpha-gamma coactivation """
    #        gd_tri = force_tri * ag_coact + ag_bias
    #        bitval = convertType(gd_tri, fromType = 'f', toType = 'I')
    #        xem_spindle.SendPara(bitVal = bitval,  trigEvent = 4) # 4 = Gamma_dyn
            
    #        print "lce0 = %.2f :: lce1 = %.2f :: total_torque = %.2f" % (lce_flexor, lce_extensor, gForearm_body.torque),                           
    #        print "force0 = %.2f :: force1 = %.2f :: angle = %.2f :: gd_bic = %.2f :: angularV =%.2f" % (force_bic, self.force_extensor,  angle,  gd_bic,  angularV )                          
            currentTime = time.time()
            elapsedTime = currentTime- self.start_time
            tempData = elapsedTime, self.lce_wrist_extensor, self.wrist_linearV, spikecnt_extensor,   self.force_extensor#,  emg_extensor,  MN1_spikes, MN2_spikes,  MN3_spikes,  MN4_spikes,  MN5_spikes,  MN6_spikes   
            self.data_tri.append(tempData)
            #r_flipper_body.apply_impulse(Vec2d.unit() * 40000, (force * 20,0))
#            time.sleep(0.07)
    
    def keyControl(self):
        while (self.running):
            """ angle calculated from mouse cursor position"""
            mouse_position = from_pygame( Vec2d(self.pygame.mouse.get_pos()), self.screen )
            forced_angle = (mouse_position-self.gForearm_body.position).angle   # calculate angle with mouse cursor loc. 
        
           
            
            # move the unfired arrow together with the cannon
#            arrow_body.position = cannon_body.position + Vec2d(cannon_shape.radius + 40, 0).rotated(cannon_body.angle)
#            arrow_body.angle = cannon_body.angle
            
#            self.gForearm_body.torque = -0.1 
            """ key control """
            for event in self.pygame.event.get():
                if event.type == QUIT:
                    self.running = False
                elif event.type == KEYDOWN and event.key == K_ESCAPE:
                    self.plotData(self.data_bic, self.data_tri)
                    self.running = False
                elif event.type == KEYDOWN and event.key == K_j:
                    self.gForearm_body.torque -= 14.0
                   
                    
                elif event.type == KEYDOWN and event.key == K_f:
                    #self.gForearm_body.apply_force(Vec2d.unit() * -40000, (-100,0))
                    self.gForearm_body.torque += 14.0
#
                elif event.type == KEYDOWN and event.key == K_z:
                    self.gForearm_body.angle = 0.0
                elif event.type == KEYDOWN and event.key == K_x:
                    self.gForearm_body_middle.angle = 0.0
                elif event.type == KEYDOWN and event.key == K_r:
                    self.gForearm_body_middle.torque += 14.0
                elif event.type == KEYDOWN and event.key == K_u:
                    self.gForearm_body_middle.torque -= 14.0

##                    
#                elif event.type == KEYDOWN and event.key == K_o:  # CN syn gain 50
#                    bitVal50 = convertType(50.0, fromType = 'f', toType = 'I')
#                    xem_muscle_index.SendPara(bitVal = bitVal50, trigEvent = 10) 
#                    xem_muscle.SendPara(bitVal = bitVal50, trigEvent = 10)
#                elif event.type == KEYDOWN and event.key == K_p:  # CN syn gain 100
#                    bitVal100 = convertType(100.0, fromType = 'f', toType = 'I')
#                    xem_muscle_index.SendPara(bitVal = bitVal100, trigEvent = 10) 
#                    xem_muscle.SendPara(bitVal = bitVal100, trigEvent = 10)  
                    

                elif event.type == KEYDOWN and event.key == K_l:  # forced movement, follow the mouse
                    if (self.record == True):
                        self.record = False
                    if (self.record == False):
                        self.record = True
                    k = 1
                  
                        
            """ mouse cursor controlled forced (passive) movement"""
            if (self.record == True):
                #self.gForearm_body.angle =forced_angle
                if k == len(self.j2List)-1:
                    self.gForearm_body.angle = 0.0
                else:
                    self.gForearm_body.angle = (self.j2List[k])*3.141592/180  # in radian   
                    k = k + 1
                    #print self.j2List[k]  
                    
            """  Clear screen  """
            self.screen.fill(THECOLORS["white"])  # ~1ms
            

            """ Draw stuff """
            for f in [self.gForearm_shape,]:
                ps = f.get_points()
                ps.append(ps[0])
                ps = map(self.to_pygame, ps)
                

                color = THECOLORS["black"]
                self.pygame.draw.lines(self.screen, color, False, ps,  2)
            #if abs(flipper_body.angle) < 0.001: flipper_body.angle = 0
            
            """ update second joint location """
            print ps
            self.gForearm_body_middle.position = (ps[3][0]+ps[4][0])/2, 300+ (300-(ps[3][1]+ps[4][1])/2) 
            print (ps[3][0]+ ps[4][0])/2, (ps[3][1]+ps[4][1])/2
#            print ps[3][0],  ps[4][0],  ps[3][1], ps[4][1]
        

            for f in [self.gForearm_shape_middle,]:
                ps = f.get_points()
                ps.append(ps[0])
                ps = map(self.to_pygame, ps)

                color = THECOLORS["black"]
                self.pygame.draw.lines(self.screen, color, False, ps,  2)
            
            """ update wrist joint"""
            self.gForearm_body_wrist.position = (ps[3][0]+ps[4][0])/2, 300+ (300-(ps[3][1]+ps[4][1])/2) 
            
            for f in [self.gForearm_shape_wrist,]:
                ps = f.get_points()
                ps.append(ps[0])
                ps = map(self.to_pygame, ps)

                color = THECOLORS["black"]
                self.pygame.draw.lines(self.screen, color, False, ps,  2)
                


         
            """draw circle """

#            pygame.draw.circle(self.screen, THECOLORS["black"], (300,  300), int(42), 0)
#            pygame.draw.circle(self.screen, THECOLORS["white"], (300,  300), int(40), 0)
#            pygame.draw.circle(self.screen, THECOLORS["black"], (300,  300), int(3), 0)
#            pygame.draw.line(self.screen, THECOLORS["black"], [300,  300-42], [500,  300-42],  2)
#            pygame.draw.line(self.screen, THECOLORS["black"], [300,  300+40], [500,  300+40],  2)
    
            
            """ Update physics  """
            fps = 30.0 #was 30.0
            step = 1
            dt = 1.0/fps/step
            for x in range(step):
                self.gSpace.step(dt)
            
            """ text message"""    
            myfont = self.pygame.font.SysFont("monospace", 15)
            label1 = myfont.render("j:torque down, f: torque up" , 1,  THECOLORS["black"])
            label2 = myfont.render("l: mouse-controlled movement, esc:out" , 1,  THECOLORS["black"])
            self.screen.blit(label1, (10, 10))
            self.screen.blit(label2, (10, 40))
            
            
        
            
            """ Flip screen (big delay from here!) """ 
            self.pygame.display.flip()  # ~1ms
            self.gClock.tick(fps)  # target fps
    #        self.gClock.tick(80)  # oscillate
            self.pygame.display.set_caption("fps: " + str(self.gClock.get_fps())) 


    def readData(self):
        self.j1List=[]
        self.j2List=[]
        for line in open('doornik_curve_resampled.txt',  "r").readlines(): 
            j1 ,  j2= line.split(',')
            j1 = float(j1)
            j2 = float(j2)

#            indexList.append(index)
            self.j1List.append(j1)   #joint1
            self.j2List.append(j2)   #joint2

    
    def main(self):
#        Process(target=self.controlLoopBiceps)
        self.readData() # read doornik data
        threading.Thread(target=self.keyControl).start()
#        threading.Thread(target=self.controlLoopBiceps).start()
        threading.Thread(target=self.controlLoopIndexFlexor, args=(xem_muscle_indexFlexor,xem_spindle_indexFlexor, )).start()    
        threading.Thread(target=self.controlLoopIndexExtensor, args=(xem_muscle_indexExtensor,xem_spindle_indexExtensor, )).start()
#        
        threading.Thread(target=self.controlLoopMiddleFlexor, args=(xem_muscle_middleFlexor,xem_spindle_middleFlexor, )).start()    
        threading.Thread(target=self.controlLoopMiddleExtensor, args=(xem_muscle_middleExtensor,xem_spindle_middleExtensor, )).start()
#        
        threading.Thread(target=self.controlLoopWristFlexor, args=(xem_muscle_middleFlexor,xem_spindle_middleFlexor, )).start() 
        threading.Thread(target=self.controlLoopWristExtensor, args=(xem_muscle_middleExtensor,xem_spindle_middleExtensor, )).start()
#         
#        threading.Thread(target=self.controlLoop_IndexFlexor).start()
#        threading.Thread(target=self.controlLoop_IndexExtensor).start()
#        
#        threading.Thread(target=self.controlLoop_MiddleFlexor).start()
#        threading.Thread(target=self.controlLoop_MiddleExtensor).start()
        
        
        
        

if __name__ == '__main__':
    import sys
    sys.path.append('../../source/py/multC_tester')
    sys.path.append('../../source/py/')
    import sys, PyQt4
    from PyQt4.QtGui import QFileDialog

    from PyQt4.QtCore import QTimer,  SIGNAL, SLOT, Qt,  QRect
    from Utilities import *
    from M_Fpga import SomeFpga # Model in MVC   
    from config_test import NUM_NEURON, SAMPLING_RATE, FPGA_OUTPUT_B1, FPGA_OUTPUT_B2, FPGA_OUTPUT_B3,   USER_INPUT_B1,  USER_INPUT_B2,  USER_INPUT_B3
    from generate_sin import gen as gen_sin
    from generate_sequence import gen as gen_ramp
    from pylab import plot, show, subplot, title
    from scipy.io import savemat, loadmat
    import numpy as np
    import time 
    import threading
#    from multiprocessing import Process
    from pygame.locals import *
    from pymunk.vec2d import Vec2d
    from pymunk.pygame_util import draw_space, from_pygame
    from pygame.color import *
  

      
#    xem_spindle_tri = SomeFpga(NUM_NEURON, SAMPLING_RATE, '12320003RN')
#    xem_spindle_bic = SomeFpga(NUM_NEURON, SAMPLING_RATE, '124300046A')
#    xem_muscle_bic = SomeFpga(NUM_NEURON, SAMPLING_RATE, '1201000216')
#    xem_muscle_tri = SomeFpga(NUM_NEURON, SAMPLING_RATE, '12430003T2')
#    
#  
    xem_spindle_indexExtensor = SomeFpga(NUM_NEURON, SAMPLING_RATE, '12320003RN')
    xem_spindle_indexFlexor = SomeFpga(NUM_NEURON, SAMPLING_RATE, '124300046A')
    xem_muscle_indexFlexor = SomeFpga(NUM_NEURON, SAMPLING_RATE, '1201000216')
    xem_muscle_indexExtensor = SomeFpga(NUM_NEURON, SAMPLING_RATE, '12430003T2')
#    
    xem_spindle_middleExtensor = SomeFpga(NUM_NEURON, SAMPLING_RATE, '000000054K')
    xem_spindle_middleFlexor = SomeFpga(NUM_NEURON, SAMPLING_RATE, '000000054G')
    xem_muscle_middleFlexor = SomeFpga(NUM_NEURON, SAMPLING_RATE, '000000053U')
    xem_muscle_middleExtensor = SomeFpga(NUM_NEURON, SAMPLING_RATE, '0000000550')
#    
#    
#    view_muscle_bic = View(count = 1,  projectName = "rack_emg" ,  projectPath = "/home/eric/nerf_verilog_eric/projects/rack_emg",  nerfModel = xem_muscle_index,  fpgaOutput = FPGA_OUTPUT_B3,  userInput = USER_INPUT_B3)
#    
#    c1= SingleXemTester(xem_muscle_index, view_muscle_bic, USER_INPUT_B3,  xem_muscle_index.HalfCountRealTime())
#    record(1,  view_muscle_bic)
#    
    
#    print "sineBic:",  sineBic[0],  sineBic[1],  sineBic[2],  sineBic[3]    
    
#    value = 10
#    newHalfCnt = 1 * 200 * (10 **6) / SAMPLING_RATE / NUM_NEURON / (value*2) / 2 / 2
#    xem0.SendPara(bitVal = newHalfCnt, trigEvent = DATA_EVT_CLKRATE)
#    xem1.SendPara(bitVal = newHalfCnt, trigEvent = DATA_EVT_CLKRATE)
#    
#    bitVal = ConvertType(20.0, fromType = 'f', toType = 'I')
#    xem0.SendPara(bitVal = bitVal, trigEvent = 1)
#    xem1.SendPara(bitVal = bitVal, trigEvent = 1)
    
    arm1 = armSetup()
    
    sys.exit()
