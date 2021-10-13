import math
import numpy as np


class Cell:
    def __init__(self,nuc_coord,nLinker,jImg,sImg):
        self.nucleus = nuc_coord
        self.angles = np.linspace(0,2*math.pi,nLinker)
        self.linkers = self.Calc_Linkers(jImg)
        if sImg != None:
            self.linspace = self.Linescans(sImg)
        self.area = self.GetArea()
        self.perimeter = self.GetPerim()
        self.AxisR = self.GetAxis()
        self.ShapeParam = self.GetShapeParam()

    def Calc_Linkers(self,jImg):
        nLinker = len(self.angles)
        x1 = self.nucleus[0]
        y1 = self.nucleus[1]

        y2_arr = x2_arr = lengths = []

        for i in range(nLinker):
            x2 = x1
            y2 = y1
            pixel = 0
            while pixel == 0:
                try:
                    pixel = jImg[int(y2)][int(y2)]
                    y2 += math.cos(self.angles[i])*0.1
                    x2 += math.sin(self.angles[i])*0.1
                except:
                    break
                x2_arr.append(int(x2))
                y2_arr.append(int(y2))
                lengths.append(math.sqrt((abs(x2-x1)**2) + (abs(y2-y1)**2)))
        
        coords = np.column_stack([x2_arr,y2_arr])
        linkers = Linkers(coords,lengths)
        return linkers
    def Linescans(self,sImg):
        linescans = 1
        return linescans
    def GetArea(self):
        x = self.linkers.coords[:,0]
        y = self.linkers.coords[:,1]
        return 0.5*np.abs(np.dot(x,np.roll(y,1)) - np.dot(y,np.roll(x,1)))
    def GetPerim(self):
        p = 0
        x = self.linkers.coords[:,0]
        y = self.linkers.coords[:,1]
        dx = abs(x[1:len(x)] - x[0:len(x)-1])
        dy = abs(y[1:len(y)] - y[0:len(y)-1])
        for i in range(len(dx)): p += math.sqrt(dx[i]**2 + dy[i]**2)
        return p

    def GetAxis(self):
        self.axis_r = 0
        linkers_lengths = self.linkers.length
        n_links = len(linkers_lengths)
        max_val = 0
        for ii in range(n_links):
            angle = self.angles[ii]
            length = linkers_lengths[ii]
            if angle <= math.pi:
                angle2 = angle+math.pi
                perpend_angle1 = angle+(math.pi/2)
                perpend_angle2 = perpend_angle1-math.pi
            else:
                angle2 = angle-math.pi
                perpend_angle1 = angle-(math.pi/2)
                perpend_angle2 = perpend_angle1+math.pi
            n = len(self.angles)
            i_2 = min(range(n), key = lambda i: abs(self.angles[i]-angle2))
            i_p1 = min(range(n),key = lambda i: abs(self.angles[i]-perpend_angle1))
            i_p2 = min(range(n),key = lambda i: abs(self.angles[i]-perpend_angle2))

            length = length+linkers_lengths[i_2]
            length_perpend = linkers_lengths[i_p1]+linkers_lengths[i_p2]

            if length > max_val:
                max_val = length
                min_val = length_perpend
            try:
                axis_r = (min_val/max_val)**-1
            except:
                print("[!] Error: Min length found to be zero")
                axis_r = max_val
            return axis_r

    def GetShapeParam(self):
        A = self.perimeter**2/(self.area*math.pi*4)
        return A
    def PlotCell(self):
        return 1

class Linkers:
    def __init__(self,coords,length):
        self.coords = coords
        self.length = length
        
        
