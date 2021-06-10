function linkers = Calc_Linkers(CENTER,ANGLES,IMAGE)

	linkers = zeros(5,length(ANGLES));
	x1 = CENTER(1);
	y1 = CENTER(2);

	for ii = 1:length(ANGLES)
		linkers(1,ii) = x1;
		linkers(2,ii) = y1;
		x2 = x1; 
        y2 = y1;
        check =0;
        
		while check < 50
			try
				pixel = IMAGE(round(y2),round(x2));
				x2 = x2 + cos(ANGLES(ii))*0.1;
				y2 = y2 + sin(ANGLES(ii))*0.1;
                if pixel ~= 0 && y2 ~= linkers(3,ii-1) && x2 ~= linkers(3,ii-1) && ii ~= 1
                    check = check + 1;
                else
                    check = 0;
                end
                
			catch
				break;
			end
		end
		linkers(3,ii) = x2;
		linkers(4,ii) = y2;
    end
    linkers(5,:) = (linkers(3,:)-linkers(1,:))./cos(ANGLES);
end
