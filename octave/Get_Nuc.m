function nucleii = Get_Nuc(centers,radii)

	nucleii = [];
	for ii = 1:length(centers)
		center = centers(ii,:);
		overlapped = centers(min((abs(center-centers) < 2*radii(ii))'),:);
		avg_overlapped = mean(overlapped);

		calculated = max(min(avg_overlapped' == reshape(nucleii,2,[])));

		if length(avg_overlapped) == 1
			nucleii = [nucleii,center];
		elseif ~calculated
			nucleii = [nucleii,avg_overlapped];
		end
	end
	nucleii = reshape(nucleii,2,[])';
end
