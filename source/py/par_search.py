# -*- coding: utf-8 -*-

"""
Module implementing Control.
"""

from PyQt4.QtGui import QDialog
from PyQt4.QtCore import pyqtSignature
from PyQt4.QtCore import QTimer,  SIGNAL, SLOT, Qt,  QRect
from PyQt4 import QtCore, QtGui




class muscle_properties:
#    def __init__(self,  flexor_len):
#        self.flexor_len = flexor_len
#        self.search(self.flexor_len)  #  as initial parater value
#        
#    def search(self,  val):
#        self.extensor_len = 2.1-val   # simple and wrong relationship between flex and extensor muscle length

    def __init__(self,  jointAngle):  # jointAngle range : 0 to pi
        self.jointAngle = jointAngle
        self.search()
        
    def search(self):
        jointRadius = 0.1
        self.flexor_len = 1.0 + jointRadius*self.jointAngle
        self.extensor_len = 2.04 - self.flexor_len 
        
            
            
            
            
            
    
         
