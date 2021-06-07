function [nucleii,new_radii] = Get_Nuc(centers,radii)

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

end

