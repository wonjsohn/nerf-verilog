#!/usr/bin/env python
# -*- coding: utf-8 -*-

import sys, PyQt4
from PyQt4.QtGui import QFileDialog
from GuiPanel import SingleDutTester # Controller in MVC
from Fpga import SomeFpga # Model in MVC
from Display import View # Viewer in MVC
from Utilities import *
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
    

    # Connect to an OpalKelly device on USB
    # Bind the .bit file with the device
    xem = SomeFpga(BITFILE_NAME)
    
    # Customize a curve plotting window 
    dispWindow = View(VIEWER_REFRESH_RATE, CHIN_PARAM)
        
    # Pass device and dispView to the main GUI
    testerGui = SingleDutTester(xem, dispWindow)
    testerGui.show()
        
    sys.exit(app.exec_())
