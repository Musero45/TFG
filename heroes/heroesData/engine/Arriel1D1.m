function eng = Arriel1D1(atmosphere,numEngines)
%
% Author: Cesar Garcia cesar.garcia.lozano@alumnos.upm.es
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
               'helicopters',{'Eurocopter AS350 B2 (1)'},...
              'manufacturer',{'Turbomeca'},...
                     'model',{'Arriel1D1'},...
                    'weight',122.018*g,...
                    'lenght',1.0465,...
                     'width',0.4623,...
                    'height',0.6121,...
                      'Snac',2.2487,...
              'PowerTakeOff',545.852e3,...
    'PowerMaximumContinuous',466.062e3,...
                  'OmegaRPM',5976,...
             'powerExponent',0.85,... % FIXME: to be fitted with actual data
                'numEngines',numEngines,...
                       'PSFC',9.78349e-08 ...
);


eng  = addEnginePerformance(eng,atmosphere);

