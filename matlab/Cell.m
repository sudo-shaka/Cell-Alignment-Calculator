classdef Cell
	properties
		Name
		Nuclear
		COM
		Angles
		Linkers
		AxisR
		Area
		Perimeter
		ShapeParam
	end
	methods
		function Cells = GetFromImages(Cell,nLinks,nImg,jImg)
			nMask = imbinarize(imgaussfilt(nImg,1),'adaptive','Sensitivity',0.05);
			nMask = imfill(nMask,'holes');
			props = regionprops(nMask,'Centroid','Perimeter');

			fprintf('Found %d cells\n',length(props));

			Cells = [];

			for ii = 1:length(props)
				if props(ii).Perimeter > 30
					C = Cell;
					C.Nuclear = props(ii).Centroid;
					C.Name = ii;
					C.Angles = linspace(0,pi*2,nLinks);
					C = C.CalcLinkers(20,jImg);
					C = C.GetArea();
					C = C.GetPerim();
					C = C.GetCOM();
					C = C.GetAxis();
					C = C.GetShapeParam();
					Cells = [Cells,C];
				end
			end

		end
		function Cell = CalcLinkers(Cell,H,jImg)
			jImg = imgaussfilt(jImg,3);
			jImg = imadjust(imtophat(jImg,strel('disk',15)));
			Pre_water = 1-(imextendedmin(jImg,H,4));
			Water = watershed(Pre_water,8);
			jMask = (Water == 0);
			imwrite(jMask,'Output/jMask.png');
			
			x1 = Cell.Nuclear(1);
			y1 = Cell.Nuclear(2);

			nLink = length(Cell.Angles);

			Cell.Linkers.Coords = zeros(2,nLink);
			Cell.Linkers.Length = zeros(1,nLink);

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

				Cell.Linkers.Coords(1,ii) = x2;
				Cell.Linkers.Coords(2,ii) = y2;
				Cell.Linkers.Length(ii) = sqrt(abs(x2-x1)^2 - abs(y2-y1)^2);
			end
		end
		function Cell = GetArea(Cell);
			Cell.Area = polyarea(Cell.Linkers.Coords(1,:),Cell.Linkers.Coords(2,:));
		end
		function Cell = GetPerim(Cell)
			x = Cell.Linkers.Coords(1,:);
			y = Cell.Linkers.Coords(2,:);
			dx = abs(x(2:end) - x(1:end-1));
			dy = abs(y(2:end) - y(1:end-1));
			p = sqrt(dx.^2 + dy.^2);
			Cell.Perimeter = sum(p);
		end
		function Cell = GetCOM(Cell)
			%warning('off','all');
			pshape = polyshape(Cell.Linkers.Coords(1,:),...
				Cell.Linkers.Coords(2,:));
			[x,y] = centroid(pshape);
			center = zeros(1,2);
			center(1) = x;
			center(2) = y;
			Cell.COM = center;
		end

		function Cell = GetAxis(Cell)
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
			Cell.AxisR = AxisR;
		end

		function Cell = GetShapeParam(Cell)
			Cell.ShapeParam = Cell.Perimeter^2/(Cell.Area*pi*4);
		end

		function PlotCell(Cell)
			plot(Cell.Nuclear(1),Cell.Nuclear(2),'ro');
			hold on;
			plot(Cell.Linkers.Coords(1,:),Cell.Linkers.Coords(2,:),'.b');
		end
	end
end
