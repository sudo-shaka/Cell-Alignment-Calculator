function area = Get_Area(linkers,junctions,name,plot)
	area = 0;
	
	for ii = 1:length(junctions)

		a = junctions(5,ii);
		b = linkers(5,ii);
		c = linkers(5,ii+1);

		s = a+b+c./2;

		arc_area = sqrt(s.*(s-a).*(s-b).*(s-c));
		area = area+arc_area;
		
		if plot
			fill(X,Y,[0,0.5,0]);
		end
	end
end
