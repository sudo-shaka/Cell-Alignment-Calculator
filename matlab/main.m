clc; close all; clear;
[N_IMG,J_IMG,S_IMG] = Get_Images();

mkdir Output
C = Cell;
Cells = C.GetFromImages(25,N_IMG,J_IMG,S_IMG);

cells_in_frame = [];
for c = Cells
	if round(max(max(c.Linkers.Coords))) < length(J_IMG) && ...
			round (min(min(c.Linkers.Coords))) > 0
		cells_in_frame = [cells_in_frame,c];
	end
end

fprintf('Found %d cells\n',length(cells_in_frame));

PLOT = 1;
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
