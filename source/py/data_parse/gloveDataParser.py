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
   


class ParseView():
    
    def __init__(self, file, digit_to_plot, parent = None):
        file = file
        indexList=[]
        j1List=[]
        j2List=[]
        j3List=[]
        
#        digit_to_plot
        
        
        for line in open(file,  "r").readlines()[digit_to_plot::10]:  # digit1
            index, j1 ,  j2,  j3= line.split()
            indexList.append(index)
            j1List.append(j1)   #joint1
            j2List.append(j2)   #joint2
            j3List.append(j3)  #joint3
    #        print d1
        
        digits = ['thumb',  'index', 'middle', 'ring',  'pinky'] 

        fig = plt.figure()
    #    frame = frame.cumsum()
    #    frame.plot()
        ax1 = fig.add_subplot(2,  2,  1)
        ax2 = fig.add_subplot(2,  2,  2)
        ax3 = fig.add_subplot(2,  2,  3)
        ax4 = fig.add_subplot(2,  2,  4)
        grid(True)
        ax1.plot(j1List)
        ax2.plot(j2List)
        ax3.plot(j3List)
        ax4.plot(indexList)
    #    plot(randn(1000).cumsum())
        
        ax1.set_title('sub title')
        ax1.set_xlabel('time')
        
        fig.suptitle(str(digits[digit_to_plot-2]))
#        print digits[digit_to_plot-2]
        savefig(file+"_"+str(digits[digit_to_plot-2])+".png")
        
#        led = QLabel() 
#        led.setPixmap(QPixmap(file+"_"+str(digits[digit_to_plot-2])+".png")) 
#        led.show()
        

        show()
        
