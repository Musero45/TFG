function eng =  PT6T_3D_DE_DF_Twin_Pac(atmosphere,numEngines)
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
               'helicopters',{'Bell/Agusta-Bell 412 EP'},...
              'manufacturer',{'Pratt & Whitney Canada'},...
                     'model',{'PT6T-3D/DE/DF Twin-Pac'},...
                    'weight',201.644*g,...
                    'lenght',1.671978,...
                     'width',1.105335,...
                    'height',0.828366,...
                      'Snac',6.466211061,...
              'PowerTakeOff',1431.740e3,...
    'PowerMaximumContinuous',1267.69e3,...
             'powerExponent',0.85,... % FIXME: to be fitted with actual data
                'numEngines',numEngines,...
                  'OmegaRPM',6600,...
                       'PSFC',1.0383e-07 ...
);


eng  = addEnginePerformance(eng,atmosphere);