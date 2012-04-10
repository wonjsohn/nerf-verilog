from struct import pack, unpack
from PyQt4.QtCore import Qt

VIEWER_REFRESH_RATE = 10 # in ms, This the T for calculating digital freq
PIPE_IN_ADDR = 0x80
BUTTON_RESET = 0
BUTTON_RESET_SIM = 1
BUTTON_ENABLE_SIM = 2

DATA_EVT_CLKRATE = 0
#            address         name   visual_gain         type            color
CHIN_PARAM =    (0x20,      'lce',      50,         'float32',      'Qt.blue'),  \
                (0x22,      'aa',      0.11,         'float32',      'Qt.red'),  \
                (0x24,      'bb',      0.005,         'float32',      'Qt.green'),  \
                (0x26,      'dd',      0.08,         'int32',      'Qt.black'),  \
                (0x28,      'ee',      0,         'float32',      'Qt.gray')
NUM_CHANNEL = len(CHIN_PARAM) # Number of channels
DATA_OUT_ADDR = list(zip(*CHIN_PARAM)[0])
CH_TYPE = list(zip(*CHIN_PARAM)[3])
                
#            trig_id    name          type          default_value                
CHOUT_PARAM =   (1, 'pps_coef_Ia',  'float32',      0.5), \
                (2, 'pps_coef_II',  'float32',      0.5), \
                (3, 'close_loop',   'int32',        0), \
                (4, 'gamma_dyn',    'float32',      80.0), \
                (5, 'gamma_sta',    'float32',      80.0), \
                (6, 'gain_MN',      'int32',        8)
                
SEND_TYPE = list(zip(*CHOUT_PARAM)[2])   

BIT_FILE = "../size_principle_xem6010.bit"
SAMPLING_RATE = 1024
NUM_NEURON = 512


def ConvertType(val, fromType, toType):
    return unpack(toType, pack(fromType, val))[0]
    

