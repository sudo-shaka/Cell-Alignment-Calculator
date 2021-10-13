import Cell
import cv2
import numpy as np

import Cell

class Domain:
    def __init__(self,nImg,jImg,sImg,nLinker):
        #Finding Nuclear Points
        _, nMask = cv2.threshold(nImg,20,255,cv2.THRESH_BINARY)
        nImg = cv2.cvtColor(nImg,cv2.COLOR_BGR2GRAY)
        cv2.bitwise_not(nMask,nMask);
        detector = cv2.SimpleBlobDetector_create()
        keypoints = detector.detect(nMask)
        pts = np.asarray([[p.pt[0],p.pt[1]] for p in keypoints])
        nMask = cv2.cvtColor(nMask,cv2.COLOR_BGR2GRAY)

        #Watershed for junctional image
        grey = cv2.cvtColor(jImg,cv2.COLOR_BGR2GRAY)
        grey = cv2.GaussianBlur(grey,(7,7),2)
        _, thresh = cv2.threshold(grey,0,255,cv2.THRESH_BINARY_INV+cv2.THRESH_OTSU)
        kernel = np.ones((3,3),np.uint8)
        opening = cv2.morphologyEx(thresh,cv2.MORPH_OPEN,kernel, iterations =30) #iterations has effect on watershed
        sure_bg = (grey*0)+255
        dist_transform = cv2.distanceTransform(opening,cv2.DIST_L2,5)
        _, sure_fg = cv2.threshold(dist_transform,0.3*dist_transform.max(),255,0) #dist_transform multiplier has effect
        sure_fg = np.uint8(sure_fg)
        unknown = cv2.subtract(sure_bg,sure_fg)
        _, markers = cv2.connectedComponents(sure_fg)
        markers = markers+1
        markers[unknown==255] = 0
        markers[nMask!=255] = 0
        markers = cv2.watershed(jImg,markers)
        grey = grey*0;
        grey[markers == -1] = 255

        self.nImg = nMask
        self.jImg = grey
        self.sImg = cv2.cvtColor(sImg,cv2.COLOR_BGR2GRAY) if type(sImg) != type(None) else None
        self.nLinks = nLinker


        #Calculating data for each cell
        Cells = list()
        for point in pts: Cells.append(Cell.Cell(point,self.nLinks,self.jImg,self.sImg))
        self.cells = Cells
        self.n_cells = len(Cells)
    
    #Function for plotting
    def PlotDomain(self):
        for c in self.cells: c.PlotCell()

    def MakeCalcImage(self):
        outimage = self.sImg if type(self.sImg) != type(None) else self.jImg*0
        outimage = cv2.cvtColor(outimage,cv2.COLOR_GRAY2BGR)
        for cell in self.cells:
            nuc_pos = (int(cell.nucleus[0]),int(cell.nucleus[1]))
            outimage = cv2.circle(outimage, nuc_pos, 3, (255,255,0))
            for i  in range(self.nLinks-1):
                color = (0,255,0);
                x = [int(p) for p in cell.linkers.coords[i,:].tolist()]
                y = [int(p) for p in cell.linkers.coords[i+1,:].tolist()]
                start_p = (x[0],x[1])
                end_p = (y[0],y[1])
                outimage = cv2.circle(outimage,end_p,5,(255,0,0))
                outimage = cv2.line(outimage,start_p,end_p,color=color,thickness=1)
                if type(self.sImg) != type(None):
                    outimage = cv2.line(outimage,nuc_pos,end_p,color=(0,255,255))
        cv2.imwrite("ModelCells.png",outimage)


