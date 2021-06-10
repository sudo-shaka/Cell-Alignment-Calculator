function c = Smooth_Boarders(cell)
	
	c = cell;

	angles = cell.angles;
	linkers = cell.linkers;
	%linkers(5,:) = smooth(linkers(5,:),5);
	linkers(5,:) = filloutliers(linkers(5,:),'nearest');
	linkers(3,:) = cos(angles).*linkers(5,:) + linkers(1,:);
	linkers(4,:) = sin(angles).*linkers(5,:) + linkers(2,:);
	
	c.linkers = linkers;
    	c.junctions = Calc_Junctions(c.linkers);
end
