function varargout = plotCellOfStructures(Z,xAxes,Vars,leg,options)
%plotCellOfStructures Plot a cell of structures
%
%   plotCellOfStructures(Z,AXS,AZS,LEG,OPTS) plots a cell of structures
%   Z of length 1xnz according to the information contained into the 
%   structure AXS with legend defined by the cell LEG and plot options 
%   especified by OPTS structure. The numerical information to be 
%   plotted is contained in the Z cell of structures. Each element of 
%   cell Z should be an structure and every structure of the cell 
%   should have the same fields, that is, all elements of the Z 
%   cell of structures are of the same kind. 
%
%   The definition of the x axis variable together with y axis variables 
%   to be plotted are contained into AXS. The structure axes data 
%   AXS should be of the form
%       xvar: {1x1 cell}
%       xlab: {1x1 cell}
%      xunit: ix
%      yvars: {1xnz cell}
%      ylabs: {1xnz cell}
%     yunits: [1xnz double]
%
%   where xvar is a 1x1 cell with a string specifying the name of the field
%   of the Z{i} structure which is the x axis variable, xlab is a 1x1 
%   cell string tat specifies the x label to be plot at the figure, xunits
%   is the scale factor to multiply x data, i.e. if xunits is 1000 the 
%   x data especify by xvar is multiply by 1000, yvars is a cell of 1xnz
%   strings being nz the length of the cell of structures Z, that specify
%   the y variables to be plotted, ylabs is a cell of strings to plot the
%   y labels of the figure and yunits is a 1xnz vector defining the scale
%   factors to multiply y data.
%
%   The options structure OPTS sets the default behavior regarding aspects
%   like series style, output format file, name of file to store the 
%   graphic information, title of figure, thick or thin line modes, and 
%   switching of the default x and y variables by specifying an alternative
%   AXS structure. The OPTS default structure is determined by the function
%   setHeroesPlotOptions.
%
%   See also setHeroesPlotOptions
%
%   TODO
%
%   * Finish to document this function FIXME

fmt       = options.format;
titletext = options.titleplot;

if strcmp(options.mode,'thick')
   setPlot
end

% Get number of series
nSeries   = length(Z);

% Avoid legends when nSeries is greater than 20
if nSeries > 20
   leg = [];
end

% Define markers
if nSeries <= length(options.mark)
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
emptyLeg  = isempty(leg);

if nSeries ~= length(leg) 
   if  ~emptyLeg
       error('PLOTCELLOFSTRUCTURES: Z and leg must be cells of same length');
   end
end

% This change is very important because it requires that axds fields should
%  be input as cells in order to be able to define several xAxes, even for
%  the usual case of just one xAxe.
% naxes  = length(xAxes);
naxes  = length(xAxes.var);

for a = 1:naxes
% xvar   = char(xAxes.var);
% xlab   = xAxes.lab;
% xunit  = xAxes.unit;
xvar   = char(xAxes.var{a});
xlab   = xAxes.lab{a};
xunit  = xAxes.unit(a);
yvars  = Vars.var;
ylabs  = Vars.lab;
yunits = Vars.unit;

hgcf   = getCurrentFigureNumber;
ax     = cell(length(yvars),2);
for i=1:length(yvars)
    var  = char(yvars{i});
    lab  = ylabs{i};
    unit = yunits(i);
    figure(hgcf + i)
    set(gcf,'Name',var);
    for j=1:nSeries
        z    = Z{j};
        x    = z.(xvar)*xunit;
        y    = z.(var)*unit;
        plot(x,y,mark{j}); hold on;
    end
    title(titletext);
    xlabel(xlab);ylabel(lab)
    if strcmp(options.gridOn,'yes')
       grid on;
    else
       grid off;
    end
    if ~emptyLeg
       gcl  = legend(leg,'Location','Best');
       set(gcl,'interpreter','latex');
    else
       gcl  = [];
    end
    if ~strcmp(options.prefix,'no')
       name = strcat(options.prefix,'_',var);
       savePlot(gcf,name,fmt);
    end
    ax{i,1} = gca;
    ax{i,2} = gcf;
    ax{i,3} = gcl;
end
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
