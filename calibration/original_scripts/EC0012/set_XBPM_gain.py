from cothread.catools import caget, caput as _caput
from cothread import Sleep
import numpy as np
import re
import matplotlib.pyplot as plt
import time

t0 = time.time()

isCheckMonitor = False

# define functions
def caput(*args, **kwargs):
        _caput(*args, **kwargs)
        caget(args[0]) # needed, for caput to really put
        
def print_warning(message, color='\033[93m'):
    print(color + "Warning: " + message + '\033[0m')

def create_pvs(I_range):
    prefix = 'XF:31ID-BI:{NSLS2_EM:}'
    gain_SP_pv = []
    gain_I_pv = []
    offset_SP_pv = []
    offset_I_pv = []
    for ch in ['A', 'B', 'C', 'D']:
        gain_SP_pv.append(prefix + f'Ch{ch}-{I_range}-Gain-SP')
        gain_I_pv.append(prefix + f'Ch{ch}-{I_range}-Gain-I')
        offset_SP_pv.append(prefix + f'Ch{ch}-{I_range}-Ofst-SP')
        offset_I_pv.append(prefix + f'Ch{ch}-{I_range}-Ofst-I')

    return gain_SP_pv, gain_I_pv, offset_SP_pv, offset_I_pv

def extract_values_from_file(file_path):
    with open(file_path, 'r') as file:
        lines = file.readlines()

    def extract_range(filename):
        match = re.search(r'Range(.*)\.txt', filename)
        if match:
            return match.group(1)
        return None
    
    I_range = extract_range(file_path)
    
    gain = []
    offset = []
    
    for line in lines[1:5]:
        parts = line.strip().split(',')
        gain.append(int(parts[1]))
        offset.append(int(parts[2]))

    return I_range, gain, offset

if __name__ == '__main__':

    filename_all = [
         'Range10mA.txt',
         'Range1mA.txt',
         'Range100uA.txt',
         'Range10uA.txt',
         'Range1uA.txt',
         'Range100nA.txt',
    ]

    nfile = len(filename_all)
    for ifile, filename in enumerate(filename_all):
        print(f"{ifile+1}/{nfile}: {filename}")

        I_range, gain, offset = extract_values_from_file(filename)
        gain_SP_pv, gain_I_pv, offset_SP_pv, offset_I_pv = create_pvs(I_range)
        print(f'  I range: {I_range}\n  gain SP [A,B,C,D]: {gain}\n  offset SP [A,B,C,D]: {offset}')

        # caput
        caput(gain_SP_pv, gain)
        caput(offset_SP_pv, offset)
        # caput(offset_SP_pv, [0,0,0,0])

        # confirm setpoint vs monitor
        if isCheckMonitor:
            Sleep(0.2) # wait for update
            gain_I = caget(gain_I_pv)
            offset_I = caget(offset_I_pv)

            if gain_I == gain: print('  check gain setpoint vs monitor: ok')
            else: print_warning('  gain setpoint is not equal to gain monitor!')
            
            if offset_I == offset: print('  check offset setpoint vs monitor: ok')
            else: print_warning('  offset setpoint is not equal to offset monitor!')

    print(f'done (in {time.time()-t0:.6f} s)')
