function eng = PW207D(atmosphere,numEngines)
%
% Author: Jose Garcia Garrido jose.garcia.garrido@alumnos.upm.es
% Date: 24/03/2014
%
% TODO LIST 
% * fit powerExponent to actual data
% * modify addEnginePerformance to define PSFC dependency on altitute and
%  consequently define psfcExponent in case it makes sense to fit actual 
%  PSFC data with a power function of the altitude 
%

g   = 9.81;
eng = struct( ...
               'helicopters',{'Bell M427 (2)'},...
              'manufacturer',{'Pratt & Whitney Canada'},...
                     'model',{'PW207D'},...
                    'weight',110.2248*g,...
                    'lenght',0.792792,...
                     'width',0.500577,...
                    'height',0.566643,...
                      'Snac',1.692166956,...
              'PowerTakeOff',529.447e+03,...
    'PowerMaximumContinuous',466.0625e+03,...
                  'OmegaRPM',6240,...
             'powerExponent',0.85,... % FIXME: to be fitted with actual data
                'numEngines',numEngines,...
                      'PSFC',9.07381e-08 ...
);


eng  = addEnginePerformance(eng,atmosphere);

