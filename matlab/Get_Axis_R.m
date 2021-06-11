function axisR = Get_Axis_R(angles,linkers)
	
	diff = zeros(1,length(angles));

	lengths = linkers(5,:);
	for ii = 1:length(angles)
		if angles(ii) <= pi
			jj = ii+round(length(angles)/2);
		else
			jj = ii-round(length(angles)/2);
		end
		try
			diff(ii) = abs(lengths(ii)-lengths(jj));
		catch
		end
	end

	[~,loc] = max(diff);
	
	if angles(loc) <= pi
		loc2 = loc + round(length(angles)/2);
	else
		loc2 = loc - round(length(angles)/2);
	end
	
	axisR = lengths(loc)/lengths(loc2);

end
