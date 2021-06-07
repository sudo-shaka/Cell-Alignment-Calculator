function area = Get_Area(linkers,junctions)
area = 0;
	for ii = 1:length(junctions)
		a = linkers(5,ii);
		b = linkers(5,ii+1);
		c = junctions(5,ii);
		
		p = 0.5*(a+b+c);
		area = area + sqrt(p*((p-a)*(p-b)*(p-c)));
	end
end
