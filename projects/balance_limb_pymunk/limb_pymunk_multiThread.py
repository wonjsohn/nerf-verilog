import pygame
from pygame.locals import *
from pygame.color import *
import pymunk
from pymunk import Vec2d
import math, sys, random
from pylab import *
import socket
from time import sleep
from pykeyboard import PyKeyboard


M_PI = 3.1415926
JOINT_MIN = -1.2
JOINT_MAX = 1.2
JOINT_RANGE = JOINT_MAX - JOINT_MIN 
BUTTON_INPUT_FROM_TRIGGER = 1
BUTTON_RESET_SIM = 2


class ArmSetup:
    def __init__(self):
        self.SWEEP_STEP_SIZE = 10 # nxn trials
        self.TOTAL_TRIALS = self.SWEEP_STEP_SIZE**2
        self.GAMMA_INC = 400.0 / self.SWEEP_STEP_SIZE
        self.currTrial = 0 # Current number of trial, for dividing the saved data files
        self.currGammaDyn = 0.0 
        self.currGammaSta = 0.0 
        self.torqueMultiplier = 1.55 #1.55 # 0.55 works the best so far
        self.JOINT_DAMPING = 0.0
#        self.RATIO_RECIPROCAL_INHIBITION = 2.0
        
        pygame.init()
        self.screen = pygame.display.set_mode((600, 600))
        self.gClock = pygame.time.Clock()
        self.running = True
    
        ### Physics stuff
        self.gSpace = pymunk.Space(50)
        self.gSpace.gravity = (0.0, -9.8 * 0.0)

        ### walls
        static_body = pymunk.Body()

#        fp = [(20,-20), (-120, 0), (20,20)]
        fp = [(40, -5), (30, -15),  (20,-20),   (-150, -10), (-150,  10), (20,20),  (30,  15),  (40,  5)]
#        fp = [(-40, -5), (-30, -15),  (-20,-20),   (150, -10), (150,  10), (-20,20),  (-30,  15),  (-40,  5)]
 
 
        mass = 0.52 # was 1.52
        moment = pymunk.moment_for_poly(mass, fp)

        # left flipper
        #gForearm_body = pymunk.Body(mass, moment_of_inertia)
#        self.gForearm_body = pymunk.Body(mass, 0.0372)
        self.gForearm_body = pymunk.Body(mass, 0.0372)
        self.gForearm_body.position = 300, 300
        self.gForearm_shape = pymunk.Poly(self.gForearm_body, [(-x,y) for x,y in fp])
#        self.gForearm_shape.friction = 10.0
        self.gSpace.add(self.gForearm_body, self.gForearm_shape)

        self.gElbow_joint_body = pymunk.Body()
        self.gElbow_joint_body.position = self.gForearm_body.position
        j1 = pymunk.PivotJoint(self.gForearm_body,  self.gElbow_joint_body, (0,0), (0,0))
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
        s = pymunk.DampedRotarySpring(self.gForearm_body, self.gElbow_joint_body, -0.0, 0.0, self.JOINT_DAMPING)
        self.strong_damper = pymunk.DampedRotarySpring(self.gForearm_body, self.gElbow_joint_body, -0.0, 0.0, 100)
        self.gSpace.add(j, j1, s, self.strong_damper) # 
        
        
        
        """ create arrow """
        arrow_body,arrow_shape = self.createArrow()
        self.gSpace.add(arrow_shape)
        
        
        """    """
        self.gForearm_shape.group = 1
        self.gForearm_shape.elasticity = 1.0

        self.gRest_joint_angle = 0.0
        
        self.data_bic = []
        self.data_tri = []
        self.start_time = time.time()
        self.pygame = pygame
        self.force_bic = 0.0
        self.force_tri = 0.0
        self.lce_bic = 0.0
        self.lce_tri = 0.0
        self.emg_bic = 0.0
        self.emg_tri = 0.0
        self.spikecnt_bic = 0.0
        self.spikecnt_tri = 0.0
        self.elapsedTime_bic = 0.0
        self.elapsedTime_tri = 0.0
        self.angle = 0.0
        self.linearV = 0.0
        self.record = False
        self.mouseOn = False
        self.scale = 1.0
        self.fmax = 0.0
        self.timeref_bic = 0.0
        self.timeref_tri = 0.0
        self.timeRef = 0.0
        self.sinewave = 0.0
        self.ind = 0  # index for sinewave
        


    """ clock-wise torque """
    def cTorque(self):
        self.gForearm_body.torque -= 0.8*7.0 #2*7.0 
    
    """ counter clock-wise torque """
    def ccTorque(self):
        #self.gForearm_body.apply_force(Vec2d.unit() * -40000, (-100,0))
        self.gForearm_body.torque += 0.8*7.0 #2*7.0
#                    
        
    """ escape """
    def escape(self):                    
        self.finalizeData(self.data_bic, self.data_tri)
        self.running = False
    
    """ tonic drive on/off"""
    def tonicDrive(self, val):
        bitVal2 = convertType(val, fromType = 'f', toType = 'I')
        xem_cortical_tri.SendPara(bitVal = bitVal2, trigEvent = 8)
        #bitVal = convertType(0.0, fromType = 'f', toType = 'I')
        #xem_cortical_bic.SendPara(bitVal = bitVal, trigEvent = 8)
        #xem_cortical_tri.SendPara(bitVal = bitVal, trigEvent = 8)    
                    
                    
                    
    """ set cortical gain """
    def corticalGain(self, val):                    
       bitVal50 = convertType(val, fromType = 'f', toType = 'I')
       xem_muscle_bic.SendPara(bitVal = bitVal50, trigEvent = 10) 
       xem_muscle_tri.SendPara(bitVal = bitVal50, trigEvent = 10)
    
    """ set gamma dyn drive """
    def setGammaDyn(self):
        bitVal = convertType(self.currGammaDyn, fromType = 'f', toType = 'I')
        xem_spindle_bic.SendPara(bitVal = bitVal, trigEvent = 4) 
        xem_spindle_tri.SendPara(bitVal = bitVal, trigEvent = 4) 
    
    """ set gamma static drive """
    def setGammaSta(self):
        bitVal = convertType(self.currGammaSta, fromType = 'f', toType = 'I')
        xem_spindle_bic.SendPara(bitVal = bitVal, trigEvent = 5) 
        xem_spindle_tri.SendPara(bitVal = bitVal, trigEvent = 5) 
        
    def softReset(self):
        self.running = True

        # left flipper
        self.gForearm_body.angle = 0.0
        self.gForearm_body.torque = 0.0
               


    def toPygame(self,  p):
        """Small hack to convert pymunk to pygame coordinates"""
        return int(p.x), int(-p.y+600)

    def angle2length(self,  angle):
        max_length = 1.3
        length = max_length + ((2.0-max_length)-max_length) / (3.14)* (angle- JOINT_MIN)      # angle in rad 
        length = 0.4*angle+1     # was: 0.3*angle+1 / angle in rad 
        return length

    def angular2LinearV(self, angularV):
        linearV = angularV * 0.3
        return linearV
    
    def finalizeData(self,  data_bic,  data_tri):
        from pylab import plot, show, subplot, title
        from scipy.io import savemat, loadmat
        import numpy as np
        import time

        timeTag = time.strftime("%Y%m%d_%H%M%S")
        
        savemat(timeTag+".mat", mdict={'data_bic': data_bic,  'data_tri': data_tri})
    
    
    def createArrow(self):
        vs = [(-30,0), (0,3), (10,0), (0,-3)]
        mass = 1
        moment = pymunk.moment_for_poly(mass, vs)
        arrow_body = pymunk.Body(mass, moment)
      
        arrow_shape = pymunk.Poly(arrow_body, vs)
        arrow_shape.friction = .5
        arrow_shape.collision_type = 1
        return arrow_body, arrow_shape
  
    def sendUdp(self,  f_emg):
        UDP_IP = "192.168.0.104"
        UDP_PORT = 8899
#        MESSAGE = "Hello, from Eric!"
##
#        print "UDP target IP:", UDP_IP
#        print "UDP target port:", UDP_PORT
#        print "message:", MESSAGE

        sock = socket.socket(socket.AF_INET, # Internet
                             socket.SOCK_DGRAM) # UDP
        sock.sendto(f_emg, (UDP_IP, UDP_PORT))


    def controlLoopBiceps(self):
        
        while self.running:

            """   Get forces   """
            force_bic_pre = max(0.0, xem_muscle_bic.ReadFPGA(0x32, "float32")) / 128 #- 0.2
            #force_bic_pre = force_bic_pre * 1.0 # force adjustment for quick reflex return
            self.spikecnt_bic = xem_muscle_bic.ReadFPGA(0x30, "int32")  
            self.emg_bic = xem_muscle_bic.ReadFPGA(0x20, "float32")  # EMG 
            self.timeref_bic = xem_spindle_bic.ReadFPGA(0x28, "float32")  # 
            
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
            
            self.force_bic = force_bic_pre*self.torqueMultiplier  #+ pipeInData_bic[j]
#            force_tri = force_tri_pre #+ pipeInData_bic[j] 
            """ overflow to opposite muscle test (helps to stabilize - eric)"""
#            temp_force_tri = self.force_tri
#            self.force_tri = self.force_tri + force_bic*0.3  # overflow to the opposite muscle
#            force_bic = force_bic + temp_force_tri*0.3       # overflow to the opposite muscle
            
                          

            """  force curve (f-input spikes) saturation effect"""
#            self.fmax =90.0
#            force_bic = force_bic * (1-exp(-force_bic/self.fmax)) 

    
#            self.force_bic = max(0, self.force_bic - self.force_tri * self.RATIO_RECIPROCAL_INHIBITION)
#            self.force_tri = max(0, self.force_tri - self.force_bic * self.RATIO_RECIPROCAL_INHIBITION)
            
            self.gForearm_body.torque = (self.force_bic - self.force_tri) * 0.02 #0.03 # was 0.06
                                            
            self.angle = ((self.gForearm_body.angle + M_PI) % (2*M_PI)) - M_PI - self.gRest_joint_angle
            
            
#            lce_tri = self.angle2length(angle)+ 0.02
            self.lce_bic = 2.04 - self.lce_tri 
            
            # Send lce of biceps 
            bitVal = convertType(self.lce_bic, fromType = 'f', toType = 'I')
    #        bitVal2 = convertType(0.0,  fromType = 'f', toType = 'I')
    #        bitVal3 = convertType(sineBic[j],  fromType = 'I', toType = 'I')
            #try M1_extra - 200000
    #        xem_muscle_bic.SendMultiPara_TEMP(bitVal1 = bitVal, bitVal2 = 200000,  bitVal3 = bitVal3, trigEvent = 9) # bitVal2: extraCN1, bitVal: extraCN2 is int type
    #        xem_muscle_bic.SendPara(bitVal = bitVal, trigEvent = 9)
            angularV = self.gForearm_body.angular_velocity

            self.linearV = self.angular2LinearV(angularV)
              
    
            
            
#            self.linearV = 0.0
    #        print linearV
            self.scale = 100.0 #15.0   # unstable when extra cortical signal is given, 30 is for doornik data collection
            
            #self.linearV = min(0, self.linearV ) # testing: only vel component in afferent active when lengthing 
            
            bitVal_bic_i = convertType(-self.linearV*self.scale, fromType = 'f', toType = 'I')
#            bitVal_tri_i = convertType(self.linearV*scale, fromType = 'f', toType = 'I')
            
            xem_muscle_bic.SendMultiPara(bitVal1 = bitVal, bitVal2 = bitVal_bic_i,  trigEvent = 9)
            xem_spindle_bic.SendPara(bitVal = bitVal, trigEvent = 9)
            """ udp sending """
            #self.sendUdp("%.4f" % self.emg_bic)
            
            
            """ Alpha-gamma coactivation """
#            ag_coact, ag_bias = 30.0, -70.0
#            ag_coact, ag_bias = 30.0, 50.0
#            gd_bic = force_bic * ag_coact + ag_bias
##            print gd_bic
#            bitval = convertType(gd_bic, fromType = 'f', toType = 'I')
#            xem_spindle_bic.SendPara(bitVal = bitval,  trigEvent = 4) # 4 = Gamma_dyn
#            xem_spindle_bic.SendPara(bitVal = bitval,  trigEvent = 5) # 4 = Gamma_sta
            
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
            
            #print "lce0 = %.2f :: lce1 = %.2f :: total_torque = %.2f" % (self.lce_bic, self.lce_tri, self.gForearm_body.torque),                           
    #        print "force0 = %.2f :: force1 = %.2f :: angle = %.2f :: gd_bic = %.2f :: angularV =%.2f" % (force_bic, force_tri,  angle,  gd_bic,  angularV )                          
            currentTime = time.time()
            self.elapsedTime_bic = currentTime- self.start_time
#            temp_bic = self.elapsedTime_bic, self.lce_bic, self.linearV, self.spikecnt_bic, self.force_bic, self.emg_bic
#            self.data_bic.append(temp_bic)           #r_flipper_body.apply_impulse(Vec2d.unit() * 40000, (force * 20,0))
    #      
#            time.sleep(1.0/1024*5)
  
            
    def controlLoopTriceps(self):
        
        while self.running:

            """   Get forces   """
#            force_bic_pre = max(0.0, xem_muscle_bic.ReadFPGA(0x32, "float32")) / 128 #- 0.2
#            emg_bic = xem_muscle_bic.ReadFPGA(0x20, "float32")  # EMG         
            self.spikecnt_tri = xem_muscle_tri.ReadFPGA(0x30, "int32")  
            force_tri_pre = max(0.0, xem_muscle_tri.ReadFPGA(0x32, "float32")) / 128 #- 2.64
            force_tri_pre = force_tri_pre * 1.0 # force adjustment for quick reflex return
            self.emg_tri = xem_muscle_tri.ReadFPGA(0x20, "float32")  # EMG
            self.timeref_tri = xem_spindle_tri.ReadFPGA(0x28, "float32")  # 
            
#            force_bic = force_bic_pre #+ pipeInData_bic[j]
            self.force_tri = force_tri_pre *self.torqueMultiplier #+ pipeInData_bic[j] 
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
###            
            
#            self.gForearm_body.torque = (self.force_bic - self.force_tri) * 0.06
            
            #lce = 1.0
                                 
            #angle = ((self.gForearm_body.angle + M_PI) % (2*M_PI)) - M_PI - self.gRest_joint_angle
            
            
            self.lce_tri = self.angle2length(self.angle)+ 0.02
#            self.lce_bic = 2.04 - self.lce_tri 
            
            # Send lce of biceps 
            bitVal = convertType(self.lce_bic, fromType = 'f', toType = 'I')
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
#            ag_coact, ag_bias = 30.0, 50.0
#            gd_tri = force_tri * ag_coact + ag_bias
#            bitval = convertType(gd_tri, fromType = 'f', toType = 'I')
#            xem_spindle_tri.SendPara(bitVal = bitval,  trigEvent = 4) # 4 = Gamma_dyn
#            xem_spindle_tri.SendPara(bitVal = bitval,  trigEvent = 5) # 4 = Gamma_sta
            
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
            
    #        print "lce0 = %.2f :: lce1 = %.2f :: total_torque = %.2f" % (self.lce_bic, lce_tri, gForearm_body.torque),                           
    #        print "force0 = %.2f :: force1 = %.2f :: angle = %.2f :: gd_bic = %.2f :: angularV =%.2f" % (force_bic, force_tri,  angle,  gd_bic,  angularV )                          
            currentTime = time.time()
            self.elapsedTime_tri = currentTime- self.start_time
#            temp_tri = self.elapsedTime_tri, self.lce_tri, self.linearV, self.spikecnt_tri,   self.force_tri,  self.emg_tri
#            self.data_tri.append(temp_tri)
            #r_flipper_body.apply_impulse(Vec2d.unit() * 40000, (force * 20,0))
#            time.sleep(1.0/1024*5)
  
    def dataRecordLoop(self):
        while (self.running):
#            temp_bic = self.currTrial, self.currGammaDyn, self.currGammaSta, self.elapsedTime_bic, self.angle,  self.lce_bic, self.spikecnt_bic, self.force_bic, self.emg_bic,  self.linearV, self.ind,  self.sinewave[self.ind],  self.timeref_bic
            temp_bic = self.currTrial, self.currGammaDyn, self.currGammaSta, self.force_bic, self.lce_bic, self.emg_bic
            self.data_bic.append(temp_bic)
#            temp_tri = self.currTrial, self.currGammaDyn, self.currGammaSta, self.elapsedTime_tri, self.angle,  self.lce_tri, self.spikecnt_tri, self.force_tri,  self.emg_tri, self.linearV, self.ind,  self.sinewave[self.ind],  self.timeref_tri
            temp_tri = self.currTrial, self.currGammaDyn, self.currGammaSta, self.force_tri, self.lce_tri, self.emg_tri
            self.data_tri.append(temp_tri)
            time.sleep(0.001)
        
        
        
    
#    def point2pointForce(self,  checked):
#        print 'enter'
#        if (checked) :
#            print 'checked'
##            pipeInData_bic = gen_ramp(T = [0.0, 0.1, 0.11, 0.31, 0.32, 2.0], L = [0.0, 0.0, 120000.0, 120000.0, 0.0, 0.0], FILT = False)
#            pipeInData_bic = gen_sin(F = 1.0, AMP = 50000.0,  BIAS = 0.0,  T = 2.0) # was 150000 for CN_general
#            pipeInDataBic=[]
#            for i in xrange(0,  2048):
#                pipeInDataBic.append(max(0.0,  pipeInData_bic[i]))
#             
#                
##            pipeIndata_tri = gen_ramp(T = [0.0, 0.3, 0.31, 0.51, 0.52, 2.0], L = [0.0, 0.0, 120000.0, 120000.0, 0.0, 0.0], FILT = False)
#            pipeIndata_tri = -gen_sin(F = 1.0,  AMP = 50000.0,  BIAS = 0.0,  T = 2.0)
#            pipeInDataTri=[]
#            for i in xrange(0,  2048):
#                pipeInDataTri.append(max(0.0,  pipeIndata_tri[i]))
#
#            xem_cortical_bic.SendPipe(pipeInDataBic)
#            xem_cortical_tri.SendPipe(pipeInDataTri)
#            
#            
#                    
#            xem_cortical_bic.SendButton(True, BUTTON_RESET_SIM) #  
#            xem_cortical_tri.SendButton(True, BUTTON_RESET_SIM) # 
#
#            xem_cortical_bic.SendButton(False, BUTTON_RESET_SIM) #  
#            xem_cortical_tri.SendButton(False, BUTTON_RESET_SIM) #     
        
    def keyControl(self):
        
        while (self.running):
            """ angle calculated from mouse cursor position"""
            mouse_position = from_pygame( Vec2d(self.pygame.mouse.get_pos()), self.screen )
            forced_angle = (mouse_position-self.gForearm_body.position).angle   # calculate angle with mouse cursor loc. 
            
            
#            xem_cortical_bic.SendButton(True, BUTTON_INPUT_FROM_TRIGGER) # BUTTON_INPUT_FROM_TRIGGER = 1
#            xem_cortical_tri.SendButton(True, BUTTON_INPUT_FROM_TRIGGER) # BUTTON_INPUT_FROM_TRIGGER = 1
#            
#            xem_cortical_bic.SendButton(True, BUTTON_RESET_SIM) #  
#            xem_cortical_tri.SendButton(True, BUTTON_RESET_SIM) # 
   
            
            # move the unfired arrow together with the cannon
#            arrow_body.position = cannon_body.position + Vec2d(cannon_shape.radius + 40, 0).rotated(cannon_body.angle)
#            arrow_body.angle = cannon_body.angle
            
#            self.gForearm_body.torque = -0.1 
            """ key control """
            for event in self.pygame.event.get():
                if event.type == QUIT:
                    self.running = False
                elif event.type == KEYDOWN and event.key == K_ESCAPE:
                    self.escape()
                elif event.type == KEYDOWN and event.key == K_p: 
                    self.point2pointForce(True)
                elif event.type == KEYDOWN and event.key == K_j:
                    self.cTorque()   # clock-wise torque
                elif event.type == KEYDOWN and event.key == K_0:
                    self.softReset()
                elif event.type == KEYDOWN and event.key == K_f:
                    self.ccTorque()   # counter-clockwise torque
                elif event.type == KEYDOWN and event.key == K_r:   # selective tonic on
                    self.tonicDrive(200.0) 
                elif event.type == KEYDOWN and event.key == K_y:   # tonic off
                    self.tonicDrive(0.0)
                elif event.type == KEYDOWN and event.key == K_z:
                    self.gForearm_body.angle = 0.0
                elif event.type == KEYDOWN and event.key == K_d:
                    self.currGammaDyn = 0.0
                    self.softReset()
                    self.setGammaDyn()
                elif event.type == KEYDOWN and event.key == K_e:
                    self.currGammaDyn += self.GAMMA_INC
                    self.setGammaDyn()
                elif event.type == KEYDOWN and event.key == K_s:
                    self.currGammaSta = 0.0
                    self.setGammaSta()
                elif event.type == KEYDOWN and event.key == K_w:
                    self.currGammaSta += self.GAMMA_INC
                    self.softReset()
                    self.setGammaSta()
#                elif event.type == KEYDOWN and event.key == K_r:
#                    self.gForearm_body.apply_impulse(Vec2d.unit()*0.1,  (4,  0))
#                elif event.type == KEYDOWN and event.key == K_u:
#                    self.gForearm_body.apply_impulse(Vec2d.unit()*0.1,  (-4,  0))
                    
                elif event.type == KEYDOWN and event.key == K_o:  # set CN syn gain= 50
                    self.corticalGain(50.0) 
                elif event.type == KEYDOWN and event.key == K_m:  # forced movement, follow the mouse    
                    self.mouseOn = True
                elif event.type == KEYDOWN and event.key == K_l:  # doornik replay
                    if (self.record == True):
                        self.record = False
                    if (self.record == False):
                        self.record = True
                    k = 1
                  
                        
            """ mouse cursor controlled forced (passive) movement"""
            if (self.mouseOn == True):
                self.gForearm_body.angle =forced_angle
            
            """ doornik replay """
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
                ps = map(self.toPygame, ps)

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
            fps = 60.0 #was 30.0
            step = 1
            dt = 1.0/fps/step
            
            for x in range(step):
                self.gSpace.step(dt) #(0.001*8) matters, matched with control loop update speed..
                
                self.ind += 1                 
 
            """ text message"""    
            myfont = self.pygame.font.SysFont("monospace", 15)
            label1 = myfont.render("j:torque c, f: torque cc" , 1,  THECOLORS["black"])
            label2 = myfont.render("l: mouse-controlled movement, esc:out" , 1,  THECOLORS["black"])
            label3 = myfont.render("Trial %d/%d, GammaDynBic %.1f, GammaStaBic %.1f" % \
                                        (self.currTrial, self.TOTAL_TRIALS, \
                                        self.currGammaDyn, self.currGammaSta), 1,  THECOLORS["black"])
            label5 = myfont.render("LceBic %.1f, LceTri %.1f" % \
                                        (self.lce_bic, self.lce_tri), 1,  THECOLORS["black"])
            label6 = myfont.render("ForceBic %.1f, ForceTri %.1f" % \
                                        (self.force_bic, self.force_tri), 1,  THECOLORS["black"])
            self.screen.blit(label1, (10, 10))
            self.screen.blit(label2, (10, 30))
            self.screen.blit(label3, (10, 50))
#            self.screen.blit(label4, (10, 70))
            self.screen.blit(label5, (10, 90))
            self.screen.blit(label6, (10, 110))
        
            
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
            
    def timeReference(self):
##        pipeInData =[]
        self.sinewave= gen_sin(F = 10.0, AMP = 0.3,  BIAS = 1.0,  T = 2.0)  #  python only
        
        pipeInData = gen_sin(F = 10.0, AMP = 0.3,  BIAS = 1.0,  T = 2.0) # pipe in to fpga
        xem_spindle_bic.SendPipe2(pipeInData)
        xem_spindle_tri.SendPipe2(pipeInData)
     
    def runExp(self):
        k = PyKeyboard()
        # Resetting both gammas
        k.type_string('s')
        k.type_string('d')
        
        for i in xrange(self.SWEEP_STEP_SIZE):           
            if (self.running):
                # Resetting gammaSta
                k.type_string('s')
                
                for j in xrange(self.SWEEP_STEP_SIZE):           
                    if (self.running):
                        self.currTrial = i*self.SWEEP_STEP_SIZE + j + 1
                    
                        # Reset and cool-down
                        for nagging in xrange(5):
                            k.type_string('0')
                            sleep(0.3)
                    
                        self.strong_damper.damping = 0.0     
                        
                        
                        # Perturbation
                        k.type_string('j')
                        sleep(3)
                        
                        
                        # Increasing gammaSta
                        k.type_string('w')
                        sleep(1.0)
                        
                        
                        # Add a strong damper to stop any motion
                        self.strong_damper.damping = 100.0
                        
                        # attmept to remove the residual torque.
                        bitVal = convertType(0.0, fromType = 'f', toType = 'I')
                        xem_spindle_bic.SendPara(bitVal = bitVal, trigEvent = 1) # Ia gain
                        xem_spindle_tri.SendPara(bitVal = bitVal, trigEvent = 1) 
                        xem_spindle_bic.SendPara(bitVal = bitVal, trigEvent = 10) # II gain
                        xem_spindle_tri.SendPara(bitVal = bitVal, trigEvent = 10) 
                        sleep(2.0)
                        bitVal = convertType(1.2, fromType = 'f', toType = 'I')
                        xem_spindle_bic.SendPara(bitVal = bitVal, trigEvent = 1) # Ia gain
                        xem_spindle_tri.SendPara(bitVal = bitVal, trigEvent = 1)
                        bitVal_II = convertType(2.0, fromType = 'f', toType = 'I') 
                        xem_spindle_bic.SendPara(bitVal = bitVal_II, trigEvent = 10) # II gain
                        xem_spindle_tri.SendPara(bitVal = bitVal_II, trigEvent = 10) 
                
                # Increasing gammaDyn
                k.type_string('e')
                        
        k.tap_key(k.escape_key)
                
        
    def main(self):
#        Process(target=self.controlLoopBiceps)
        self.readData() # read doornik data
        self.timeReference()
        t1 = threading.Thread(target=self.keyControl)
        t2 = threading.Thread(target=self.controlLoopBiceps)
        t3 = threading.Thread(target=self.controlLoopTriceps)
        t4 = threading.Thread(target=self.dataRecordLoop)
        t5 = threading.Thread(target=self.runExp)
        
        t1.start()
        t2.start()
        t3.start()
        t4.start()
        t5.start()
        
        t1.join()
        t2.join()
        t3.join()
        t4.join()
        t5.join()
        
if __name__ == '__main__':
    import sys
    sys.path.append('../../source/py/multC_tester')
    sys.path.append('../../source/py/')
    
    import sys, PyQt4
    from PyQt4.QtGui import QFileDialog

    from PyQt4.QtCore import QTimer,  SIGNAL, SLOT, Qt,  QRect
    from M_Fpga import SomeFpga # Model in MVC   
    from config_test import NUM_NEURON, SAMPLING_RATE, FPGA_OUTPUT_B1, FPGA_OUTPUT_B2, FPGA_OUTPUT_B3,   USER_INPUT_B1,  USER_INPUT_B2,  USER_INPUT_B3
    from Utilities import convertType
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
#    xem_cortical_bic = SomeFpga(NUM_NEURON, SAMPLING_RATE, '12320003RM')
#    xem_cortical_tri = SomeFpga(NUM_NEURON, SAMPLING_RATE, '11160001CJ')
#   

    xem_spindle_tri = SomeFpga(NUM_NEURON, SAMPLING_RATE, '000000054K')
    xem_spindle_bic = SomeFpga(NUM_NEURON, SAMPLING_RATE, '000000054G')
    xem_muscle_bic = SomeFpga(NUM_NEURON, SAMPLING_RATE, '000000053U')
    xem_muscle_tri = SomeFpga(NUM_NEURON, SAMPLING_RATE, '0000000550')
    
#    xemSerialList = ['000000054G', '000000054P',  '000000053U'] # copper top
#    xemSerialList = ['000000054K', '000000053X',  '0000000550'] # copper top
    
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
    
    arm1 = ArmSetup()
    arm1.main() # Start the main loop until ESC     
    
    sys.exit()
