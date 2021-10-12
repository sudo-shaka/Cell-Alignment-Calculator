clc; close all; clear;
[N_IMG,J_IMG,S_IMG] = Get_Images();

mkdir Output
C = Cell;
Cells = C.GetFromImages(25,N_IMG,J_IMG);

PLOT = 1;

if PLOT
  IMG = (J_IMG.*0)+1;
  figure;
  imshow(IMG);
  hold on;
  for C = Cells
	  C.PlotCell();
  end
end
