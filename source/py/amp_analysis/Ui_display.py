# -*- coding: utf-8 -*-

# Form implementation generated from reading ui file 'C:\Code\nerf_verilog\source\py\amp_analysis\display.ui'
#
# Created: Tue Apr 09 17:19:38 2013
#      by: PyQt4 UI code generator 4.10
#
# WARNING! All changes made in this file will be lost!

from PyQt4 import QtCore, QtGui

try:
    _fromUtf8 = QtCore.QString.fromUtf8
except AttributeError:
    def _fromUtf8(s):
        return s

try:
    _encoding = QtGui.QApplication.UnicodeUTF8
    def _translate(context, text, disambig):
        return QtGui.QApplication.translate(context, text, disambig, _encoding)
except AttributeError:
    def _translate(context, text, disambig):
        return QtGui.QApplication.translate(context, text, disambig)

class Ui_Dialog(object):
    def setupUi(self, Dialog):
        Dialog.setObjectName(_fromUtf8("Dialog"))
        Dialog.setWindowModality(QtCore.Qt.WindowModal)
        Dialog.resize(982, 682)
        self.listWidget = QtGui.QListWidget(Dialog)
        self.listWidget.setGeometry(QtCore.QRect(10, 40, 281, 151))
        self.listWidget.setObjectName(_fromUtf8("listWidget"))
        self.label = QtGui.QLabel(Dialog)
        self.label.setGeometry(QtCore.QRect(110, 200, 81, 17))
        self.label.setObjectName(_fromUtf8("label"))
        self.checkBox = QtGui.QCheckBox(Dialog)
        self.checkBox.setGeometry(QtCore.QRect(300, 50, 70, 17))
        self.checkBox.setObjectName(_fromUtf8("checkBox"))
        self.checkBox_2 = QtGui.QCheckBox(Dialog)
        self.checkBox_2.setGeometry(QtCore.QRect(300, 70, 70, 17))
        self.checkBox_2.setObjectName(_fromUtf8("checkBox_2"))
        self.checkBox_3 = QtGui.QCheckBox(Dialog)
        self.checkBox_3.setGeometry(QtCore.QRect(300, 90, 70, 17))
        self.checkBox_3.setObjectName(_fromUtf8("checkBox_3"))
        self.checkBox_4 = QtGui.QCheckBox(Dialog)
        self.checkBox_4.setGeometry(QtCore.QRect(300, 110, 70, 17))
        self.checkBox_4.setObjectName(_fromUtf8("checkBox_4"))
        self.checkBox_5 = QtGui.QCheckBox(Dialog)
        self.checkBox_5.setGeometry(QtCore.QRect(300, 130, 70, 17))
        self.checkBox_5.setObjectName(_fromUtf8("checkBox_5"))
        self.pushButton = QtGui.QPushButton(Dialog)
        self.pushButton.setGeometry(QtCore.QRect(300, 170, 171, 31))
        self.pushButton.setObjectName(_fromUtf8("pushButton"))
        self.lineEdit = QtGui.QLineEdit(Dialog)
        self.lineEdit.setGeometry(QtCore.QRect(10, 10, 281, 20))
        self.lineEdit.setObjectName(_fromUtf8("lineEdit"))
        self.label_2 = QtGui.QLabel(Dialog)
        self.label_2.setGeometry(QtCore.QRect(300, 10, 81, 17))
        self.label_2.setObjectName(_fromUtf8("label_2"))
        self.label_4 = QtGui.QLabel(Dialog)
        self.label_4.setGeometry(QtCore.QRect(80, 260, 351, 331))
        self.label_4.setObjectName(_fromUtf8("label_4"))
        self.label_5 = QtGui.QLabel(Dialog)
        self.label_5.setGeometry(QtCore.QRect(460, 260, 361, 331))
        self.label_5.setObjectName(_fromUtf8("label_5"))
        self.pushButton_4 = QtGui.QPushButton(Dialog)
        self.pushButton_4.setGeometry(QtCore.QRect(450, 10, 75, 23))
        self.pushButton_4.setObjectName(_fromUtf8("pushButton_4"))
        self.doubleSpinBox = QtGui.QDoubleSpinBox(Dialog)
        self.doubleSpinBox.setGeometry(QtCore.QRect(490, 180, 62, 22))
        self.doubleSpinBox.setDecimals(2)
        self.doubleSpinBox.setMinimum(-99.0)
        self.doubleSpinBox.setSingleStep(0.1)
        self.doubleSpinBox.setObjectName(_fromUtf8("doubleSpinBox"))
        self.label_3 = QtGui.QLabel(Dialog)
        self.label_3.setGeometry(QtCore.QRect(560, 180, 91, 17))
        self.label_3.setObjectName(_fromUtf8("label_3"))
        self.pushButton_2 = QtGui.QPushButton(Dialog)
        self.pushButton_2.setGeometry(QtCore.QRect(50, 220, 171, 31))
        self.pushButton_2.setObjectName(_fromUtf8("pushButton_2"))
        self.spinBox = QtGui.QSpinBox(Dialog)
        self.spinBox.setGeometry(QtCore.QRect(490, 150, 61, 22))
        self.spinBox.setMaximum(10000)
        self.spinBox.setObjectName(_fromUtf8("spinBox"))
        self.label_6 = QtGui.QLabel(Dialog)
        self.label_6.setGeometry(QtCore.QRect(560, 150, 141, 17))
        self.label_6.setObjectName(_fromUtf8("label_6"))

        self.retranslateUi(Dialog)
        QtCore.QMetaObject.connectSlotsByName(Dialog)

    def retranslateUi(self, Dialog):
        Dialog.setWindowTitle(_translate("Dialog", "Dialog", None))
        self.label.setText(_translate("Dialog", "data glove files", None))
        self.checkBox.setText(_translate("Dialog", "thumb", None))
        self.checkBox_2.setText(_translate("Dialog", "index", None))
        self.checkBox_3.setText(_translate("Dialog", "middle", None))
        self.checkBox_4.setText(_translate("Dialog", "ring", None))
        self.checkBox_5.setText(_translate("Dialog", "pinky", None))
        self.pushButton.setText(_translate("Dialog", "Analysis", None))
        self.label_2.setText(_translate("Dialog", "project path", None))
        self.label_4.setText(_translate("Dialog", "INDEX", None))
        self.label_5.setText(_translate("Dialog", "MIDDLE", None))
        self.pushButton_4.setText(_translate("Dialog", "REFRESH", None))
        self.label_3.setText(_translate("Dialog", "enter pivot value", None))
        self.pushButton_2.setText(_translate("Dialog", "just show", None))
        self.label_6.setText(_translate("Dialog", "enter starting time index", None))


if __name__ == "__main__":
    import sys
    app = QtGui.QApplication(sys.argv)
    Dialog = QtGui.QDialog()
    ui = Ui_Dialog()
    ui.setupUi(Dialog)
    Dialog.show()
    sys.exit(app.exec_())

