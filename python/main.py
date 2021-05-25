import GetData,ProcessData
import cv2
import os

def main():

    try:
        os.mkdir("Output")
    except FileExistsError:
        pass

    
    args = GetData.Get_Image_Names()

    _,Nuclear_KP,centers =  GetData.get_nucleus(args["Nuclear"])

    Junctions = GetData.get_junctions(args["Junctional"])
    
    n_linkers = 250
    linker_lengths,linker_data = GetData.Calc_Linkers(Junctions,centers,n_linkers)

    clean_data = False  

    if clean_data:
        linker_data = ProcessData.Filter_Link_Data(linker_data)
        linker_lengths = ProcessData.Filter_Link_Lengths(linker_lengths)    

    ProcessData.Plot_Hist(linker_lengths)
    ProcessData.Plot_Angle_Length(linker_data)

    nuc_image = cv2.imread(args["Nuclear"])

    Cell_Data_Image = ProcessData.Draw_Cell_Data(nuc_image,Nuclear_KP,linker_data)

    cv2.imwrite("Blob+Linker.png",Cell_Data_Image)

if __name__ == "__main__":
    main()
