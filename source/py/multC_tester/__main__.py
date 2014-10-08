
#!/usr/bin/env python
# -*- coding: utf-8 -*-


import sys, PyQt4
from PyQt4.QtGui import QFileDialog

from PyQt4.QtCore import QTimer,  SIGNAL, SLOT, Qt,  QRect
from MVC_MainGUI import MultiXemScheduler
from C_XemScheduler import SingleXemTester # Controller in MVC
from M_Fpga import SomeFpga # Model in MVC
from V_Display import View, ViewChannel,  CtrlChannel # Viewer in MVC
import importlib

#from cortex import cortexView
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
    
    board_scheme = importlib.import_module(str(sys.argv[1]))
    
    assert (board_scheme.LINUX + board_scheme.WINDOWS ==1),  "CHOOSE ONE ENVIRONMENT!"
    assert (board_scheme.TWO_BOARDS+board_scheme.THREE_BOARDS+board_scheme.CORTICAL_BOARDS== 1), "CHOOSE ONE BOARD SETTING!"
    
    if (board_scheme.WINDOWS==1) :
        ROOT_PATH = "C:\\nerf_sangerlab\\projects\\"  # windows setting
    if (board_scheme.LINUX==1):
        ROOT_PATH = "/home/eric/nerf_verilog_eric/projects/"

    #################################################
    if (board_scheme.TWO_BOARDS == 1):
        PROJECT_LIST = ["rack_test", "rack_emg"] 

    if (board_scheme.THREE_BOARDS ==1) :
        PROJECT_LIST = ["rack_test", "rack_CN_simple_S1M1", "rack_emg"]   # rack_CN_simple_general
    
    if (board_scheme.CORTICAL_BOARDS ==1) :
        PROJECT_LIST = ["rack_CN_simple_S1M1", "rack_CN_simple_S1M1"]   # rack_CN_general
        
    PROJECT_PATH = [(ROOT_PATH + p) for p in PROJECT_LIST]
    DEVICE_MODEL = "xem6010"
    
    #BITFILE_NAME = PROJECT_PATH1 + "/" + PROJECT_NAME + "_" + DEVICE_MODEL + ".bit"
    #print BITFILE_NAME
    #assert os.path.exists(BITFILE_NAME.encode('utf-8')), ".bit file NOT found!"

    # Connect to an OpalKelly device on USB
    # Bind the .bit file with the device
    # CONFIGURE MULTIPLE BOARDS 
    
    ### Building M in MVC
    xemList = []
    testrun = ok.FrontPanel()
    numFpga = testrun.GetDeviceCount()
    assert numFpga > 0, "No OpalKelly boards found, is one connected?"
    print "Found ",  numFpga, " OpalKelly devices:"           
    availableFPGAs = [testrun.GetDeviceListSerial(i) for i in xrange(numFpga)]
    print availableFPGAs
    

    print board_scheme.xemSerialList
    
    
    
        
        
    #sys.path.append(PROJECT_PATH)
    from config_test import NUM_NEURON, SAMPLING_RATE, FPGA_OUTPUT_B1, FPGA_OUTPUT_B2, FPGA_OUTPUT_B3,   USER_INPUT_B1,  USER_INPUT_B2,  USER_INPUT_B3
    FPGA_OUTPUT_B = []
    USER_INPUT_B = []
    
    if (board_scheme.TWO_BOARDS ==1) :
        FPGA_OUTPUT_B.append(FPGA_OUTPUT_B1)
        FPGA_OUTPUT_B.append(FPGA_OUTPUT_B3)
        USER_INPUT_B.append(USER_INPUT_B1)
        USER_INPUT_B.append(USER_INPUT_B3)
    
    if (board_scheme.THREE_BOARDS ==1) :
        FPGA_OUTPUT_B.append(FPGA_OUTPUT_B1)
        FPGA_OUTPUT_B.append(FPGA_OUTPUT_B2)
        FPGA_OUTPUT_B.append(FPGA_OUTPUT_B3)
        USER_INPUT_B.append(USER_INPUT_B1)
        USER_INPUT_B.append(USER_INPUT_B2)
        USER_INPUT_B.append(USER_INPUT_B3)
    
    if (board_scheme.CORTICAL_BOARDS==1):
        FPGA_OUTPUT_B.append(FPGA_OUTPUT_B2)
        FPGA_OUTPUT_B.append(FPGA_OUTPUT_B2)
        USER_INPUT_B.append(USER_INPUT_B2)
        USER_INPUT_B.append(USER_INPUT_B2)
    
    for idx,  name in enumerate(board_scheme.xemSerialList):
        print idx,  name
        serX = board_scheme.xemSerialList[idx]
        xem = SomeFpga(NUM_NEURON, SAMPLING_RATE, serX)
        xemList.append(xem)
    
    """ RESET FPGAs  """
    BUTTON_RESET =0
    BUTTON_INPUT_FROM_TRIGGER = 1
    
    for idx,  name in enumerate(board_scheme.xemSerialList):
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
   
#    # cortical overflow 
#    cortexControl = cortexView(xemList = xemList)
#    cortexControl.show()
#    
    sys.exit(app.exec_())


