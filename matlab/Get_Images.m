function [image1,image2,image3] = Get_Images()
	[nFile,nPath] = uigetfile('*','Select Nuclear Image');
	[jFile,jPath] = uigetfile('*','Select Junctional Image');
	%[sFile,sPath] = uigetfile('*','Select Signal Image');
	disp('Reading Images');
	image1 = imread(append(nPath,nFile));
	image2 = imread(append(jPath,jFile));
	%image3 = imread(append(sPath,sFile));
	image3 = image2;
end
