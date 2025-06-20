function eng = RR_250_C47B(atmosphere,numEngines)
%
% Author: Hector Fernandez hector.fdotu@alumnos.upm.es
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
               'helicopters',{'Bell 407 (1), MD Helicopter MD 600N (1)'},...
              'manufacturer',{'Rolls-Royce'},...
                     'model',{'250-C47B'},...
                    'weight',124.2864*g,...
                    'lenght',1.0414,...
                     'width',0.5588,...
                    'height',0.65278,...
                      'Snac',2.523478824,...
              'PowerTakeOff',484.705e3,...
    'PowerMaximumContinuous',447.42e3,...
                  'OmegaRPM',6317,...
             'powerExponent',0.85,... % FIXME: to be fitted with actual data
                'numEngines',numEngines,...
                       'PSFC',9.86798e-08 ...
);


eng  = addEnginePerformance(eng,atmosphere);

