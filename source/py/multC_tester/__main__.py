#!/usr/bin/env python
# -*- coding: utf-8 -*-

import sys, PyQt4
from PyQt4.QtGui import QFileDialog

from PyQt4.QtCore import QTimer,  SIGNAL, SLOT, Qt,  QRect
from MVC_MainGUI import MultiXemScheduler
from C_XemScheduler import SingleXemTester # Controller in MVC
from M_Fpga import SomeFpga # Model in MVC
from V_Display import View, ViewChannel,  CtrlChannel # Viewer in MVC
import os

sys.path.append('../')
import platform 
arch = platform.architecture()[0]
if arch == "32bit":
    from opalkelly_32bit import ok
elif arch == "64bit":
    from opalkelly_64bit import ok


if __name__ == "__main__":        
    app = PyQt4.QtGui.QApplication(sys.argv)
    
#    ROOT_PATH = QFileDialog.getExistingDirectory(None, "Path for the Verilog .bit file", os.getcwd() + "../../")

    ROOT_PATH = "/home/eric/nerf_verilog_eric/projects/"
    PROJECT_NAME = "one_joint_parameterSearch"
#    PROJECT_NAME = "ucf_newWiringTest"
    PROJECT_PATH = ROOT_PATH + PROJECT_NAME
    DEVICE_MODEL = "xem6010"
    
    BITFILE_NAME = PROJECT_PATH + "/" + PROJECT_NAME + "_" + DEVICE_MODEL + ".bit"
    print BITFILE_NAME
    assert os.path.exists(BITFILE_NAME.encode('utf-8')), ".bit file NOT found!"
    
    sys.path.append(PROJECT_PATH)
    from config_test import NUM_NEURON, SAMPLING_RATE, FPGA_OUTPUT, USER_INPUT

        
    # Connect to an OpalKelly device on USB
    # Bind the .bit file with the device
    # CONFIGURE MULTIPLE BOARDS 
    
    ### Building M in MVC
    xemList = []
    testrun = ok.FrontPanel()
    numFpga = testrun.GetDeviceCount()
    assert numFpga > 0, "No OpalKelly boards found, is one connected?"
    print "Found ",  numFpga, " OpalKelly devices:"                        
    xemSerialList = [testrun.GetDeviceListSerial(i) for i in xrange(numFpga)]
    
    for idx,  name in enumerate(xemSerialList):
        print idx,  name
        serX = xemSerialList[idx]
        xem = SomeFpga(BITFILE_NAME, NUM_NEURON, SAMPLING_RATE, serX)
        xemList.append(xem)
    
    
    """ RESET FPGAs  """
    BUTTON_RESET_SIM = 1;
    
    for idx,  name in enumerate(xemSerialList):
        xemList[idx].SendButton(True, BUTTON_RESET_SIM)   # send to FPGA (flexor)
        xemList[idx].SendButton(False, BUTTON_RESET_SIM)
        print "reset_sim board:",  idx
    ### Building V in MVC
    
    vList = []
    dispWin = View(nerfModel = xemList[0],  fpgaOutput = FPGA_OUTPUT,  userInput = USER_INPUT)
    vList.append(dispWin)
    dispWin = View(nerfModel = xemList[1],  fpgaOutput = FPGA_OUTPUT,  userInput = USER_INPUT)
    vList.append(dispWin)
        
      
    # display VIEW windows for each channel
    vList[0].show()
    vList[1].show()
    
    ### Building C::(M,V)->C in MVC
    
    cList = []
    testerGui = SingleXemTester(xemList[0], vList[0], USER_INPUT,  xem.HalfCountRealTime())
    cList.append(testerGui)
    testerGui = SingleXemTester(xemList[1], vList[1], USER_INPUT,  xem.HalfCountRealTime())
    cList.append(testerGui)
    

    
    #testerGui.show()
    
    ### global control for MVC
    threeBoard = MultiXemScheduler(xemList = xemList, cList = cList,  vList = vList, halfCountRealTime = xem.HalfCountRealTime() )
    threeBoard.show()
   
   
    sys.exit(app.exec_())


