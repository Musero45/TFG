function plotAMPract(amS,legend,varargin)

if length(varargin)==1 
   while iscell(varargin) && length(varargin)==1
      varargin = varargin{1};
   end
end

r2d    = 180/pi;

axesData.xvar = 'theta1S';
axesData.xlab = '\theta_{1S} [º]';
axesData.xunit = r2d;
axesData.yvars = {'beta0' 'beta1C' 'beta1S' 'lambda0' ...
        'CH' 'CY' 'CT' 'equil'...
        'CMaEx' 'CMaEy' 'CMaEz' 'CMFax' 'CMFay' 'CMFaz' ...
        'CME2Fx' 'CME2Fy' 'CME2Fz' 'CMax' 'CMay' 'CMaz'};
axesData.ylabs = {'\beta_0 [º]' '\beta_{1C} [º]' '\beta_{1S} [º]' '\lambda_0 [-]' ...
        'C_{H} [-]' 'C_{Y} [-]' 'C_{T} [-]' 'C_{H}cos\Theta_A +C_{T}sin\Theta_A [-]' ...
        'C_{Mx_A}^{a,E} [-]' 'C_{My_A}^{a,E} [-]' 'C_{Mz_A}^{a,E}'...
        'C_{Mx_A}^{F^a} [-]' 'C_{My_A}^{F^a} [-]' 'C_{Mz_A}^{F^a}'...
        'C_{Mx_A}^{a,E}/C_{Mx_A}^{F^a} [-]'...
        'C_{My_A}^{a,E}/C_{My_A}^{F^a} [-]'...
        'C_{Mz_A}^{a,E}/C_{Mz_A}^{F^a} [-]'...
        'C_{Mx_A}^a [-]' 'C_{My_A}^a [-]' 'C_{Mz_A}^a [-]'};
axesData.yunits = [r2d r2d r2d 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1];

pairs = {};
%%%% Uncomment following line in order to generate output files
%     pairs = {'format' {'pdf'} 'prefix' prefix{k} 'closePlot' 'yes'};

plotOpt = parseOptions(pairs,@setHeroesPlotOptions);
plotOpt.mode = 'thick';
plotCellOfStructures(amS,axesData,legend,plotOpt);