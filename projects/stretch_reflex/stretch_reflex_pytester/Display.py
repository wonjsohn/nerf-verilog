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

PIXEL_OFFSET = 200 # pixels offsets

from Ui_Display import Ui_Dialog

class ViewChannel:
    def __init__(self, hostDialog, name, id, width = 2, color = 'Qt.blue'):
        exec interp('self.id = #{id}')
        exec interp('self.width = #{width}')
        exec interp('self.color = #{color}')
        exec interp('self.vscale = 0.0')
        exec interp('self.yoffset = 1.0')
        exec interp('self.data = deque([0]*100, maxlen=100)')
        exec interp('self.slider = QtGui.QSlider(hostDialog)')
        exec interp('self.slider.setGeometry(QtCore.QRect(100, 130+#{id}*100, 29, 100))')
        exec interp('self.slider.setOrientation(QtCore.Qt.Vertical)')
        exec interp('self.slider.setObjectName("gain_#{name}")')
        

        exec interp('self.label = QtGui.QLabel(hostDialog)')
        exec interp('pal = self.label.palette()')        
        exec interp('pal.setColor( QtGui.QPalette.Foreground, #{color} )')        
        exec interp('self.label.setPalette(pal)')        
        exec interp('self.label.setObjectName("label_#{name}")')
        exec interp('self.label.setText("#{name}")')        
        exec interp('self.label.setGeometry(QtCore.QRect(10, 90+#{id}*100, 80, 100))')
        exec interp('self.label.show()')        


class View(QMainWindow, Ui_Dialog):
    """
    Class View inherits the GUI generated by QtDesigner, and add customized actions
    """
    def __init__(self, parent = None, VIEWER_REFRESH_RATE = 5, ch_all = []):
        """
        Constructor
        """
#        QMainWindow.__init__(self, parent, Qt.FramelessWindowHint)
        QMainWindow.__init__(self, parent)
        self.setupUi(self)
        self.x = 200
        self.pen = QPen()

        self.numPt = PIXEL_OFFSET
        self.isPause = False
        self.NUM_CHANNEL = len(CHIN_PARAM)

        # Create a gain_slider for each channel
        self.ch_all = []
        for (addr, name, visual_gain, type, color), i in zip(CHIN_PARAM, xrange(NUM_CHANNEL)):
            exec interp('self.ch_#{name} = ViewChannel(hostDialog=self, name=name, id=i, color = color)')
            exec interp('self.connect(self.ch_#{name}.slider, SIGNAL("valueChanged(int)"), self.onChInGain)')
            exec interp('self.ch_all.append(self.ch_#{name})')

        #print self.ch_all
        self.timer = QTimer(self)
        self.connect(self.timer, SIGNAL("timeout()"), self.onTimeOut)        
        self.timer.start(VIEWER_REFRESH_RATE)

    def newDataIO(self, newData, newSpikeAll = []):
        for ch, pt in zip(self.ch_all, newData):
            ch.data.appendleft(pt)
            ch.label.setText("%4.2f" % pt)      

        self.spike_all = newSpikeAll

    def onTimeOut(self):
        if (self.isPause):
            return
        size = self.size()
        self.update(QRect(self.x+ 1, 0,size.width() - self.x,size.height()))
        
        if (self.x < size.width()):
            self.x = self.x + 1  
        else:
            self.x = PIXEL_OFFSET 
            
    def onChInGain(self):
        for ch in self.ch_all:
            ch.vscale = ch.slider.value()* 0.1   

    def paintEvent(self, e):
        """ 
        Overload the standard paintEvent function
        """

        #p = QPainter(self.graphicsView)                         ## our painter
        canvas = QPainter(self)                         ## our painter
        self.drawPoints(canvas, self.ch_all)          ## paint clipped graphics
#        self.drawRaster(canvas)

#    def drawRaster(self, gp):
#        for spkid, i_mu in zip(self.spike_all,  xrange(len(self.spike_all))):
#            spikeSeq = unpack("%d" % len(spkid) + "b", spkid)
#            
#            size = self.size()
#            winScale = size.height()*0.2 + size.height()*0.618/self.NUM_CHANNEL * 4;
#            self.pen.setStyle(Qt.SolidLine)
#            self.pen.setWidth(1)
#            self.pen.setBrush(Qt.blue)
#            self.pen.setCapStyle(Qt.RoundCap)
#            self.pen.setJoinStyle(Qt.RoundJoin)
#            gp.setPen(self.pen)
#            ## display the spike rasters
#            for i in xrange(0, len(spikeSeq), 2):
#                neuronID = spikeSeq[i+1]
#                rawspikes = spikeSeq[i]
#                ## flexors
#                if (rawspikes & 64) : ## Ia
#                    gp.drawLine(self.x-2,(winScale) - 22 ,\
#                                     self.x, (winScale) -  22)
#                if (rawspikes & 128) : ## MN
#    #                gp.drawPoint(self.x, (winScale) - 24 - (neuronID/4)   ) 
#                    gp.drawLine(self.x-2,(winScale) +22 - (neuronID/4)*0 + i_mu * 15 ,\
#                                     self.x, (winScale) + 26 - (neuronID/4) *0 + i_mu * 15)

    def drawPoints(self, qp, ch_all):
        """ 
        Draw a line between previous and current data points.
        """
        size = self.size()

        for ch in ch_all:
            self.pen.setStyle(Qt.SolidLine)
            self.pen.setWidth(2)
            self.pen.setBrush(ch.color)
            self.pen.setCapStyle(Qt.RoundCap)
            self.pen.setJoinStyle(Qt.RoundJoin)
            qp.setPen(self.pen)


            yOffset = int(size.height()*0.2 + size.height()*0.618/self.NUM_CHANNEL * ch.id)
            y0 = yOffset - ch.data[1] * ch.vscale
            y1 = yOffset - ch.data[0] * ch.vscale


            qp.drawLine(self.x - 1 , y0, self.x + 1 , y1)

    @pyqtSignature("bool")
    def on_pushButton_toggled(self, checked):
        """
        Pausing the plot, FPGA calculation still continues.
        """
        self.isPause = checked

    @pyqtSignature("bool")
    def on_checkBox_clicked(self, checked):
        """
        Slot documentation goes here.
        """
        # TODO: not implemented yet
        for ch in self.ch_all:
            ch.vscale = 50.0 / (max(ch.data)+1)
