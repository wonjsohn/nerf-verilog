from struct import pack, unpack
from PyQt4.QtCore import Qt, SIGNAL, SLOT, pyqtSignature, pyqtSlot

REFRESH_RATE = 10 # in ms, both for data update & display. Min = 10ms 
PIPE_IN_ADDR = 0x80
BUTTON_RESET = 0
BUTTON_RESET_SIM = 2
#BUTTON_ENABLE_SIM = 2
BUTTON_INPUT_FROM_TRIGGER = 1

TRIG_CLKRATE = 0


def convertType(val, fromType, toType):
    return unpack(toType, pack(fromType, val))[0]
    

import sys, re
def interp(string):
  locals  = sys._getframe(1).f_locals
  globals = sys._getframe(1).f_globals
  for item in re.findall(r'#\{([^}]*)\}', string):
    string = string.replace('#{%s}' % item,
                            str(eval(item, globals, locals)))
  return string


