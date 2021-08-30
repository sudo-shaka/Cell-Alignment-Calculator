function  Make_Calc_Image(Reference_Image,cells)
  Reference_Image=Reference_Image.*0;
  figure; hold on;
  imshow(Reference_Image);
    for ii = 1:length(cells)
        
        d = cells(ii).nuclear(3)*2;
        px = cells(ii).nuclear(1)-cells(ii).nuclear(3);
        py = cells(ii).nuclear(2)-cells(ii).nuclear(3);
        rectangle('Position',[px py d d],'Curvature',[1,1]);
        
      for jj = 1:length(cells(ii).linkers(1,:))
        line([cells(ii).linkers(1,jj),cells(ii).linkers(3,jj)],[cells(ii).linkers(2,jj),cells(ii).linkers(4,jj)]);
      end
     
        for jj = 1:length(cells(ii).junctions(1,:))
                line([cells(ii).linkers(3,jj),cells(ii).linkers(3,jj+1)],[cells(ii).linkers(4,jj),cells(ii).linkers(4,jj+1)],'Color','green');
        end

       text(px,py,string(cells(ii).name),'color','red');

    end
    hold off;
    
    s = size(Reference_Image);
    axis([0 s(1) 0 s(2)]);
    
    saveas(gcf,'Output/Computer Cells.png');
    
end

