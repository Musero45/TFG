function eng = RR250C20J(atmosphere,numEngines)
%
% Author: Rocio Macarro rocio.martin.macarro@alumnos.upm.es
% Date: 18/03/2014
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
               'helicopters',{'Bell 206B, JetRanger III (1), Bell TH-57 (1), BellTH-67 (1)'},...
              'manufacturer',{'Rolls Royce'},...
                     'model',{'250-C20J'},...
                    'weight',73.4832*g,...
                    'lenght',0.9652,...
                     'width',0.4826,...
                    'height',0.58928,...
                      'Snac',2.069157152,...
              'PowerTakeOff',313.194e3,...
    'PowerMaximumContinuous',313.194e3,...
                  'OmegaRPM',6016,...
             'powerExponent',0.85,... % FIXME: to be fitted with actual data
                'numEngines',numEngines,...
                      'PSFC',1.09831944444444e-7 ...
);
eng  = addEnginePerformance(eng,atmosphere);