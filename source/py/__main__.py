#!/usr/bin/env python
# -*- coding: utf-8 -*-

import sys, PyQt4
from PyQt4.QtGui import QFileDialog

from PyQt4.QtCore import QTimer,  SIGNAL, SLOT, Qt,  QRect
from GuiPanel import SingleDutTester, CtrlChannel # Controller in MVC
from Fpga import SomeFpga # Model in MVC
from Display import View # Viewer in MVC
import os


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
    
    sys.path.append(PROJECT_PATH)
    from config_test import NUM_NEURON, SAMPLING_RATE, FPGA_OUTPUT, USER_INPUT

    # Connect to an OpalKelly device on USB
    # Bind the .bit file with the device
    xem = SomeFpga(BITFILE_NAME, NUM_NEURON, SAMPLING_RATE)
    
    # Customize a curve plotting window 
    dispWindow = View(FPGA_OUTPUT)
    
    # Pass device and dispView to the main GUI
    testerGui = SingleDutTester(xem, dispWindow, USER_INPUT, xem.HalfCountRealTime())
    #dynamicConnect(obj = testerGui, methodName = "__onNewValue__")
    testerGui.show()
        
    sys.exit(app.exec_())
