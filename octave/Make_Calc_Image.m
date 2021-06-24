function Make_Calc_Image(Ref_Img,cells)
	figure; hold on;
	imshow(Ref_Img);
	for ii = 1:length(cells)
		
		for jj = 1:length(cells(ii).linkers(1,:))
			line([cells(ii).linkers(1,jj),cells(ii).linkers(3,jj)],[cells(ii).linkers(2,jj),cells(ii).linkers(4,jj)]);
		end
		for jj = 1:length(cells(ii).junctions(1,:))
			line([cells(ii).junctions(1,jj),cells(ii).junctions(3,jj)],[cells(ii).junctions(2,jj),cells(ii).junctions(4,jj)],'Color','green');
		end

		text(cells(ii).nuclear(1),cells(ii).nuclear(2),int2str(cells(ii).name),'Color','red');

	end
	hold off;

	s = size(Ref_Img);
	axis([0 s(1) 0 s(2)]);

	saveas(gcf,"Output/Computer_cells.png");
end
