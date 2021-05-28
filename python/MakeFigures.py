from matplotlib import pyplot as plt
import cv2
import Domains
import pandas as pd

def ImagePlots(angles,lengths,figurename):
    plt.figure()
    plt.plot(angles,lengths)
    plt.xlabel("Angle (Radians)"); plt.ylabel("Length From Nucleus (AU)")
    plt.savefig(figurename)
    plt.close('all')

    data = pd.DataFrame(list(zip(angles,lengths)),columns=["Angle","Length"])
    data.to_csv(figurename+'.csv')

def PopulationPlots(cells):
    axis_Rs = []
    sizes = []
    for cell in cells:
        axis_Rs.append(Domains.cell.GetAxisRatio(cell))
        sizes.append(Domains.cell.GetArea(cell))

    data = pd.DataFrame(list(zip(axis_Rs,sizes)),columns = ["Axis R","Area"])

    data.to_csv("Output/PopulationData.csv")

    plt.figure()
    plt.hist(axis_Rs)
    plt.xlabel("Axis Ratio"); plt.ylabel("number of cells")
    plt.savefig("Output/Axis_Ratios.png")
    plt.close('all')

    plt.figure()
    plt.hist(sizes)
    plt.xlabel("Cell Size"); plt.ylabel("number of cells")
    plt.savefig("Output/CellSizes.png")
    plt.close('all')

def MakeImage(reference_image,cells):
    new_image = reference_image*0

    for cell in cells:
        #center = [int(cell.nucleus.center_x),int(cell.nucleus.center_y)]
        color = (200,0,0)
        
        #fix nuclear algorithm
        #new_image = cv2.circle(new_image,center,cell.nucleus.radius,color,thickness=2)
        
        for ii in range(0,len(cell.linker.x1)):
            color=(255,0,0)
            start_p = [int(cell.linker.x1[ii]),int(cell.linker.y1[ii])]
            end_p = [int(cell.linker.x2[ii]),int(cell.linker.y2[ii])]
            new_image = cv2.line(new_image,start_p,end_p,color,thickness=1)
        
        for ii in range(0,len(cell.junction.x1)):
            color = (255,0,0)
            start_p = [int(cell.junction.x1[ii]),int(cell.junction.y1[ii])]
            end_p = [int(cell.junction.x2[ii]),int(cell.junction.y2[ii])]
            new_image = cv2.line(new_image,start_p,end_p,color,thickness=1)
    cv2.imwrite("Output/ModelCells.png",new_image)
