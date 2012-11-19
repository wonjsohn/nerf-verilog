#!/usr/bin/env python
# -*- coding: utf-8 -*-

if __name__ == "__main__":
    import sys, PyQt4
    sys.path.append('../../../source/py/')
    from Controls import User1
    app = PyQt4.QtGui.QApplication(sys.argv)
    user1 = User1()
    user1.show()
    sys.exit(app.exec_())
