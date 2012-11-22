#!/usr/bin/env python
# -*- coding: utf-8 -*-

import sys, PyQt4
from PyQt4.QtGui import QFileDialog
from PyQt4.QtCore import pyqtSignature, pyqtSlot

from PyQt4.QtCore import QTimer,  SIGNAL, SLOT, Qt,  QRect
from GuiPanel import SingleDutTester, CtrlChannel # Controller in MVC
from Fpga import SomeFpga # Model in MVC
from Display import View # Viewer in MVC
from Utilities import *
import os
import types
import inspect

updater_macro = """
@pyqtSlot('double')
def #{realUpdaterName}(self, value): 
    print value
    frame = inspect.currentframe()
    print inspect.getframeinfo(frame)
"""



if __name__ == "__main__":        
    app = PyQt4.QtGui.QApplication(sys.argv)
    
#    ROOT_PATH = QFileDialog.getExistingDirectory(None, "Path for the Verilog .bit file", os.getcwd() + "../../")

    ROOT_PATH = "/home/minos001/Code/nerf-verilog/projects/"
    PROJECT_NAME = "velocity_encoder"
    PROJECT_PATH = ROOT_PATH + PROJECT_NAME
    DEVICE_MODEL = "xem6010"
    
    BITFILE_NAME = PROJECT_PATH + "/" + PROJECT_NAME + "_" + DEVICE_MODEL + ".bit"
    print BITFILE_NAME
    assert os.path.exists(BITFILE_NAME.encode('utf-8')), ".bit file NOT found!"
    

    # Connect to an OpalKelly device on USB
    # Bind the .bit file with the device
    xem = SomeFpga(BITFILE_NAME)
    
    # Customize a curve plotting window 
    dispWindow = View(VIEWER_REFRESH_RATE, CHIN_PARAM)
    
    # Pass device and dispView to the main GUI
    testerGui = SingleDutTester(xem, dispWindow, TESTABLE_INPUTS)
    for name in testerGui.ctrl_all:
        eachCtrl = testerGui.ctrl_all[name]
        realUpdaterName = "__onNewValue__" + name
        exec interp(updater_macro)
        testerGui.__dict__[realUpdaterName] = types.MethodType(eval(realUpdaterName), testerGui)        
        testerGui.connect(eachCtrl.doubleSpinBox, SIGNAL("valueChanged(double)"), testerGui.__getattribute__(realUpdaterName))
    testerGui.show()
        
    sys.exit(app.exec_())
