# -*- coding: utf-8 -*-

# Form implementation generated from reading ui file '/home/minos001/nerf_project/nerf_verilog_cmn/projects/stretch_reflex/stretch_reflex_pytester/Controls.ui'
#
# Created: Mon Oct 24 11:24:15 2011
#      by: PyQt4 UI code generator 4.8.3
#
# WARNING! All changes made in this file will be lost!

from PyQt4 import QtCore, QtGui

try:
    _fromUtf8 = QtCore.QString.fromUtf8
except AttributeError:
    _fromUtf8 = lambda s: s

class Ui_Dialog(object):
    def setupUi(self, Dialog):
        Dialog.setObjectName(_fromUtf8("Dialog"))
        Dialog.setWindowModality(QtCore.Qt.WindowModal)
        Dialog.resize(463, 840)
        self.pushButton_2 = QtGui.QPushButton(Dialog)
        self.pushButton_2.setGeometry(QtCore.QRect(20, 30, 105, 30))
        self.pushButton_2.setObjectName(_fromUtf8("pushButton_2"))
        self.pushButton_4 = QtGui.QPushButton(Dialog)
        self.pushButton_4.setGeometry(QtCore.QRect(20, 110, 105, 30))
        self.pushButton_4.setCheckable(True)
        self.pushButton_4.setObjectName(_fromUtf8("pushButton_4"))
        self.pushButton_5 = QtGui.QPushButton(Dialog)
        self.pushButton_5.setGeometry(QtCore.QRect(20, 150, 105, 30))
        self.pushButton_5.setCheckable(True)
        self.pushButton_5.setObjectName(_fromUtf8("pushButton_5"))
        self.comboBox = QtGui.QComboBox(Dialog)
        self.comboBox.setGeometry(QtCore.QRect(20, 240, 101, 31))
        self.comboBox.setObjectName(_fromUtf8("comboBox"))
        self.comboBox.addItem(_fromUtf8(""))
        self.comboBox.addItem(_fromUtf8(""))
        self.comboBox.addItem(_fromUtf8(""))
        self.layoutWidget = QtGui.QWidget(Dialog)
        self.layoutWidget.setGeometry(QtCore.QRect(230, 80, 176, 34))
        self.layoutWidget.setObjectName(_fromUtf8("layoutWidget"))
        self.formLayout_1 = QtGui.QFormLayout(self.layoutWidget)
        self.formLayout_1.setMargin(0)
        self.formLayout_1.setObjectName(_fromUtf8("formLayout_1"))
        self.label_1 = QtGui.QLabel(self.layoutWidget)
        self.label_1.setObjectName(_fromUtf8("label_1"))
        self.formLayout_1.setWidget(0, QtGui.QFormLayout.FieldRole, self.label_1)
        self.doubleSpinBox_1 = QtGui.QDoubleSpinBox(self.layoutWidget)
        self.doubleSpinBox_1.setMaximum(200.0)
        self.doubleSpinBox_1.setProperty(_fromUtf8("value"), 80.0)
        self.doubleSpinBox_1.setObjectName(_fromUtf8("doubleSpinBox_1"))
        self.formLayout_1.setWidget(0, QtGui.QFormLayout.LabelRole, self.doubleSpinBox_1)
        self.horizontalSlider = QtGui.QSlider(Dialog)
        self.horizontalSlider.setGeometry(QtCore.QRect(21, 281, 171, 25))
        self.horizontalSlider.setMinimum(1)
        self.horizontalSlider.setMaximum(1000)
        self.horizontalSlider.setTracking(False)
        self.horizontalSlider.setOrientation(QtCore.Qt.Horizontal)
        self.horizontalSlider.setInvertedControls(True)
        self.horizontalSlider.setTickPosition(QtGui.QSlider.TicksBelow)
        self.horizontalSlider.setTickInterval(10)
        self.horizontalSlider.setObjectName(_fromUtf8("horizontalSlider"))
        self.lcdNumber = QtGui.QLCDNumber(Dialog)
        self.lcdNumber.setGeometry(QtCore.QRect(0, 300, 81, 40))
        sizePolicy = QtGui.QSizePolicy(QtGui.QSizePolicy.Minimum, QtGui.QSizePolicy.Minimum)
        sizePolicy.setHorizontalStretch(0)
        sizePolicy.setVerticalStretch(0)
        sizePolicy.setHeightForWidth(self.lcdNumber.sizePolicy().hasHeightForWidth())
        self.lcdNumber.setSizePolicy(sizePolicy)
        palette = QtGui.QPalette()
        brush = QtGui.QBrush(QtGui.QColor(0, 0, 0))
        brush.setStyle(QtCore.Qt.SolidPattern)
        palette.setBrush(QtGui.QPalette.Active, QtGui.QPalette.WindowText, brush)
        brush = QtGui.QBrush(QtGui.QColor(255, 0, 0))
        brush.setStyle(QtCore.Qt.SolidPattern)
        palette.setBrush(QtGui.QPalette.Active, QtGui.QPalette.Button, brush)
        brush = QtGui.QBrush(QtGui.QColor(255, 127, 127))
        brush.setStyle(QtCore.Qt.SolidPattern)
        palette.setBrush(QtGui.QPalette.Active, QtGui.QPalette.Light, brush)
        brush = QtGui.QBrush(QtGui.QColor(255, 63, 63))
        brush.setStyle(QtCore.Qt.SolidPattern)
        palette.setBrush(QtGui.QPalette.Active, QtGui.QPalette.Midlight, brush)
        brush = QtGui.QBrush(QtGui.QColor(127, 0, 0))
        brush.setStyle(QtCore.Qt.SolidPattern)
        palette.setBrush(QtGui.QPalette.Active, QtGui.QPalette.Dark, brush)
        brush = QtGui.QBrush(QtGui.QColor(170, 0, 0))
        brush.setStyle(QtCore.Qt.SolidPattern)
        palette.setBrush(QtGui.QPalette.Active, QtGui.QPalette.Mid, brush)
        brush = QtGui.QBrush(QtGui.QColor(0, 0, 0))
        brush.setStyle(QtCore.Qt.SolidPattern)
        palette.setBrush(QtGui.QPalette.Active, QtGui.QPalette.Text, brush)
        brush = QtGui.QBrush(QtGui.QColor(255, 255, 255))
        brush.setStyle(QtCore.Qt.SolidPattern)
        palette.setBrush(QtGui.QPalette.Active, QtGui.QPalette.BrightText, brush)
        brush = QtGui.QBrush(QtGui.QColor(0, 0, 0))
        brush.setStyle(QtCore.Qt.SolidPattern)
        palette.setBrush(QtGui.QPalette.Active, QtGui.QPalette.ButtonText, brush)
        brush = QtGui.QBrush(QtGui.QColor(255, 255, 255))
        brush.setStyle(QtCore.Qt.SolidPattern)
        palette.setBrush(QtGui.QPalette.Active, QtGui.QPalette.Base, brush)
        brush = QtGui.QBrush(QtGui.QColor(255, 0, 0))
        brush.setStyle(QtCore.Qt.SolidPattern)
        palette.setBrush(QtGui.QPalette.Active, QtGui.QPalette.Window, brush)
        brush = QtGui.QBrush(QtGui.QColor(0, 0, 0))
        brush.setStyle(QtCore.Qt.SolidPattern)
        palette.setBrush(QtGui.QPalette.Active, QtGui.QPalette.Shadow, brush)
        brush = QtGui.QBrush(QtGui.QColor(255, 127, 127))
        brush.setStyle(QtCore.Qt.SolidPattern)
        palette.setBrush(QtGui.QPalette.Active, QtGui.QPalette.AlternateBase, brush)
        brush = QtGui.QBrush(QtGui.QColor(255, 255, 220))
        brush.setStyle(QtCore.Qt.SolidPattern)
        palette.setBrush(QtGui.QPalette.Active, QtGui.QPalette.ToolTipBase, brush)
        brush = QtGui.QBrush(QtGui.QColor(0, 0, 0))
        brush.setStyle(QtCore.Qt.SolidPattern)
        palette.setBrush(QtGui.QPalette.Active, QtGui.QPalette.ToolTipText, brush)
        brush = QtGui.QBrush(QtGui.QColor(0, 0, 0))
        brush.setStyle(QtCore.Qt.SolidPattern)
        palette.setBrush(QtGui.QPalette.Inactive, QtGui.QPalette.WindowText, brush)
        brush = QtGui.QBrush(QtGui.QColor(255, 0, 0))
        brush.setStyle(QtCore.Qt.SolidPattern)
        palette.setBrush(QtGui.QPalette.Inactive, QtGui.QPalette.Button, brush)
        brush = QtGui.QBrush(QtGui.QColor(255, 127, 127))
        brush.setStyle(QtCore.Qt.SolidPattern)
        palette.setBrush(QtGui.QPalette.Inactive, QtGui.QPalette.Light, brush)
        brush = QtGui.QBrush(QtGui.QColor(255, 63, 63))
        brush.setStyle(QtCore.Qt.SolidPattern)
        palette.setBrush(QtGui.QPalette.Inactive, QtGui.QPalette.Midlight, brush)
        brush = QtGui.QBrush(QtGui.QColor(127, 0, 0))
        brush.setStyle(QtCore.Qt.SolidPattern)
        palette.setBrush(QtGui.QPalette.Inactive, QtGui.QPalette.Dark, brush)
        brush = QtGui.QBrush(QtGui.QColor(170, 0, 0))
        brush.setStyle(QtCore.Qt.SolidPattern)
        palette.setBrush(QtGui.QPalette.Inactive, QtGui.QPalette.Mid, brush)
        brush = QtGui.QBrush(QtGui.QColor(0, 0, 0))
        brush.setStyle(QtCore.Qt.SolidPattern)
        palette.setBrush(QtGui.QPalette.Inactive, QtGui.QPalette.Text, brush)
        brush = QtGui.QBrush(QtGui.QColor(255, 255, 255))
        brush.setStyle(QtCore.Qt.SolidPattern)
        palette.setBrush(QtGui.QPalette.Inactive, QtGui.QPalette.BrightText, brush)
        brush = QtGui.QBrush(QtGui.QColor(0, 0, 0))
        brush.setStyle(QtCore.Qt.SolidPattern)
        palette.setBrush(QtGui.QPalette.Inactive, QtGui.QPalette.ButtonText, brush)
        brush = QtGui.QBrush(QtGui.QColor(255, 255, 255))
        brush.setStyle(QtCore.Qt.SolidPattern)
        palette.setBrush(QtGui.QPalette.Inactive, QtGui.QPalette.Base, brush)
        brush = QtGui.QBrush(QtGui.QColor(255, 0, 0))
        brush.setStyle(QtCore.Qt.SolidPattern)
        palette.setBrush(QtGui.QPalette.Inactive, QtGui.QPalette.Window, brush)
        brush = QtGui.QBrush(QtGui.QColor(0, 0, 0))
        brush.setStyle(QtCore.Qt.SolidPattern)
        palette.setBrush(QtGui.QPalette.Inactive, QtGui.QPalette.Shadow, brush)
        brush = QtGui.QBrush(QtGui.QColor(255, 127, 127))
        brush.setStyle(QtCore.Qt.SolidPattern)
        palette.setBrush(QtGui.QPalette.Inactive, QtGui.QPalette.AlternateBase, brush)
        brush = QtGui.QBrush(QtGui.QColor(255, 255, 220))
        brush.setStyle(QtCore.Qt.SolidPattern)
        palette.setBrush(QtGui.QPalette.Inactive, QtGui.QPalette.ToolTipBase, brush)
        brush = QtGui.QBrush(QtGui.QColor(0, 0, 0))
        brush.setStyle(QtCore.Qt.SolidPattern)
        palette.setBrush(QtGui.QPalette.Inactive, QtGui.QPalette.ToolTipText, brush)
        brush = QtGui.QBrush(QtGui.QColor(127, 0, 0))
        brush.setStyle(QtCore.Qt.SolidPattern)
        palette.setBrush(QtGui.QPalette.Disabled, QtGui.QPalette.WindowText, brush)
        brush = QtGui.QBrush(QtGui.QColor(255, 0, 0))
        brush.setStyle(QtCore.Qt.SolidPattern)
        palette.setBrush(QtGui.QPalette.Disabled, QtGui.QPalette.Button, brush)
        brush = QtGui.QBrush(QtGui.QColor(255, 127, 127))
        brush.setStyle(QtCore.Qt.SolidPattern)
        palette.setBrush(QtGui.QPalette.Disabled, QtGui.QPalette.Light, brush)
        brush = QtGui.QBrush(QtGui.QColor(255, 63, 63))
        brush.setStyle(QtCore.Qt.SolidPattern)
        palette.setBrush(QtGui.QPalette.Disabled, QtGui.QPalette.Midlight, brush)
        brush = QtGui.QBrush(QtGui.QColor(127, 0, 0))
        brush.setStyle(QtCore.Qt.SolidPattern)
        palette.setBrush(QtGui.QPalette.Disabled, QtGui.QPalette.Dark, brush)
        brush = QtGui.QBrush(QtGui.QColor(170, 0, 0))
        brush.setStyle(QtCore.Qt.SolidPattern)
        palette.setBrush(QtGui.QPalette.Disabled, QtGui.QPalette.Mid, brush)
        brush = QtGui.QBrush(QtGui.QColor(127, 0, 0))
        brush.setStyle(QtCore.Qt.SolidPattern)
        palette.setBrush(QtGui.QPalette.Disabled, QtGui.QPalette.Text, brush)
        brush = QtGui.QBrush(QtGui.QColor(255, 255, 255))
        brush.setStyle(QtCore.Qt.SolidPattern)
        palette.setBrush(QtGui.QPalette.Disabled, QtGui.QPalette.BrightText, brush)
        brush = QtGui.QBrush(QtGui.QColor(127, 0, 0))
        brush.setStyle(QtCore.Qt.SolidPattern)
        palette.setBrush(QtGui.QPalette.Disabled, QtGui.QPalette.ButtonText, brush)
        brush = QtGui.QBrush(QtGui.QColor(255, 0, 0))
        brush.setStyle(QtCore.Qt.SolidPattern)
        palette.setBrush(QtGui.QPalette.Disabled, QtGui.QPalette.Base, brush)
        brush = QtGui.QBrush(QtGui.QColor(255, 0, 0))
        brush.setStyle(QtCore.Qt.SolidPattern)
        palette.setBrush(QtGui.QPalette.Disabled, QtGui.QPalette.Window, brush)
        brush = QtGui.QBrush(QtGui.QColor(0, 0, 0))
        brush.setStyle(QtCore.Qt.SolidPattern)
        palette.setBrush(QtGui.QPalette.Disabled, QtGui.QPalette.Shadow, brush)
        brush = QtGui.QBrush(QtGui.QColor(255, 0, 0))
        brush.setStyle(QtCore.Qt.SolidPattern)
        palette.setBrush(QtGui.QPalette.Disabled, QtGui.QPalette.AlternateBase, brush)
        brush = QtGui.QBrush(QtGui.QColor(255, 255, 220))
        brush.setStyle(QtCore.Qt.SolidPattern)
        palette.setBrush(QtGui.QPalette.Disabled, QtGui.QPalette.ToolTipBase, brush)
        brush = QtGui.QBrush(QtGui.QColor(0, 0, 0))
        brush.setStyle(QtCore.Qt.SolidPattern)
        palette.setBrush(QtGui.QPalette.Disabled, QtGui.QPalette.ToolTipText, brush)
        self.lcdNumber.setPalette(palette)
        self.lcdNumber.setFrameShape(QtGui.QFrame.Panel)
        self.lcdNumber.setFrameShadow(QtGui.QFrame.Sunken)
        self.lcdNumber.setLineWidth(0)
        self.lcdNumber.setMidLineWidth(8)
        self.lcdNumber.setSegmentStyle(QtGui.QLCDNumber.Flat)
        self.lcdNumber.setProperty(_fromUtf8("intValue"), 1)
        self.lcdNumber.setObjectName(_fromUtf8("lcdNumber"))
        self.label_RT = QtGui.QLabel(Dialog)
        self.label_RT.setGeometry(QtCore.QRect(90, 310, 87, 22))
        self.label_RT.setObjectName(_fromUtf8("label_RT"))
        self.pushButtonData = QtGui.QPushButton(Dialog)
        self.pushButtonData.setGeometry(QtCore.QRect(20, 360, 105, 30))
        self.pushButtonData.setCheckable(True)
        self.pushButtonData.setChecked(False)
        self.pushButtonData.setDefault(False)
        self.pushButtonData.setFlat(False)
        self.pushButtonData.setObjectName(_fromUtf8("pushButtonData"))
        self.layoutWidget_2 = QtGui.QWidget(Dialog)
        self.layoutWidget_2.setGeometry(QtCore.QRect(230, 120, 214, 34))
        self.layoutWidget_2.setObjectName(_fromUtf8("layoutWidget_2"))
        self.formLayout_2 = QtGui.QFormLayout(self.layoutWidget_2)
        self.formLayout_2.setMargin(0)
        self.formLayout_2.setObjectName(_fromUtf8("formLayout_2"))
        self.label_2 = QtGui.QLabel(self.layoutWidget_2)
        self.label_2.setObjectName(_fromUtf8("label_2"))
        self.formLayout_2.setWidget(0, QtGui.QFormLayout.FieldRole, self.label_2)
        self.doubleSpinBox_2 = QtGui.QDoubleSpinBox(self.layoutWidget_2)
        self.doubleSpinBox_2.setDecimals(5)
        self.doubleSpinBox_2.setMaximum(1000000.0)
        self.doubleSpinBox_2.setSingleStep(0.1)
        self.doubleSpinBox_2.setProperty(_fromUtf8("value"), 0.25)
        self.doubleSpinBox_2.setObjectName(_fromUtf8("doubleSpinBox_2"))
        self.formLayout_2.setWidget(0, QtGui.QFormLayout.LabelRole, self.doubleSpinBox_2)
        self.layoutWidget_3 = QtGui.QWidget(Dialog)
        self.layoutWidget_3.setGeometry(QtCore.QRect(230, 160, 176, 34))
        self.layoutWidget_3.setObjectName(_fromUtf8("layoutWidget_3"))
        self.formLayout_3 = QtGui.QFormLayout(self.layoutWidget_3)
        self.formLayout_3.setMargin(0)
        self.formLayout_3.setObjectName(_fromUtf8("formLayout_3"))
        self.label_3 = QtGui.QLabel(self.layoutWidget_3)
        self.label_3.setObjectName(_fromUtf8("label_3"))
        self.formLayout_3.setWidget(0, QtGui.QFormLayout.FieldRole, self.label_3)
        self.doubleSpinBox_3 = QtGui.QDoubleSpinBox(self.layoutWidget_3)
        self.doubleSpinBox_3.setMaximum(100.0)
        self.doubleSpinBox_3.setProperty(_fromUtf8("value"), 0.0)
        self.doubleSpinBox_3.setObjectName(_fromUtf8("doubleSpinBox_3"))
        self.formLayout_3.setWidget(0, QtGui.QFormLayout.LabelRole, self.doubleSpinBox_3)
        self.layoutWidget_4 = QtGui.QWidget(Dialog)
        self.layoutWidget_4.setGeometry(QtCore.QRect(230, 200, 203, 34))
        self.layoutWidget_4.setObjectName(_fromUtf8("layoutWidget_4"))
        self.formLayout_4 = QtGui.QFormLayout(self.layoutWidget_4)
        self.formLayout_4.setMargin(0)
        self.formLayout_4.setObjectName(_fromUtf8("formLayout_4"))
        self.label_4 = QtGui.QLabel(self.layoutWidget_4)
        self.label_4.setObjectName(_fromUtf8("label_4"))
        self.formLayout_4.setWidget(0, QtGui.QFormLayout.FieldRole, self.label_4)
        self.doubleSpinBox_4 = QtGui.QDoubleSpinBox(self.layoutWidget_4)
        self.doubleSpinBox_4.setDecimals(5)
        self.doubleSpinBox_4.setMaximum(200.0)
        self.doubleSpinBox_4.setProperty(_fromUtf8("value"), 80.0)
        self.doubleSpinBox_4.setObjectName(_fromUtf8("doubleSpinBox_4"))
        self.formLayout_4.setWidget(0, QtGui.QFormLayout.LabelRole, self.doubleSpinBox_4)
        self.layoutWidget_5 = QtGui.QWidget(Dialog)
        self.layoutWidget_5.setGeometry(QtCore.QRect(230, 240, 176, 34))
        self.layoutWidget_5.setObjectName(_fromUtf8("layoutWidget_5"))
        self.formLayout_5 = QtGui.QFormLayout(self.layoutWidget_5)
        self.formLayout_5.setMargin(0)
        self.formLayout_5.setObjectName(_fromUtf8("formLayout_5"))
        self.label_5 = QtGui.QLabel(self.layoutWidget_5)
        self.label_5.setObjectName(_fromUtf8("label_5"))
        self.formLayout_5.setWidget(0, QtGui.QFormLayout.FieldRole, self.label_5)
        self.doubleSpinBox_5 = QtGui.QDoubleSpinBox(self.layoutWidget_5)
        self.doubleSpinBox_5.setMaximum(200.0)
        self.doubleSpinBox_5.setProperty(_fromUtf8("value"), 80.0)
        self.doubleSpinBox_5.setObjectName(_fromUtf8("doubleSpinBox_5"))
        self.formLayout_5.setWidget(0, QtGui.QFormLayout.LabelRole, self.doubleSpinBox_5)
        self.layoutWidget_6 = QtGui.QWidget(Dialog)
        self.layoutWidget_6.setGeometry(QtCore.QRect(230, 280, 176, 34))
        self.layoutWidget_6.setObjectName(_fromUtf8("layoutWidget_6"))
        self.formLayout_6 = QtGui.QFormLayout(self.layoutWidget_6)
        self.formLayout_6.setMargin(0)
        self.formLayout_6.setObjectName(_fromUtf8("formLayout_6"))
        self.label_6 = QtGui.QLabel(self.layoutWidget_6)
        self.label_6.setObjectName(_fromUtf8("label_6"))
        self.formLayout_6.setWidget(0, QtGui.QFormLayout.FieldRole, self.label_6)
        self.doubleSpinBox_6 = QtGui.QDoubleSpinBox(self.layoutWidget_6)
        self.doubleSpinBox_6.setMaximum(200.0)
        self.doubleSpinBox_6.setProperty(_fromUtf8("value"), 80.0)
        self.doubleSpinBox_6.setObjectName(_fromUtf8("doubleSpinBox_6"))
        self.formLayout_6.setWidget(0, QtGui.QFormLayout.LabelRole, self.doubleSpinBox_6)
        self.layoutWidget_7 = QtGui.QWidget(Dialog)
        self.layoutWidget_7.setGeometry(QtCore.QRect(230, 320, 176, 34))
        self.layoutWidget_7.setObjectName(_fromUtf8("layoutWidget_7"))
        self.formLayout_7 = QtGui.QFormLayout(self.layoutWidget_7)
        self.formLayout_7.setMargin(0)
        self.formLayout_7.setObjectName(_fromUtf8("formLayout_7"))
        self.label_7 = QtGui.QLabel(self.layoutWidget_7)
        self.label_7.setObjectName(_fromUtf8("label_7"))
        self.formLayout_7.setWidget(0, QtGui.QFormLayout.FieldRole, self.label_7)
        self.doubleSpinBox_7 = QtGui.QDoubleSpinBox(self.layoutWidget_7)
        self.doubleSpinBox_7.setMaximum(200.0)
        self.doubleSpinBox_7.setProperty(_fromUtf8("value"), 80.0)
        self.doubleSpinBox_7.setObjectName(_fromUtf8("doubleSpinBox_7"))
        self.formLayout_7.setWidget(0, QtGui.QFormLayout.LabelRole, self.doubleSpinBox_7)
        self.layoutWidget_8 = QtGui.QWidget(Dialog)
        self.layoutWidget_8.setGeometry(QtCore.QRect(230, 360, 176, 34))
        self.layoutWidget_8.setObjectName(_fromUtf8("layoutWidget_8"))
        self.formLayout_8 = QtGui.QFormLayout(self.layoutWidget_8)
        self.formLayout_8.setMargin(0)
        self.formLayout_8.setObjectName(_fromUtf8("formLayout_8"))
        self.label_8 = QtGui.QLabel(self.layoutWidget_8)
        self.label_8.setObjectName(_fromUtf8("label_8"))
        self.formLayout_8.setWidget(0, QtGui.QFormLayout.FieldRole, self.label_8)
        self.doubleSpinBox_8 = QtGui.QDoubleSpinBox(self.layoutWidget_8)
        self.doubleSpinBox_8.setMaximum(200.0)
        self.doubleSpinBox_8.setProperty(_fromUtf8("value"), 80.0)
        self.doubleSpinBox_8.setObjectName(_fromUtf8("doubleSpinBox_8"))
        self.formLayout_8.setWidget(0, QtGui.QFormLayout.LabelRole, self.doubleSpinBox_8)
        self.layoutWidget_9 = QtGui.QWidget(Dialog)
        self.layoutWidget_9.setGeometry(QtCore.QRect(230, 40, 176, 34))
        self.layoutWidget_9.setObjectName(_fromUtf8("layoutWidget_9"))
        self.formLayout_0 = QtGui.QFormLayout(self.layoutWidget_9)
        self.formLayout_0.setMargin(0)
        self.formLayout_0.setObjectName(_fromUtf8("formLayout_0"))
        self.label_0 = QtGui.QLabel(self.layoutWidget_9)
        self.label_0.setObjectName(_fromUtf8("label_0"))
        self.formLayout_0.setWidget(0, QtGui.QFormLayout.FieldRole, self.label_0)
        self.doubleSpinBox_0 = QtGui.QDoubleSpinBox(self.layoutWidget_9)
        self.doubleSpinBox_0.setMaximum(200.0)
        self.doubleSpinBox_0.setProperty(_fromUtf8("value"), 80.0)
        self.doubleSpinBox_0.setObjectName(_fromUtf8("doubleSpinBox_0"))
        self.formLayout_0.setWidget(0, QtGui.QFormLayout.LabelRole, self.doubleSpinBox_0)
        self.layoutWidget_10 = QtGui.QWidget(Dialog)
        self.layoutWidget_10.setGeometry(QtCore.QRect(230, 400, 203, 34))
        self.layoutWidget_10.setObjectName(_fromUtf8("layoutWidget_10"))
        self.formLayout_9 = QtGui.QFormLayout(self.layoutWidget_10)
        self.formLayout_9.setMargin(0)
        self.formLayout_9.setObjectName(_fromUtf8("formLayout_9"))
        self.label_9 = QtGui.QLabel(self.layoutWidget_10)
        self.label_9.setObjectName(_fromUtf8("label_9"))
        self.formLayout_9.setWidget(0, QtGui.QFormLayout.FieldRole, self.label_9)
        self.doubleSpinBox_9 = QtGui.QDoubleSpinBox(self.layoutWidget_10)
        self.doubleSpinBox_9.setDecimals(5)
        self.doubleSpinBox_9.setMaximum(2000000.0)
        self.doubleSpinBox_9.setProperty(_fromUtf8("value"), 80.0)
        self.doubleSpinBox_9.setObjectName(_fromUtf8("doubleSpinBox_9"))
        self.formLayout_9.setWidget(0, QtGui.QFormLayout.LabelRole, self.doubleSpinBox_9)
        self.layoutWidget_11 = QtGui.QWidget(Dialog)
        self.layoutWidget_11.setGeometry(QtCore.QRect(230, 440, 203, 34))
        self.layoutWidget_11.setObjectName(_fromUtf8("layoutWidget_11"))
        self.formLayout_10 = QtGui.QFormLayout(self.layoutWidget_11)
        self.formLayout_10.setMargin(0)
        self.formLayout_10.setObjectName(_fromUtf8("formLayout_10"))
        self.label_10 = QtGui.QLabel(self.layoutWidget_11)
        self.label_10.setObjectName(_fromUtf8("label_10"))
        self.formLayout_10.setWidget(0, QtGui.QFormLayout.FieldRole, self.label_10)
        self.doubleSpinBox_10 = QtGui.QDoubleSpinBox(self.layoutWidget_11)
        self.doubleSpinBox_10.setDecimals(5)
        self.doubleSpinBox_10.setMaximum(2000000.0)
        self.doubleSpinBox_10.setProperty(_fromUtf8("value"), 80.0)
        self.doubleSpinBox_10.setObjectName(_fromUtf8("doubleSpinBox_10"))
        self.formLayout_10.setWidget(0, QtGui.QFormLayout.LabelRole, self.doubleSpinBox_10)
        self.layoutWidget_12 = QtGui.QWidget(Dialog)
        self.layoutWidget_12.setGeometry(QtCore.QRect(230, 480, 203, 34))
        self.layoutWidget_12.setObjectName(_fromUtf8("layoutWidget_12"))
        self.formLayout_11 = QtGui.QFormLayout(self.layoutWidget_12)
        self.formLayout_11.setMargin(0)
        self.formLayout_11.setObjectName(_fromUtf8("formLayout_11"))
        self.label_11 = QtGui.QLabel(self.layoutWidget_12)
        self.label_11.setObjectName(_fromUtf8("label_11"))
        self.formLayout_11.setWidget(0, QtGui.QFormLayout.FieldRole, self.label_11)
        self.doubleSpinBox_11 = QtGui.QDoubleSpinBox(self.layoutWidget_12)
        self.doubleSpinBox_11.setDecimals(5)
        self.doubleSpinBox_11.setMaximum(2000000.0)
        self.doubleSpinBox_11.setProperty(_fromUtf8("value"), 80.0)
        self.doubleSpinBox_11.setObjectName(_fromUtf8("doubleSpinBox_11"))
        self.formLayout_11.setWidget(0, QtGui.QFormLayout.LabelRole, self.doubleSpinBox_11)
        self.layoutWidget_13 = QtGui.QWidget(Dialog)
        self.layoutWidget_13.setGeometry(QtCore.QRect(230, 520, 203, 34))
        self.layoutWidget_13.setObjectName(_fromUtf8("layoutWidget_13"))
        self.formLayout_12 = QtGui.QFormLayout(self.layoutWidget_13)
        self.formLayout_12.setMargin(0)
        self.formLayout_12.setObjectName(_fromUtf8("formLayout_12"))
        self.label_12 = QtGui.QLabel(self.layoutWidget_13)
        self.label_12.setObjectName(_fromUtf8("label_12"))
        self.formLayout_12.setWidget(0, QtGui.QFormLayout.FieldRole, self.label_12)
        self.doubleSpinBox_12 = QtGui.QDoubleSpinBox(self.layoutWidget_13)
        self.doubleSpinBox_12.setDecimals(5)
        self.doubleSpinBox_12.setMaximum(2000000.0)
        self.doubleSpinBox_12.setProperty(_fromUtf8("value"), 80.0)
        self.doubleSpinBox_12.setObjectName(_fromUtf8("doubleSpinBox_12"))
        self.formLayout_12.setWidget(0, QtGui.QFormLayout.LabelRole, self.doubleSpinBox_12)
        self.layoutWidget_14 = QtGui.QWidget(Dialog)
        self.layoutWidget_14.setGeometry(QtCore.QRect(230, 560, 203, 34))
        self.layoutWidget_14.setObjectName(_fromUtf8("layoutWidget_14"))
        self.formLayout_13 = QtGui.QFormLayout(self.layoutWidget_14)
        self.formLayout_13.setMargin(0)
        self.formLayout_13.setObjectName(_fromUtf8("formLayout_13"))
        self.label_13 = QtGui.QLabel(self.layoutWidget_14)
        self.label_13.setObjectName(_fromUtf8("label_13"))
        self.formLayout_13.setWidget(0, QtGui.QFormLayout.FieldRole, self.label_13)
        self.doubleSpinBox_13 = QtGui.QDoubleSpinBox(self.layoutWidget_14)
        self.doubleSpinBox_13.setDecimals(5)
        self.doubleSpinBox_13.setMaximum(2000000.0)
        self.doubleSpinBox_13.setProperty(_fromUtf8("value"), 80.0)
        self.doubleSpinBox_13.setObjectName(_fromUtf8("doubleSpinBox_13"))
        self.formLayout_13.setWidget(0, QtGui.QFormLayout.LabelRole, self.doubleSpinBox_13)
        self.layoutWidget_15 = QtGui.QWidget(Dialog)
        self.layoutWidget_15.setGeometry(QtCore.QRect(230, 600, 212, 34))
        self.layoutWidget_15.setObjectName(_fromUtf8("layoutWidget_15"))
        self.formLayout_14 = QtGui.QFormLayout(self.layoutWidget_15)
        self.formLayout_14.setMargin(0)
        self.formLayout_14.setObjectName(_fromUtf8("formLayout_14"))
        self.label_14 = QtGui.QLabel(self.layoutWidget_15)
        self.label_14.setObjectName(_fromUtf8("label_14"))
        self.formLayout_14.setWidget(0, QtGui.QFormLayout.FieldRole, self.label_14)
        self.doubleSpinBox_14 = QtGui.QDoubleSpinBox(self.layoutWidget_15)
        self.doubleSpinBox_14.setDecimals(5)
        self.doubleSpinBox_14.setMaximum(2000000.0)
        self.doubleSpinBox_14.setSingleStep(0.01)
        self.doubleSpinBox_14.setProperty(_fromUtf8("value"), 0.0362)
        self.doubleSpinBox_14.setObjectName(_fromUtf8("doubleSpinBox_14"))
        self.formLayout_14.setWidget(0, QtGui.QFormLayout.LabelRole, self.doubleSpinBox_14)
        self.layoutWidget_16 = QtGui.QWidget(Dialog)
        self.layoutWidget_16.setGeometry(QtCore.QRect(230, 635, 212, 34))
        self.layoutWidget_16.setObjectName(_fromUtf8("layoutWidget_16"))
        self.formLayout_15 = QtGui.QFormLayout(self.layoutWidget_16)
        self.formLayout_15.setMargin(0)
        self.formLayout_15.setObjectName(_fromUtf8("formLayout_15"))
        self.label_15 = QtGui.QLabel(self.layoutWidget_16)
        self.label_15.setObjectName(_fromUtf8("label_15"))
        self.formLayout_15.setWidget(0, QtGui.QFormLayout.FieldRole, self.label_15)
        self.doubleSpinBox_15 = QtGui.QDoubleSpinBox(self.layoutWidget_16)
        self.doubleSpinBox_15.setDecimals(5)
        self.doubleSpinBox_15.setMaximum(2000000.0)
        self.doubleSpinBox_15.setSingleStep(0.1)
        self.doubleSpinBox_15.setProperty(_fromUtf8("value"), 0.2356)
        self.doubleSpinBox_15.setObjectName(_fromUtf8("doubleSpinBox_15"))
        self.formLayout_15.setWidget(0, QtGui.QFormLayout.LabelRole, self.doubleSpinBox_15)
        self.layoutWidget_17 = QtGui.QWidget(Dialog)
        self.layoutWidget_17.setGeometry(QtCore.QRect(230, 670, 203, 34))
        self.layoutWidget_17.setObjectName(_fromUtf8("layoutWidget_17"))
        self.formLayout_16 = QtGui.QFormLayout(self.layoutWidget_17)
        self.formLayout_16.setMargin(0)
        self.formLayout_16.setObjectName(_fromUtf8("formLayout_16"))
        self.label_16 = QtGui.QLabel(self.layoutWidget_17)
        self.label_16.setObjectName(_fromUtf8("label_16"))
        self.formLayout_16.setWidget(0, QtGui.QFormLayout.FieldRole, self.label_16)
        self.doubleSpinBox_16 = QtGui.QDoubleSpinBox(self.layoutWidget_17)
        self.doubleSpinBox_16.setDecimals(5)
        self.doubleSpinBox_16.setMaximum(2000000.0)
        self.doubleSpinBox_16.setProperty(_fromUtf8("value"), 80.0)
        self.doubleSpinBox_16.setObjectName(_fromUtf8("doubleSpinBox_16"))
        self.formLayout_16.setWidget(0, QtGui.QFormLayout.LabelRole, self.doubleSpinBox_16)
        self.layoutWidget_18 = QtGui.QWidget(Dialog)
        self.layoutWidget_18.setGeometry(QtCore.QRect(230, 705, 203, 34))
        self.layoutWidget_18.setObjectName(_fromUtf8("layoutWidget_18"))
        self.formLayout_17 = QtGui.QFormLayout(self.layoutWidget_18)
        self.formLayout_17.setMargin(0)
        self.formLayout_17.setObjectName(_fromUtf8("formLayout_17"))
        self.label_17 = QtGui.QLabel(self.layoutWidget_18)
        self.label_17.setObjectName(_fromUtf8("label_17"))
        self.formLayout_17.setWidget(0, QtGui.QFormLayout.FieldRole, self.label_17)
        self.doubleSpinBox_17 = QtGui.QDoubleSpinBox(self.layoutWidget_18)
        self.doubleSpinBox_17.setDecimals(5)
        self.doubleSpinBox_17.setMaximum(2000000.0)
        self.doubleSpinBox_17.setProperty(_fromUtf8("value"), 80.0)
        self.doubleSpinBox_17.setObjectName(_fromUtf8("doubleSpinBox_17"))
        self.formLayout_17.setWidget(0, QtGui.QFormLayout.LabelRole, self.doubleSpinBox_17)

        self.retranslateUi(Dialog)
        QtCore.QObject.connect(self.horizontalSlider, QtCore.SIGNAL(_fromUtf8("valueChanged(int)")), self.lcdNumber.display)
        QtCore.QObject.connect(self.pushButton_2, QtCore.SIGNAL(_fromUtf8("clicked()")), Dialog.close)
        QtCore.QObject.connect(self.horizontalSlider, QtCore.SIGNAL(_fromUtf8("sliderMoved(int)")), self.lcdNumber.display)
        QtCore.QMetaObject.connectSlotsByName(Dialog)

    def retranslateUi(self, Dialog):
        Dialog.setWindowTitle(QtGui.QApplication.translate("Dialog", "Dialog", None, QtGui.QApplication.UnicodeUTF8))
        self.pushButton_2.setText(QtGui.QApplication.translate("Dialog", "Close", None, QtGui.QApplication.UnicodeUTF8))
        self.pushButton_4.setText(QtGui.QApplication.translate("Dialog", "Reset Global", None, QtGui.QApplication.UnicodeUTF8))
        self.pushButton_5.setText(QtGui.QApplication.translate("Dialog", "ReSim", None, QtGui.QApplication.UnicodeUTF8))
        self.comboBox.setItemText(0, QtGui.QApplication.translate("Dialog", "Spike Train 1Hz", None, QtGui.QApplication.UnicodeUTF8))
        self.comboBox.setItemText(1, QtGui.QApplication.translate("Dialog", "Spike Train 10Hz", None, QtGui.QApplication.UnicodeUTF8))
        self.comboBox.setItemText(2, QtGui.QApplication.translate("Dialog", "Spike Train 20Hz", None, QtGui.QApplication.UnicodeUTF8))
        self.label_1.setText(QtGui.QApplication.translate("Dialog", "unused", None, QtGui.QApplication.UnicodeUTF8))
        self.label_RT.setText(QtGui.QApplication.translate("Dialog", "x Real-time", None, QtGui.QApplication.UnicodeUTF8))
        self.pushButtonData.setText(QtGui.QApplication.translate("Dialog", "Log Data", None, QtGui.QApplication.UnicodeUTF8))
        self.label_2.setText(QtGui.QApplication.translate("Dialog", "pps coef", None, QtGui.QApplication.UnicodeUTF8))
        self.label_3.setText(QtGui.QApplication.translate("Dialog", "Close loop", None, QtGui.QApplication.UnicodeUTF8))
        self.label_4.setText(QtGui.QApplication.translate("Dialog", "GammaDyn", None, QtGui.QApplication.UnicodeUTF8))
        self.label_5.setText(QtGui.QApplication.translate("Dialog", "unused", None, QtGui.QApplication.UnicodeUTF8))
        self.label_6.setText(QtGui.QApplication.translate("Dialog", "unused", None, QtGui.QApplication.UnicodeUTF8))
        self.label_7.setText(QtGui.QApplication.translate("Dialog", "GammaSta", None, QtGui.QApplication.UnicodeUTF8))
        self.label_8.setText(QtGui.QApplication.translate("Dialog", "Clkrate", None, QtGui.QApplication.UnicodeUTF8))
        self.label_0.setText(QtGui.QApplication.translate("Dialog", "unused", None, QtGui.QApplication.UnicodeUTF8))
        self.label_9.setText(QtGui.QApplication.translate("Dialog", "Clkrate", None, QtGui.QApplication.UnicodeUTF8))
        self.label_10.setText(QtGui.QApplication.translate("Dialog", "Clkrate", None, QtGui.QApplication.UnicodeUTF8))
        self.label_11.setText(QtGui.QApplication.translate("Dialog", "Clkrate", None, QtGui.QApplication.UnicodeUTF8))
        self.label_12.setText(QtGui.QApplication.translate("Dialog", "Clkrate", None, QtGui.QApplication.UnicodeUTF8))
        self.label_13.setText(QtGui.QApplication.translate("Dialog", "Clkrate", None, QtGui.QApplication.UnicodeUTF8))
        self.label_14.setText(QtGui.QApplication.translate("Dialog", "B2damp", None, QtGui.QApplication.UnicodeUTF8))
        self.label_15.setText(QtGui.QApplication.translate("Dialog", "B1damp", None, QtGui.QApplication.UnicodeUTF8))
        self.label_16.setText(QtGui.QApplication.translate("Dialog", "Clkrate", None, QtGui.QApplication.UnicodeUTF8))
        self.label_17.setText(QtGui.QApplication.translate("Dialog", "Clkrate", None, QtGui.QApplication.UnicodeUTF8))


if __name__ == "__main__":
    import sys
    app = QtGui.QApplication(sys.argv)
    Dialog = QtGui.QDialog()
    ui = Ui_Dialog()
    ui.setupUi(Dialog)
    Dialog.show()
    sys.exit(app.exec_())

