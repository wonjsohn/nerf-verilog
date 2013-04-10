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
from ampDetection import AmpAnalysis
   


class ParseGloveData():
    
    def __init__(self, txtfile, digit_to_plot, gloveDataPath,  pivot, startTimeIndex,  parent = None):
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
        AmpAnalysis(pivot, startTimeIndex,  j1List)
        
        
        
