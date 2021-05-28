import math
import numpy as np

class nucleus:
    def __init__(self,center_x,center_y,radius):
        self.radius = radius
        self.center_x = center_x
        self.center_y = center_y

class linker:
    def __init__(self,x1,x2,y1,y2):
        self.x1 = x1
        self.x2 = x2
        self.y1 = y1
        self.y2 = y2
        self.length = []
    def Get_Length(self):
        try:
            for ii in range(0,len(self.x1)):
                self.length.append(math.sqrt(((self.x2[ii]-self.x1[ii])**2)\
                    +((self.y2[ii]-self.y1[ii])**2)))
        except:
            self.length = math.sqrt(((self.x2-self.x1)**2)+(self.y2-self.y1)**2)
        return self.length

class junction:
    def __init__(self,x1,x2,y1,y2):
        self.x1 = x1
        self.y1 = y1
        self.y2 = y2
        self.x2 = x2
        self.length = []
    def Get_Length(self):
        try:
            for ii in range(0,len(self.x1)):
                self.length.append(math.sqrt(((self.x2[ii]-self.x1[ii])**2)\
                    +((self.y2[ii]-self.y1[ii])**2)))
        except:
            self.length = math.sqrt(((self.x2-self.x1)**2)+(self.y2-self.y1)**2)
        return self.length


class cell:
    def __init__(self,nucleus,linker,junction):
        self.nucleus = nucleus
        self.linker = linker
        self.junction = junction
        self.area = None
        self.axis_r = None
        

    def GetArea(self):
        linker_lengths = self.linker.Get_Length()
        junction_lengths = self.junction.Get_Length()
        self.area = 0
        try:
            for ii in range(0,len(junction_lengths)):
                linker_length_1 = linker_lengths[ii]
                linker_length_2 = linker_lengths[ii+1]
                junction_length = junction_lengths[ii]

                p = 0.5*(linker_length_1+linker_length_2+junction_length)

                arc_area = math.sqrt(p*(p-linker_length_1)*(p*linker_length_2)*(p-junction_length))
                
                self.area = self.area+arc_area
        except:
            print("[!] Unable to calculate area")
            self.area = 0
        return self.area

        
    def GetAxisRatio(self):
        #major error here. Need total length, not radius
        self.axis_r = 0

        linker_lengths=self.linker.Get_Length()
        n_linkers = len(linker_lengths)
        angles = np.linspace(0,2*math.pi,n_linkers)

        max_value = 0; min_value = 650**2
        for ii in range(0,n_linkers):
            angle = angles[ii]
            length = linker_lengths[ii]

            if angle <= math.pi:
                angle2 = angle+math.pi
            else:
                angle2 = angle-math.pi
        
            i_2 = min(range(len(angles)), key=lambda i: abs(angles[i]-angle2))
            length = length+linker_lengths[i_2]

            if length < min_value:
                min_value = length
            if length > max_value:
                max_value = length
        try:
            self.axis_r = (min_value/max_value)**(-1)
        except:
            print("[!] Min length determined to be zero")
            self.axis_r = max_value
        return self.axis_r