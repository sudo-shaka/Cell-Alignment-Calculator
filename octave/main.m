clear;
mkdir Output;
pkg load image;
pkg load statistics;

N_IMG = imread("Sample_Images/DAPI.png");
J_IMG = imread("Sample_Images/VECAD.png");

J_MASK = im2bw(J_IMG,0.5);
N_MASK = im2bw(N_IMG,0.2);

J_MASK = J_MASK-N_MASK;
J_MASK(J_MASK == -1) = 0;

[CENTERS,RADII] = imfindcircles(N_MASK,[15 50],'Sensitivity', 0.9);
NUCLEII = Get_Nuc(CENTERS,RADII);
%NUCLEII = [NUCLEII,RADII'];

N_LINK = 21;

cell = struct(...
	'name',0,...
	'nuclear',[0 0],...
	'angles',linspace(0,2*pi,N_LINK),...
	'linkers',zeros(5,N_LINK),...
	'junctions',zeros(5,N_LINK),...
	'AxisR',0,...
	'Area',0 ...
	);

cells = [];

for ii = 1:length(NUCLEII)
	cell.name = ii;
	cell.nuclear = NUCLEII(ii,:);
	cell.linkers = Calc_Linkers(NUCLEII(ii,:),cell.angles,J_MASK);
	cell.junctions = Calc_Junctions(cell.linkers);
	cell.AxisR = Get_Axis_R(cell.angles,cell.linkers);
	cell.area = Get_Area(cell.linkers,cell.junctions,cell.name,0);

	cells = [cells,cell];
end


Make_Calc_Image(J_MASK+N_MASK,cells);
