#! /usr/bin/python
import numpy as np
from pylab import *
from struct import pack, unpack


def ConvertType(val, fromType, toType):
    return unpack(toType, pack(fromType, val))[0]

def isFloat(string):
    try:
            float(string)
            return True
    except ValueError:
            return False
    
SAMPLING_RATE = 1024

newData = open('/home/eric/eric_nerf_verilog/source/py/dataout.txt',  'r')


#for item in data:
#   newData = ConvertType(item, 'i', 'f')
#
newData_list = []
for x_i in newData:
    #newData_i = newData_i1 + x_i * (1.0 /SAMPLING_RATE)
    if (isFloat(x_i)):
        newData_list.append(x_i)
        


plot(newData_list)
show()


#pl.plot(newData[:, 0],  newData[:, 1],  'ro')
#pl.xlabel('x')
#pl.ylabel('y')
#
#pl.show()
