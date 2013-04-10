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
        
        
        for line in open(emgDataPath+txtfile,  "r").readlines()[10:]:  #15
#            emg1,  emg2,  emg3,  emg4,  emg5,  emg6,  emg7,  emg8,  emg9 = line.split()
            emg1,  emg2,  emg3,  emg4,  emg5  = line.split()
            
            emg1List.append(emg1)   
            emg2List.append(emg2)
            emg3List.append(emg3)
            emg4List.append(emg4)
            
             
        #print lines_after_9
        region = ['lower1',  'lower2', 'upper1', 'upper2'] 

#        fig = plt.figure()
    #    frame = frame.cumsum()
    #    frame.plot()
        num_of_subplots = 4
        fig, axes = plt.subplots(num_of_subplots, 1, sharex=True, sharey=True)
        axes[0].plot(emg1List,  label = 'index flexor')
        axes[1].plot(emg2List,   label = 'middle flexor')
        axes[2].plot(emg3List,   label = 'index extensor')
        axes[3].plot(emg4List,  label = 'middle extensor')

        
#        axes[0].set_title(region[0])
##        x1.set_xlabel('time')
#        axes[1].set_title(region[1])
#        axes[2].set_title(region[2])
##        x1.set_xlabel('time')
#        axes[3].set_title(region[3])
       

        for i in range(num_of_subplots):
            axes[i].grid()
            axes[i].legend(loc='best')
        
        fig.suptitle('emg')
#        print digits[digit_to_plot-2]
        savefig("emg_figures\\"+txtfile+".png")
        
#        led = QLabel() 
#        led.setPixmap(QPixmap(file+"_"+str(digits[digit_to_plot-2])+".png")) 
#        led.show()
        

        show()
        
