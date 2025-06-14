function options = setISAPlotOptions
%  SETISAPLOTOPTIONS Defines the default options of ISA plots
%     
%  OPTIONS = SETISAPLOTOPTIONS returns the default options
%  structure of ISAPLOT, OPTIONS. The default structure is:
%
%                  hspan: [1x51 double]
%        temperatureUnit: 'Kelvin'
%              [+options: setHeroesPlotOptions]
%
%   See also setHeroesPlotOptions
% 
%  hspan - vector of altitude to plot atmosphere properties variation 
%             [  {linspace(0,20000,51)} | double ]
%
%  temperatureUnit - string to set the temperature unit
%             [   {'Kelvin'}|'Celsius' ]
%


% These are the options set by default
options  = setHeroesPlotOptions;

% Adding other fields
options.hspan               = linspace(0,20000,51); % {linspace(0,20000,51)} | double 
options.temperatureUnit     = 'Kelvin'; % {'Kelvin'}|'Celsius'

