clc; close all; clear;
[N_IMG,J_IMG,S_IMG] = Get_Images();

mkdir Output
C = Cell;
N_LINK = 25; %change this value to alter the number of points calculated at the cell perimeter. Larger number is more sensitive but takes more time...

%getting cell data
Cells = C.GetFromImages(N_LINK,N_IMG,J_IMG,S_IMG);

%excluding cells that are not fully in frame. 
cells_in_frame = [];
for c = Cells
	if round(max(max(c.Linkers.Coords))) < length(J_IMG) && ...
			round (min(min(c.Linkers.Coords))) > 0
		cells_in_frame = [cells_in_frame,c];
	end
end

fprintf('Found %d cells\n',length(cells_in_frame));

PLOT = 1; %change to zero to make calculations but not plot anything
if PLOT
	IMG = (J_IMG.*0)+1;
	figure;
	imshow(IMG);
	hold on;
	for C = cells_in_frame
		C.PlotCell();
	end
	saveas(gcf,'Output/Calculated_Cells.png');
	
	Plot_Polarization(cells_in_frame);
	saveas(gcf,'Output/CellPolarization.png');
end
