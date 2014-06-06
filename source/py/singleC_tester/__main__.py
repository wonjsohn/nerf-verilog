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

    LINUX = 1
    WINDOWS = 0
    assert (LINUX + WINDOWS ==1),  "CHOOSE ONE ENVIRONMENT!"
    
   
    if (WINDOWS==1) :
        ROOT_PATH = "C:\\nerf_sangerlab\\projects\\"  # windows setting
    if (LINUX==1):
        ROOT_PATH = "/home/eric/nerf_verilog_eric/projects/"


   
#    PROJECT_LIST = ["izneuron_range_test"] 
#    PROJECT_LIST = ["rack_mn_muscle"] 
    PROJECT_LIST = ["stdp_test"] 

    PROJECT_PATH = [(ROOT_PATH + p) for p in PROJECT_LIST]
    DEVICE_MODEL = "xem6010"
    
    #BITFILE_NAME = PROJECT_PATH1 + "/" + PROJECT_NAME + "_" + DEVICE_MODEL + ".bit"
    #print BITFILE_NAME
    #assert os.path.exists(BITFILE_NAME.encode('utf-8')), ".bit file NOT found!"
    
    #sys.path.append(PROJECT_PATH)
    print PROJECT_PATH
    os.chdir('/home/eric/nerf_verilog_eric/projects/stdp_test')
    from config_test_local import NUM_NEURON, SAMPLING_RATE, FPGA_OUTPUT,  USER_INPUT  
    FPGA_OUTPUT_B = []
    USER_INPUT_B = []
    
  
    FPGA_OUTPUT_B.append(FPGA_OUTPUT)
    USER_INPUT_B.append(USER_INPUT)
    
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
    print xemSerialList
    xemSerialList = ['11160001CJ']

    print xemSerialList
    
    for idx,  name in enumerate(xemSerialList):
        print idx,  name
        serX = xemSerialList[idx]
        xem = SomeFpga(NUM_NEURON, SAMPLING_RATE, serX)
        xemList.append(xem)
    
    
    """ RESET FPGAs  """
    BUTTON_RESET =0
    BUTTON_INPUT_FROM_TRIGGER = 1
    
    for idx,  name in enumerate(xemSerialList):
        xemList[idx].SendButton(True, BUTTON_RESET)   # send to FPGA (flexor)
        xemList[idx].SendButton(False, BUTTON_RESET)
        print "reset_global board:",  idx
    ### Building V in MVC
    
    vList = []

 
    for i in xrange(len(xemList)):
        dispWin = View(count = i,  projectName = PROJECT_LIST[i] ,  projectPath = PROJECT_PATH[i],  nerfModel = xemList[i],  fpgaOutput = FPGA_OUTPUT_B[i],  userInput = USER_INPUT_B[i])
        vList.append(dispWin)

    # display VIEW windows for each channel
    for i in xrange(len(xemList)):
        vList[i].show()
    
    ### Building C::(M,V)->C in MVC
    cList = []
    for i in xrange(len(xemList)):
        testerGui = SingleXemTester(xemList[i], vList[i], USER_INPUT_B[i],  xem.HalfCountRealTime())
        cList.append(testerGui)

    #testerGui.show()
    
    print vList
    ### global control for MVC
    threeBoard = MultiXemScheduler(xemList = xemList, cList = cList,  vList = vList, halfCountRealTime = xem.HalfCountRealTime() )
    threeBoard.show()
   
   
    sys.exit(app.exec_())


