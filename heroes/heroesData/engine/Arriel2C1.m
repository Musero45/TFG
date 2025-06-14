function eng = Arriel2C1(atmosphere,numEngines)
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
               'helicopters',{'Eurocopter EC155 B (2)'},...
              'manufacturer',{'Turbomeca'},...
                     'model',{'Arriel2C1'},...
                    'weight',127.9152*g,...
                    'lenght',1.0160,...
                     'width',0.4623,...
                    'height',0.5766,...
                      'Snac',2.1110,...
              'PowerTakeOff',625.6423e3,...
    'PowerMaximumContinuous',595.8143e3,...
                  'OmegaRPM',6000,...
             'powerExponent',0.85,... % FIXME: to be fitted with actual data
                'numEngines',numEngines,...
                       'PSFC',9.2766e-08 ...
);


eng  = addEnginePerformance(eng,atmosphere);

