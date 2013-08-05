from PyQt4.QtCore import Qt

#            address         name   visual_gain         type            color
FPGA_OUTPUT =    (0x20,      'spikecnt',      1.0,         'int32',      Qt.darkGray),  \
                (0x22,      'mixed_input0',      1.0,         'float32',      Qt.red),  \
                (0x24,      'f_neuronoutput',      1.0,         'float32',      Qt.green),  \
                (0x26,      'xxx',      1.0,         'int32',      Qt.black),  \
                (0x28,      'xxx',      1.0,         'int32',      Qt.magenta),  \
                (0x2A,      'xxx',      1.0,         'float32',      Qt.darkRed),  \
                (0x2C,      'xxx',      1.0,         'int32',      Qt.darkGray)

#            trig_id    name          type          default_value                
USER_INPUT =   (1, 'xxx',  'float32',      30.0), \
                    (2, 'xxx',  'float32',      0.03), \
                    (3, 'xxx',   'int32',       1), \
                    (4, 'xxx',    'float32',      80.0), \
                    (5, 'xxx',    'float32',      80.0), \
                    (6, 'xxx',      'int32',        1),  \
                    (7, 'half_count',      'int32',        381),  \
                    (8, 'xxx',      'int32',        0),  \
                    (9, 'lce',      'float32',        1.1),  \
                    (10, 'xxx',      'float32',        1.1),  \
                    (11, 'xxx',      'int32',        0),  \
                    (12, 'xxx',      'int32',        1)

SAMPLING_RATE = 1024
NUM_NEURON = 128
