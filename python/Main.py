import Domain
import Cell
import numpy as np
import cv2 as cv
import argparse as arg

def main():
    ap = arg.ArgumentParser()
    ap.add_argument('-n','--nuclear',required = True, help = "Path to nuclear image")
    ap.add_argument('-j','--junctional',required = True, help = "Path to junctional images")
    ap.add_argument('-s','--signal',required = False,default = None, help = "Path to junctional images")
    ap.add_argument('-l','--nlink',required = False, type = int, default=35)
    args = vars(ap.parse_args())

    nImg = cv.imread(args['nuclear'])
    jImg = cv.imread(args['junctional'])
    sImg = None if args['signal'] == None else cv.imread(args['signal'])

    print("Starting to gather information")
    D = Domain.Domain(nImg,jImg,sImg,args['nlink'])
    print(str(D.n_cells)+" cells found")
    D.MakeCalcImage()

if __name__ == "__main__":
	main()
