# -*- coding: utf-8 -*-

# Form implementation generated from reading ui file '/home/eric/eric_nerf_verilog/projects/size_principle/size_principle_pytester/Display.ui'
#
# Created: Mon Apr  9 14:15:16 2012
#      by: PyQt4 UI code generator 4.7.4
#
# WARNING! All changes made in this file will be lost!

from PyQt4 import QtCore, QtGui

class Ui_Dialog(object):
    def setupUi(self, Dialog):
        Dialog.setObjectName("Dialog")
        Dialog.resize(987, 768)
        self.pushButton = QtGui.QPushButton(Dialog)
        self.pushButton.setGeometry(QtCore.QRect(20, 10, 105, 30))
        self.pushButton.setCheckable(True)
        self.pushButton.setChecked(False)
        self.pushButton.setObjectName("pushButton")
        self.layoutWidget = QtGui.QWidget(Dialog)
        self.layoutWidget.setGeometry(QtCore.QRect(0, 60, 191, 224))
        self.layoutWidget.setObjectName("layoutWidget")
        self.gridLayout = QtGui.QGridLayout(self.layoutWidget)
        self.gridLayout.setObjectName("gridLayout")
        self.lineEdit_5 = QtGui.QLineEdit(self.layoutWidget)
        self.lineEdit_5.setObjectName("lineEdit_5")
        self.gridLayout.addWidget(self.lineEdit_5, 1, 0, 1, 1)
        self.lineEdit_6 = QtGui.QLineEdit(self.layoutWidget)
        self.lineEdit_6.setObjectName("lineEdit_6")
        self.gridLayout.addWidget(self.lineEdit_6, 2, 0, 1, 1)
        self.lineEdit_7 = QtGui.QLineEdit(self.layoutWidget)
        self.lineEdit_7.setObjectName("lineEdit_7")
        self.gridLayout.addWidget(self.lineEdit_7, 3, 0, 1, 1)
        self.lineEdit_8 = QtGui.QLineEdit(self.layoutWidget)
        self.lineEdit_8.setObjectName("lineEdit_8")
        self.gridLayout.addWidget(self.lineEdit_8, 4, 0, 1, 1)
        self.lineEdit_9 = QtGui.QLineEdit(self.layoutWidget)
        self.lineEdit_9.setObjectName("lineEdit_9")
        self.gridLayout.addWidget(self.lineEdit_9, 5, 0, 1, 1)
        self.lineEdit_4 = QtGui.QLineEdit(self.layoutWidget)
        self.lineEdit_4.setObjectName("lineEdit_4")
        self.gridLayout.addWidget(self.lineEdit_4, 0, 0, 1, 1)
        self.doubleSpinBox = QtGui.QDoubleSpinBox(self.layoutWidget)
        self.doubleSpinBox.setSpecialValueText("")
        self.doubleSpinBox.setMaximum(65535.0)
        self.doubleSpinBox.setSingleStep(0.1)
        self.doubleSpinBox.setProperty("value", 99.99)
        self.doubleSpinBox.setObjectName("doubleSpinBox")
        self.gridLayout.addWidget(self.doubleSpinBox, 0, 1, 1, 1)
        self.doubleSpinBox_2 = QtGui.QDoubleSpinBox(self.layoutWidget)
        self.doubleSpinBox_2.setSpecialValueText("")
        self.doubleSpinBox_2.setMaximum(65535.0)
        self.doubleSpinBox_2.setSingleStep(0.1)
        self.doubleSpinBox_2.setProperty("value", 99.99)
        self.doubleSpinBox_2.setObjectName("doubleSpinBox_2")
        self.gridLayout.addWidget(self.doubleSpinBox_2, 1, 1, 1, 1)
        self.doubleSpinBox_3 = QtGui.QDoubleSpinBox(self.layoutWidget)
        self.doubleSpinBox_3.setSpecialValueText("")
        self.doubleSpinBox_3.setMaximum(65535.0)
        self.doubleSpinBox_3.setSingleStep(0.1)
        self.doubleSpinBox_3.setProperty("value", 99.99)
        self.doubleSpinBox_3.setObjectName("doubleSpinBox_3")
        self.gridLayout.addWidget(self.doubleSpinBox_3, 2, 1, 1, 1)
        self.doubleSpinBox_4 = QtGui.QDoubleSpinBox(self.layoutWidget)
        self.doubleSpinBox_4.setSpecialValueText("")
        self.doubleSpinBox_4.setDecimals(5)
        self.doubleSpinBox_4.setMaximum(65535.0)
        self.doubleSpinBox_4.setSingleStep(0.1)
        self.doubleSpinBox_4.setObjectName("doubleSpinBox_4")
        self.gridLayout.addWidget(self.doubleSpinBox_4, 3, 1, 1, 1)
        self.doubleSpinBox_5 = QtGui.QDoubleSpinBox(self.layoutWidget)
        self.doubleSpinBox_5.setSpecialValueText("")
        self.doubleSpinBox_5.setMaximum(65535.0)
        self.doubleSpinBox_5.setSingleStep(0.1)
        self.doubleSpinBox_5.setObjectName("doubleSpinBox_5")
        self.gridLayout.addWidget(self.doubleSpinBox_5, 4, 1, 1, 1)
        self.doubleSpinBox_6 = QtGui.QDoubleSpinBox(self.layoutWidget)
        self.doubleSpinBox_6.setSpecialValueText("")
        self.doubleSpinBox_6.setMaximum(65535.0)
        self.doubleSpinBox_6.setSingleStep(0.1)
        self.doubleSpinBox_6.setObjectName("doubleSpinBox_6")
        self.gridLayout.addWidget(self.doubleSpinBox_6, 5, 1, 1, 1)

        self.retranslateUi(Dialog)
        QtCore.QMetaObject.connectSlotsByName(Dialog)

    def retranslateUi(self, Dialog):
        Dialog.setWindowTitle(QtGui.QApplication.translate("Dialog", "Dialog", None, QtGui.QApplication.UnicodeUTF8))
        self.pushButton.setText(QtGui.QApplication.translate("Dialog", "Pause", None, QtGui.QApplication.UnicodeUTF8))
        self.lineEdit_5.setText(QtGui.QApplication.translate("Dialog", "Ch2 Gain", None, QtGui.QApplication.UnicodeUTF8))
        self.lineEdit_6.setText(QtGui.QApplication.translate("Dialog", "Ch3 Gain", None, QtGui.QApplication.UnicodeUTF8))
        self.lineEdit_7.setText(QtGui.QApplication.translate("Dialog", "Ch4 Gain", None, QtGui.QApplication.UnicodeUTF8))
        self.lineEdit_8.setText(QtGui.QApplication.translate("Dialog", "Ch5 Gain", None, QtGui.QApplication.UnicodeUTF8))
        self.lineEdit_9.setText(QtGui.QApplication.translate("Dialog", "Ch6 Gain", None, QtGui.QApplication.UnicodeUTF8))
        self.lineEdit_4.setText(QtGui.QApplication.translate("Dialog", "Ch1 Gain", None, QtGui.QApplication.UnicodeUTF8))


if __name__ == "__main__":
    import sys
    app = QtGui.QApplication(sys.argv)
    Dialog = QtGui.QDialog()
    ui = Ui_Dialog()
    ui.setupUi(Dialog)
    Dialog.show()
    sys.exit(app.exec_())

