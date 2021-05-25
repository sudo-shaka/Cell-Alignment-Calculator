clear all; clc;

Nuclear_Image =  imread("DAPI.png");
Junctional_Image = imread("VECAD.png");

Nuclear_Mask = im2bw(Nuclear_Image,0.5);
Junctional_Mask= im2bw(Junctional_Image,.65);

[centers,radii,metric] = imfindcircles(Nuclear_Mask,[15 50],'Sensitivity',0.9);

nucleii = []; new_radii = [];
for ii = 1:length(centers)
    center = centers(ii,:);
    overlapped = centers(min((abs(center-centers) < 2*radii(ii))'),:);
    avg_overlapped = mean(overlapped);
    
     calculated = max(min(avg_overlapped' == reshape(nucleii,2,[])));

    if length(avg_overlapped) == 1
        nucleii = [nucleii,center];
        new_radii = [new_radii,radii(ii)];
    elseif ~calculated
        nucleii = [nucleii,avg_overlapped];
        new_radii = [new_radii,radii(ii)];
    end
end


nucleii = reshape(nucleii,2,[])';

n_linkers = 250;

[linker_lengths,linker_data] = Calc_Linkers(Junctional_Mask,nucleii,n_linkers);
angles = linker_data(:,1);

linker_data = Filter_Data(linker_data);
axis_ratio = Get_Axis_R(linker_lengths);

merge_img = (Nuclear_Mask+Junctional_Mask);
Make_Calc_Image(merge_img,nucleii,new_radii,linker_data);
figure;
plot(angles,linker_lengths);PrettyFig;

figure;
histogram(axis_ratio,10);
PrettyFig;
