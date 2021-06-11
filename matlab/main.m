clear; clc;

%% Get Nucleii via circle finder and mask junctional image
mkdir Output;

NUCLEAR_IMAGE = imread("Sample_Images/STAT_DAPI.png");
JUNCTIONAL_IMAGE = imread("Sample_Images/STAT_VECAD.png");

JUNCTIONAL_IMAGE = imgaussfilt(JUNCTIONAL_IMAGE,1.2);

J_MASK= imbinarize(JUNCTIONAL_IMAGE);
N_MASK= imbinarize(NUCLEAR_IMAGE);

J_MASK = imbinarize(J_MASK-N_MASK);
J_MASK(J_MASK == -1)=0;

[CENTERS,RADII,METRIC] = imfindcircles(N_MASK,[15 50],'Sensitivity',0.9);
[NUCLEII,RADII] = Get_Nuc(CENTERS,RADII);
NUCLEII= [NUCLEII,RADII'];

fprintf("Found %d cells\n",length(NUCLEII));

N_LINK = 30;

%% Creating structure for cells
cell = struct(...
    'name',0,...
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
    cell.name = ii;
    cell.Area = Get_Area(cell.linkers,cell.junctions,cell.name,0);
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
Make_Plots(cells2);
close all;

%%
%Extra
extra = 1;
if extra
Area = [cells2(:).Area]';
Axis_R = [cells2(:).AxisR]';

Cell_Data = [Area,Axis_R];

csvwrite("Output/CellSize_AxisRatio.csv",Cell_Data);

figure; hold on
    plotSpread(Area);
    boxplot(Area);
    ylabel("Cell Area");
    PrettyFig;
    saveas(gcf,'Output/AreaSwarm.png');


    figure; hold on
    plotSpread(Axis_R);
    boxplot(Axis_R);
    ylabel("Axis Ratio");
    PrettyFig;
    saveas(gcf,'Output/AxisRSwarm.png');
end

close all;

