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

class CtrlChannel:
    def __init__(self, hostDialog, id, name, type, value = 0.0):
        exec interp('self.currVal = #{value}')
        self.type = type
        self.id = id

        self.doubleSpinBox = QtGui.QDoubleSpinBox(hostDialog)
        self.doubleSpinBox.setGeometry(QtCore.QRect(230, id * 35, 105, 30))
        self.doubleSpinBox.setProperty("value", value)
        self.doubleSpinBox.setObjectName("param_"+name)
        self.doubleSpinBox.setSingleStep(0.1)
        self.doubleSpinBox.setMaximum(100000.0)
        
        self.label = QtGui.QLabel(hostDialog)
        self.label.setObjectName("label_"+name)
        self.label.setText(name)
        self.label.setGeometry(QtCore.QRect(350, id * 35, 105, 30))
             
         

from Ui_Controls import Ui_Dialog
class SingleDutTester(QDialog, Ui_Dialog):
    """
    GUI class for feeding waveforms or user inputs to OpalKelly boards
    """
    
    
    def __init__(self, nerfModel, dispView, TESTABLE_INPUTS, parent = None):
        """
        Constructor
        """
        QDialog.__init__(self, parent)
        self.setupUi(self)

        self.nerfModel = nerfModel
        self.dispView = dispView

        self.dispView.show()
        self.data = []
        self.isLogData = False

        # Prepare the widgets for each control channel to Fpga
        self.ch_all = {}
        for (id, name, type, value) in TESTABLE_INPUTS:    
            self.ch_all[name] = CtrlChannel(hostDialog=self, id = id, name=name, type=type, value=value) 

        # Timer for pulling data, separated from timer_display
        self.timer = QTimer(self)
        self.connect(self.timer, SIGNAL("timeout()"), self.onTimer)       
        self.timer.start(VIEWER_REFRESH_RATE )
        
        self.on_horizontalSlider_valueChanged(5)   

    def updateTrigger(trigEvent):
        def realUpdateTrigger(function):
            def wrapper(self, *args, **kw):
                newValue = function(self, *args, **kw)
                self.nerfModel.SendPara(newValue, trigEvent)
            return wrapper
        return realUpdateTrigger

    def onTimer(self):
        """
        Core function of Controller, polling data from Model(fpga) and sending to Viewer.
        """
        newData = []
        for xaddr, xtype in zip(DATA_OUT_ADDR, CH_TYPE):
            #newData[i] = self.nerfModel.ReadFPGA(DATA_OUT_ADDR[i], CH_TYPE[i])
#            if i == 3: 
#                newData[i] = newData[i] / 100
            newData.append(max(-16777216, min(16777216, self.nerfModel.ReadFPGA(xaddr, xtype))))
            #print newData[0::6]   # printing 
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
        

        #newSpike = "" # read ## bytes
        
        self.dispView.newDataIO(newData, [newSpike1, newSpike2, newSpike3, newSpike4, newSpike5])
        #self.dispView.newDataIO(newData, [])
        if (self.isLogData):
            self.data.append(newData)          
    
    @updateTrigger(DATA_EVT_CLKRATE) # This nice syntax runs updateTrigger after onClkRate()
    def onClkRate(self, value):   
        """ value = how many times of 1/10 real-time
        """
        # F_fpga = C * NUM_NEURON * V * F_emu ,  (C : cycles_per_neuron = 2,  V = 365)
        # if F_fpga = 200Mhz,  F_emu = 1khz)
        # halfcnt = F_fpga / F_neuron / 2 = F_fpga / (C * NUM_NEURON * V * F_emu) / 2
        NUM_CYCLE = 2
        newHalfCnt = 200 * (10 **6) / (NUM_CYCLE * NUM_NEURON * value * SAMPLING_RATE/10 ) /2 
#        print 'halfcnt=%d' %newHalfCnt
#        print 'value=%d' %value
        return newHalfCnt

        #self.nerfModel.SendPara(bitVal = newHalfCnt, trigEvent = DATA_EVT_CLKRATE)
        
    def tellFpga(self, chanName, newWireIn):
        ctrl = self.ch_all[chanName] # Handle of the Tester channel
        ctrl.currValue = newWireIn
        if (ctrl.type == 'int32'):
            bitVal = convertType(floor(newWireIn),  fromType = 'i',  toType = 'I')
        elif (ctrl.type == 'float32'):
            bitVal = convertType(newWireIn, fromType = 'f', toType = 'I')
        bitVal2 = convertType(1000.0, fromType = 'f', toType = 'I')
        self.nerfModel.SendMultiPara(bitVal1 = bitVal, bitVal2=bitVal2,  trigEvent = ctrl.id)
                

    def plotData(self, data):
        from pylab import plot, show, subplot
        from scipy.io import savemat, loadmat
        import numpy as np
        
        if (data != []):
            forplot = np.array(data)
            for i in xrange(NUM_CHANNEL):
                subplot(NUM_CHANNEL, 1, i+1)
                plot(forplot[:, i])
            show()
            savemat("./matlab_cmn.mat", {"lce": forplot[:, 0], "Ia": forplot[:, 1], \
                                         "II": forplot[:, 2], "force": forplot[:, 3], \
                                         "emg": forplot[:, 4]})
   
    @pyqtSignature("QString")
    def on_comboBox_activated(self, p0):
        """
        Slot documentation goes here.
        """
        choice = p0
        if choice == "Spike Train 1Hz":
#            pipeInData = spike_train(firing_rate = 1) 
            pipeInData = gen_sin(F = 1.0, AMP = 100.0,  T = 2.0)
        elif choice == "Spike Train 10Hz":
#            pipeInData = spike_train(firing_rate = 10)      
#            pipeInData = gen_sin(F = 4.0, AMP = 0.3)
            pipeInData = gen_tri(T = 2.0) 
            
        elif choice == "Spike Train 20Hz":
#            pipeInData = gen_tri() 
            pipeInData = gen_ramp(T = [0.0, 0.1, 0.2, 0.8, 0.9, 2.0], L = [1.0, 1.0, 1.3, 1.3, 1.0, 1.0], FILT = False)
#            pipeInData = gen_ramp(T = [0.0, 0.4, 1.5, 1.55,  1.6,  2.0], L = [0,  0,  15000, 15000, 0, 0], FILT = False)
#                pipeInData = gen_ramp(T = [0.0, 0.2, 0.25, 1.75,  1.8,  2.0], L = [1.0,  1.0,  5000.0, 5000.0, 1.0, 1.0], FILT = False)  # abrupt rise / fall
#            pipeInData = spike_train(firing_rate = 1000) 
        
        self.nerfModel.SendPipe(pipeInData)

    
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
        self.dispView.close()
        self.plotData(self.data)
    
    @pyqtSignature("int")
    def on_horizontalSlider_valueChanged(self, value):
        """
        Slot documentation goes here.
        """
        self.onClkRate(value)
    
    @pyqtSignature("bool")
    def on_pushButton_5_clicked(self, checked):
        """
        Toggle reset_sim, doesn't stop Fpga clock.
        """
        newResetSim = checked
        self.nerfModel.SendButton(newResetSim, BUTTON_RESET_SIM)
    
    @pyqtSignature("bool")
    def on_pushButton_4_clicked(self, checked):
        """
        Slot documentation goes here.
        """
        newResetGlobal = checked
        self.nerfModel.SendButton(newResetGlobal, BUTTON_RESET)
    
    @pyqtSignature("bool")
    def on_pushButtonData_clicked(self, checked):
        """
        Toggling data logging for Matlab use.
        """
        self.isLogData = checked

