import Domains
import statistics as s

def Linker_Filter(cell):
    linkers = cell.linker
    junctions = cell.junction

    for ii in range(0,len(junctions.length)):
        linker1 = linkers.length[ii]
        linker2 = linkers.length[ii+1]
        junction = junctions.length[ii]

        if junction.Get_Length() > 0.5*linker1.Get_Length() or \
            junction.Get_Length() > 0.5*linker2.Get_Length():
            linker2 = linker1
        
        linkers[ii] = linker1
        linkers[ii+1] = linker2


    
    cell.linker=linkers
    return cell