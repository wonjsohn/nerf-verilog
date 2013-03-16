from PyQt4.QtCore import Qt

#            address         name   visual_gain         type            color
FPGA_OUTPUT_B1 =    (0x20,      'waveform',      1.0,         'float32',      Qt.blue),  \
                (0x22,      'Ia_spindle0',      1.0,         'float32',      Qt.red),  \
                (0x24,      'II_spindle0',      1.0,         'float32',      Qt.green),  \
                (0x26,      'blank',      1.0,         'int32',      Qt.black),  \
                (0x28,      'blank',      1.0,         'float32',      Qt.magenta),  \
                (0x2A,      'blank',      1.0,         'float32',      Qt.darkRed),  \
                (0x2C,      'blank',      1.0,         'int32',      Qt.darkGray)
                
#            address         name   visual_gain         type            color
FPGA_OUTPUT_B2 =   (0x20,      'v_neuron0',      1.0,         'float32',      Qt.blue),  \
                (0x22,      'population_neuron0',      1.0,         'float32',      Qt.red),  \
                (0x24,      'spike_count_neuron0',      1.0,         'int32',      Qt.green),  \
                (0x26,      'I_synapse0',      1.0,         'int32',      Qt.black),  \
                (0x28,      'blank',      1.0,         'float32',      Qt.magenta),  \
                (0x2A,      'blank',      1.0,         'float32',      Qt.darkRed),  \
                (0x2C,      'blank',      1.0,         'int32',      Qt.darkGray)
                
#            address         name   visual_gain         type            color
FPGA_OUTPUT_B3 =    (0x20,      'mixed_input0',      1.0,         'float32',      Qt.blue),  \
                (0x22,      'total_force_out_muscle0_sync',      1.0,         'float32',      Qt.red),  \
                (0x24,      'spike_count_neuron0_sync',      1.0,         'int32',      Qt.green),  \
                (0x26,      'spike_count_neuron0',      1.0,         'int32',      Qt.black),  \
                (0x28,      'i_EPSC_synapse0',      1.0,         'int32',      Qt.magenta),  \
                (0x2A,      'total_force_out_muscle0',      1.0,         'float32',      Qt.darkRed),  \
                (0x2C,      'blank',      1.0,         'int32',      Qt.darkGray)
                
#            address         name   visual_gain         type            color
FPGA_OUTPUT_DEFAULT =    (0x20,      'f_len',      1.0,         'float32',      Qt.blue),  \
                (0x22,      'f_fr_Ia',      1.0,         'float32',      Qt.red),  \
                (0x24,      'f_len_pxi',      1.0,         'int32',      Qt.green),  \
                (0x26,      'i_MN_spkcnt',      1.0,         'int32',      Qt.black),  \
                (0x28,      'i_EPSC_CN_to_MN',      1.0,         'float32',      Qt.magenta),  \
                (0x2A,      'f_force_bic',      1.0,         'float32',      Qt.darkRed),  \
                (0x2C,      'i_emg',      1.0,         'int32',      Qt.darkGray)

#            trig_id    name          type          default_value                
USER_INPUT_B1 =   (1, 'spindle_gain',  'float32',      4.0), \
                    (2, 'tau',  'float32',      0.03), \
                    (3, 'spindl_offset',   'float32',   10.12), \
                    (4, 'gamma_dyn',    'float32',      80.0), \
                    (5, 'gamma_sta',    'float32',      80.0), \
                    (6, 'xxx',      'int32',        0),  \
                    (7, 'clk_halfCnt',      'int32',        0),  \
                    (8, 'xxx',      'int32',        0),  \
                    (9, 'Lce',      'float32',        1.1),  \
                    (10, 'xxx',      'float32',        1.1),  \
                    (11, 'xxx',      'int32',        0),  \
                    (12, 'xxx',      'int32',        0),  \
                    (13, 'BDAMP1',      'float32',        0.2356),  \
                    (14, 'BDAMP2',      'float32',        0.0362),  \
                    (15, 'BDAMP_chain',      'float32',        0.0132)

#            trig_id    name          type          default_value                
USER_INPUT_B2 =   (1, 'xxx',  'float32',      30.0), \
                    (2, 'xxx',  'float32',      0.03), \
                    (3, 'synapse_gain',   'int32',       1), \
                    (4, 'xxx',    'float32',      80.0), \
                    (5, 'xxx',    'float32',      80.0), \
                    (6, 'xxx',      'int32',        0),  \
                    (7, 'clk_halfCnt',      'int32',        0),  \
                    (8, 'xxx',      'int32',        0),  \
                    (9, 'xxx',      'int32',        1),  \
                    (10, 'p_delta',      'float32',        0.0),  \
                    (11, 'ltd',      'int32',        0),  \
                    (12, 'ltp',      'int32',        0)

#            trig_id    name          type          default_value                
USER_INPUT_B3 =   (1, 'xxx',  'float32',      30.0), \
                    (2, 'tau',  'float32',      0.03), \
                    (3, 'synapse_gain',   'int32',       1), \
                    (4, 'xxx',    'float32',      80.0), \
                    (5, 'xxx',    'float32',      80.0), \
                    (6, 'xxx',      'int32',        0),  \
                    (7, 'clk_halfCnt',      'int32',        0),  \
                    (8, 'xxx',      'int32',        0),  \
                    (9, 'Lce',      'float32',        1.0),  \
                    (10, 'p_delta',      'float32',        0.0),  \
                    (11, 'ltd',      'int32',        0),  \
                    (12, 'ltp',      'int32',        0)

#            trig_id    name          type          default_value                
USER_INPUT_DEFAULT =   (1, 'pps_coef_Ia',  'float32',      30.0), \
                    (2, 'tau',  'float32',      0.03), \
                    (3, 'gain_syn_CN_to_MN',   'int32',       1), \
                    (4, 'gamma_dyn',    'float32',      80.0), \
                    (5, 'gamma_sta',    'float32',      80.0), \
                    (6, 'gain_syn_SN_to_MN',      'int32',        0),  \
                    (7, 'clk_halfCnt',      'int32',        0),  \
                    (8, 'i_M1_CN2_drive',      'int32',        0),  \
                    (9, 'i_gain_syn_CN2_to_MN',      'int32',        1),  \
                    (10, 'bicep_len_pxi',      'float32',        1.0),  \
                    (11, 'i_m1_drive',      'int32',        0),  \
                    (12, 'gain_syn_SN_to_CN',      'int32',        1)
SAMPLING_RATE = 1024
NUM_NEURON = 128
