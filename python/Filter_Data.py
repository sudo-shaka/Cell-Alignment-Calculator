import Domains
import GetCellDataFromImage as GD
import numpy as np
import pandas as pd
import math

def Linker_Filter(cell):
    linkers = cell.linker
    junctions = cell.junction

    lengths = linkers.Get_Length()
    
    for length in lengths:
        if length > 2*(sum(lengths)/len(lengths)):
            length = sum(lengths)/len(lengths)
    
    angles = np.linspace(0,2*math.pi,len(lengths))

    for ii in range(0,len(lengths)):
        linkers.y2[ii] = math.cos(angles[ii])*lengths[ii] + linkers.y1[ii]
        linkers.x2[ii] = math.sin(angles[ii])*lengths[ii] + linkers.x1[ii]
    
    cell.linker=linkers
    cell.junction=GD.Calc_Junctions(linkers,len(angles));
    return cell
