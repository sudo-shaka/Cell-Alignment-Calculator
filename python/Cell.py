import math
import numpy as np


class Cell:
    def __init__(self,nuc_coord,nLinker,jImg,sImg):
        if nLinker < 3:
            print("[!] Error: Need at least 3 linkers for calculations")
            exit(0)
        self.nucleus = nuc_coord
        self.angles = np.linspace(0,2*math.pi,nLinker)
        self.linkers = self.Calc_Linkers(jImg)
        self.linspace = self.Linescans(sImg) if type(sImg) != type(None) else None
        self.area = self.GetArea()
        self.perimeter = self.GetPerim()
        self.ShapeParam = self.GetShapeParam()
        print(self.nucleus,[self.area,self.perimeter,self.ShapeParam]);
    
    def Calc_Linkers(self,jImg):
        nLinker = len(self.angles)
        x1 = self.nucleus[0]
        y1 = self.nucleus[1]

        coords = np.zeros((nLinker,2))
        lengths = []

        for i in range(nLinker):
            x2 = x1
            y2 = y1
            pixel = 0
            while pixel == 0:
                try:
                    pixel = jImg[int(y2)][int(x2)]
                    y2 += math.cos(self.angles[i])*0.1
                    x2 += math.sin(self.angles[i])*0.1
                except:
                    break
            coords[i,0] = x2
            coords[i,1] = y2
            lengths.append(math.sqrt((abs(x2-x1)**2) + (abs(y2-y1)**2)))

        linkers = Linkers(coords,lengths)
        return linkers

    def Linescans(self,sImg):
        x1 = self.nucleus[0]
        y1 = self.nucleus[1]
        means = []
        for i in range(len(self.angles)):
            x2 = self.linkers.coords[i,0]
            y2 = self.linkers.coords[i,1]
            m = (y2-y1)/(x1-x2)
            x = x1; y = y1;
            val = 0; count = 0
            while int(x) != int(x2) and int(y) != int(y2):
                try:
                    x+=1 if x<x2 else x-1
                    y += y*m
                    count += 1
                    val += sImg[int(y)][int(x)]
                except:
                    break
                    
            try:
                means.append(val/count)
            except:
                means.append(None)
        return(means)


        return means
    def GetArea(self):
        x = self.linkers.coords[:,0]
        y = self.linkers.coords[:,1]
        area = 0
        for i in range(len(x)-2):
            area -= (x[i+1] + x[i])*(y[i+1]-y[i])
        area -= (x[0] + x[len(x)-1]) * (y[0] - y[len(y)-1])
        return area

    def GetPerim(self):
        p = 0
        x = self.linkers.coords[:,0]
        y = self.linkers.coords[:,1]
        dx = abs(x[1:len(x)] - x[0:len(x)-1])
        dy = abs(y[1:len(y)] - y[0:len(y)-1])
        for i in range(len(dx)): p += math.sqrt(dx[i]**2 + dy[i]**2)
        return p

    def GetShapeParam(self):
        A = (self.perimeter**2)/(self.area*math.pi*4)
        return A

class Linkers:
    def __init__(self,coords,length):
        self.coords = coords
        self.length = length
        
        
