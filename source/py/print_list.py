#! /usr/bin/python
from generate_sin import *
from generate_spikes import *
from struct import pack, unpack
import pickle

def ConvertType(val, fromType, toType):
    return unpack(toType, pack(fromType, val))[0]

#x =  gen(F = 2.0, BIAS = 1.0, AMP = 0.2)
x = spike_train(firing_rate = 150)
file = open('/home/eric/outx.txt', 'w')
for item in x:
  #new_item = ConvertType(item, 'f', 'i')
  print>>file, "%x" % item

file.close()
