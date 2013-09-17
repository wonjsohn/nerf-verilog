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
#    ROOT_PATH = "/home/eric/"
#    PROJECT_NAME = "one_joint_parameterSearch"
#    PROJECT_NAME = "ucf_newWiringTest"
    PROJECT_NAME = "izneuron_range_test"

    PROJECT_PATH = ROOT_PATH + PROJECT_NAME
    DEVICE_MODEL = "xem6010"
    
    BITFILE_NAME = PROJECT_PATH + "/" + PROJECT_NAME + "_" + DEVICE_MODEL + ".bit"
    print BITFILE_NAME
    assert os.path.exists(BITFILE_NAME.encode('utf-8')), ".bit file NOT found!"
    
#    sys.path.append(PROJECT_PATH)
    os.chdir(PROJECT_PATH)
    print PROJECT_PATH
    from config_test_local import NUM_NEURON, SAMPLING_RATE, FPGA_OUTPUT, USER_INPUT

    # CONFIGURE MULTIPLE BOARDS 
    testrun = ok.FrontPanel()
    numFpga = testrun.GetDeviceCount()
    assert numFpga > 0, "No OpalKelly boards found, is one connected?"
    print "Found ",  numFpga, " OpalKelly devices:"                        
#    xemSerialList = [testrun.GetDeviceListSerial(i) for i in xrange(numFpga)]
#    for name in xemSerialList: print name
    

        
    # Connect to an OpalKelly device on USB
    # Bind the .bit file with the device
    
    xemSerial = '12320003RM'
    
    xem = SomeFpga(NUM_NEURON, SAMPLING_RATE, xemSerial)


#    # Customize a curve plotting window 

#    dispWin = View(FPGA_OUTPUT)
    dispWin = View(count = 1,  projectName = PROJECT_NAME ,  projectPath = PROJECT_PATH,  nerfModel = xem,  fpgaOutput = FPGA_OUTPUT,  userInput = USER_INPUT)
        

#  
    
    """ custumized code  -eric """
    """ RESET FPGAs  """
    BUTTON_RESET_SIM = 1;
    # current convention = board '0': flexor /  board '1': extensor (two board setting) 
    xem.SendButton(True, BUTTON_RESET_SIM)   # send to FPGA (flexor)

    xem.SendButton(False, BUTTON_RESET_SIM)

    
    xem.SendButton(True, BUTTON_RESET_SIM)   # send to FPGA (flexor)

    xem.SendButton(False, BUTTON_RESET_SIM)

    
    
  # Pass device and dispView to the main GUI
    testerGui = SingleDutTester(xem, dispWin, USER_INPUT, xem.HalfCountRealTime())
#    #dynamicConnect(obj = testerGui, methodName = "__onNewValue__")
    testerGui.show()



        
    sys.exit(app.exec_())


