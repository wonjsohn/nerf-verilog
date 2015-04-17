from PyQt4.QtCore import Qt

#            address         name   visual_gain         type            color
FPGA_OUTPUT_B1 =    (0x20,      'population_neuron0',      1.0,         'spike32',      Qt.blue),  \
                (0x22,      'Ia_spindle0',      1.0,         'float32',      Qt.red),  \
                (0x24,      'II_spindle0',      1.0,         'float32',      Qt.green),  \
                (0x26,      'mixed_input',      1.0,         'float32',      Qt.black),  \
                (0x28,      'i_wn_counter',      1.0,         'int32',      Qt.magenta),  \
                (0x2A,      'i_rng_current_to_SN_Ia',      1.0,         'int32',      Qt.darkRed),  \
                (0x2C,      'spike_count_Ia_normal',      1.0,         'int32',      Qt.darkGray),  \
                (0x2E,      'spike_count_II_normal',      1.0,         'int32',      Qt.blue),  \
                (0x30,      'population_neuron0_II',      1.0,         'spike32',      Qt.red)
                
##            address         name   visual_gain         type            color
#FPGA_OUTPUT_B2 =   (0x20,      'i_I_from_CN2extra_buttonScaled',      1.0,         'int32',      Qt.blue),  \
#                (0x22,      'population_neuron_CN1',      1.0,         'spike32',      Qt.red),  \
#                (0x24,      'i_I_from_spindle',      1.0,         'int32',      Qt.green),  \
#                (0x26,      'fixed_drive_to_CN',      1.0,         'int32',      Qt.black),  \
#                (0x28,      'i_I_from_CN1extra',      1.0,         'int32',      Qt.magenta),  \
#                (0x2A,      'mixed_input0',      1.0,         'float32',      Qt.darkRed),  \
#                (0x2C,      'i_stuffed_scaler',      1.0,         'int32',      Qt.darkGray)
#                
#            address         name   visual_gain         type            color
FPGA_OUTPUT_B2 =   (0x20,      'i_rng_CN1_extra_drive',      1.0,         'int32',      Qt.blue),  \
                (0x22,      'i_gainScaled_I_from_spindle',      1.0,         'int32',      Qt.red),  \
                (0x24,      'fixed_drive_to_CN_offset_subtracted',      1.0,         'int32',      Qt.green),  \
                (0x26,      'f_I_synapse_Ia',      1.0,         'float32',      Qt.black),  \
                (0x28,      'i_CN2_extra_drive',      1.0,         'int32',      Qt.magenta),  \
                (0x2A,      'i_I_from_spindle',      1.0,         'int32',      Qt.darkRed),  \
                (0x2C,      'i_cn_counter',      1.0,         'int32',      Qt.darkGray),  \
                (0x2E,      'i_scaled_drive_to_CN',      1.0,         'int32',      Qt.red)
                 
                #            address         name   visual_gain         type            color
FPGA_OUTPUT_B3 =    (0x20,      'f_emg',      1.0,         'float32',      Qt.blue),  \
                (0x22,      'raster0_31_MN1',      1.0,         'spike32',      Qt.red),  \
                (0x24,      'raster0_31_MN2',      1.0,         'spike32',      Qt.green),  \
                (0x26,      'raster0_31_MN3',      1.0,         'spike32',      Qt.black),  \
                (0x28,      'raster0_31_MN4',      1.0,         'spike32',      Qt.magenta),  \
                (0x2A,      'raster0_31_MN5',      1.0,         'spike32',      Qt.darkRed),  \
                (0x2C,      'raster0_31_MN6',      1.0,         'spike32',      Qt.darkGray),  \
                (0x2E,      'xxx',      1.0,         'float32',      Qt.darkGray),  \
                (0x30,      'i_active_muscleDrive',      1.0,         'int32',      Qt.red),  \
                (0x32,      'f_force',      1.0,         'float32',      Qt.green),  \
                (0x34,      'xxx',      1.0,         'int32',      Qt.magenta),  \
                (0x36,      'f_I_synapse_CN',      1.0,         'float32',      Qt.black)
 
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
USER_INPUT_B1 =   (1, 'spindle_Ia_gain',  'float32',      1.2), \
                    (2, 'tau',  'float32',      0.03), \
                    (3, 'spindl_Ia_offset',   'float32',   0.0), \
                    (4, 'gamma_dyn',    'float32',      80.0), \
                    (5, 'gamma_sta',    'float32',      80.0), \
                    (6, 'spindl_II_offset',      'float32',        0.0),  \
                    (7, 'half_cnt',      'int32',        0),  \
                    (8, 'xxx',      'int32',        0),  \
                    (9, 'Lce',      'float32',        1.0),  \
                    (10, 'spindle_II_gain',      'float32',        2.0),  \
                    (11, 'xxx',      'int32',        0),  \
                    (12, 'xxx',      'int32',        0),  \
                    (13, 'BDAMP1',      'float32',        0.2356),  \
                    (14, 'BDAMP2',      'float32',        0.0362),  \
                    (15, 'BDAMP_chain',      'float32',        0.0132)

#            trig_id    name          type          default_value                
USER_INPUT_B2 =   (1, 'Ia_gain',  'float32',      1.0), \
                    (2, 'II_gain',  'float32',      1.0), \
                    (3, 'synapse_gain',   'int32',       1), \
                    (4, 'overflow',    'float32',      1.0), \
                    (5, 'xxx',    'float32',      80.0), \
                    (6, 'CN_offset',      'int32',        0),  \
                    (7, 'half_cnt',      'int32',        0),  \
                    (8, 'i_CN1_extra_drive',      'int32',        0),  \
                    (9, 'mixed_input0(sine)',      'float32',        0.0),  \
                    (10, 'p_delta',      'float32',        0.0),  \
                    (11, 'ltd',      'int32',        0),  \
                    (12, 'ltp',      'int32',        0),  \
                    (13, 'f_extraCN_syn_gain',      'float32',        4.0)


#Transfer function:  (close to simulink)
#0.001635 z^2 - 0.001636 z + 7.263e-19
#-------------------------------------
# z^3 - 2.668 z^2 + 2.373 z - 0.7036

#Transfer function: (1/128 pulse width)
#1.524e-05 z^2 - 1.524e-05 z + 3.383e-21
#---------------------------------------
#  z^3 - 2.997 z^2 + 2.995 z - 0.9973

# f= (2*t+350*t.^2).*exp(300*t);   pulse width ~= 5ms, dies out around 40ms 

#Transfer function:
#0.001208 z^2 - 0.001273 z - 2.826e-19
#-------------------------------------
#  z^3 - 2.238 z^2 + 1.67 z - 0.4152

#            trig_id    name          type          default_value                
USER_INPUT_B3 =   (1, 'b1',  'float32',      0.002389), \
                    (2, 'tau',  'float32',      0.03), \
                    (3, 'syn_Ia_gain',   'float32',       35.0), \
                    (4, 'b2',    'float32',      -0.002474), \
                    (5, 'xxx',    'float32',      -2.238), \
                    (6, 's_weight',      'int32',        0),  \
                    (7, 'half_cnt',      'int32',        0),  \
                    (8, 'MN_offset',      'int32',        0),  \
                    (9, 'Lce_vel',      'float32',        1.0),  \
                    (10, 'syn_CN_gain',      'float32',        50.0),  \
                    (11, 'syn_II_gain',      'float32',        35.0),  \
                    (12, 'synapse_1n2_offset',      'float32',        0.0)
               

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
