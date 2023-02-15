classdef Cell
	properties
		Name
		Nuclear
		COM
		Angles
		Linkers
		Linescan
		AxisR
		Area
		Perimeter
		ShapeParam
        Intensity
	end
	methods
		function Cells = GetFromImages(Cell,nLinks,nImg,jImg,sImg)
			nMask = imbinarize(imgaussfilt(nImg,1),'adaptive','Sensitivity',0.05);
			nMask = imfill(nMask,'holes');
			props = regionprops(nMask,'Centroid','Perimeter');

			Cells = []; 

			for ii = 1:length(props)
				if props(ii).Perimeter > (max([props(:).Perimeter]) - 50)
					C = Cell;
					C.Nuclear = props(ii).Centroid;
					C.Name = ii;
					C.Angles = linspace(0,pi*2,nLinks);
					C.Linkers = C.CalcLinkers(jImg);
					C.Linescan = C.LineScans(sImg);
					C.Area = C.GetArea();
					C.Perimeter = C.GetPerim();
					C.COM = C.GetCOM();
					C.AxisR = C.GetAxis();
					C.ShapeParam = C.GetShapeParam();
                    C.Intensity = C.GetIntensity();
					Cells = [Cells,C];
				end
			end

		end
        function Linkers = CalcLinkers(Cell,jImg)
			jImg = imgaussfilt(jImg,3);
			jImg = imadjust(imtophat(jImg,strel('disk',15)));
			Pre_water = 1-(imextendedmin(jImg,mean(jImg,'all'),4));
			Water = watershed(Pre_water,8);
			jMask = (Water == 0);
			imwrite(jMask,'Output/jMask.png');
			
			x1 = Cell.Nuclear(1);
			y1 = Cell.Nuclear(2);

			nLink = length(Cell.Angles);

			Linkers.Coords = zeros(2,nLink);
			Linkers.Length = zeros(1,nLink);

			for ii = 1:nLink
				x2 = x1;
				y2 = y1;

				pixel=0;
				while ~pixel
					try
						pixel = jMask(round(y2),round(x2));
						x2 = x2 + cos(Cell.Angles(ii))*0.1;
						y2 = y2 + sin(Cell.Angles(ii))*0.1;
					catch
						break;
					end
				end

				Linkers.Coords(1,ii) = x2;
				Linkers.Coords(2,ii) = y2;
				Linkers.Length(ii) = sqrt(abs(x2-x1)^2 + abs(y2-y1)^2);
			end
		end
		function out = LineScans(Cell,sImg)
			n = length(Cell.Angles);
			longest_length = ceil(max(Cell.Linkers.Length))+1;
			out = zeros(n,longest_length);
			x1 = Cell.Nuclear(1);
			y1 = Cell.Nuclear(2);
			x2 = Cell.Linkers.Coords(1,:);
			y2 = Cell.Linkers.Coords(2,:);

			for ii = 1:n
				x = [x1,x2(ii)];
				y = [y1,y2(ii)];
				linescan = improfile(sImg,x,y);
				nu = max(numel(out(ii,:)),numel(linescan));
				linescan(end+1:nu) = nan;
				out(ii,:) = linescan;
			end
		end
		function Area = GetArea(Cell);
			Area = polyarea(Cell.Linkers.Coords(1,:),Cell.Linkers.Coords(2,:));
		end
		function Perim = GetPerim(Cell)
			x = Cell.Linkers.Coords(1,:);
			y = Cell.Linkers.Coords(2,:);
			dx = abs(x(2:end) - x(1:end-1));
			dy = abs(y(2:end) - y(1:end-1));
			p = sqrt(dx.^2 + dy.^2);
			Perim = sum(p);
		end
		function center = GetCOM(Cell)
			pshape = polyshape(Cell.Linkers.Coords(1,:),...
				Cell.Linkers.Coords(2,:));
			[x,y] = centroid(pshape);
			center = zeros(1,2);
			center(1) = x;
			center(2) = y;
		end

		function AxisR = GetAxis(Cell)
			diff = zeros(1,length(Cell.Angles));
			lengths = Cell.Linkers.Length;
			n = length(diff);

			for ii = 1:n
				if Cell.Angles(ii) <= pi
					jj = ii+(round(n)/2);
				else
					jj = ii-(round(n)/2);
				end
				try
					diff(ii) = abs(lengths(ii)-length(jj));
				catch
				end
			end

			[~,loc] = max(diff);

			if Cell.Angles(loc) < pi;
				loc2 = loc + round(n/2);
			else 
				loc2 = loc - round(n/2);
			end
			try
				AxisR = lengths(loc)/lengths(loc2);
			catch
				AxisR = length(loc)/lengths(loc2+1);
			end
		end

		function ShapeParam = GetShapeParam(Cell)
			ShapeParam = Cell.Perimeter^2/(Cell.Area*pi*4);
        end

        function Intensity = GetIntensity(Cell)
            Intensity = mean(Cell.Linescan,'all','omitnan');
        end

		function PlotCell(Cell)
			plot(Cell.Nuclear(1),Cell.Nuclear(2),'ro');
			hold on;
			plot(Cell.COM(1),Cell.COM(2),'go')
			plot(Cell.Linkers.Coords(1,:),Cell.Linkers.Coords(2,:),'.b');
			line(Cell.Linkers.Coords(1,:),Cell.Linkers.Coords(2,:),'color','green');
		end
	end
end
