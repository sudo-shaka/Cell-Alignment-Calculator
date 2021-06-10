clear; clc;

%% Get Nucleii via circle finder and mask junctional image
mkdir Output;

NUCLEAR_IMAGE = imread("Sample_Images/STAT_DAPI.png");
JUNCTIONAL_IMAGE = imread("Sample_Images/STAT_VECAD.png");

JUNCTIONAL_IMAGE = imgaussfilt(JUNCTIONAL_IMAGE,1.5);

J_MASK= imbinarize(JUNCTIONAL_IMAGE);
N_MASK= imbinarize(NUCLEAR_IMAGE);

J_MASK = imbinarize(J_MASK-N_MASK);
J_MASK(J_MASK == -1)=0;

[CENTERS,RADII,METRIC] = imfindcircles(N_MASK,[15 50],'Sensitivity',0.9);
[NUCLEII,RADII] = Get_Nuc(CENTERS,RADII);
NUCLEII= [NUCLEII,RADII'];

fprintf("Found %d cells\n",length(NUCLEII));

N_LINK = 21;

%% Creating structure for cells
cell = struct(...
    'nuclear',NUCLEII,...
    'angles',linspace(0,2*pi,N_LINK),...
    'linkers',zeros(5,N_LINK),...
    'junctions',zeros(5,N_LINK-1),...
    'AxisR',0,...
    'Area',0 ...
);
%% Getting data for each cell
cells = [];
for ii = 1:length(NUCLEII)
    cell.nuclear = NUCLEII(ii,:);
    cell.linkers = Calc_Linkers(NUCLEII(ii,:),cell.angles,J_MASK);
    cell.junctions = Calc_Junctions(cell.linkers);
    cell.AxisR = Get_Axis_R(cell.angles,cell.linkers);
    cell.Area = Get_Area(cell.linkers,cell.junctions);
    cells = [cells,cell];
end

%% Cleaning Data
cells2 = []; sds = [];
for cell = cells
    if round(max(max(cell.linkers(1:4,:)))) < length(J_MASK) && round(min(min(cell.linkers(1:4,:)))) > 0
        cell = Smooth_Boarders(cell);
	sds = [sds,std(cell.linkers(5,:))];
	cells2 = [cells2,cell];
    end
end
fprintf("%d cells in frame and anaylized\n",length(cells2));

%% Plotting data for each cell
Make_Calc_Image(J_MASK+N_MASK,cells2);
