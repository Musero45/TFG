function plotSimplifiedTS(tS,legend,varargin)

tS  = output2cellOfStructures(tS);


if length(varargin)==1 
   while iscell(varargin) && length(varargin)==1
      varargin = varargin{1};
   end
end

r2d    = 180/pi;

axesData.xvar = 'mux';
axesData.xlab = 'V/(\Omega R) [-]';
axesData.xunit = 1;
axesData.yvars = {'Phi' 'beta0' 'beta1C' ...
        'beta1S' 'lambda0'};
axesData.ylabs = {'\Phi [^o]' '\beta_0 [^o]' '\beta_{1C} [^o]' ...
        '\beta_{1S} [^o]' '\lambda_0 [-]'};
axesData.yunits = [r2d r2d r2d r2d 1 1 1 1];


plotOpt = parseOptions(varargin,@setHeroesPlotOptions);
plotOpt.mode = 'thick';
% plotOpt.mark = plotOpt.lines;
plotCellOfStructures(tS,axesData,legend,plotOpt);