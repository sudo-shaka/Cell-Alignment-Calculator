function axis_ratios= Get_Axis_R(distances)
    axis_ratios=zeros(1,length(distances(:,1)));
    for ii = 1:length(axis_ratios)
        data = rmoutliers(distances(ii,:));
        data = distances(ii,:);
        ratio=max(data)/min(data);
        axis_ratios(ii) = ratio;
    end
    axis_ratios = rmoutliers(axis_ratios);
end

