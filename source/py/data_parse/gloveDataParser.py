#!/usr/bin/env python
# -*- coding: utf-8 -*-


#import pandas as pd
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
from ampDetection import AmpAnalysis
   


class ParseGloveData():
    
    def __init__(self, txtfile, digit_to_plot, gloveDataPath,  parent = None):
        txtfile = txtfile
        indexList=[]
        j1List=[]
        j2List=[]
        j3List=[]
        
        for line in open(gloveDataPath+txtfile,  "r").readlines()[digit_to_plot::10]:  # read a row in every 10 rows, starting from the row =(digit_to_plot) 
            index, j1 ,  j2,  j3= line.split()
            j1 = float(j1)
            j2 = float(j2)
            j3 = float(j3)
            indexList.append(index)
            j1List.append(j1)   #joint1
            j2List.append(j2)   #joint2
            j3List.append(j3)  #joint3
        
        digits = ['thumb',  'index', 'middle', 'ring',  'pinky'] 

        fig = plt.figure()
    #    frame = frame.cumsum()
    #    frame.plot()
        ax1 = fig.add_subplot(3,  1,  1)
        ax2 = fig.add_subplot(3,  1,  2)
        ax3 = fig.add_subplot(3,  1,  3)
#        ax4 = fig.add_subplot(2,  2,  4)
        
        grid(True)
        ax1.plot(j1List)
        ax2.plot(j2List)
        ax3.plot(j3List)
#        ax4.plot(indexList)
#        show(ax1)

#        plot(j1List)
#        plot(j2List)
#        plot(j3List)

        ax1.set_title('joint1')
#        x1.set_xlabel('time')
        ax2.set_title('joint2')
        ax2.set_xlabel('time')
        ax3.set_title('joint3')
        ax3.set_xlabel('time')
        
#        AmpAnalysis(j1List)
        
##        fig.suptitle(str(digits[digit_to_plot-2]))
#        print digits[digit_to_plot-2]
        savefig("glove_figures\\"+txtfile+"_"+str(digits[digit_to_plot-2])+".png")
        
#        led = QLabel() 
#        led.setPixmap(QPixmap(file+"_"+str(digits[digit_to_plot-2])+".png")) 
#        led.show()
        

        #show()
        
