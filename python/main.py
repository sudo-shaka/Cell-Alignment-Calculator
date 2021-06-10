#!/usr/bin/python3
import cv2
import GetCellDataFromImage as GD
import Domains as D
import MakeFigures as MF
import math
import numpy as np
import os
import Filter_Data as FD

def main():
    args = GD.Get_Image_Names()

    Nuclear_Mask,nucluii = GD.get_nucleus(args['Nuclear'],args['nuclear_threshold'])
    Junctional_Mask = GD.ThresholdJunctions(args['Junctional'],args['junctional_threshold'])

    try:
        Junctional_Mask = cv2.bitwise_and(Nuclear_Mask,Junctional_Mask)
    except:
        print("Error opening images")
        exit(1)


    print(str(len(nucluii))+" Cells found")
    cv2.imwrite("Output/Nuclear_Mask.png",Nuclear_Mask)
    cv2.imwrite("Output/Junctional_Mask.png",Junctional_Mask)

    if len(nucluii) == 0:
        quit()

    n_linkers = args['n_linkers']+1

    try:
        os.mkdir("Output")
    except:
        pass

    cells = []; jj = -1

    print("Gather data from images..")
    for ii in range(0,len(nucluii)):
        linkers = GD.Calc_Linkers(Junctional_Mask,nucluii[ii],n_linkers)
        junctions = GD.Calc_Junctions(linkers,n_linkers)
        cell = D.cell(nucluii[ii],linkers,junctions)
        min_x = round(min(cell.linker.x2))
        min_y = round(min(cell.linker.y2))
        max_x = round(max(cell.linker.x2))
        max_y = round(max(cell.linker.y2))
        if min_x > 0 and min_y > 0 and \
            max_x < len(Nuclear_Mask) and max_y < len(Nuclear_Mask):
            jj+=1
#            cell = FD.Linker_Filter(cell)
            cells.append(cell)

            angles = np.linspace(0,math.pi*2,n_linkers)
            lengths = np.array(cell.linker.Get_Length())

            figurename = "Output/Plot"+str(jj)+".png"
            MF.ImagePlots(angles,lengths,figurename)

    merge = cv2.bitwise_xor(Nuclear_Mask,Junctional_Mask)
    merge = cv2.bitwise_not(merge)
    merge = cv2.merge([merge,merge,merge])

    MF.MakeImage(merge,cells)
    MF.PopulationPlots(cells)
    
    print(str(len(cells))+" Cells analyzed")

if __name__ == "__main__":
    try:
        main()
    except KeyboardInterrupt:
        quit()
