function eng = RTM322_01_9A(atmosphere,numEngines)
%
% Author: Sergio Nadal s.nadal@alumnos.upm.es
% Date: 13/03/2014
%
% TODO LIST 
% * fit powerExponent to actual data
% * modify addEnginePerformance to define PSFC dependency on altitute and
%  consequently define psfcExponent in case it makes sense to fit actual 
%  PSFC data with a power function of the altitude 
%
%

g=9.81;
eng = struct( ...
               'helicopters',{'NHI NH90 (2)'},...
              'manufacturer',{'Rolls-Royce Turbomeca'},...
                     'model',{'RTM322-01/9A'},...
                    'weight',227.254*g,...
                    'lenght',1.1176,...
                     'width',0.64008,...
                    'height',0.60198,...
                      'Snac',2.77625,...
              'PowerTakeOff',1.90452e+06,...
    'PowerMaximumContinuous',1.80534e+06,...
                  'OmegaRPM',20900,...
             'powerExponent',0.85,... % FIXME: to be fitted with actual data
                'numEngines',numEngines,...
                       'SPC',7.2e-08 ...
);


eng  = addEnginePerformance(eng,atmosphere);