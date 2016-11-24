from PyQt4.QtCore import Qt
import numpy
import random


#            address         name   visual_gain         type            color
FPGA_OUTPUT =    (0x20,      'xxx',      1.0,         'int32',      Qt.darkGray),  \
                (0x22,      'xxx',      1.0,         'int32',      Qt.red),  \
                (0x24,      'f_derivative',      1.0,         'float32',      Qt.black),  \
                (0x26,      'mixed_input0',      1.0,         'float32',      Qt.black),  \
                (0x28,      'f_difference',      1.0,         'float32',      Qt.magenta),  \
                (0x2A,      'xxx',      1.0,         'spike32',      Qt.red),  \
                (0x2C,      'xxx',      1.0,         'int32',      Qt.black)

#            trig_id    name          type          default_value                
USER_INPUT =   (1, 'xxx',  'int32',      1), \
                    (2, 'xxx',  'int32',      11), \
                    (3, 'xxx',   'int32',       0), \
                    (4, 'xxx',    'int32',      0), \
                    (5, 'xxx',    'int32',      1000), \
                    (6, 'xxx',      'int32',        1600),  \
                    (7, 'half_count',      'int32',        381),  \
                    (8, 'xxx',      'int32',        0),  \
                    (9, 'xxx',      'int32',        200000.0),  \
                    (10, 'xxx',      'int32',        30),  \
                    (11, 'xxx',      'int32',        1),  \
                    (12, 'xxx',      'int32',        1), \
		    (13, 'xxx',      'int32',        20)

SAMPLING_RATE = 1024
NUM_NEURON = 128

