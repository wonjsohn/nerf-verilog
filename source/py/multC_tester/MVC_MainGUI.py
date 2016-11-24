# -*- coding: utf-8 -*-

"""
Module implementing Control.
"""

from PyQt4.QtGui import QDialog
from PyQt4.QtCore import pyqtSignature, pyqtSlot
from PyQt4.QtCore import QTimer,  SIGNAL, SLOT, Qt,  QRect
from PyQt4 import QtCore, QtGui

import sys
import glob
import errno
import sys, PyQt4

from Utilities import *
from generate_sin import gen as gen_sin
from generate_tri import gen as gen_tri
from generate_spikes import spike_train
from generate_sequence import gen as gen_ramp
from math import floor,  pi
import types
from functools import partial
#from par_search import muscle_properties
from Utilities import convertType
#from M_Fpga import SendPara
from loadMatTest import loadMat as loadMat
from time import sleep
import threading
import time
import multiprocessing
import glob
import logging

from Ui_MVC_MainGUI import Ui_Dialog

try:
    _fromUtf8 = QtCore.QString.fromUtf8
except AttributeError:
    _fromUtf8 = lambda s: s

class MultiXemScheduler(QDialog, Ui_Dialog):
    """
    GUI class for feeding waveforms or user inputs to OpalKelly boards
    """
    def __init__(self, xemList, cList, vList,  halfCountRealTime, viewOn, parent = None):
        """
        Constructor
        """
        QDialog.__init__(self, parent)
        self.setupUi(self)
        self.move(300, 10)   # windows position
        self.xemList = xemList
        self.cList = cList
        self.vList = vList
        self.halfCountRealTime = halfCountRealTime
        self.viewOn = viewOn

#        self.cList.setWindowTitle('Global Control')
        #self.cList.show() 

#        self.jointAngle = 0.0  # initial joint 
#        self.best_ForceDiff = 1.0 * 0xFFFF  #inital muscle length difference (arbitrary)
#        self.start = False
       
       
        
        self.onClkRate(10) 
#        self.startSim()
        
    def o(self):
        print "close the window"
        self.close()

    def onClkRate(self, value):   
        """ value = how many times of 1/10 real-time, 100 is real time...
        """
        # F_fpga = C * NUM_NEURON * V * F_emu ,  (C : cycles_per_neuron = 2,  V = 365)
        # if F_fpga = 200Mhz,  F_emu = 1khz)
        # halfcnt = F_fpga / F_neuron / 2 = F_fpga / (C * NUM_NEURON * V * F_emu) / 2
        
        #self.clkRate = value
       
        
        newHalfCnt = self.halfCountRealTime * 10 / value  * 10  # * 10 added later for slow emulation       
        print value,  newHalfCnt
        
        for eachXem in self.xemList:
            eachXem.SendPara(bitVal = newHalfCnt, trigEvent = 7)
#
    @pyqtSignature("int")
    def on_horizontalSlider_sliderMoved(self, position):
        """
        Slot documentation goes here.
        """
        self.onClkRate(position)

    @pyqtSignature("bool")
    def on_pushButton_2_clicked(self, checked):
        """
        Slot documentation goes here.
        """
        for eachC in self.cList:
            eachC.close()

    @pyqtSignature("int")
    def on_horizontalSlider_valueChanged(self, value):
        """
        Slot documentation goes here.
        """
        self.onClkRate(value)

    @pyqtSignature("bool")
    def on_pushButton_4_clicked(self, checked):
        """
        Slot documentation goes here.
        """
        newResetGlobal = checked
        for eachXem in self.xemList:
            eachXem.SendButton(newResetGlobal, BUTTON_RESET)
#        self.xemList[1].SendButton(newResetGlobal, BUTTON_RESET)

    @pyqtSignature("bool")
    def on_pushButtonData_clicked(self, checked):
        """
        Toggling data logging for Matlab use.
        """
        for eachC in self.cList:
            eachC.isLogData = checked

    # this button starts the simulation 
    @pyqtSignature("bool")
    def on_pushButton_clicked(self, checked):
        """
        Slot documentation goes here.
        """
#        self.running = True

        for eachC in self.cList:
            eachC.startSim()
            
#        
#        for eachV in self.vList:
#            print eachV
#            eachV.readParameters()

    
    @pyqtSignature("bool")
    def on_pushButton_burn_clicked(self, checked):
        """
        Slot documentation goes here.
        """
        bitFileList = []
        for eachV in self.vList:
            bitFileList.append(str(eachV.listWidget.currentItem().text()))
         
        print bitFileList
        for eachXem, eachBitFile in zip(self.xemList, bitFileList):
            eachXem.BurnBitFile(eachBitFile)
    
    @pyqtSignature("bool")
    def on_pushButton_reset_sim_clicked(self, checked):
        """
        Slot documentation goes here.
        """
        print checked
        newResetSim = checked
        for eachXem in self.xemList:
            eachXem.SendButton(newResetSim, BUTTON_RESET_SIM)
    
   
#    @pyqtSignature("bool")
#    def on_checkBox_clicked(self, checked):
#        """
#        Slot documentation goes here.
#        """
#  
#        if (checked):
#            print "waveform sine_bic fed"
#    #            pipeInData = spike_train(firing_rate = 10)      
#            #pipeInData = gen_sin(F = 0.5, AMP = 5000.0,  BIAS = 5001.0,  T = 2.0) 
#    #            pipeInData = gen_tri(T = 2.0) 
#
#            pipeInData_bic = gen_sin(F = 1.0, AMP = 50000.0,  BIAS = 0.0,  T = 2.0) # was 150000 for CN_general
#
#            pipeInDataBic=[]
#            for i in xrange(0,  2048):
#                pipeInDataBic.append(max(0.0,  pipeInData_bic[i]))
#
#
#    #        elif choice == "middleBoard_sine_Tri":
#            print "waveform sine_tri fed"
#
#            pipeIndata_tri = -gen_sin(F = 1.0,  AMP = 50000.0,  BIAS = 0.0,  T = 2.0)
#
#            pipeInDataTri=[]
#            for i in xrange(0,  2048):
#                pipeInDataTri.append(max(0.0,  pipeIndata_tri[i]))
#   
#
#            self.xemList[0].SendPipe(pipeInDataBic)
#            self.xemList[1].SendPipe(pipeInDataTri)
#    

    @pyqtSignature("bool")
    def on_checkBox_clicked(self, checked):
        """
        Slot documentation goes here.
        """
  
        if (checked):
            print "waveform sine_bic fed"
    #            pipeInData = spike_train(firing_rate = 10)      
            #pipeInData = gen_sin(F = 0.5, AMP = 5000.0,  BIAS = 5001.0,  T = 2.0) 
    #            pipeInData = gen_tri(T = 2.0) 

            pipeInData_bic = gen_sin(F = 0.5, AMP = 50000.0,  BIAS = 0.0,  T = 2.0) # was 150000 for CN_general
#            pipeInData_bic = gen_ramp(T = [0.0, 0.01, 0.02,  0.22, 0.23, 2.0], L = [0.0, 0.0, 120000.0, 120000.0, 0.0, 0.0], FILT = False)
            

            pipeInDataBic=[]
            for i in xrange(0,  2048):
                pipeInDataBic.append(max(0.0,  pipeInData_bic[i]))


    #        elif choice == "middleBoard_sine_Tri":
            print "waveform sine_tri fed"

            pipeIndata_tri = -gen_sin(F = 0.5,  AMP = 50000.0,  BIAS = 0.0,  T = 2.0)
#            pipeIndata_tri = gen_ramp(T = [0.0, 0.21, 0.22, 0.42, 0.43, 2.0], L = [0.0, 0.0, 120000.0, 120000.0, 0.0, 0.0], FILT = False)
            
            pipeInDataTri=[]
            for i in xrange(0,  2048):
                pipeInDataTri.append(max(0.0,  pipeIndata_tri[i]))
   

            self.xemList[0].SendPipe(pipeInDataTri)
            self.xemList[1].SendPipe(pipeInDataBic)
    
  
   
#
    
    @pyqtSignature("int")
    def on_horizontalSlider_2_valueChanged(self, value):
        """
        Slot documentation goes here.
        """
        inputvalue = value*0.01
        for eachV in self.vList:
            eachV.tellFpga('overflow', inputvalue)
    
    
    @pyqtSignature("int")
    def on_horizontalSlider_2_sliderMoved(self, position):
        """
        Slot documentation goes here.
        """
        inputvalue = position*0.01
        print inputvalue
        for eachV in self.vList:
            eachV.tellFpga('overflow', inputvalue)
#


    # logging.basicConfig(level=logging.DEBUG,
    #                     format='(%threadName) -9s) %(messages)s',)

    @pyqtSignature("bool")
    def on_checkBox_2_clicked(self, checked):
        """
        Slot documentation goes here.
        """
        if (checked):




# #            bitVal1 = convertType(400.0, fromType = 'f', toType = 'I')
# #            bitVal2 = convertType(100.0, fromType = 'f', toType = 'I')
#             # TODO: not implemented yet
#             self.xemList[0].SendPara(bitVal = 1000, trigEvent = 8)
#             self.xemList[1].SendPara(bitVal = 5000, trigEvent = 8)
            print self.xemList[0],  self.xemList[1], self.xemList[2]


            #p = multiprocessing.Process(target=self.pipeinloop, name="pipeinloop", args=())
            if self.viewOn:
                self.pipeinloop( filepath = "C:\Users\wonjsohn\Dropbox\BBDL_data\sliceBy4Output\\", fileId = "Gd0_Gs200_c3_v4")
            else:
                p1=threading.Thread(target=self.pipeinloop, name='pipeinloop', args=("C:\Users\wonjsohn\Dropbox\BBDL_data\sliceBy4Output\\", "Gd0_Gs0_c3_v1",))
                p2=threading.Thread(target=self.timer, name='timer')
                p1.start()
                p2.start()

                p1.join()
                p2.join()







        
        # else:
            # bitVal = convertType(0.0, fromType = 'f', toType = 'I')
            #
            # # TODO: not implemented yet
            # self.xemList[0].SendPara(bitVal = bitVal, trigEvent = 8)
            # self.xemList[1].SendPara(bitVal = bitVal, trigEvent = 8)
    def timer(self):
         n=1
         # for num in range(1,2):
         #    time.sleep(32)
         #    print time.time()
         #    n = n+1
         #    print n
         time.sleep(48)
            # save data to mat file at this time
         for eachC in self.cList:
            eachC.close()
            print "savefile called"

                # logging.debug('in for loop')
         #self.on_pushButton_2_clicked(True) # close all
         # logging.debug('Exiting')


    def pipeinloop(self, filepath, fileId):
        # use glob.glob("C:\Users\wonjsohn\Dropbox\BBDL_data\sliceBy4Output\\*.mat"
        # logging.debug('starting')
        # filepath = "C:\Users\wonjsohn\Dropbox\BBDL_data\sliceBy4Output\\"
        # fileId = "2_0_0_1_2"
        for eachV in self.vList:
            eachV.fileId = fileId
        filename = fileId+".mat"
        [flexorLengthThisGamma, GdArray ,GsArray, cortical, vel] = loadMat(filepath, filename)
        print  GdArray[0][0],  GsArray[0][0], cortical[0][0], vel[0][0]
        pipeInData = flexorLengthThisGamma
        self.xemList[0].SendPipe(pipeInData)
        self.xemList[2].SendPipe(pipeInData)
        bitVal = convertType(3810,  fromType = 'i',  toType = 'I')
        #self.on_spinBox_valueChanged(bitVal)  # set clock 1/10th of real time. (int)
        time.sleep(0.1)
        for eachXem in self.xemList:
            eachXem.SendPara(bitVal = bitVal, trigEvent = 7)
            time.sleep(0.1)

        time.sleep(0.1)
        # print GdArray[0][0],  GsArray[0][0], cortical[0][0]
        #bitVal = convertType( GdArray[0][0], fromType = 'f', toType = 'I')
        # self.xemList[0].SendPara(bitVal = bitVal,  trigEvent = 4) # 4 (float) - Gd
        self.vList[0].tellFpga('gamma_dyn', GdArray[0][0]);
        # bitVal = convertType( GsArray[0][0], fromType = 'f', toType = 'I')
        # self.xemList[0].SendPara(bitVal = bitVal, trigEvent =5) # 5 (float) - Gs
        self.vList[0].tellFpga('gamma_sta', GsArray[0][0]);
        time.sleep(0.1)
        # bitVal = convertType(cortical[0][0],  fromType = 'i',  toType = 'I')
        # self.xemList[1].SendPara(bitVal =bitVal , trigEvent =8) # 8 (int) - cortical tonic drive
        if  cortical[0][0] == 1:
            cdrive = 0
        elif cortical[0][0] == 2:
            cdrive = 900
        else:
            cdrive = 1250

        print cdrive
        self.vList[1].tellFpga('i_CN1_extra_drive', cdrive);
        # bitVal = convertType(70.0,  fromType = 'f', toType = 'I')                       # SOMETHING REALLY BAD
        # self.xemList[2].SendPara(bitVal = 70.0, trigEvent =3) # 3 syn_Ia_gain(float)   # SOMETHING REALLY BAD
        time.sleep(0.1)
        self.vList[2].tellFpga('syn_Ia_gain',  60.0);
        time.sleep(0.1)
        # bitVal = convertType(1, fromType = 'i',  toType = 'I')
        # self.xemList[2].SendPara(bitVal = bitVal, trigEvent =6) # 6 s_weight(int)
        self.vList[2].tellFpga('syn_CN_gain',  200.0);
        time.sleep(0.1)
        self.vList[2].tellFpga('syn_II_gain',  60.0);
        time.sleep(0.1)
        self.vList[0].tellFpga('spindl_Ia_offset',  250.0);
        time.sleep(0.1)
        self.vList[0].tellFpga('spindl_II_offset',  50.0);
        time.sleep(0.1)
        self.vList[2].tellFpga("b1", 0.002459);  #
        time.sleep(0.1)
        self.vList[0].tellFpga('gamma_dyn',  GdArray[0][0]);
        time.sleep(0.1)
        self.vList[0].tellFpga('gamma_sta',  GsArray[0][0]);
        time.sleep(0.1)
        self.vList[2].tellFpga('s_weight',  1);
        time.sleep(0.1)
        self.vList[2].tellFpga('muscleVelGain',  1.0);
        time.sleep(0.1)

        bitVal = convertType(1,  fromType = 'i',  toType = 'I') # reset sim to start pipe from the beginning
        self.on_pushButton_reset_sim_clicked(bitVal)
        time.sleep(0.1)
        bitVal = convertType(0,  fromType = 'i',  toType = 'I')
        self.on_pushButton_reset_sim_clicked(bitVal)
        self.vList[0].on_checkBox_2_clicked(1) # input from trigger
        self.vList[2].on_checkBox_2_clicked(1) # input from trigger
        self.on_pushButtonData_clicked(1)# data logging start
        print time.time()
        # logging.debug('Exiting')








    
    
    @pyqtSignature("int")
    def on_spinBox_valueChanged(self, newHalfCnt):
        """
        half count direct input to all boards
        """
        # TODO: not implemented yet
        for eachXem in self.xemList:
            eachXem.SendPara(bitVal = newHalfCnt, trigEvent = 7)

