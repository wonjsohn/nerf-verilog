from PyQt4.QtCore import Qt
import numpy
import random


#            address         name   visual_gain         type            color
FPGA_OUTPUT =    (0x20,      'neuron0_input',      1.0,         'int32',      Qt.darkGray),  \
                (0x22,      'population_neuron0',      1.0,         'spike32',      Qt.red),  \
                (0x24,      'variable_syn_strength0',      1.0,         'int32',      Qt.black),  \
                (0x26,      'delta_w_ltp',      1.0,         'int32',      Qt.black),  \
                (0x28,      'each_I_synapse0',      1.0,         'int32',      Qt.magenta),  \
                (0x2A,      'population_neuron1',      1.0,         'spike32',      Qt.red),  \
                (0x2C,      'variable_syn_strength1',      1.0,         'int32',      Qt.black), \
 		(0x2E,      'blank',      1.0,         'int32',      Qt.darkRed),  \
                (0x30,      'each_I_synapse1',      1.0,         'int32',      Qt.darkGray), \
 		(0x32,      'population_neuron2',      1.0,         'spike32',      Qt.red),  \
		(0x34,      'variable_syn_strength2',      1.0,         'int32',      Qt.black), \
                (0x36,      'each_I_synapse2',      1.0,         'int32',      Qt.darkRed), \
		(0x38,      'population_neuron3',      1.0,         'spike32',      Qt.red), \
		(0x3A,      'variable_syn_strength3',      1.0,         'int32',      Qt.black), \
		(0x3C,      'neuron2_input',      1.0,         'int32',      Qt.darkGray), \
		(0x3E,      'each_I_synapse3',      1.0,         'int32',      Qt.darkGray)

#            trig_id    name          type          default_value                
USER_INPUT =   (1, 'xxx',  'float32',      30.0), \
                    (2, 'xxx',  'float32',      0.03), \
                    (3, 'flag_sync_inputs',   'int32',       0), \
                    (4, 'block_neuron1',    'int32',      0), \
                    (5, 'xxx',    'int32',      10240), \
                    (6, 'N0_in',      'int32',        10240),  \
                    (7, 'half_count',      'int32',        381),  \
                    (8, 'block_neuron2',      'int32',        0),  \
                    (9, 'lce',      'float32',        1.0),  \
                    (10, 'p_delta',      'int32',        0),  \
                    (11, 'ltd_scale',      'int32',        1),  \
                    (12, 'ltp_scale',      'int32',        2)

SAMPLING_RATE = 1024
NUM_NEURON = 128

