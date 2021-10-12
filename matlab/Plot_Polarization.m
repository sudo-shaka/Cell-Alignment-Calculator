function p = PlotPolarization(Cells)
	figure; hold on;
	for c = Cells
		Angles = c.Angles.*180./pi;
		Linescans = mean(c.Linescan,2,'omitnan');
		plot(Angles,Linescans,'.');
	end
	xlabel("Angle (Degrees)");
	ylabel("Intensity of Signal");
end
