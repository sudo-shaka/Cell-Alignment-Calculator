clear;

%% Get Nucleii via circle finder and mask junctional image

mkdir Output;

NUCLEAR_IMAGE = imread('../images/DAPI.png');
JUNCTIONAL_IMAGE = imread('../images/VECAD.png');
SIGNAL_IMAGE = imread('../images/DAPI.png');

JUNCTIONAL_IMAGE = imgaussfilt(JUNCTIONAL_IMAGE,3);
JUNCTIONAL_IMAGE = imadjust(imtophat(JUNCTIONAL_IMAGE,strel('disk',15)));

N_MASK= bwareaopen(imbinarize(NUCLEAR_IMAGE),1);

%if you are having issues with junctional detection change this best_h value. 
%increasing the value decreses edge detection, and decreasing increases edge detections
%(High brightness images work between 10-20, and dimmer images have required values around 4000-5000. 
best_h =20;

Pre_water = 1-(imextendedmin(JUNCTIONAL_IMAGE,best_h,4));
Pre_water = imbinarize(Pre_water-N_MASK);
Water = watershed(Pre_water,8);
J_MASK = (Water==0);

imwrite(J_MASK,'Output/J_MASK.png');

[CENTERS,RADII,METRIC] = imfindcircles(N_MASK,[15 50],'Sensitivity',0.9);
[NUCLEII,RADII] = Get_Nuc(CENTERS,RADII);
NUCLEII= [NUCLEII,RADII'];

fprintf("Found %d cells\n",length(NUCLEII));

N_LINK = 121;

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
    cell.Area = Get_Area(cell.linkers,cell.junctions,cell.name);
    cells = [cells,cell];
    close all;
end

%% Cleaning Data
cells2 = []; sds = [];
for cell = cells
    if round(max(max(cell.linkers(1:4,:)))) < length(J_MASK) && round(min(min(cell.linkers(1:4,:)))) > 0
        sds = [sds,std(cell.linkers(5,:))];
        cells2 = [cells2,cell];
    end
end

close all;

fprintf("%d cells in frame and anaylized\n",length(cells2));
%% Getting line scan
linescans = [];
n = zeros(1,length(cells2));
ii = 0;
figure; hold on;
for cell = cells2
    ii = ii+1;
    [l,n(ii)] = linescan(SIGNAL_IMAGE,cell);
    plot(l','.');
    n(ii) = sum(n);
    linescans = [linescans,l];
    writematrix(l',"Output/linescan"+string(cell.name)+".csv");
    writematrix(cell.linkers',"Output/linkers"+string(cell.name)+".csv");
end
hold off;
ylabel("Intensity (AU)");xlabel("Distange from Center (Pixels)");

saveas(gcf,'Output/LINESCAN1.png');
figure;bar(mean(linescans','omitnan'));
ylabel("Average Intensity (AU)");
xlabel("Angle (0:2pi)"); 
saveas(gcf,'Output/LINESCAN2.png');

%% Plotting data for each cell
close all;
Make_Calc_Image(J_MASK,cells2);
Make_Plots(cells2);
Area = [cells2(:).Area]';
Axis_R = [cells2(:).AxisR]';
Number = [cells2(:).name]';
Cell_Data = [Number,Area,Axis_R];
csvwrite("Output/CellSize_AxisRatio.csv",Cell_Data);
close all;

