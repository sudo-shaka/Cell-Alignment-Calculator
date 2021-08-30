function [out,n] = linescan(IMAGE,cell)

out = zeros(length(cell.angles),ceil(max(cell.linkers(5,:)))+1);
x1 = cell.linkers(1,:);
y1 = cell.linkers(2,:);
x2 = cell.linkers(3,:);
y2 = cell.linkers(4,:);
n = zeros(1,length(x1));

for ii = 1:length(x1)
    x = [x1(ii),x2(ii)];
    y = [y1(ii),y2(ii)];
    linescan = improfile(IMAGE,x,y);
    n = max(numel(out(ii,:)),numel(linescan));
    linescan(end+1:n)=nan;
    out(ii,:) = linescan;
end

end
