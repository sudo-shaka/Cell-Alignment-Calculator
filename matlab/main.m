clc; close all; clear;

%% Reading Images
[N_IMG,J_IMG,S_IMG] = Get_Images();

%% Obtaining Cell data from Image
C = Cell;
N_LINK = 25;

Cells = C.GetFromImages(N_LINK,N_IMG,J_IMG,S_IMG);

cells_in_frame = [];
for c = Cells
    %exclude cells at the border
	if round(max(max(c.Linkers.Coords))) < length(J_IMG) && ...
			round (min(min(c.Linkers.Coords))) > 0
		cells_in_frame = [cells_in_frame,c];
	end
end

fprintf('Found %d cells\n',length(cells_in_frame));
%% Plotting Data
mkdir Output

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

%% Saving data
Number = [cells_in_frame(:).Name]';
Area  =[cells_in_frame(:).Area]';
Perimeters = [cells_in_frame(:).Perimeter]';
ShapeParams  = [cells_in_frame(:).ShapeParam]';
AxisR = [cells_in_frame(:).AxisR]';
MeanIntensity = [cells_in_frame(:).Intensity]';
T = table(Number,Area,Perimeters,ShapeParams,AxisR,MeanIntensity);
writetable(T,"Output/results.csv","WriteRowNames",true);
disp("Done! See output folder");
