function eng = PT6T_6B_Twin_Pac(atmosphere,numEngines)
%
% Author: Maria Sanz mariass0@alumnos.upm.es
% Date: 13/03/2014
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
               'helicopters',{'Agusta Bell 412 HP'},...
              'manufacturer',{'Pratt & Whitney Canada'},...
                     'model',{'PT6T-6B Twin Pac'},...
                    'weight',305.2728*g,...
                    'lenght',1.671978,...
                     'width',1.105335,...
                    'height',0.828366,...
                      'Snac',6.466211061,...
              'PowerTakeOff',1469.030e3,...
    'PowerMaximumContinuous',1301.247e3,...
             'powerExponent',0.85,... % FIXME: to be fitted with actual data
                'numEngines',numEngines,...
                  'OmegaRPM',6600,...
                       'PSFC',9.98626e-08 ...
);


eng  = addEnginePerformance(eng,atmosphere);