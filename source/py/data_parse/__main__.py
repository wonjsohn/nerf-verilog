#!/usr/bin/env python
# -*- coding: utf-8 -*-

import sys, PyQt4
from PyQt4.QtGui import QFileDialog

from PyQt4.QtCore import QTimer,  SIGNAL, SLOT, Qt,  QRect
from display import View
from gloveDataParser import ParseGloveData


if __name__ == "__main__":        
    app = PyQt4.QtGui.QApplication(sys.argv)
    
#    ROOT_PATH = "C:\\Code\\nerf_verilog\\source\\py\\"
    ROOT_PATH = "/home/eric/overflow_data/"
#    PROJECT_NAME1 = "data_parse"
    PROJECT_NAME1 = "AlanM_CONTROL/20130830/"
    
    PROJECT_PATH1 = ROOT_PATH + PROJECT_NAME1

    dispWin = View(projectPath = PROJECT_PATH1)
    dispWin.show()

    sys.exit(app.exec_())


