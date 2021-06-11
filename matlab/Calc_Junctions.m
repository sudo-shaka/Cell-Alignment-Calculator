function junctions = Calc_Junctions(linkers)
   junctions = zeros(5,length(linkers)-1);
	for ii = 1:length(linkers)-1
		junctions(1,ii) = linkers(3,ii); %x1
		junctions(2,ii) = linkers(4,ii); %y1
		junctions(3,ii) = linkers(3,ii+1); %x2
		junctions(4,ii) = linkers(4,ii+1); %y2
    end
    a = abs(junctions(3,:)-junctions(1,:));
    b = abs(junctions(4,:)-junctions(3,:));
    angle = (2*pi)/ii;
    junctions(5,:) = sqrt((a.^2 + b.^2)-(2.*a.*b.*cos(angle)));
end
