function eng = RR250C20R(atmosphere,numEngines)
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
               'helicopters',{'Agusta A1 09C (2),Bell 206B,JetRanger III (1),HeliLynx 355FX (2),Starflex 355F2 (2),Kamov Ka-226 (2),MD Helicopters MD500E (1),MD Helicopters MD520N (1),PZLSW-4 (1),Tridair Gemini ST (2)'},...
              'manufacturer',{'Rolls Royce'},...
                     'model',{'250-C20R'},...
                    'weight',78.4728*g,...
                    'lenght',0.98552,...
                     'width',0.52832,...
                    'height',0.58928,...
                      'Snac',2.202834304,...
              'PowerTakeOff',335.565e3,...
    'PowerMaximumContinuous',335.565e3,...
                  'OmegaRPM',6016,...
             'powerExponent',0.85,... % FIXME: to be fitted with actual data
                'numEngines',numEngines,...
                      'PSFC',1.02735111111111e-7 ...
);
eng  = addEnginePerformance(eng,atmosphere);