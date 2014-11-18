from PyQt4.QtCore import Qt
import numpy
import random


#            address         name   visual_gain         type            color
FPGA_OUTPUT =    (0x20,      'neuron0_input',      1.0,         'int32',      Qt.darkGray),  \
                (0x22,      'each_I_synapse_n0_n2',      1.0,         'int32',      Qt.red),  \
                (0x24,      'variable_syn_strength0',      1.0,         'int32',      Qt.black),  \
                (0x26,      'I_synapse0',      1.0,         'int32',      Qt.black),  \
                (0x28,      'spike_count_0_normal',      1.0,         'int32',      Qt.magenta),  \
                (0x2A,      'population_neuron1',      1.0,         'spike32',      Qt.red),  \
                (0x2C,      'variable_syn_strength1',      1.0,         'int32',      Qt.black), \
 		(0x2E,      'I_synapse1',      1.0,         'int32',      Qt.darkRed),  \
                (0x30,      'spike_spike_neuron0',      1.0,         'int32',      Qt.darkGray), \
 		(0x32,      'population_neuron2',      1.0,         'spike32',      Qt.red),  \
		(0x34,      'variable_syn_strength2',      1.0,         'int32',      Qt.black), \
                (0x36,      's_spike_neuron1d',      1.0,         'int32',      Qt.darkRed), \
		(0x38,      's_spike_neuron3',      1.0,         'int32',      Qt.red), \
		(0x3A,      'variable_syn_strength3',      1.0,         'int32',      Qt.black), \
		(0x3C,      'neuron2_input',      1.0,         'int32',      Qt.darkGray), \
		(0x3E,      'each_I_synapse3',      1.0,         'int32',      Qt.darkGray)


#            trig_id    name          type          default_value                
USER_INPUT =   (1, 'synaptic_decay',  'int32',      1), \
                    (2, 'random_digits',  'int32',      11), \
                    (3, 'flag_sync_inputs',   'int32',       0), \
                    (4, 'block_neuron0',    'int32',      0), \
                    (5, 'i_p_deltaW',    'int32',      1000), \
                    (6, 'N0_in',      'int32',        1600),  \
                    (7, 'half_count',      'int32',        381),  \
                    (8, 'block_neuron2',      'int32',        0),  \
                    (9, 'i_weightUpperCap',      'int32',        200000.0),  \
                    (10, 'i_p_decay_ipsi',      'int32',        30),  \
                    (11, 'i_ltd_scale',      'int32',        1),  \
                    (12, 'i_ltp_scale',      'int32',        1), \
		    (13, 'i_p_decay_contra',      'int32',        20)

SAMPLING_RATE = 1024
NUM_NEURON = 128

