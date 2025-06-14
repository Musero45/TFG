function options = setTrimPlotOptions
%  actionsByElements - Logical variable to plot actions by elements [ {'yes'} | 'no']
%     This string specifies whether the plotTrimState plots actions by
%     elements or not
%
%  controlAngles - Logical variable to plot control angles [ {'yes'} | 'no']
%     This string specifies whether the plotTrimState plots control angles 
%     or not
%

% Parent options of trim plot 
options = setHeroesPlotOptions;

% Actual options for trim plots
options.actionsByElements  = 'no';
options.controlAngles  = 'no';