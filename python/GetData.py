import cv2
import numpy as np
import math
import argparse

def Get_Image_Names():
    #parse arugments for CLI script
    ap = argparse.ArgumentParser()
    ap.add_argument("-n","--Nuclear", required=True,help="Path to Nuclear Image")
    ap.add_argument("-j","--Junctional",required=True, help = "Path to junctional Image")
    args = vars(ap.parse_args())
    return args


def get_nucleus(Image):
    #Open image into np array for processing. Use opencv to find circular shapes
    print("Opening Image "+Image)
    image = cv2.imread(Image, 0) 
 
    _, image = cv2.threshold(image, 127,255, cv2.THRESH_BINARY)
    cv2.bitwise_not(image,image)
    detector = cv2.SimpleBlobDetector_create()
    keypoints = detector.detect(image)
    pts = np.asarray([[p.pt[0], p.pt[1]] for p in keypoints])

    print(str(len(keypoints))+" nuclei found.")

    return(image,keypoints,pts)


def get_junctions(image):
    #Getting the junctional image threshold
    print("Getting junctional image")
    image = cv2.imread(image,0)

    _, image = cv2.threshold(image,100,255,cv2.THRESH_BINARY)

    return(image)


def Calc_Linkers(junctional_image,centers,n_linkers):
    print("Calculating lengths from nuclear center to junction")
    n_nucleus = len(centers)
    links = np.linspace(0,2*math.pi,n_linkers)

    linker_lengths = np.empty((n_nucleus,n_linkers))
    linker_data = [[]]

    for ii in range(0,n_nucleus):
        linker_data_jj = []
        for jj in range(0,n_linkers):
            x = centers[ii][1]
            y = centers[ii][0]
            pixel = junctional_image[int(x)][int(y)]
            while pixel == 0:
                try:
                    pixel = junctional_image[int(x)][int(y)]
                    y = y + math.sin(links[jj])*0.1
                    x = x + math.cos(links[jj])*0.1 
                    in_frame = True
                except IndexError:
                    in_frame = False
                    break
            if in_frame:
                end_location = [y,x]
                from_center = end_location-centers[ii]
                distance = int(math.sqrt((from_center[1]**2)+from_center[0]**2))
                linker_lengths[ii][jj] = distance

                angle = links[jj]

                linker_data_jj.append([angle,from_center[1],from_center[0]])
            else:
                linker_lengths[ii][jj] = None
        
        linker_data.append(linker_data_jj)
    return (linker_lengths,linker_data)
