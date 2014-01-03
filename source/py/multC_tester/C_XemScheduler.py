# -*- coding: utf-8 -*-

"""
Module implementing Control.
"""

from PyQt4.QtGui import QDialog
from PyQt4.QtCore import pyqtSignature, pyqtSlot
from PyQt4.QtCore import QTimer,  SIGNAL, SLOT, Qt,  QRect
from PyQt4 import QtCore, QtGui

from Utilities import *
from generate_sin import gen as gen_sin
from generate_tri import gen as gen_tri
from generate_spikes import spike_train
from generate_sequence import gen as gen_ramp
from math import floor
import types
from V_Display import *
from functools import partial
#
#def onNewWireIn(self, whichCh, value = -1):
#    if value == -1: 
#        value = self.ch_all[whichCh].doubleSpinBox.value() 
#    self.tellFpga(whichCh, value)
#    print whichCh, " is now ", value
#        

class SingleXemTester(QDialog):
    """
    GUI class for feeding waveforms or user inputs to OpalKelly boards
    """
    def __init__(self, nerfModel, dispView, rawChanList, halfCountRealTime, parent = None):
        """
        Constructor
        """
        QDialog.__init__(self, parent)
#        self.setupUi(self)

        self.nerfModel = nerfModel
        self.dispView = dispView
        self.halfCountRealTime = halfCountRealTime

        #self.dispView.show()
        self.data = []
        self.isLogData = False
        self.running = False
        self.startTime=int(time.time()*1000)  # in milisecond

    def updateTrigger(trigEvent):
        def realUpdateTrigger(function):
            def wrapper(self, *args, **kw):
                newValue = function(self, *args, **kw)
                self.nerfModel.SendPara(newValue, trigEvent)
            return wrapper
        return realUpdateTrigger

    def close(self):
        self.dispView.close()
        self.dispView.plotData(self.data)
        
        
    def startSim(self):
        # hold the simulation until start button is pushed
        if ~self.running:
            self.timer = QTimer(self)
            self.connect(self.timer, SIGNAL("timeout()"), self.onTimer)       
            self.timer.start(REFRESH_RATE )
            self.running = True
#            self.on_horizontalSlider_sliderMoved(self, position):
        

              

    def onTimer(self):
        """
        Core function of Controller, polling data from Model(fpga) and sending to Viewer.
        """
        newData = self.dispView.reportData()
        newData.append(int(time.time()*1000)-self.startTime) # time tag
#        print newData
        #print newData[0::3] 
            #        newSpike1 = self.nerfModel.ReadPipe(0xA0, 5000) # read ## bytes
#        newSpike2 = self.nerfModel.ReadPipe(0xA1, 5000) # read ## bytes
#        newSpike3 = self.nerfModel.ReadPipe(0xA2, 5000) # read ## bytes
#        newSpike4 = self.nerfModel.ReadPipe(0xA3, 5000) # read ## bytes
#        newSpike5 = self.nerfModel.ReadPipe(0xA4, 5000) # read ## bytes
        newSpike1 = ""
        newSpike2 = ""
        newSpike3 = ""
        newSpike4 = ""
        newSpike5 = ""
        
        self.dispView.newDataIO(newData, [newSpike1, newSpike2, newSpike3, newSpike4, newSpike5])
        self.dispView.onTimeOut()
        
        #self.dispView.newDataIO(newData, [])
        if (self.isLogData):
            self.data.append(newData)          
    
    @updateTrigger(TRIG_CLKRATE) # This nice syntax runs updateTrigger after onClkRate()
    def onClkRate(self, value):   
        """ value = how many times of 1/10 real-time
        """
        # F_fpga = C * NUM_NEURON * V * F_emu ,  (C : cycles_per_neuron = 2,  V = 365)
        # if F_fpga = 200Mhz,  F_emu = 1khz)
        # halfcnt = F_fpga / F_neuron / 2 = F_fpga / (C * NUM_NEURON * V * F_emu) / 2
        newHalfCnt = self.halfCountRealTime * 10 / value
        #print 'halfcnt=%d' %newHalfCnt
#        print 'value=%d' %value
        return newHalfCnt

        #self.nerfModel.SendPara(bitVal = newHalfCnt, trigEvent = DATA_EVT_CLKRATE)
        
#    def tellFpga(self, chanName, newWireIn):
#        ctrl = self.ch_all[chanName] # Handle of the Tester channel
#        ctrl.currValue = newWireIn
#        if (ctrl.type == 'int32'):
#            bitVal = convertType(floor(newWireIn),  fromType = 'i',  toType = 'I')
#        elif (ctrl.type == 'float32'):
#            bitVal = convertType(newWireIn, fromType = 'f', toType = 'I')
#        bitVal2 = convertType(1000.0, fromType = 'f', toType = 'I')
#        print "bitval2, ",  bitVal2
#        self.nerfModel.SendMultiPara(bitVal1 = bitVal, bitVal2=bitVal2,  trigEvent = ctrl.id)

            
   
