# -*- coding: utf-8 -*-

"""
Module implementing Control.
"""

from PyQt4.QtGui import QDialog
from PyQt4.QtCore import pyqtSignature
from PyQt4.QtCore import QTimer,  SIGNAL, SLOT, Qt,  QRect
from PyQt4 import QtCore, QtGui




class muscle_properties:
    def __init__(self,  flexor_len):
        self.flexor_len = flexor_len
        self.search(self.flexor_len)  #  as initial parater value
        
    def search(self,  val):
        self.extensor_len = 1.4-0.6/0.5*(val-0.75)   # simple and wrong relationship between flex and extensor muscle length
        
        
        
            
            
            
            
            
    
         
