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
#import numpy
#import scipy


class AmpAnalysis():
    def __init__(self, list,  parent = None):
        self.list = list
        
        length = len(list)
        print "length = ",  length
        
        ## task:  automate to get time markers
        ##produce_20time_markers(pivot)
        
        i=0
        j=0
        hill = 0  
        time_markers = []
        ## generate time_markers list to get local min and max's
        pivot = -1.0
        
        
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
        for i in range(0, 16, 2):
            localMin.append(max(list[time_markers[i]:time_markers[i+1]]))
            localMax.append(min(list[time_markers[i+1]:time_markers[i+2]]))
        
        print "localMin:", localMin
        print "localMax",  localMax
        
        ampList =[]
        for a,  b in zip(localMin,  localMax):
            ampList.append(abs(b-a))
        
        print "ampList: ",  ampList
        print "mean amplitude: ",  mean(ampList)
    
    
        show()   
        
        
if __name__ == "__main__": 
    ROOT_PATH = "C:\\Code\\nerf_verilog\\source\\py\\"
    PROJECT_NAME1 = "data_parse"
    
    PROJECT_PATH1 = ROOT_PATH + PROJECT_NAME1   
    self.gloveDataPath = PROJECT_PATH1
    
    glove_data_index= ParseGloveData(str(self.glove_item.text()), 3,  self.gloveDataPath )
    glove_data_middle = ParseGloveData(str(self.glove_item.text()), 4,  self.gloveDataPath )
