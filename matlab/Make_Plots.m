function p = Make_Plots(cells)
    try
        i = 1;
        for cell = cells
            figure;
            plot(cell.angles,cell.linkers(5,:));
            xlabel("Angles (Radians)"); ylabel("Length from Nuc (AU)");
            saveas(gcf,'Output/Plot_'+string(cell.name)+'.png');
            i = i +1;
        end
        
        figure
        histogram([cells(:).AxisR]);
        title("Axis Ratio Histogram");
        saveas(gcf,'Output/AxisR.png');
        
        figure
        histogram([cells(:).Area]);
        title("Cell Area Histogram");
        saveas(gcf,'Output/Areas.png');
        
    catch
        disp("Plotting Error");
    end
    
end

