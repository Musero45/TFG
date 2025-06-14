function eng = T5317BCV(atmosphere,numEngines)
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
               'helicopters',{'B210, Huey II, Bell 205'},...
              'manufacturer',{'Honeywell Engines & Systems'},...
                     'model',{'T5317BCV'},...
                    'weight',249.0264*g,...
                    'lenght',1.209516,...
                     'width',0.622545,...
                    'height',0.622545,...
                      'Snac',3.0119126,...
              'PowerTakeOff',1342.26e3,...
    'PowerMaximumContinuous',1118.55e3,...
                  'OmegaRPM',6230,...
             'powerExponent',0.85,... % FIXME: to be fitted with actual data
                'numEngines',numEngines,...
                      'PSFC',9.61e-08 ...
);


eng  = addEnginePerformance(eng,atmosphere);

