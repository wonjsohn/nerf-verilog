#!/usr/bin/env python
# -*- coding: utf-8 -*-

    
    
    
if __name__ == "__main__":
    import sys, PyQt4
    sys.path.append('../../../source/py/')
    
    from Fpga import FpgaDevice
    import platform
    arch = platform.architecture()[0]
    if arch == "32bit":
        from opalkelly_32bit import ok
    elif arch == "64bit":
        from opalkelly_64bit import ok
        
    from Controls import User
    app = PyQt4.QtGui.QApplication(sys.argv)
    
#    rawxem = ok.FrontPanel()
#    count = rawxem.GetDeviceCount()
#    print count
#    
#    xemList = []
#    deviceList=[]
#    for i in xrange(count):
#        serX = rawxem.GetDeviceListSerial(i)
#        print "serial = ",  serX    
#        xemList.append(FpgaDevice(serX))
#        user = User()

    #print xemList[0]
    user = User()
    
    user.show()
    sys.exit(app.exec_())
