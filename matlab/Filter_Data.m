function data = Filter_Data(data)
    len_col = length(data(1,:));
    for ii = 1:len_col
        data(ii,:)  = rmoutliers(data(ii,:));
    end
end

