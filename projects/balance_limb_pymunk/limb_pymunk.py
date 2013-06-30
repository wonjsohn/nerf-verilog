import pygame
from pygame.locals import *
from pygame.color import *
import pymunk
from pymunk import Vec2d
import math, sys, random

M_PI = 3.1415926
JOINT_MIN = -1
JOINT_MAX = 1
JOINT_RANGE = JOINT_MAX - JOINT_MIN

def to_pygame(p):
    """Small hack to convert pymunk to pygame coordinates"""
    return int(p.x), int(-p.y+600)

def angle2length(angle):
    max_length = 1.3
    length = max_length + ((2.0-max_length)-max_length) / (3.14)* (angle- JOINT_MIN)      # angle in rad 
    length = 0.3*angle+1     # angle in rad 
    return length

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
    
#def SineGen():
#    
#    F = 12. # in Hz
#    BIAS = 0.0
#    AMP = 60000.0
#    PHASE = 0.0
#    SAMPLING_RATE = 1024.0
#    dt = 1.0 / SAMPLING_RATE # Sampling interval in seconds
#    periods = 1.0
#
#    w = F * 2 * 3.141592 * dt
#    max_n = 1024; #//floor(periods * SAMPLING_RATE / F)
#    print "max_n =", max_n
#    data=[]
#    for i in xrange(0, max_n):
#        data[i] = AMP * sin(w * i + PHASE) + BIAS;
#
#    return data

    

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
    #forearm_body = pymunk.Body(mass, moment_of_inertia)
    forearm_body = pymunk.Body(mass, 0.0372)
    forearm_body.position = 300, 300
    forearm_shape = pymunk.Poly(forearm_body, [(-x,y) for x,y in fp])
    space.add(forearm_body, forearm_shape)

    elbot_joint_body = pymunk.Body()
    elbot_joint_body.position = forearm_body.position
#    j = pymunk.PinJoint(forearm_body, elbot_joint_body, (0,0), (0,0))
    j = pymunk.RotaryLimitJoint(forearm_body, elbot_joint_body, JOINT_MIN, JOINT_MAX)
    
    JOINT_DAMPING_SCHEIDT2007 = 2.1
    JOINT_DAMPING = JOINT_DAMPING_SCHEIDT2007 * 0.11 #was 0.1
    s = pymunk.DampedRotarySpring(forearm_body, elbot_joint_body, -0.0, 0.0, JOINT_DAMPING)
    space.add(j, s)

    forearm_shape.group = 1
    forearm_shape.elasticity = 0.4
    

    rest_joint_angle = 0.0
    
    ###--- Generate Sine Wave as a voluntary command --- #####
    #sineGen(xem_spindle_bic)
    #sineGen(xem_spindle_tri)
    i = 0
    print sineBic
    print sineTri
    
    
    while running:
        i = i + 1
        j = i % 1024
        print j
        # Get forces
        force_bic_pre = max(0.0, xem_muscle_bic.ReadFPGA(0x32, "float32")) / 128 #- 0.2
        force_tri_pre = max(0.0, xem_muscle_tri.ReadFPGA(0x32, "float32")) / 128 #- 2.64
        force_bic = force_bic_pre #+ pipeInData_bic[j]
        force_tri = force_tri_pre #+ pipeInData_bic[j] 
        forearm_body.torque = (force_bic - force_tri) * 0.06
        
        #lce = 1.0
                             
        angle = ((forearm_body.angle + M_PI) % (2*M_PI)) - M_PI - rest_joint_angle
        
#        lce_bic = angle / (2*M_PI) * 1.5 + rest_len
#        lce_tri = 2 * rest_len - lce_bic 
        
        lce_tri = angle2length(angle)+ 0.02
        lce_bic = 2.04 - lce_tri 
        
        # Send lce of biceps 
        bitVal = convertType(lce_bic, fromType = 'f', toType = 'I')
#        bitVal2 = convertType(0.0,  fromType = 'f', toType = 'I')
        bitVal3 = convertType(sineBic[j],  fromType = 'I', toType = 'I')
        #try M1_extra - 200000
        xem_muscle_bic.SendMultiPara_TEMP(bitVal1 = bitVal, bitVal2 = 200000,  bitVal3 = bitVal3, trigEvent = 9) # bitVal2: extraCN1, bitVal: extraCN2 is int type
#        xem_muscle_bic.SendPara(bitVal = bitVal, trigEvent = 9)
        xem_spindle_bic.SendPara(bitVal = bitVal, trigEvent = 9)
        
        # Alpha-gamma coactivation
#        ag_coact, ag_bias = 30.0, -70.0
        ag_coact, ag_bias = 0.0, 50.0
        gd_bic = force_bic * ag_coact + ag_bias
        bitval = convertType(gd_bic, fromType = 'f', toType = 'I')
#        xem_spindle_bic.SendPara(bitVal = bitval,  trigEvent = 4) # 4 = Gamma_dyn
        
        # Send lce of triceps
        bitVal = convertType(lce_tri, fromType = 'f', toType = 'I')
#        bitVal2 = convertType(1.0,  fromType = 'f', toType = 'I')
    
        bitVal3 = convertType(sineTri[j],  fromType = 'I', toType = 'I')
        xem_muscle_tri.SendMultiPara_TEMP(bitVal1 = bitVal, bitVal2 = 200000,  bitVal3=bitVal3,  trigEvent = 9)  # bitVal2: extraCN1, bitVal: extraCN2 is int type
#        xem_muscle_tri.SendPara(bitVal = bitVal, trigEvent = 9)
        xem_spindle_tri.SendPara(bitVal = bitVal, trigEvent = 9)
        
        # Alpha-gamma coactivation
        gd_tri = force_tri * ag_coact + ag_bias

        bitval = convertType(gd_tri, fromType = 'f', toType = 'I')
#        xem_spindle_tri.SendPara(bitVal = bitval,  trigEvent = 4) # 4 = Gamma_dyn
        
        print "lce0 = %.2f :: lce1 = %.2f :: total_torque = %.2f" % (lce_bic, lce_tri, forearm_body.torque),                           
        print "force0 = %.2f :: force1 = %.2f :: angle = %.2f :: gd_bic = %.2f" % (force_bic, force_tri,  angle,  gd_bic)                            

        
        #r_flipper_body.apply_impulse(Vec2d.unit() * 40000, (force * 20,0))
#        
        for event in pygame.event.get():
            if event.type == QUIT:
                running = False
            elif event.type == KEYDOWN and event.key == K_ESCAPE:
                running = False
            elif event.type == KEYDOWN and event.key == K_j:
                forearm_body.torque -= 20.0
                pass
            elif event.type == KEYDOWN and event.key == K_f:
                #forearm_body.apply_force(Vec2d.unit() * -40000, (-100,0))
                forearm_body.torque += 20.0
            elif event.type == KEYDOWN and event.key == K_z:
                rest_joint_angle = angle 
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
    sys.path.append('../../source/py/multC_tester')
    sys.path.append('../../source/py/')
    from Utilities import *
    from M_Fpga import SomeFpga # Model in MVC   
    from config_test import NUM_NEURON, SAMPLING_RATE, FPGA_OUTPUT_B1, FPGA_OUTPUT_B2, FPGA_OUTPUT_B3,   USER_INPUT_B1,  USER_INPUT_B2,  USER_INPUT_B3
    from generate_sin import gen as gen_sin
    from generate_sequence import gen as gen_ramp
  
    xem_spindle_tri = SomeFpga(NUM_NEURON, SAMPLING_RATE, '12320003RN')
    xem_spindle_bic = SomeFpga(NUM_NEURON, SAMPLING_RATE, '124300046A')
    xem_muscle_bic = SomeFpga(NUM_NEURON, SAMPLING_RATE, '1201000216')
    xem_muscle_tri = SomeFpga(NUM_NEURON, SAMPLING_RATE, '12430003T2')
    
   
    sineBic=sineGen_bic()
    sineTri=sineGen_tri()
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
    
    sys.exit(main())
