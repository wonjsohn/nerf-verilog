from PyQt4.QtCore import Qt

#            address         name   visual_gain         type            color
FPGA_OUTPUT_B1 =    (0x20,      'Ia_raster_ch20',      1.0,         'spike32',      Qt.blue),  \
                (0x22,      'Ia_spindle0',      1.0,         'float32',      Qt.red),  \
                (0x24,      'II_spindle0',      1.0,         'float32',      Qt.green),  \
                (0x26,      'mixed_input',      1.0,         'float32',      Qt.black),  \
                (0x28,      'spike_count_length2spk',      1.0,         'int32',      Qt.magenta),  \
                (0x2A,      'i_rand_current_out',      1.0,         'int32',      Qt.darkRed),  \
                (0x2C,      'spike_count_Ia_normal',      1.0,         'int32',      Qt.darkGray),  \
                (0x2E,      'spike_count_II_normal',      1.0,         'int32',      Qt.blue)
                
#            address         name   visual_gain         type            color
FPGA_OUTPUT_B2 =   (0x20,      'v_neuron0',      1.0,         'float32',      Qt.blue),  \
                (0x22,      'population_neuron0',      1.0,         'float32',      Qt.red),  \
                (0x24,      'spike_count_neuron0',      1.0,         'int32',      Qt.green),  \
                (0x26,      'I_synapse0',      1.0,         'int32',      Qt.black),  \
                (0x28,      'blank',      1.0,         'float32',      Qt.magenta),  \
                (0x2A,      'blank',      1.0,         'float32',      Qt.darkRed),  \
                (0x2C,      'blank',      1.0,         'int32',      Qt.darkGray)
                
##            address         name   visual_gain         type            color
#FPGA_OUTPUT_B3 =    (0x20,      'mixed_input0',      1.0,         'float32',      Qt.blue),  \
#                (0x22,      'total_force_out_muscle0_sync',      1.0,         'float32',      Qt.red),  \
#                (0x24,      'spike_count_neuron0_sync',      1.0,         'int32',      Qt.green),  \
#                (0x26,      'spike_count_neuron0',      1.0,         'int32',      Qt.black),  \
#                (0x28,      'i_emg',      1.0,         'int32',      Qt.magenta),  \
#                (0x2A,      'blank',      1.0,         'float32',      Qt.darkRed),  \
#                (0x2C,      'blank',      1.0,         'int32',      Qt.darkGray)
                
                #            address         name   visual_gain         type            color
FPGA_OUTPUT_B3 =    (0x20,      'f_emg',      1.0,         'float32',      Qt.blue),  \
                (0x22,      'spike_count_neuron_MN1',      1.0,         'int32',      Qt.red),  \
                (0x24,      'spike_count_neuron_MN2',      1.0,         'int32',      Qt.green),  \
                (0x26,      'spike_count_neuron_MN3',      1.0,         'int32',      Qt.black),  \
                (0x28,      'spike_count_neuron_MN4',      1.0,         'int32',      Qt.magenta),  \
                (0x2A,      'spike_count_neuron_MN5',      1.0,         'int32',      Qt.darkRed),  \
                (0x2C,      'spike_count_neuron_MN6',      1.0,         'int32',      Qt.darkGray),  \
                (0x2E,      'spike_count_neuron_MN7',      1.0,         'int32',      Qt.blue),  \
                (0x30,      'total_spike_count_sync',      1.0,         'int32',      Qt.red),  \
                (0x32,      'total_force',      1.0,         'float32',      Qt.green),  \
                (0x34,      'spike_count_neuron_sync_inputPin',      1.0,         'int32',      Qt.magenta),  \
                (0x36,      'int_I_synapse',      1.0,         'int32',      Qt.black)
 
### For video recording: only display force 
##            address         name   visual_gain         type            color
#FPGA_OUTPUT_B3 =    (0x20,      'blank',      1.0,         'float32',      Qt.blue),  \
#                (0x22,      'total_force_out_muscle0_sync',      1.0,         'float32',      Qt.red),  \
#                (0x24,      'blank',      1.0,         'int32',      Qt.green),  \
#                (0x26,      'blank',      1.0,         'int32',      Qt.black),  \
#                (0x28,      'blank',      1.0,         'int32',      Qt.magenta),  \
#                (0x2A,      'blank',      1.0,         'float32',      Qt.darkRed),  \
#                (0x2C,      'blank',      1.0,         'int32',      Qt.darkGray)
#                
#            address         name   visual_gain         type            color
FPGA_OUTPUT_DEFAULT =    (0x20,      'f_len',      1.0,         'float32',      Qt.blue),  \
                (0x22,      'f_fr_Ia',      1.0,         'float32',      Qt.red),  \
                (0x24,      'f_len_pxi',      1.0,         'int32',      Qt.green),  \
                (0x26,      'i_MN_spkcnt',      1.0,         'int32',      Qt.black),  \
                (0x28,      'i_EPSC_CN_to_MN',      1.0,         'float32',      Qt.magenta),  \
                (0x2A,      'f_force_bic',      1.0,         'float32',      Qt.darkRed),  \
                (0x2C,      'i_emg',      1.0,         'int32',      Qt.darkGray)

#            trig_id    name          type          default_value                
USER_INPUT_B1 =   (1, 'spindle_Ia_gain',  'float32',      1.5), \
                    (2, 'tau',  'float32',      0.03), \
                    (3, 'spindl_Ia_offset',   'float32',   30.12), \
                    (4, 'gamma_dyn',    'float32',      80.0), \
                    (5, 'gamma_sta',    'float32',      80.0), \
                    (6, 'spindl_II_offset',      'float32',        10.12),  \
                    (7, 'xxx',      'int32',        0),  \
                    (8, 'xxx',      'int32',        0),  \
                    (9, 'Lce',      'float32',        1.1),  \
                    (10, 'spindle_II_gain',      'float32',        1.5),  \
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
                    (7, 'xxx',      'int32',        0),  \
                    (8, 'cortial_input',      'int32',        0),  \
                    (9, 'xxx',      'int32',        1),  \
                    (10, 'p_delta',      'float32',        0.0),  \
                    (11, 'ltd',      'int32',        0),  \
                    (12, 'ltp',      'int32',        0)


#Transfer function:  (close to simulink)
#0.001635 z^2 - 0.001636 z + 7.263e-19
#-------------------------------------
# z^3 - 2.668 z^2 + 2.373 z - 0.7036

#Transfer function: (1/128 pulse width)
#1.524e-05 z^2 - 1.524e-05 z + 3.383e-21
#---------------------------------------
#  z^3 - 2.997 z^2 + 2.995 z - 0.9973
 

#            trig_id    name          type          default_value                
USER_INPUT_B3 =   (1, 'b1',  'float32',      0.001208), \
                    (2, 'tau',  'float32',      0.03), \
                    (3, 'synapse1_gain',   'float32',       100.0), \
                    (4, 'b2',    'float32',      -0.001273), \
                    (5, 'a1',    'float32',      -2.238), \
                    (6, 'a2',      'float32',        1.67),  \
                    (7, 'xxx',      'int32',        0),  \
                    (8, 'a3',      'float32',        -0.4152),  \
                    (9, 'Lce_vel',      'float32',        1.0),  \
                    (10, 'threshold',      'int32',        30),  \
                    (11, 'synapse2_gain',      'float32',        100.0),  \
                    (12, 'synapse_1n2_offset',      'float32',        0)

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
