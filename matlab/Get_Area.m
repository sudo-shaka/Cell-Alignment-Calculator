function area = Get_Area(linkers,junctions,name,plot)
    area = 0;
    if plot
        figure; hold on;
    end
	for ii = 1:length(junctions)
		a = [junctions(1,ii),junctions(2,ii)];
		b = [junctions(3,ii),junctions(4,ii)];
		c = [linkers(1,ii),linkers(2,ii)];
        
        X = [a(1), b(1), c(1)];
        Y = [a(2), b(2), c(2)];
		
        arc_area = polyarea(X,Y);
        
		area = area + arc_area;
        fill(X,Y,[0,0.5,0]);
        
    end
    if plot
        hold off;
        axis equal;
        saveas(gcf,'Output/cell_'+string(name)+'.png');
        close all;
    end
end
