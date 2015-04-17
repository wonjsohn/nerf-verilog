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
BUTTON_INPUT_FROM_TRIGGER = 1



class armSetup:
    def __init__(self):
        pygame.init()
        self.screen = pygame.display.set_mode((600, 600))
        self.gClock = pygame.time.Clock()
        self.running = True
    
        ### Physics stuff
        self.gSpace = pymunk.Space(50)
        self.gSpace.gravity = (0.0, -9.8 * 0.0)

        ### walls
        static_body = pymunk.Body()
        
        self.jointMin = 0.0

#        fp = [(20,-20), (-120, 0), (20,20)]
        fp = [(40, -5), (30, -15),  (20,-20),   (-150, -10), (-150,  10), (20,20),  (30,  15),  (40,  5)]
#        fp = [(-40, -5), (-30, -15),  (-20,-20),   (150, -10), (150,  10), (-20,20),  (-30,  15),  (-40,  5)]
 
 
        mass = 1.52 # was 1.52
        moment = pymunk.moment_for_poly(mass, fp)

        # left flipper
        #gForearm_body = pymunk.Body(mass, moment_of_inertia)
        self.gForearm_body = pymunk.Body(mass, 0.0372)
        self.gForearm_body.position = 300, 300
        self.gForearm_shape = pymunk.Poly(self.gForearm_body, [(-x,y) for x,y in fp])
#        self.gForearm_shape.friction = 10.0
        self.gSpace.add(self.gForearm_body, self.gForearm_shape)

        self.gElbow_joint_body = pymunk.Body()
        self.gElbow_joint_body.position = self.gForearm_body.position
        j1 = pymunk.PinJoint(self.gForearm_body,  self.gElbow_joint_body, (0,0), (0,0))
        self.gElbow_joint_body.shape = pymunk.Circle(self.gElbow_joint_body, 250)
        
    #    j = pymunk.PinJoint(forearm_body, gElbow_joint_body, (0,0), (0,0))
        j = pymunk.RotaryLimitJoint(self.gForearm_body, self.gElbow_joint_body, JOINT_MIN, JOINT_MAX)
        
        
#        """ attempt to draw circle without affecting physics"""
##        circlespace=pymunk.Space()
##        circlebody = pymunk.Body(0, 0)  # mass, inertia
#        circleshape = pymunk.Circle(self.gForearm_body, 40, Vec2d(0,0)) 
#        
#
#        circleshape.color = THECOLORS["black"]
#
#        self.gSpace.add(circleshape)
#        
        
        
        pymunk.collision_slop = 0
        JOINT_DAMPING_SCHEIDT2007 = 2.1
        JOINT_DAMPING = JOINT_DAMPING_SCHEIDT2007 * 0.25 #was 0.1
        s = pymunk.DampedRotarySpring(self.gForearm_body, self.gElbow_joint_body, -0.0, 0.0, JOINT_DAMPING)
        self.gSpace.add(j,  j1,  s) # 
        
        """ create arrow """
        arrow_body,arrow_shape = self.create_arrow()
        self.gSpace.add(arrow_shape)
        
        
        """    """
        self.gForearm_shape.group = 1
        self.gForearm_shape.elasticity = 1.0

        self.gRest_joint_angle = 0.0
        
        self.data_bic = []
        self.data_tri = []
        self.start_time = time.time()
        self.pygame = pygame
        self.force_tri = 0.0
        self.lce_bic = 0.0
        self.lce_tri = 0.0
        self.angle = 0.0
        self.linearV = 0.0
        self.record = False
        self.scale = 1.0
        self.fmax = 0.0
        self.timeMinJerk = 0.0
        self.p2ptime = 0.0
        self.main()
        self.forceMultiplier = 4.0
        


    def to_pygame(self,  p):
        """Small hack to convert pymunk to pygame coordinates"""
        return int(p.x), int(-p.y+600)

    def angle2length(self,  angle):
        max_length = 1.3
        length = 0.3 * (angle - self.jointMin) + 1     # was: 0.3*angle+1 / angle in rad 
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
  

    def controlLoopBiceps(self):
        
        while self.running:

            """   Get forces   """
            force_bic_pre = max(0.0, xem_muscle_bic.ReadFPGA(0x32, "float32")) / 128 #- 0.2
            spikecnt_bic = xem_muscle_bic.ReadFPGA(0x30, "int32")  
            emg_bic = xem_muscle_bic.ReadFPGA(0x20, "float32")  # EMG 
            
            """ extra data for close loop data acquisition"""  
#            Ia_afferent = xem_spindle_bic.ReadFPGA(0x22, "float32")  # EMG 
#            II_afferent = xem_spindle_bic.ReadFPGA(0x24, "float32")  # EMG    
#            MN1_spikes = xem_muscle_bic.ReadFPGA(0x22, "spike32")  #             
#            MN2_spikes = xem_muscle_bic.ReadFPGA(0x24, "spike32")  #             
#            MN3_spikes = xem_muscle_bic.ReadFPGA(0x26, "spike32")  #             
#            MN4_spikes = xem_muscle_bic.ReadFPGA(0x28, "spike32")  #             
#            MN5_spikes = xem_muscle_bic.ReadFPGA(0x2A, "spike32")  #             
#            MN6_spikes = xem_muscle_bic.ReadFPGA(0x2C, "spike32")  # 
            
#            force_tri_pre = max(0.0, xem_muscle_tri.ReadFPGA(0x32, "float32")) / 128 #- 2.64
#            emg_tri = xem_muscle_tri.ReadFPGA(0x20, "float32")  # EMG

            force_bic_pre=force_bic_pre*self.forceMultiplier # scale down force
            force_bic = force_bic_pre #+ pipeInData_bic[j]
#            force_tri = force_tri_pre #+ pipeInData_bic[j] 
            """ overflow to opposite muscle test (helps to stabilize - eric)"""
#            temp_force_tri = self.force_tri
#            self.force_tri = self.force_tri + force_bic*0.3  # overflow to the opposite muscle
#            force_bic = force_bic + temp_force_tri*0.3       # overflow to the opposite muscle
            
          
            """ reciprocal inhibition  """
#            if (self.linearV > 0): # biceps force contraction phase
#                self.force_tri = self.force_tri*0.5
#            else:   # triceps contraction phase
#                force_bic = force_bic*0.5
                

            """  force curve (f-input spikes) saturation effect"""
#            self.fmax =90.0
#            force_bic = force_bic * (1-exp(-force_bic/self.fmax)) 

    
            self.gForearm_body.torque = (force_bic - self.force_tri) * 0.03 # was 0.06
                                            
            self.angle = ((self.gForearm_body.angle + M_PI) % (2*M_PI)) - M_PI - self.gRest_joint_angle
            
            
#            lce_tri = self.angle2length(angle)+ 0.02
            lce_bic = 2.04 - self.lce_tri 
            
            # Send lce of biceps 
            bitVal = convertType(lce_bic, fromType = 'f', toType = 'I')
    #        bitVal2 = convertType(0.0,  fromType = 'f', toType = 'I')
    #        bitVal3 = convertType(sineBic[j],  fromType = 'I', toType = 'I')
            #try M1_extra - 200000
    #        xem_muscle_bic.SendMultiPara_TEMP(bitVal1 = bitVal, bitVal2 = 200000,  bitVal3 = bitVal3, trigEvent = 9) # bitVal2: extraCN1, bitVal: extraCN2 is int type
    #        xem_muscle_bic.SendPara(bitVal = bitVal, trigEvent = 9)
            angularV = self.gForearm_body.angular_velocity

            self.linearV = self.angular2LinearV(angularV)
              
    
            
            
#            self.linearV = 0.0
    #        print linearV
            self.scale = 1.0 #10.0   # unstable when extra cortical signal is given, 30 is for doornik data collection
            
            #self.linearV = min(0, self.linearV ) # testing: only vel component in afferent active when lengthing 
            
            bitVal_bic_i = convertType(-self.linearV*self.scale, fromType = 'f', toType = 'I')
#            bitVal_tri_i = convertType(self.linearV*scale, fromType = 'f', toType = 'I')
            
            xem_muscle_bic.SendMultiPara(bitVal1 = bitVal, bitVal2 = bitVal_bic_i,  trigEvent = 9)
            xem_spindle_bic.SendPara(bitVal = bitVal, trigEvent = 9)
           
            
            
            """ Alpha-gamma coactivation """
    #        ag_coact, ag_bias = 30.0, -70.0
    #        ag_coact, ag_bias = 0.0, 50.0
    #        gd_bic = force_bic * ag_coact + ag_bias
    #        bitval = convertType(gd_bic, fromType = 'f', toType = 'I')
    #        xem_spindle_bic.SendPara(bitVal = bitval,  trigEvent = 4) # 4 = Gamma_dyn
            
            """ Send lce of triceps """
#            bitVal = convertType(self.lce_tri, fromType = 'f', toType = 'I')
    #        bitVal2 = convertType(1.0,  fromType = 'f', toType = 'I')
        
    #        bitVal3 = convertType(sineTri[j],  fromType = 'I', toType = 'I')
    #        xem_muscle_tri.SendMultiPara_TEMP(bitVal1 = bitVal, bitVal2 = 200000,  bitVal3=bitVal3,  trigEvent = 9)  # bitVal2: extraCN1, bitVal: extraCN2 is int type
    #        xem_muscle_tri.SendPara(bitVal = bitVal, trigEvent = 9)
#            xem_muscle_tri.SendMultiPara(bitVal1 = bitVal, bitVal2= bitVal_tri_i,   trigEvent = 9)
#            xem_spindle_tri.SendPara(bitVal = bitVal, trigEvent = 9)
            
            """ Alpha-gamma coactivation """
    #        gd_tri = force_tri * ag_coact + ag_bias
    #        bitval = convertType(gd_tri, fromType = 'f', toType = 'I')
    #        xem_spindle_tri.SendPara(bitVal = bitval,  trigEvent = 4) # 4 = Gamma_dyn
            
            #print "lce0 = %.2f :: lce1 = %.2f :: total_torque = %.2f" % (lce_bic, self.lce_tri, self.gForearm_body.torque),                           
    #        print "force0 = %.2f :: force1 = %.2f :: angle = %.2f :: gd_bic = %.2f :: angularV =%.2f" % (force_bic, force_tri,  angle,  gd_bic,  angularV )                          
            currentTime = time.time()
            elapsedTime = currentTime- self.start_time
            tempData = elapsedTime,  self.angle, lce_bic, spikecnt_bic, force_bic, emg_bic, self.linearV#,  MN1_spikes,  MN2_spikes, MN3_spikes,  MN4_spikes,  MN5_spikes, MN6_spikes  
            self.data_bic.append(tempData)
            #r_flipper_body.apply_impulse(Vec2d.unit() * 40000, (force * 20,0))
    #      
#            time.sleep(0.07)
  
            
    def controlLoopTriceps(self):
        
        while self.running:

            """   Get forces   """
#            force_bic_pre = max(0.0, xem_muscle_bic.ReadFPGA(0x32, "float32")) / 128 #- 0.2
#            emg_bic = xem_muscle_bic.ReadFPGA(0x20, "float32")  # EMG         
            spikecnt_tri = xem_muscle_tri.ReadFPGA(0x30, "int32")  
            force_tri_pre = max(0.0, xem_muscle_tri.ReadFPGA(0x32, "float32")) / 128 #- 2.64
            emg_tri = xem_muscle_tri.ReadFPGA(0x20, "float32")  # EMG
            
#            force_bic = force_bic_pre #+ pipeInData_bic[j]
            force_tri_pre = force_tri_pre * self.forceMultiplier
            self.force_tri = force_tri_pre #+ pipeInData_bic[j] 
            """  force curve (f-input spikes) saturation effect"""
#            self.force_tri = self.force_tri * (1-exp(-self.force_tri/self.fmax)) 
              
            """ extra data for close loop data acquisition"""  
#            Ia_afferent = xem_spindle_tri.ReadFPGA(0x22, "float32")  # EMG 
#            II_afferent = xem_spindle_tri.ReadFPGA(0x24, "float32")  # EMG    
#            MN1_spikes = xem_muscle_tri.ReadFPGA(0x22, "spike32")  #             
#            MN2_spikes = xem_muscle_tri.ReadFPGA(0x24, "spike32")  #             
#            MN3_spikes = xem_muscle_tri.ReadFPGA(0x26, "spike32")  #             
#            MN4_spikes = xem_muscle_tri.ReadFPGA(0x28, "spike32")  #             
#            MN5_spikes = xem_muscle_tri.ReadFPGA(0x2A, "spike32")  #             
#            MN6_spikes = xem_muscle_tri.ReadFPGA(0x2C, "spike32")  # 
##            
            
#            self.gForearm_body.torque = (self.force_bic - self.force_tri) * 0.06
            
            #lce = 1.0
                                 
            #angle = ((self.gForearm_body.angle + M_PI) % (2*M_PI)) - M_PI - self.gRest_joint_angle
            
            
            self.lce_tri = self.angle2length(self.angle)+ 0.02
            angle_tri = -1*self.angle
            lce_bic = 2.04 - self.lce_tri 
            
            # Send lce of biceps 
            bitVal = convertType(lce_bic, fromType = 'f', toType = 'I')
    #        bitVal2 = convertType(0.0,  fromType = 'f', toType = 'I')
    #        bitVal3 = convertType(sineBic[j],  fromType = 'I', toType = 'I')
            #try M1_extra - 200000
    #        xem_muscle_bic.SendMultiPara_TEMP(bitVal1 = bitVal, bitVal2 = 200000,  bitVal3 = bitVal3, trigEvent = 9) # bitVal2: extraCN1, bitVal: extraCN2 is int type
    #        xem_muscle_bic.SendPara(bitVal = bitVal, trigEvent = 9)
#            self.angularV = self.gForearm_body.angular_velocity

#            self.linearV = self.angular2LinearV(angularV)
    #        print linearV
#            self.scale = 500.0
#            bitVal_bic_i = convertType(-linearV*scale, fromType = 'f', toType = 'I')
            bitVal_tri_i = convertType(self.linearV*self.scale, fromType = 'f', toType = 'I')
            
#            xem_muscle_bic.SendMultiPara(bitVal1 = bitVal, bitVal2 = bitVal_bic_i,  trigEvent = 9)
#            xem_spindle_bic.SendPara(bitVal = bitVal, trigEvent = 9)
            
            """ Alpha-gamma coactivation """
    #        ag_coact, ag_bias = 30.0, -70.0
    #        ag_coact, ag_bias = 0.0, 50.0
    #        gd_bic = force_bic * ag_coact + ag_bias
    #        bitval = convertType(gd_bic, fromType = 'f', toType = 'I')
    #        xem_spindle_bic.SendPara(bitVal = bitval,  trigEvent = 4) # 4 = Gamma_dyn
            
            """ Send lce of triceps """
            bitVal = convertType(self.lce_tri, fromType = 'f', toType = 'I')
    #        bitVal2 = convertType(1.0,  fromType = 'f', toType = 'I')
        
    #        bitVal3 = convertType(sineTri[j],  fromType = 'I', toType = 'I')
    #        xem_muscle_tri.SendMultiPara_TEMP(bitVal1 = bitVal, bitVal2 = 200000,  bitVal3=bitVal3,  trigEvent = 9)  # bitVal2: extraCN1, bitVal: extraCN2 is int type
    #        xem_muscle_tri.SendPara(bitVal = bitVal, trigEvent = 9)
            xem_muscle_tri.SendMultiPara(bitVal1 = bitVal, bitVal2= bitVal_tri_i,   trigEvent = 9)
            xem_spindle_tri.SendPara(bitVal = bitVal, trigEvent = 9)
          
 
            
            """ Alpha-gamma coactivation """
    #        gd_tri = force_tri * ag_coact + ag_bias
    #        bitval = convertType(gd_tri, fromType = 'f', toType = 'I')
    #        xem_spindle_tri.SendPara(bitVal = bitval,  trigEvent = 4) # 4 = Gamma_dyn
            
    #        print "lce0 = %.2f :: lce1 = %.2f :: total_torque = %.2f" % (lce_bic, lce_tri, gForearm_body.torque),                           
    #        print "force0 = %.2f :: force1 = %.2f :: angle = %.2f :: gd_bic = %.2f :: angularV =%.2f" % (force_bic, force_tri,  angle,  gd_bic,  angularV )                          
            currentTime = time.time()
            elapsedTime = currentTime- self.start_time
            tempData = elapsedTime, angle_tri, self.lce_tri, spikecnt_tri,   self.force_tri,  emg_tri, self.linearV#,  MN1_spikes, MN2_spikes,  MN3_spikes,  MN4_spikes,  MN5_spikes,  MN6_spikes   
            self.data_tri.append(tempData)
            #r_flipper_body.apply_impulse(Vec2d.unit() * 40000, (force * 20,0))
#            time.sleep(0.07)
  
    def point2pointForce(self,  checked):
        if (checked) :
            print 'checked'
#            pipeInData_bic = gen_ramp(T = [0.0, 0.01, 0.02,  0.22, 0.23, 2.0], L = [0.0, 0.0, 480000.0, 480000.0, 0.0, 0.0], FILT = False)
#            pipeInData_bic = gen_sin(F = 1.0, AMP = 480000.0,  BIAS = 0.0,  T = 2.0) # was 150000 for CN_general
            b=0.77
#            pipeInData_bic = gen_ramp(T = [0.0, b+0.01, b+0.02,  b+0.23, b+0.24, b+0.43,  b+0.44,  b+0.54,  b+0.55,  2.0], L = [0.0, 0.0, 460000.0, 460000.0, 50000.0, 50000.0,  80000.0,  80000.0, 0.0,  0.0], FILT = False) # dont change: healthy, b=0.77
            pipeInData_bic = gen_ramp(T = [0.0, b+0.01, b+0.02,  b+0.23, b+0.24, b+0.43,  b+0.44,  b+0.64,  b+0.65,  2.0], L = [0.0, 0.0, 520000.0, 520000.0, 70000.0, 70000.0,  140000.0,  140000.0, 0.0,  0.0], FILT = False)
            
            pipeInDataBic=[]
            for i in xrange(0,  2048):
                pipeInDataBic.append(max(0.0,  pipeInData_bic[i]))
            
            
            
#            pipeIndata_tri = gen_ramp(T = [0.0, 0.21, 0.22, 0.52, 0.53, 2.0], L = [0.0, 0.0, 480000.0, 480000.0, 0.0, 0.0], FILT = False)
#            pipeIndata_tri = -gen_sin(F = 1.0,  AMP = 480000.0,  BIAS = 0.0,  T = 2.0)
            
#            pipeIndata_tri = gen_ramp(T = [0.0, 0.21, 0.22, 0.52, 0.53, 2.0], L = [0.0, 0.0, 480000.0, 480000.0, 0.0, 0.0], FILT = False)
            a=0.01
#            pipeIndata_tri = gen_ramp(T = [0.0, a+0.18, a+0.19, a+0.38, a+0.39, a+0.50,  a+0.51,  a+0.74,  a+0.75,   2.0], L = [0.0, 0.0, 360000.0, 360000.0, 50000.0, 50000.0,  30000.0,  30000.0,  0.0,  0.0], FILT = False) # don't change: healthy: a=0.01
            pipeIndata_tri = gen_ramp(T = [0.0, a+0.18, a+0.19, a+0.38, a+0.39, a+0.50,  a+0.51,  a+1.75,  a+1.76,  2.0], L = [0.0, 0.0, 470000.0, 470000.0, 60000.0, 60000.0,  50000.0,  50000.0,  0.0,  0.0], FILT = False) # don't change: healthy: a=0.01
            
            
            pipeInDataTri=[]
            for i in xrange(0,  2048):
                pipeInDataTri.append(max(0.0,  pipeIndata_tri[i]))

            xem_cortical_bic.SendPipe(pipeInDataBic)
            xem_cortical_tri.SendPipe(pipeInDataTri)
##            
            xem_cortical_tri.SendButton(True, BUTTON_RESET_SIM) #  
            xem_cortical_bic.SendButton(True, BUTTON_RESET_SIM) # 
 
            xem_cortical_tri.SendButton(False, BUTTON_RESET_SIM) # 
            xem_cortical_bic.SendButton(False, BUTTON_RESET_SIM) # 
            
#
###            
#
#            xem_cortical_bic.SendButton(True, BUTTON_INPUT_FROM_TRIGGER) # BUTTON_INPUT_FROM_TRIGGER = 1
#            xem_cortical_tri.SendButton(True, BUTTON_INPUT_FROM_TRIGGER) # BUTTON_INPUT_FROM_TRIGGER = 1
#
#            
#            xem_cortical_bic.SendButton(False, BUTTON_RESET_SIM) #  
#            xem_cortical_tri.SendButton(False, BUTTON_RESET_SIM) # 
            

                
            
    
    def keyControl(self):
        isMinJerk = False
        isPointToPoint = False
        while (self.running):
            """ angle calculated from mouse cursor position"""
            mouse_position = from_pygame( Vec2d(self.pygame.mouse.get_pos()), self.screen )
            forced_angle = (mouse_position-self.gForearm_body.position).angle   # calculate angle with mouse cursor loc. 
            
            
            # move the unfired arrow together with the cannon
#            arrow_body.position = cannon_body.position + Vec2d(cannon_shape.radius + 40, 0).rotated(cannon_body.angle)
#            arrow_body.angle = cannon_body.angle
            
#            self.gForearm_body.torque = -0.1 

            # rest-length change
            if (isMinJerk):
                d = 10   # 40 ,  speed
                jmax = 0.8  # 1.0 , joint maxzz
                t = jmax * (10*(self.timeMinJerk/d)**3 - 15*(self.timeMinJerk/d)**4 + 6*(self.timeMinJerk/d)**5)
                
                if t > jmax:
                    self.jointMin = jmax  
                    xem_cortical_bic.SendButton(False, BUTTON_INPUT_FROM_TRIGGER) # BUTTON_INPUT_FROM_TRIGGER = 1
                    xem_cortical_tri.SendButton(False, BUTTON_INPUT_FROM_TRIGGER) # BUTTON_INPUT_FROM_TRIGGER = 1
                    print "t > jmax"

            
                else:
                    self.jointMin = t
                    if self.timeMinJerk == 0.0:  # enter only once
                        print "time 0"
                        xem_cortical_bic.SendButton(True, BUTTON_INPUT_FROM_TRIGGER) # BUTTON_INPUT_FROM_TRIGGER = 1
                        xem_cortical_tri.SendButton(True, BUTTON_INPUT_FROM_TRIGGER) # BUTTON_INPUT_FROM_TRIGGER = 1
#                        xem_cortical_bic.SendPara(bitVal = 5000, trigEvent = 8) # up  (TONIC ON triceps)
                    elif self.timeMinJerk == 7.0:
#                        xem_cortical_tri.SendPara(bitVal = 5000, trigEvent = 8)  # down  (TONIC ON biceps)
                        print "time 7"
                    
                self.timeMinJerk+= 1.0   # time step
            
           # point to point trigger in for only one cycle (non-repetitive)     
            if (isPointToPoint):
                if self.p2ptime > 500.0: # 50.0
                    xem_cortical_bic.SendButton(False, BUTTON_INPUT_FROM_TRIGGER) # BUTTON_INPUT_FROM_TRIGGER = 1
                    xem_cortical_tri.SendButton(False, BUTTON_INPUT_FROM_TRIGGER) # BUTTON_INPUT_FROM_TRIGGER = 1
                
                self.p2ptime += 1.0
            
            print self.p2ptime 
   
        
    
    
            """ key control """
            for event in self.pygame.event.get():
                if event.type == QUIT:
                    self.running = False
                elif event.type == KEYDOWN and event.key == K_ESCAPE:
                    self.plotData(self.data_bic, self.data_tri)
                    self.running = False
                elif event.type == KEYDOWN and event.key == K_p: # Point-to-point
#                    isMinJerk = True
                    bitVal = convertType(0.0, fromType = 'f', toType = 'I')
                    xem_cortical_bic.SendPara(bitVal = 0, trigEvent = 8)
                    xem_cortical_tri.SendPara(bitVal = 0, trigEvent = 8)
#                    xem_cortical_bic.SendButton(True, BUTTON_RESET_SIM) #  
#                    xem_cortical_tri.SendButton(True, BUTTON_RESET_SIM) # 
# 
#                    xem_cortical_tri.SendButton(False, BUTTON_RESET_SIM) # 
#                    xem_cortical_bic.SendButton(False, BUTTON_RESET_SIM) #           
                    self.point2pointForce(True)  # point-to-point movement
                    

#                    bitVal = convertType(200.0, fromType = 'f', toType = 'I')   
#                    xem_cortical_bic.SendPara(bitVal = 5000, trigEvent = 8)
#                    xem_cortical_tri.SendPara(bitVal = 5000, trigEvent = 8)
                    
                elif event.type == KEYDOWN and event.key == K_j:
                    self.gForearm_body.torque -= 14.0
                elif event.type == KEYDOWN and event.key == K_f:
                    #self.gForearm_body.apply_force(Vec2d.unit() * -40000, (-100,0))
                    self.gForearm_body.torque += 14.0
                elif event.type == KEYDOWN and event.key == K_t:   # tonic on
#                    bitVal = convertType(6000.0, fromType = 'f', toType = 'I')
                    xem_cortical_bic.SendPara(bitVal = 18000, trigEvent = 8)
                    xem_cortical_tri.SendPara(bitVal = 12000, trigEvent = 8)
                elif event.type == KEYDOWN and event.key == K_y:   # tonic off
                    bitVal = convertType(0.0, fromType = 'f', toType = 'I')
                    xem_cortical_bic.SendPara(bitVal = 0, trigEvent = 8)
                    xem_cortical_tri.SendPara(bitVal = 0, trigEvent = 8)
                elif event.type == KEYDOWN and event.key == K_z:
#                    self.gRest_joint_angle = self.angle
                    self.gForearm_body.angle = 0.0
                elif event.type == KEYDOWN and event.key == K_r:
                    self.gForearm_body.apply_impulse(Vec2d.unit()*0.3,  (4,  0))
                elif event.type == KEYDOWN and event.key == K_u:
                    self.gForearm_body.apply_impulse(Vec2d.unit()*0.3,  (-4,  0))
                    
                elif event.type == KEYDOWN and event.key == K_s:  #reset-sim boards
                    xem_cortical_bic.SendButton(True, BUTTON_RESET_SIM) #  
                    xem_cortical_tri.SendButton(True, BUTTON_RESET_SIM) # 
#                    xem_cortical_tri.SendButton(False, BUTTON_RESET_SIM) # 
#                    xem_cortical_bic.SendButton(False, BUTTON_RESET_SIM) #  
                    
                elif event.type == KEYDOWN and event.key == K_d:  #reset-sim boards
                    xem_cortical_bic.SendButton(False, BUTTON_RESET_SIM) #  
                    xem_cortical_tri.SendButton(False, BUTTON_RESET_SIM) # 

#                elif event.type == KEYDOWN and event.key == K_d:  #reset-sim boards
                
   
                elif event.type == KEYDOWN and event.key == K_e:  # trigger off
                    xem_cortical_bic.SendButton(False, BUTTON_INPUT_FROM_TRIGGER) # BUTTON_INPUT_FROM_TRIGGER = 1
                    xem_cortical_tri.SendButton(False, BUTTON_INPUT_FROM_TRIGGER) # BUTTON_INPUT_FROM_TRIGGER = 1
                elif event.type == KEYDOWN and event.key == K_w:  # trigger on
                    isPointToPoint = True
                    xem_cortical_bic.SendButton(True, BUTTON_INPUT_FROM_TRIGGER) # BUTTON_INPUT_FROM_TRIGGER = 1
                    xem_cortical_tri.SendButton(True, BUTTON_INPUT_FROM_TRIGGER) # BUTTON_INPUT_FROM_TRIGGER = 1
                
#                elif event.type == KEYDOWN and event.key == K_o:  # CN syn gain 50
#                    bitVal50 = convertType(50.0, fromType = 'f', toType = 'I')
#                    xem_muscle_bic.SendPara(bitVal = bitVal50, trigEvent = 10) 
#                    xem_muscle_tri.SendPara(bitVal = bitVal50, trigEvent = 10)
#                elif event.type == KEYDOWN and event.key == K_p:  # CN syn gain 100
#                    bitVal100 = convertType(100.0, fromType = 'f', toType = 'I')
#                    xem_muscle_bic.SendPara(bitVal = bitVal100, trigEvent = 10) 
#                    xem_muscle_tri.SendPara(bitVal = bitVal100, trigEvent = 10)  
                    

                elif event.type == KEYDOWN and event.key == K_l:  # forced movement, follow the mouse
                    if (self.record == True):
                        self.record = False
                    if (self.record == False):
                        self.record = True
                    k = 1
                  
                        
            """ Minos - A simple angle servo """
#            servo_torque = 3.0 * (30.0/180.0 * 3.141592 - self.gForearm_body.angle)
#            self.gForearm_body.torque += servo_torque
            
            
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
#                self.gSpace.step(dt)
                self.gSpace.step(0.001*8*2)
            
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
        threading.Thread(target=self.controlLoopBiceps).start()
        threading.Thread(target=self.controlLoopTriceps).start()
        
        xem_cortical_bic.SendButton(False, BUTTON_INPUT_FROM_TRIGGER) # BUTTON_INPUT_FROM_TRIGGER = 1
        xem_cortical_tri.SendButton(False, BUTTON_INPUT_FROM_TRIGGER) # BUTTON_INPUT_FROM_TRIGGER = 1
        

        
        
        
        

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
#    xem_cortical_tri = SomeFpga(NUM_NEURON, SAMPLING_RATE, '11160001CJ')
#    xem_muscle_tri = SomeFpga(NUM_NEURON, SAMPLING_RATE, '12430003T2')
    
#    xem_spindle_tri = SomeFpga(NUM_NEURON, SAMPLING_RATE, '000000054G')
#    xem_cortical_tri = SomeFpga(NUM_NEURON, SAMPLING_RATE, '000000054P')
#    xem_muscle_tri = SomeFpga(NUM_NEURON, SAMPLING_RATE, '000000053U')
#    
#    xem_spindle_bic = SomeFpga(NUM_NEURON, SAMPLING_RATE, '000000054K')
#    xem_cortical_bic = SomeFpga(NUM_NEURON, SAMPLING_RATE, '000000053X')
#    xem_muscle_bic = SomeFpga(NUM_NEURON, SAMPLING_RATE, '0000000550')
    
    
    xem_spindle_tri = SomeFpga(NUM_NEURON, SAMPLING_RATE, '000000054K')
#    xem_spindle_bic = SomeFpga(NUM_NEURON, SAMPLING_RATE, '000000054G')
#    xem_muscle_bic = SomeFpga(NUM_NEURON, SAMPLING_RATE, '000000053U')
    xem_muscle_tri = SomeFpga(NUM_NEURON, SAMPLING_RATE, '0000000550')
    
    
#    xem_cortical_bic = SomeFpga(NUM_NEURON, SAMPLING_RATE, '000000054P')
    xem_cortical_tri = SomeFpga(NUM_NEURON, SAMPLING_RATE, '000000053X')
    
    # silver top
    xem_spindle_bic = SomeFpga(NUM_NEURON, SAMPLING_RATE, '12320003RN')
    xem_muscle_bic = SomeFpga(NUM_NEURON, SAMPLING_RATE, '12430003T2')
    xem_cortical_bic = SomeFpga(NUM_NEURON, SAMPLING_RATE, '11160001CJ')
    
    
#    
#    xem_spindle_bic = SomeFpga(NUM_NEURON, SAMPLING_RATE, '124300046A')
#    xem_cortical_bic = SomeFpga(NUM_NEURON, SAMPLING_RATE, '12320003RM')
#    xem_muscle_bic = SomeFpga(NUM_NEURON, SAMPLING_RATE, '1201000216')
#    
#    view_muscle_bic = View(count = 1,  projectName = "rack_emg" ,  projectPath = "/home/eric/nerf_verilog_eric/projects/rack_emg",  nerfModel = xem_muscle_bic,  fpgaOutput = FPGA_OUTPUT_B3,  userInput = USER_INPUT_B3)
#    
#    c1= SingleXemTester(xem_muscle_bic, view_muscle_bic, USER_INPUT_B3,  xem_muscle_bic.HalfCountRealTime())
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
