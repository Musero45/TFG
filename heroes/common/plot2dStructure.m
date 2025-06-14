function varargout = plot2dStructure(Z,xAxes,Vars,options)
% function varargout = plot2dStructure(Z,axesData,options)

if length(Z)>1
   error('PLOTCELL0FONESTRUCTURE: input cell data length should be equal to 1')
end

fmt       = options.format;
titletext = options.titleplot;

if strcmp(options.mode,'thick')
   setPlot
end



naxes  = length(xAxes);

for a = 1:naxes

xvar   = char(xAxes.var);
xlab   = xAxes.lab;
xunit  = xAxes.unit;
yvars  = Vars.var;
ylabs  = Vars.lab;
yunits = Vars.unit;


% Get number of series
nSeries   = length(yvars);

% Avoid legends when nSeries is greater than 20
if nSeries > 20
   leg = [];
end

% Define markers
if nSeries < length(options.mark)
   mark      = options.mark;
else
   ol      = options.lines;
   nLines  = length(ol);
   nl      = nLines*ceil(nSeries/nLines);
   mark    = cell(1,nl);
   for i=1:ceil(nSeries/nLines)
       mark(1+(i-1)*nLines:i*nLines) = ol;
   end
end

% emptyLeg  = isempty(leg);
% 
% if nSeries ~= length(leg) 
%    if  ~emptyLeg
%        error('PLOTCELLOFSTRUCTURES: Z and leg must be cells of same length');
%    end
% end

hgcf   = getCurrentFigureNumber;
ax     = cell(1,2);
lab    = ylabs{1};
figure(hgcf + 1)
set(gcf,'Name',yvars{1});
leg    = ylabs;

for i=1:length(yvars)
    var  = char(yvars{i});
    unit = yunits(i);
    x    = Z.(xvar)*xunit;
    y    = Z.(var)*unit;
    plot(x,y,mark{i}); hold on;
    title(titletext);
    xlabel(xlab);ylabel(lab);
    if strcmp(options.gridOn,'yes')
       grid on;
    else
       grid off;
    end
    if ~strcmp(options.prefix,'no')
       name = strcat(options.prefix,'_',var);
       savePlot(gcf,name,fmt);
    end
end
gcl  = legend(leg,0);
ax{1,1} = gca;
ax{1,2} = gcf;
ax{1,3} = gcl;

end

hold off
if strcmp(options.closePlot,'yes')
   close all
end
if strcmp(options.mode,'thick')
   unsetPlot
end

if nargout==1
   varargout{1} = ax;
end