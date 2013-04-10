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
#import numpy
#import scipy


class AmpAnalysis():
    def __init__(self, pivot, startTimeIndex,   list,  parent = None):
        self.list = list
        pivot = pivot
        length = len(list)
        print "length = ",  length
        
        ## task:  automate to get time markers
        ##produce_20time_markers(pivot)
        
        i=startTimeIndex
        j=0
        hill = 0  
        time_markers = []
        ## generate time_markers list to get local min and max's
#        pivot = -1.0
        
        
        while(j < 19 or i  == length): 
            if (hill):
                if list[i] < pivot:
                    time_markers.append(i)
                    j = j+1
                    hill = 0
            else:                
                if list[i] > pivot:
                    time_markers.append(i)
                    j = j+1
                    hill = 1
            i = i+1
            
        print "length = ", len(time_markers)
        print "time_markers: ",  time_markers
        
        #time_markers = [1900, 2650,  3300,  3900,  4630,  5330,  6050,  6750, 7200,  7950,  8500,  9350,  9800, 10600, 11250,  12000,  12600,  13400, 14000, 14900  ]     # 20 time markers to get local min max
        
        t_range = range(length)
        plt.plot(t_range,    list,  'g-')

        for element in time_markers:
            plt.plot(element, list[element], 'rD')
            
        localMin = []
        localMax = []
        for k in range(0, 16, 2):
            localMin.append(max(list[time_markers[k]:time_markers[k+1]]))
            localMax.append(min(list[time_markers[k+1]:time_markers[k+2]]))
        
        print "localMax:", localMin
        print "localMin",  localMax
        
        ampList =[]
        for a,  b in zip(localMin,  localMax):
            ampList.append(abs(b-a))
        
        print "ampList: ",  ampList
        print "mean amplitude: ",  mean(ampList)
    
    
        show()   
        
#        
