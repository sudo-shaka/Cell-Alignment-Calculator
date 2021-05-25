import statistics as st
import pandas as pd
import numpy as np
import cv2
import math

def Filter_Link_Lengths(linker_data):
    for ii in range(0,len(linker_data)):
        length_links = linker_data[ii]
        for jj in range(0,len(length_links)):
            if length_links[jj] > 3*st.median(length_links) or \
                length_links[jj] < 0.25*st.median(length_links): #change to be local regoin. not whole cell
                length_links[jj] = None
        linker_data[ii] = length_links

    return linker_data

def Filter_Link_Data(data):
    for arr in data:
        if arr != []:
            angles = [item[0] for item in arr]
            x_vals = [item[1] for item in arr]
            y_vals = [item[2] for item in arr]

            distance = []

            for ii in range(0,len(angles)):
                distance.append(math.sqrt((x_vals[ii]**2)+(y_vals[ii])**2))
            
            for ii in range(0,len(distance)):
                n_next=5
                if ii <= n_next:
                    if distance[ii] < 0.25*st.median(distance[ii:(ii+n_next*2)]) \
                        or distance[ii] > 3*st.mean(distance[ii:ii+(n_next*2)]):
                        arr[ii][1] = 0
                        arr[ii][2] = 0
                elif ii >= len(distance)-n_next:
                    if distance[ii] < 0.25*st.median(distance[ii-(n_next*2):ii]) \
                        or distance[ii] > 3*st.mean(distance[ii-n_next:ii]):
                        arr[ii][1] = 0
                        arr[ii][2] = 0
                else:
                    if distance[ii] < 0.25*st.median(distance[ii-n_next:ii+n_next]) \
                        or distance[ii] > 3*st.mean(distance[ii-n_next:ii+n_next]):
                        arr[ii][1] = 0
                        arr[ii][2] = 0

    return data

def Get_Axis_Ratio(linker_data):
    axis_ratio = np.empty((len(linker_data),2))
    linker_data = Filter_Link_Lengths(linker_data)
    for ii in range(0,len(linker_data)):
        axis_ratio[ii][0] = ii
        axis_ratio[ii][1] = max(linker_data[ii])/min(linker_data[ii])
        print(str(ii)+" : "+str(axis_ratio[ii]))
    
    return axis_ratio

def Plot_Hist(data):
    from matplotlib import pyplot as plt
    ii = 0
    for n in data:
        ii+=1
        plt.figure()
        plt.hist(n,bins='auto')
        plt.savefig("Output/Hist_"+str(ii)+".png")

def Plot_Angle_Length(data):
    from matplotlib import pyplot as plt
    i = 0
    for arr in data:
        if arr != []:
            angles = [item[0] for item in arr]
            x_vals = [item[1] for item in arr]
            y_vals = [item[2] for item in arr]

            distance = []

            for ii in range(0,len(angles)):
                distance.append(math.sqrt((x_vals[ii]**2)+(y_vals[ii])**2))

            i+=1
            plt.figure()
            plt.plot(angles,distance)
            plt.savefig("Output/Plot_"+str(i)+".png")

def Draw_Cell_Data(reference_image,kp,linker_data):
    print("Creating Anaylized Image")

    centers = np.asarray([[p.pt[0], p.pt[1]] for p in kp])
    
    Cell_Data_Image = reference_image*0
        
    color = (0,255,0)
    
    ii = 0

    for arr in linker_data:
        if arr != []:
            x_vals = [item[2] for item in arr]
            y_vals = [item[1] for item in arr]

            for jj in range(0,len(x_vals)):
                start_p = (int(centers[ii][0]),int(centers[ii][1]))
                x = centers[ii][0]+x_vals[jj]
                y = centers[ii][1]+y_vals[jj]
                end_p = (int(x),int(y))
                Cell_Data_Image = cv2.line(Cell_Data_Image, start_p, end_p, color, 1)
            ii+=1
    
    Cell_Data_Image = cv2.drawKeypoints(Cell_Data_Image, kp, np.zeros((1,1)), (0, 0, 255), cv2.DRAW_MATCHES_FLAGS_DRAW_RICH_KEYPOINTS)
    
    return Cell_Data_Image