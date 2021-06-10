import cv2
import numpy as np
import math
import argparse
import Domains

def Get_Image_Names():
    #parse arugments for CLI script
    ap = argparse.ArgumentParser()
    ap.add_argument("-n","--Nuclear", required=True,help="Path to Nuclear Image")
    ap.add_argument("-j","--Junctional",required=True, help = "Path to junctional Image")
    ap.add_argument('-t1','--nuclear_threshold',required=False,type=int,default=100)
    ap.add_argument('-t2','--junctional_threshold',required=False,type=int,default=100)
    ap.add_argument('-l','--n_linkers',default=20,type=int,required=False)
    args = vars(ap.parse_args())
    return args

def get_nucleus(Image,thresh_num):
    #Open image into np array for processing. Use opencv to find circular shapes
    print("Opening Image "+Image)
    image = cv2.imread(Image, 0) 
 
    _, image = cv2.threshold(image,thresh_num,255, cv2.THRESH_BINARY)
    cv2.bitwise_not(image,image)
    detector = cv2.SimpleBlobDetector_create()
    keypoints = detector.detect(image)
    pts = np.asarray([[p.pt[0], p.pt[1]] for p in keypoints])

    nuclii = []

    #Fix below
    for ii in range(0,len(keypoints)):
        x_i = pts[ii][0]
        y_i = pts[ii][1]
        
        nucleus = Domains.nucleus(x_i,y_i,0)

        nuclii.append(nucleus)
 
    return(image,nuclii)

def ThresholdJunctions(image,thesh_val):
    print("Opening Image "+image)
    image = cv2.imread(image,0)
    image = cv2.medianBlur(image,5)
    _, image = cv2.threshold(image,thesh_val,255,cv2.THRESH_BINARY)
    return(image)

def Calc_Linkers(junctional_image,center,n_linkers):
    links = np.linspace(0,2*math.pi,n_linkers)
    x1 = []; x2 = []; y1 =[]; y2 = []

    for jj in range(0,n_linkers):
        x = center.center_x + math.cos(links[jj])*center.radius
        y = center.center_y + math.sin(links[jj])*center.radius
        x1.append(x); y1.append(y)
        
        pixel = junctional_image[int(y)][int(x)]
        while pixel == 0:
            try:
                pixel = junctional_image[int(y)][int(x)]
                y+=math.cos(links[jj])*0.1
                x+=math.sin(links[jj])*0.1 
            except IndexError:
                break
        x2.append(x); y2.append(y)

    linkers = Domains.linker(x1,x2,y1,y2)

    return linkers

def Calc_Junctions(linkers,n_linkers):
    x1 = []; x2 = []; y1=[]; y2=[]
    for ii in range(0,n_linkers-1):
        x1.append(linkers.x2[ii])
        x2.append(linkers.x2[ii+1])

        y1.append(linkers.y2[ii])
        y2.append(linkers.y2[ii+1])

    junctions = Domains.junction(x1,x2,y1,y2)

    return junctions



            
