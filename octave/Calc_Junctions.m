function junctions = Calc_Junctions(linkers)
	junctions = zeros(5,length(linkers)-1);

	junctions(1,:) = linkers(3,1:length(junctions));
	junctions(2,:) = linkers(4,1:length(junctions));
	junctions(3,:) = linkers(3,2:length(junctions)+1);
	junctions(4,:) = linkers(4,2:length(junctions)+1);

	junctions(5,:) = sqrt(abs(junctions(3,:) - junctions(1,:)).^2 ...
	       	+ abs(junctions(4,:) - junctions(2,:)).^2);

end
