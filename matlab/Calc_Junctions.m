function junctions = Calc_Junctions(linkers)
    junctions = zeros(5,length(linkers)-1);
    
    junctions(1,:) = linkers(3,1:length(junctions)); %x1
    junctions(2,:) = linkers(4,1:length(junctions)); %y1
    junctions(3,:) = linkers(3,2:length(junctions)+1); %x2
    junctions(4,:) = linkers(4,2:length(junctions)+1); %y2
   
    a = abs(junctions(3,:)-junctions(1,:));
    b = abs(junctions(4,:)-junctions(3,:));
    
    junctions(5,:) = sqrt(a.^2 + b.^2);
end
