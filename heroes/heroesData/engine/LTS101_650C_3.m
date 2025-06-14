function eng = LTS101_650C_3(atmosphere,numEngines)
%
% Author: Iker Camiruaga ikercamiruaga@gmail.com
% Date: 2012
%
% TODO LIST 
% * fit powerExponent to actual data
% * modify addEnginePerformance to define PSFC dependency on altitute and
%  consequently define psfcExponent in case it makes sense to fit actual 
%  PSFC data with a power function of the altitude 
%
%

g   = 9.81;
eng = struct( ...
               'helicopters',{'Bell 222 (2)'},...
              'manufacturer',{'Honeywell Engines & Systems'},...
                     'model',{'LTS101-650C-3'},...
                    'weight',110.2248*g,...
                    'lenght',0.7955871,...
                     'width',0.574266,...
                    'height',0.4942245,...
                      'Snac',1.700154517,...
              'PowerTakeOff',469.791e+03,...
    'PowerMaximumContinuous',445.9286e+03,...
                  'OmegaRPM',9545,...
             'powerExponent',0.85,... % FIXME: to be fitted with actual data
                'numEngines',numEngines,...
                      'PSFC',9.631e-08 ...
);


eng  = addEnginePerformance(eng,atmosphere);

