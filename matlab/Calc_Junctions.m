function junctions = Calc_Junctions(linkers)
   junctions = zeros(5,length(linkers)-1);
	for ii = 1:length(linkers)-1
		junctions(1,ii) = linkers(3,ii); %x1
		junctions(2,ii) = linkers(4,ii); %y1
		junctions(3,ii) = linkers(3,ii+1); %x2
		junctions(4,ii) = linkers(4,ii+1); %y2
    end
    junctions(5,:) = sqrt(abs(junctions(3,:)-junctions(1,:)).^2+abs(junctions(4,:)-junctions(2,:).^2)); %length
end
