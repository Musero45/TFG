function eng = PW207E(atmosphere,numEngines)
%
% Author: Lucia Sanchez lucia.sanchez.iglesias@alumnos.upm.es
% Date: 17/03/2014
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
               'helicopters',{'MD Explorer (2)'},...
              'manufacturer',{'Pratt & Whitney Canada'},...
                     'model',{'PW207E'},...
                    'weight',108,864*g,...
                    'lenght',0,792792,...
                     'width',0,500577,...
                    'height',0,569184,...
                      'Snac',1,696195925424,...
              'PowerTakeOff',529,447e3,...
    'PowerMaximumContinuous',466,0625e3,...
                  'OmegaRPM',6240,...
             'powerExponent',0.85,... % FIXME: to be fitted with actual data
                'numEngines',numEngines,...
                       'PSFC',9.1245e-08 ...
);


eng  = addEnginePerformance(eng,atmosphere);