function eng = PT6C_67C(atmosphere,numEngines)
%
% Author: Ivan Marq ivanmarq@gmail.com
% Date: 13/03/2014
%
% TODO LIST 
% * fit powerExponent to actual data
% * modify addEnginePerformance to define PSFC dependency on altitute and
%  consequently define psfcExponent in case it makes sense to fit actual 
%  PSFC data with a power function of the altitude 
%
%

g = 9.81;
eng = struct( ...
               'helicopters',{'Augusta Westland AW139 (2)'},...
              'manufacturer',{'Pratt & Whitney Canada'},...
                     'model',{'PT6C_67C'},...
                    'weight',188.244*g,...
                    'lenght',1.506813,...
                     'width',0.571725,...
                    'height',0.571725,...
                      'Snac',3.4459306,...
              'PowerTakeOff',1252.03e3,...
    'PowerMaximumContinuous',1141.667e3,...
                  'OmegaRPM',21420,...
             'powerExponent',0.85,...% FIXME: to be fitted with actual data
                'numEngines',numEngines,...
                      'PSFC',8.56689e-8 ...
);


eng = addEnginePerformance(eng,atmosphere);