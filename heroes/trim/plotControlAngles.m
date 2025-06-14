function plotControlAngles(tS,legend,varargin)

if isempty(varargin)
    axesData.xvar  = 'mux';
    axesData.xlab  = 'V/(\Omega R) [-]';
    axesData.xunit = 1;
    plotOption     = {};
    plotOption     = parseOptions(plotOption,@setTrimPlotOptions);
elseif length(varargin) == 1
    if iscell(varargin)
       plotOption     = varargin{1};
       if isstruct(plotOption)
          plotOption = struct2pv_pairsCell(plotOption);
       end
       plotOption = parseOptions(plotOption,@setTrimPlotOptions);
    elseif isstruct(varargin)
       plotOption     = varargin{1};
    end
    Zvars          = plotOption.defaultVars;
    if isstruct(Zvars)
       axesData.xvar  = Zvars.xvar;
       axesData.xlab  = Zvars.xlab;
       axesData.xunit = Zvars.xunit;
    else
       axesData.xvar  = 'mux';
       axesData.xlab  = 'V/(\Omega R) [-]';
       axesData.xunit = 1;
    end

end

% if length(varargin)==1 
%    while iscell(varargin) && length(varargin)==1
%       varargin = varargin{1};
%    end
% end

r2d    = 180/pi;

% % % % % % axesData.xvar = 'mux';
% % % % % % axesData.xlab = 'V/(\Omega R) [-]';
% % % % % % axesData.xunit = 1;
axesData.yvars = {'Theta' 'theta0' 'theta1C' ...
        'theta1S' 'theta0tr'};
axesData.ylabs = {'\Theta [^o]' '\theta_0 [^o]' '\theta_{1C} [^o]' ...
        '\theta_{1S} [^o]' '\theta_{T} [^o]'};
axesData.yunits = [r2d r2d r2d r2d r2d];


% plotOpt = parseOptions(varargin,@setHeroesPlotOptions);
% plotOpt.mode = 'thick';
% plotOpt.mark = plotOpt.lines;
plotCellOfStructures(tS,axesData,legend,plotOption);

