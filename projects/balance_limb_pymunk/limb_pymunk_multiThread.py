import pygame
from pygame.locals import *
from pygame.color import *
import pymunk
from pymunk import Vec2d
import math, sys, random
from pylab import *

M_PI = 3.1415926
JOINT_MIN = -1
JOINT_MAX = 1
JOINT_RANGE = JOINT_MAX - JOINT_MIN


def sineGen(xem):
    pipeInData = gen_sin(F = 0.5, AMP = 0.25,  BIAS = 1.15,  T = 2.0) 
    #pipeInData = gen_ramp(T = [0.0, 0.1, 0.11, 0.16, 0.17, 2.0], L = [1.0, 1.0, 1.4, 1.4, 1.0, 1.0], FILT = False)
    print "length :",  len(pipeInData)
    print "pipeInDate is ",  pipeInData
    return pipeInData
#    xem.SendPipe(pipeInData)
#    
def sineGen_bic():
    pipeInData_bic = gen_sin(F = 12.0, AMP = 10000.0,  BIAS = 0.0,  T = 1.0)
    print "length :",  len(pipeInData_bic)
    print pipeInData_bic

    pipeInData_out=[]

        
    for i in xrange(0,  1024):
        pipeInData_out.append(max(0.0,  pipeInData_bic[i]))
        
   
    print "length of Bic pipeInData_out", len(pipeInData_out)
   
    return pipeInData_out
    
def sineGen_tri():
#    pipeInZero512 = [0] * 512
    pipeIndata_tri = -gen_sin(F = 12.0, AMP = 10000.0,  BIAS = 0.0,  T = 1.0)

    pipeInData_out=[]
    for i in xrange(0,  1024):
        pipeInData_out.append(max(0.0,  pipeIndata_tri[i]))
        
   
    print "length of Tri pipeInData_out", len(pipeInData_out)
   
    return pipeInData_out



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

#        fp = [(20,-20), (-120, 0), (20,20)]
        fp = [(40, -5), (30, -15),  (20,-20),   (-150, -10), (-150,  10), (20,20),  (30,  15),  (40,  5)]
 
        mass = 1.52
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
        
        JOINT_DAMPING_SCHEIDT2007 = 2.1
        JOINT_DAMPING = JOINT_DAMPING_SCHEIDT2007 * 0.20 #was 0.1
        s = pymunk.DampedRotarySpring(self.gForearm_body, self.gElbow_joint_body, -0.0, 0.0, JOINT_DAMPING)
        self.gSpace.add(j,  j1,  s) # 
        
        """ create arrow """
        arrow_body,arrow_shape = self.create_arrow()
        self.gSpace.add(arrow_shape)
        
        
        """    """
        self.gForearm_shape.group = 1
        self.gForearm_shape.elasticity = 0.4

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
        

        self.main()
        


    def to_pygame(self,  p):
        """Small hack to convert pymunk to pygame coordinates"""
        return int(p.x), int(-p.y+600)

    def angle2length(self,  angle):
        max_length = 1.3
        length = max_length + ((2.0-max_length)-max_length) / (3.14)* (angle- JOINT_MIN)      # angle in rad 
        length = 0.3*angle+1     # angle in rad 
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
#            force_tri_pre = max(0.0, xem_muscle_tri.ReadFPGA(0x32, "float32")) / 128 #- 2.64
#            emg_tri = xem_muscle_tri.ReadFPGA(0x20, "float32")  # EMG
            
            force_bic = force_bic_pre #+ pipeInData_bic[j]
#            force_tri = force_tri_pre #+ pipeInData_bic[j] 
            self.gForearm_body.torque = (force_bic - self.force_tri) * 0.06
                                            
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
            scale = 1.0
            bitVal_bic_i = convertType(-self.linearV*scale, fromType = 'f', toType = 'I')
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
            
    #        print "lce0 = %.2f :: lce1 = %.2f :: total_torque = %.2f" % (lce_bic, lce_tri, gForearm_body.torque),                           
    #        print "force0 = %.2f :: force1 = %.2f :: angle = %.2f :: gd_bic = %.2f :: angularV =%.2f" % (force_bic, force_tri,  angle,  gd_bic,  angularV )                          
            currentTime = time.time()
            elapsedTime = currentTime- self.start_time
            tempData = elapsedTime,  lce_bic, self.linearV, spikecnt_bic,  force_bic, emg_bic
            self.data_bic.append(tempData)
            #r_flipper_body.apply_impulse(Vec2d.unit() * 40000, (force * 20,0))
    #      
            
            
    def controlLoopTriceps(self):
        
        while self.running:

            """   Get forces   """
#            force_bic_pre = max(0.0, xem_muscle_bic.ReadFPGA(0x32, "float32")) / 128 #- 0.2
#            emg_bic = xem_muscle_bic.ReadFPGA(0x20, "float32")  # EMG         
            spikecnt_tri = xem_muscle_tri.ReadFPGA(0x30, "int32")  
            force_tri_pre = max(0.0, xem_muscle_tri.ReadFPGA(0x32, "float32")) / 128 #- 2.64
            emg_tri = xem_muscle_tri.ReadFPGA(0x20, "float32")  # EMG
            
#            force_bic = force_bic_pre #+ pipeInData_bic[j]
            self.force_tri = force_tri_pre #+ pipeInData_bic[j] 
#            self.gForearm_body.torque = (self.force_bic - self.force_tri) * 0.06
            
            #lce = 1.0
                                 
            #angle = ((self.gForearm_body.angle + M_PI) % (2*M_PI)) - M_PI - self.gRest_joint_angle
            
            
            self.lce_tri = self.angle2length(self.angle)+ 0.02
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
            scale = 1.0
#            bitVal_bic_i = convertType(-linearV*scale, fromType = 'f', toType = 'I')
            bitVal_tri_i = convertType(self.linearV*scale, fromType = 'f', toType = 'I')
            
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
            tempData = elapsedTime, self.lce_tri, self.linearV, spikecnt_tri,   self.force_tri,  emg_tri  
            self.data_tri.append(tempData)
            #r_flipper_body.apply_impulse(Vec2d.unit() * 40000, (force * 20,0))
  
            
    def keyControl(self):
        while (self.running):
            
            mouse_position = from_pygame( Vec2d(self.pygame.mouse.get_pos()), self.screen )
            forced_angle = (mouse_position-self.gForearm_body.position).angle

            # move the unfired arrow together with the cannon
#            arrow_body.position = cannon_body.position + Vec2d(cannon_shape.radius + 40, 0).rotated(cannon_body.angle)
#            arrow_body.angle = cannon_body.angle
            
        
            """ key control """
            for event in self.pygame.event.get():
                if event.type == QUIT:
                    self.running = False
                elif event.type == KEYDOWN and event.key == K_ESCAPE:
                    self.plotData(self.data_bic, self.data_tri)
                    self.running = False
                elif event.type == KEYDOWN and event.key == K_j:
                    self.gForearm_body.torque -= 30.0
                    pass
                elif event.type == KEYDOWN and event.key == K_f:
                    #self.gForearm_body.apply_force(Vec2d.unit() * -40000, (-100,0))
                    self.gForearm_body.torque += 30.0
                elif event.type == KEYDOWN and event.key == K_z:
                    self.gRest_joint_angle = self.angle
                elif event.type == KEYDOWN and event.key == K_r:
                    self.gForearm_body.apply_impulse(Vec2d.unit()*0.1,  (5,  0))
                elif event.type == KEYDOWN and event.key == K_u:
                    self.gForearm_body.apply_impulse(Vec2d.unit()*0.1,  (-5,  0))
                elif event.type == KEYDOWN and event.key == K_l:  # forced movement, follow the mouse
                    if (self.record == True):
                        self.record = False
                    if (self.record == False):
                        self.record = True
                        
                    
            if (self.record == True):
                self.gForearm_body.angle =forced_angle
                

                    
            """  Clear screen  """
            self.screen.fill(THECOLORS["white"])  # ~1ms

            """ Draw stuff """
            for f in [self.gForearm_shape,]:
                ps = f.get_points()
                ps.append(ps[0])
                ps = map(self.to_pygame, ps)

                color = THECOLORS["red"]
                self.pygame.draw.lines(self.screen, color, False, ps)
            #if abs(flipper_body.angle) < 0.001: flipper_body.angle = 0

            """ Update physics  """
            dt = 1.0/60.0/5.
            for x in range(5):
                self.gSpace.step(dt)
            
            """ text message"""    
            myfont = self.pygame.font.SysFont("monospace", 15)
            label1 = myfont.render("j:torque down, f: torque up" , 1,  THECOLORS["black"])
            label2 = myfont.render("l: mouse-controlled movement, esc:out" , 1,  THECOLORS["black"])
            self.screen.blit(label1, (10, 10))
            self.screen.blit(label2, (10, 40))
        
            
            """ Flip screen (big delay from here!) """ 
            self.pygame.display.flip()  # ~1ms
            self.gClock.tick(30)  # target fps
    #        self.gClock.tick(80)  # oscillate
            self.pygame.display.set_caption("fps: " + str(self.gClock.get_fps())) 
            
            
 

    def main(self):
#        Process(target=self.controlLoopBiceps)
        threading.Thread(target=self.keyControl).start()
        threading.Thread(target=self.controlLoopBiceps).start()
        threading.Thread(target=self.controlLoopTriceps).start()
        
        
        
        

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
  

    
  
    xem_spindle_tri = SomeFpga(NUM_NEURON, SAMPLING_RATE, '12320003RN')
    xem_spindle_bic = SomeFpga(NUM_NEURON, SAMPLING_RATE, '124300046A')
    xem_muscle_bic = SomeFpga(NUM_NEURON, SAMPLING_RATE, '1201000216')
    xem_muscle_tri = SomeFpga(NUM_NEURON, SAMPLING_RATE, '12430003T2')
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
