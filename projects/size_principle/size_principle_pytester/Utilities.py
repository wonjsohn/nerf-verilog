from struct import pack, unpack
from PyQt4.QtCore import Qt

VIEWER_REFRESH_RATE = 10 # in ms, This the T for calculating digital freq
PIPE_IN_ADDR = 0x80
BUTTON_RESET = 0
BUTTON_RESET_SIM = 1
BUTTON_ENABLE_SIM = 2

#DATA_EVT_PPS_I_COEF = 2
#DATA_EVT_GAMMA_DYN = 5
DATA_EVT_CLKRATE = 7
#            add         name   visual_gain         type            color
CHIN_PARAM =    (0x20,      'lce',      50,         'float32',      'Qt.blue'),  \
                (0x22,      'aa',      0.11,         'float32',      'Qt.red'),  \
                (0x24,      'bb',      0.005,         'float32',      'Qt.green'),  \
                (0x26,      'dd',      0.08,         'float32',      'Qt.black'),  \
                (0x28,      'ee',      0,         'float32',      'Qt.gray')
NUM_CHANNEL = len(CHIN_PARAM) # Number of channels

SEND_TYPE = ['', 'float32', 'float32', 'int32', 'float32', 'float32', 'int32', 'int32', '', '', \
             '', '', '', '', 'float32', 'float32']
             

#DISPLAY_SCALING =[50, 0.11,  0.005, 0.08, 0,  0]
DATA_OUT_ADDR = [0x20, 0x22, 0x24, 0x26, 0x28,  0x30]
CH_TYPE = ['float32', 'float32', 'float32', 'int32', 'float32', 'float32']
#CH_NAME = ['lce',  'fr_Ia', 'fr_II', 'force']
#CHANNEL_COLOR = [Qt.blue, Qt.red, Qt.green, Qt.black, Qt.yellow, Qt.gray]
ZERO_DATA = [0.0 for ix in xrange(len(CHIN_PARAM))]
BIT_FILE = "../size_principle_xem6010.bit"
SAMPLING_RATE = 1024
NUM_NEURON = 512


def ConvertType(val, fromType, toType):
    return unpack(toType, pack(fromType, val))[0]
    

import sys, re
def interp(string):
  locals  = sys._getframe(1).f_locals
  globals = sys._getframe(1).f_globals
  for item in re.findall(r'#\{([^}]*)\}', string):
    string = string.replace('#{%s}' % item,
                            str(eval(item, globals, locals)))
  return string

