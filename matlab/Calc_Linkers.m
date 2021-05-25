function [linker_lengths,linker_data] = Calc_Linkers(junctional_image,centers,n_linkers)
	n_nuc = length(centers);
	links = linspace(0,2*pi,n_linkers);

	linker_lengths = zeros(n_nuc,n_linkers);
    linker_data = [];
    
	for ii = 1:n_nuc
        linker_data_ii = zeros(n_linkers,5);
        start_location = centers(ii,:);
		for jj = 1:n_linkers
			x = centers(ii,2);
			y = centers(ii,1);
			pixel = 0;
			while pixel==0 && min([x,y] < size(junctional_image)) && min([round(x),round(y)]) ~= 0
                pixel = junctional_image(round(x),round(y));
                y = y + sin(links(jj))*0.01;
                x = x + cos(links(jj))*0.01;
                end_location = [y,x];
                distance = sqrt((end_location(1).^2)+(end_location(2).^2));
                linker_lengths(ii,jj) = distance;
                angles = links(jj);
                linker_data_ii(jj,:) = [angles,start_location(1),start_location(2),end_location(1),end_location(2)];
            end
        end
        linker_data = [linker_data,linker_data_ii];
    end
end
