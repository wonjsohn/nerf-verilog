from PyQt4.QtCore import Qt

#            address         name   visual_gain         type            color
FPGA_OUTPUT =    (0x20,      'N1_in',      1.0,         'int32',      Qt.darkGray),  \
                (0x22,      'population_neuron0',      1.0,         'spike32',      Qt.red),  \
                (0x24,      'spike_count_0_normal',      1.0,         'int32',      Qt.green),  \
                (0x26,      'variable_synaptic_strength0',      1.0,         'int32',      Qt.black),  \
                (0x28,      'each_I_synapse0',      1.0,         'int32',      Qt.magenta),  \
                (0x2A,      'I_synapse0',      1.0,         'int32',      Qt.darkRed),  \
                (0x2C,      'v_neuron1',      1.0,         'int32',      Qt.darkGray), \
 		(0x2E,      'population_neuron1',      1.0,         'spike32',      Qt.darkRed),  \
                (0x30,      'spike_count_1_normal',      1.0,         'int32',      Qt.darkGray), \
 		(0x32,      'xxx',      1.0,         'int32',      Qt.darkRed),  \
                (0x34,      'each_I_synapse1',      1.0,         'int32',      Qt.darkGray)

#            trig_id    name          type          default_value                
USER_INPUT =   (1, 'xxx',  'float32',      30.0), \
                    (2, 'xxx',  'float32',      0.03), \
                    (3, 'xxx',   'int32',       1), \
                    (4, 'xxx',    'float32',      80.0), \
                    (5, 'xxx',    'int32',      10240), \
                    (6, 'N1_in',      'int32',        10240),  \
                    (7, 'half_count',      'int32',        381),  \
                    (8, 'xxx',      'int32',        0),  \
                    (9, 'lce',      'float32',        1.0),  \
                    (10, 'p_delta',      'int32',        0),  \
                    (11, 'ltd',      'int32',        0),  \
                    (12, 'ltp',      'int32',        0)

SAMPLING_RATE = 1024
NUM_NEURON = 128
