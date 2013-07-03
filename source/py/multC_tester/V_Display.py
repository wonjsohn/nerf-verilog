# -*- coding: utf-8 -*-

"""
Module implementing MainWindow.
"""

from PyQt4 import QtCore, QtGui
from PyQt4.QtGui import QMainWindow
from PyQt4.QtCore import pyqtSignature
from PyQt4.QtCore import QTimer,  SIGNAL, SLOT, Qt,  QRect
from PyQt4.QtGui import QPainter, QRegion, QPen
import sys, random
from struct import unpack
from Utilities import *
from collections import deque
from generate_sin import gen as gen_sin
from generate_tri import gen as gen_tri
from generate_spikes import spike_train
from generate_sequence import gen as gen_ramp
from functools import partial
from math import floor
from glob import glob

PIXEL_OFFSET = 200 # pixels offsets
BUTTON_INPUT_FROM_TRIGGER = 1

from Ui_V_Display import Ui_Dialog
import time


class CtrlChannel:
    def __init__(self, hostDialog, id, name, type, value = 0.0):
        exec interp('self.currVal = #{value}')
        self.type = type
        self.id = id
        self.defaultValue = value

        self.doubleSpinBox = QtGui.QDoubleSpinBox(hostDialog)
        self.doubleSpinBox.setStyleSheet("background-color: rgb(255, 255, 255);"
                                        "border:1px solid rgb(100, 200, 255);"
                                        "max-width: 90px;"
                                        "max-height: 20px;")
                                        #"border-left: 1px solid none;"
                      # "border-right: 1px solid none; border-bottom: 1px solid black; width: 0px; height: 0px;")
        SPINBOX_VOFFSET = 130
        SPINBOX_HOFFSET = 180
        self.doubleSpinBox.setGeometry(QtCore.QRect(SPINBOX_HOFFSET + 620, SPINBOX_VOFFSET+ id * 30, 205, 30))
        self.doubleSpinBox.setSingleStep(0.000001)
        self.doubleSpinBox.setDecimals(6)
        self.doubleSpinBox.setMaximum(100000.0)
        self.doubleSpinBox.setMinimum(-100000.0)
        self.doubleSpinBox.setProperty("value", value)
        self.doubleSpinBox.setObjectName("param_"+name)


        self.label = QtGui.QLabel(hostDialog)
        self.label.setObjectName("label_"+name)
        self.label.setText(name)
        self.label.setGeometry(QtCore.QRect(SPINBOX_HOFFSET + 510, SPINBOX_VOFFSET+ id * 30, 105, 30))           

class ViewChannel:
    def __init__(self, hostDialog, name, id, width = 2, color = Qt.blue, addr = 0x20, type = ""):
        self.id = id
        self.width = width
        self.color = color
        self.vscale = 0.0
        self.yoffset = 1.0
        self.addr = addr
        self.type = type

        self.data = deque([0]*100, maxlen=100)
        self.slider = QtGui.QSlider(hostDialog)
        self.slider.setGeometry(QtCore.QRect(100, 70+ id*80, 29, 80))
        self.slider.setOrientation(QtCore.Qt.Vertical)
        self.slider.setObjectName("gain_"+name)

        self.label = QtGui.QLabel(hostDialog)
        pal = self.label.palette()
        pal.setColor( QtGui.QPalette.Foreground, color )
        self.label.setPalette(pal)
        self.label.setObjectName("label_"+name)
        self.label.setText(name)
        self.label.setGeometry(QtCore.QRect(10, 70+ id*80, 80, 100))
        self.label.show()


def onVisualSlider(self, whichCh, value = -1):
    if value == -1: value = self.allFpgaOutput[whichCh].slider.value()
    self.allFpgaOutput[whichCh].vscale = value * 0.5   
    print "VisualGain of ", whichCh, " is now ", value


def onNewWireIn(self, whichCh, value = -1):
    if value == -1: 
        value = self.allUserInput[whichCh].doubleSpinBox.value()         
    self.tellFpga(whichCh, value)
    #self.tellWhichFpga(0, whichCh, value)
    print "board",  whichCh, " is now ", value



class View(QMainWindow, Ui_Dialog):
    """
    Class View inherits the GUI generated by QtDesigner, and add customized actions
    """
    def __init__(self, count, projectName,  projectPath,  nerfModel,  fpgaOutput= [], userInput = [],  parent = None):
        """
        Constructor
        """
        self.nerfModel = nerfModel
#        QMainWindow.__init__(self, parent, Qt.FramelessWindowHint)
        QMainWindow.__init__(self, parent)
        self.setStyleSheet("background-color:  rgb(240, 235, 235); margin: 2px;")
        self.setWindowOpacity(0.75)

#                                    "QLineEdit { border-width: 20px;border-style: solid; border-color: darkblue; };")
        self.setupUi(self)
        self.projectName = projectName
        self.move(10+count*450,  100)

        self.x = 200
        self.pen = QPen()

        self.numPt = PIXEL_OFFSET
        self.isPause = False
        self.NUM_CHANNEL = len(fpgaOutput)
        self.setWindowTitle(projectPath)

        # Search all .bit files, make them selectable 
        sys.path.append(projectPath)
        import os
        print projectPath
        for eachBitFile in glob(projectPath+"/*.bit"): 
#            (filepath, filename) = os.path.split(eachBitFile) 
            self.listWidget.addItem(eachBitFile)
        self.listWidget.setCurrentRow(0)
        self.listWidget.setStyleSheet("background-color:  rgb(220, 235, 235); margin: 2px;")


        # Prepare 
         # Prepare the widgets for each control channel to Fpga
        self.allUserInput = {}
        for (id, name, type, value) in userInput: 
            if name != 'xxx':
                self.allUserInput[name] = CtrlChannel(hostDialog=self, id = id, name=name, type=type, value=value) 

        # VERY important: dynamically connect SIGNAL to SLOT, with curried arguments
        for eachName, eachChan in self.allUserInput.iteritems():
            fn = partial(onNewWireIn, self, eachName) # Customizing onNewWireIn() into channel-specific 
            eachChan.doubleSpinBox.valueChanged.connect(fn)
            eachChan.doubleSpinBox.editingFinished.connect(fn)    
            fn(eachChan.defaultValue)

        # Prepare the widgets for each Display channel 
        self.allFpgaOutput = {}
        for i, (addr, name, visual_gain, type, color) in enumerate(fpgaOutput):
            if name != 'blank':
                self.allFpgaOutput[name] = ViewChannel(hostDialog=self, name=name, id=i, color = color, addr = addr, type = type)

        for eachName, eachChan in self.allFpgaOutput.iteritems():
            fn = partial(onVisualSlider, self, eachName) # Customizing onNewWireIn() into channel-specific 
            eachChan.slider.valueChanged.connect(fn)    

    def individualWireIn(self, whichCh, value = -1):
        if value == -1: 
            value = self.allUserInput[whichCh].doubleSpinBox.value()         
        self.tellFpga(whichCh, value)
        #self.tellWhichFpga(0, whichCh, value)
        print "board",  whichCh, " is now ", value

    def readParameters(self):        
        for eachName, eachChan in self.allUserInput.iteritems():
            val = eachChan.doubleSpinBox.value()   
            print eachName, val
            self.individualWireIn(eachName, val)


    def plotData(self, data):
        from pylab import plot, show, subplot, title
        from scipy.io import savemat, loadmat
        import numpy as np

        dim = np.shape(data)
        if (data != []):
            forplot = np.array(data)
            i = 0
            for eachName, eachChan in self.allFpgaOutput.iteritems():
                subplot(dim[1], 1, i+1)

                plot(forplot[:, i])
                title(eachName)
                i = i + 1
                #
            show()
            timeTag = time.strftime("%Y%m%d_%H%M%S")
            savemat(self.projectName+"_"+timeTag+".mat", {eachName: forplot[:, i] for i, eachName in enumerate(self.allFpgaOutput)})


    def reportData(self):
        newData = []
        for name, chan in self.allFpgaOutput.iteritems(): # Sweep thru channels coming out of Fpga
            #newData.append(max(-16777216, min(16777216, self.nerfModel.ReadFPGA(chan.addr, chan.type))))  # disable range limitation for spike raster
            newData.append(self.nerfModel.ReadFPGA(chan.addr, chan.type))
#            newData.append(self.nerfModel.ReadFPGA(chan.addr, chan.type))
        return newData


    def newDataIO(self, newData, newSpikeAll = []):
        for (name, ch), pt in zip(self.allFpgaOutput.iteritems(), newData):
            ch.data.appendleft(pt)
            ch.label.setText("%4.6f" % pt)      

        self.spike_all = newSpikeAll

    def onTimeOut(self):
        if (self.isPause):
            return
        size = self.size()
        self.update(QRect(self.x+ 1, 0,size.width() - self.x,size.height()))

        if (self.x < size.width() *0.7):  # display line width adjustment
            self.x = self.x + 1  
        else:
            self.x = PIXEL_OFFSET 

    def onChInGain(self):
        for ch in self.allFpgaOutput:
            ch.vscale = ch.slider.value()* 0.1   

    def paintEvent(self, e):
        """ 
        Overload the standard paintEvent function
        """

        #p = QPainter(self.graphicsView)                         ## our painter
        canvas = QPainter(self)                         ## our painter

        for name, ch in self.allFpgaOutput.iteritems():
            if ch.type == "spike32":
                self.drawRaster(canvas, ch)
            else:
                self.drawPoints(canvas, ch)          ## paint clipped graphics

    def drawRaster(self, gp, ch):           
        size = self.size()
        winScale = size.height()*0.2 + size.height()*0.618/self.NUM_CHANNEL * 4;
        self.pen.setStyle(Qt.SolidLine)
        self.pen.setWidth(2)
        self.pen.setBrush(ch.color)
        self.pen.setCapStyle(Qt.RoundCap)
        self.pen.setJoinStyle(Qt.RoundJoin)
        gp.setPen(self.pen)
        
        yOffset = int(size.height()*0.20 + size.height()*0.818/self.NUM_CHANNEL * ch.id)
        bit_mask = 0x0000001
        ## display the spike rasters
#        print ch.data[0]
        spike_train = int(ch.data[0])
        #print spike_train
        for i in xrange(32):
            ## flexors
            if (bit_mask & spike_train) : ## Ia
                gp.drawLine(self.x-10, yOffset - 32 + i ,\
                                 self.x+10, yOffset - 32 + i)
            bit_mask = bit_mask << 1

    def drawRaster_old(self, gp):
        for spkid, i_mu in zip(self.spike_all,  xrange(len(self.spike_all))):
            spikeSeq = unpack("%d" % len(spkid) + "b", spkid)

            size = self.size()
            winScale = size.height()*0.2 + size.height()*0.618/self.NUM_CHANNEL * 4;
            self.pen.setStyle(Qt.SolidLine)
            self.pen.setWidth(1)
            self.pen.setBrush(Qt.blue)
            self.pen.setCapStyle(Qt.RoundCap)
            self.pen.setJoinStyle(Qt.RoundJoin)
            gp.setPen(self.pen)
            ## display the spike rasters
            for i in xrange(0, len(spikeSeq), 2):
                neuronID = spikeSeq[i+1]
                rawspikes = spikeSeq[i]
                ## flexors
                if (rawspikes & 64) : ## Ia
                    gp.drawLine(self.x-2,(winScale) - 22 + i ,\
                                     self.x, (winScale) -  22 + i)
                if (rawspikes & 128) : ## MN
    #                gp.drawPoint(self.x, (winScale) - 24 - (neuronID/4)   ) 
                    gp.drawLine(self.x-2,(winScale) +22 - (neuronID/4)*0 + i_mu * 15 ,\
                                     self.x, (winScale) + 26 - (neuronID/4) *0 + i_mu * 15)

    def drawPoints(self, qp, ch):
        """ 
        Draw a line between previous and current data points.
        """
        size = self.size()


        #for name, ch in allFpgaOutput.iteritems():
        self.pen.setStyle(Qt.SolidLine)
        self.pen.setWidth(2)
        self.pen.setBrush(ch.color)
        self.pen.setCapStyle(Qt.RoundCap)
        self.pen.setJoinStyle(Qt.RoundJoin)
        qp.setPen(self.pen)


        yOffset = int(size.height()*0.20 + size.height()*0.818/self.NUM_CHANNEL * ch.id)
        y0 = yOffset - ch.data[1] * ch.vscale
        y1 = yOffset - ch.data[0] * ch.vscale

#        print "self.x=",  self.x
#        print "y0=" ,  y0
#        print "y1=" ,  y1
        qp.drawLine(self.x - 1 , y0, self.x + 1 , y1)



    def tellFpga(self, chanName, newWireIn):
        ctrl = self.allUserInput[chanName] # Handle of the Tester channel
        ctrl.currValue = newWireIn
        if (ctrl.type == 'int32'):
            bitVal = convertType(floor(newWireIn),  fromType = 'i',  toType = 'I')
        elif (ctrl.type == 'float32'):
            bitVal = convertType(newWireIn, fromType = 'f', toType = 'I')
#        bitVal2 = convertType(0.0, fromType = 'f', toType = 'I')
#        print "bitval2, ",  bitVal2
        self.nerfModel.SendMultiPara(bitVal1 = bitVal, bitVal2=0,  trigEvent = ctrl.id)
        
       

    def tellWhichFpga(self, xemNum, chanName, newWireIn):
        ctrl = self.allUserInput[chanName] # Handle of the Tester channel
        ctrl.currValue = newWireIn
        if (ctrl.type == 'int32'):
            bitVal = convertType(floor(newWireIn),  fromType = 'i',  toType = 'I')
        elif (ctrl.type == 'float32'):
            bitVal = convertType(newWireIn, fromType = 'f', toType = 'I')
        bitVal2 = convertType(0.0, fromType = 'f', toType = 'I') # velocity
        self.nerfModel[xemNum].SendMultiPara(bitVal1 = bitVal, bitVal2=bitVal2,  trigEvent = ctrl.id)


    @pyqtSignature("QString")
    def on_comboBox_activated(self, p0):
        """
        Slot documentation goes here.
        """
        choice = p0
        if choice == "waveform 1":
#            pipeInData = gen_ramp(T = [0.0, 0.1, 0.3, 1.0, 1.2, 2.0], L = [0.0, 0.0, 120000.0, 120000.0, 0.0, 0.0], FILT = False)
            #pipeInData = gen_ramp(T = [0.0, 0.1, 0.3, 1.0, 1.2, 2.0], L = [0.0, 0.0, 1.4, 1.4, 0.0, 0.0], FILT = False)
            pipeInData = gen_ramp(T = [0.0, 0.1, 0.11, 0.16, 0.17, 2.0], L = [1.0, 1.0, 1.4, 1.4, 1.0, 1.0], FILT = False)

            print "waveform 1 fed"
#            pipeInData = gen_sin(F = 1.0, AMP = 100.0,  T = 2.0) 
            
            
        elif choice == "waveform 2":
            print "waveform  fed"
#            pipeInData = spike_train(firing_rate = 10)      
            pipeInData = gen_sin(F = 0.5, AMP = 5000.0,  BIAS = 5001.0,  T = 2.0) 
#            pipeInData = gen_tri(T = 2.0) 

                
            
          
 
        elif choice == "waveform 3":
#            pipeInData = gen_tri() 

#            pipeInData = spike_train(firing_rate = 1) 
            print "waveform 3 fed"
            pipeInData = gen_sin(F = 0.5, AMP = 0.15,  BIAS = 1.15,  T = 2.0) 
            #pipeInData = gen_ramp(T = [0.0, 0.1, 0.2, 0.8, 0.9, 2.0], L = [1.0, 1.0, 1.3, 1.3, 1.0, 1.0], FILT = False)
#            pipeInData = gen_ramp(T = [0.0, 0.4, 1.5, 1.55,  1.6,  2.0], L = [0,  0,  15000, 15000, 0, 0], FILT = False)
#                pipeInData = gen_ramp(T = [0.0, 0.2, 0.25, 1.75,  1.8,  2.0], L = [1.0,  1.0,  5000.0, 5000.0, 1.0, 1.0], FILT = False)  # abrupt rise / fall
#            pipeInData = spike_train(firing_rate = 1000) 

        self.nerfModel.SendPipe(pipeInData)
          




    @pyqtSignature("bool")
    def on_pushButton_toggled(self, checked):
        """
        Pausing the plot, FPGA calculation still continues.
        """
        self.isPause = checked

    @pyqtSignature("bool")
    def on_checkBox_clicked(self, checked):
        """
        Auto-scale
        """
        for name, ch in self.allFpgaOutput.iteritems():
            ch.vscale = 50.0 / (max(ch.data)+1)




    @pyqtSignature("QListWidgetItem*")
    def on_listWidget_itemClicked(self, item):
        """
        item burnt upon clicking the .bit file
        """
        self.nerfModel.BurnBitFile(str(item.text()))


#    @pyqtSignature("QListWidgetItem*")
#      
#    def on_listWidget_itemActivated(self, item):
#        """
#        Default selection of .bit file burnt without clicking burn button
#        """
#        self.nerfModel.BurnBitFile(str(item.text()))
#    
    @pyqtSignature("bool")
    def on_checkBox_2_clicked(self, checked):
        """
        Slot documentation goes here.
        """
        newInput = checked
        print newInput
        self.nerfModel.SendButton(newInput, BUTTON_INPUT_FROM_TRIGGER)
    
  
#       
#    
#    @pyqtSignature("bool")
#    def on_pushButton_extraCN_clicked(self, checked):
#        """
#        Slot documentation goes here.
#        """
#         # dystonia
#        bitVal = convertType(0.0, fromType = 'f', toType = 'I')
#        if (checked): 
#            self.nerfModel.SendMultiPara_TEMP(bitVal1 = bitVal, bitVal2=20000, bitVal3=10000, trigEvent = 9)
#        else:
#            self.nerfModel.SendMultiPara_TEMP(bitVal1 = bitVal, bitVal2=0, bitVal3=0, trigEvent = 9)
#        
