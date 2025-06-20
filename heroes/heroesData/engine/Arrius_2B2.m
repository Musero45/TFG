function eng = Arrius_2B2(atmosphere,numEngines)
%
% Author: Alvaro Moreno alvaro.msacristan@alumnos.upm.es
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
               'helicopters',{'Eurocopter EC135 t2i (2)'},...
              'manufacturer',{'Turbomeca'},...
                     'model',{'Arrius 2B2'},...
                    'weight',113.8536*g,...
                    'lenght',1.18364,...
                     'width',0.51816,...
                    'height',0.69088,...
                      'Snac',2.8621362112,...
              'PowerTakeOff',485.4507e+03,...
    'PowerMaximumContinuous',437.7259e+03,...
                  'OmegaRPM',6252,...
             'powerExponent',0.85,... % FIXME: to be fitted with actual data
                'numEngines',numEngines,...
                      'PSFC',9.10760277777778e-08 ...
);


eng  = addEnginePerformance(eng,atmosphere);

