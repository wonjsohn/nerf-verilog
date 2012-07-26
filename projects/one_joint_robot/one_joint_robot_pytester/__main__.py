#!/usr/bin/env python
# -*- coding: utf-8 -*-

if __name__ == "__main__":
    import sys, PyQt4
    sys.path.append('../../../source/py/')
    from Controls import User1#,  User2
    app = PyQt4.QtGui.QApplication(sys.argv)
    user1 = User1()
    #user2 = User2()
    user1.show()
    #user2.show()
    sys.exit(app.exec_())
