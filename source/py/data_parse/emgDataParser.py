#!/usr/bin/env python
# -*- coding: utf-8 -*-


import pandas as pd
import sys, random
import matplotlib.pyplot as plt

from PyQt4 import QtCore, QtGui
#from PyQt4.QtGui import QMainWindow
from PyQt4.QtGui import *
from PyQt4.QtCore import pyqtSignature
from PyQt4.QtCore import QTimer,  SIGNAL, SLOT, Qt,  QRect
from PyQt4.QtGui import QPainter, QRegion, QPen
from pylab import *
from numpy.random import randn
   


class ParseEmgData():
    
    def __init__(self, txtfile, emgDataPath,  parent = None):
        txtfile = txtfile
        indexList=[]
        j1List=[]
        j2List=[]
        j3List=[]
        
#        lines = open(emgDataPath+txtfile,  "r").readlines()
#        with open(emgDataPath+txtfile) as f:
#            lines_after_9 = f.readlines()[9:]
        
        emg1List=[]
        emg2List=[]
        emg3List=[]
        emg4List=[]
        
        
        for line in open(emgDataPath+txtfile,  "r").readlines()[15:]:
            emg1,  emg2,  emg3,  emg4,  emg5,  emg6,  emg7,  emg8,  emg9 = line.split()
            emg1List.append(emg1)   
            emg2List.append(emg2)
            emg3List.append(emg3)
            emg4List.append(emg4)
            
             
        #print lines_after_9
        region = ['lower1',  'lower2', 'upper1', 'upper2'] 

        fig = plt.figure()
    #    frame = frame.cumsum()
    #    frame.plot()
        ax1 = fig.add_subplot(4,  1,  1)
        ax2 = fig.add_subplot(4,  1,  2)
        ax3 = fig.add_subplot(4,  1,  3)
        ax4 = fig.add_subplot(4,  1,  4)

        grid(True)
        ax1.plot(emg1List)
        ax2.plot(emg2List)
        ax3.plot(emg3List)
        ax4.plot(emg4List)

    #    plot(randn(1000).cumsum())
        
        ax1.set_title(region[0])
#        x1.set_xlabel('time')
        ax2.set_title(region[1])
        ax1.set_title(region[2])
#        x1.set_xlabel('time')
        ax2.set_title(region[3])
        ax2.set_xlabel('time')

        
        
        fig.suptitle('emg')
#        print digits[digit_to_plot-2]
        savefig("emg_figures\\"+txtfile+".png")
        
#        led = QLabel() 
#        led.setPixmap(QPixmap(file+"_"+str(digits[digit_to_plot-2])+".png")) 
#        led.show()
        

        show()
        
