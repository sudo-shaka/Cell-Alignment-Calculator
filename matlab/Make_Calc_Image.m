function  Make_Calc_Image(Reference_Image,centers,radii,linker_data)
  figure; hold on;
  imshow(Reference_Image)
    for ii = 1:length(centers)        
        link_select = (ii*5)-4;
        points = linker_data(:,(link_select+1):(link_select+4));
        
        for jj = 1:length(points)
            line([points(jj,1),points(jj,3)],[points(jj,2),points(jj,4)],'color','green');                
        end
    end
    viscircles(centers,radii);
    hold off;
    
    s = size(Reference_Image);
    axis([0 s(1) 0 s(2)]);
end

