function [gammaTauto, Pauto] = gammaTgivenPower(he,fC,atmosphere,varargin)

options   = parseOptions(varargin,@setHeroesEnergyOptions);

% Get the main variable of the flight condition fC, altitude, H.
H      = fC.H;

% Dimensions of the output power state object
n      = numel(H);
s      = size(H);

% Allocate of output variables
gammaTauto = zeros(s);
Pauto      = zeros(s);

% Set constrained or unconstrained engine map due to transmission power
% limitation
if strcmp(options.constrainedEnginePower,'yes')
   fPmstr  = strcat('fPa_',options.powerEngineMap);
   fPm     = he.availablePower.(fPmstr);
   % Get available power
   Pa     = fPm(H);
   
elseif strcmp(options.constrainedEnginePower,'no')
   fPmstr  = strcat('fP',options.powerEngineMap);
   fPm    = he.engine.(fPmstr);
   % Get available power
   Pa     = fPm(H);
   
elseif strcmp(options.constrainedEnginePower,'flightCondition')
   Pa     = fC.P;
   % override flight condition to avoid autorrotation evaluation
   fC.P   = NaN(s);
   
else
   error('gammaTgivenPower: wrong input option');
   
end


gammaT0 = 0;


for i=1:n
    % Slice flight condition data
    fCi    = getSliceFC(i,fC);

    % Define function handled 
    fixedPower  = @(gammaT) defineGoal(gammaT,he,fCi,atmosphere,Pa(i),options);
    ops = optimset('Display','off');

    % Get solution
    gammaTauto(i)       = fzero(fixedPower,gammaT0,ops);

    % Get power for corresponding V given power
    % Set flight condition velocity
    fCi.gammaT       = gammaTauto(i);

    % Get power state
    EnStD   = getEpowerState(he,fCi,atmosphere,options);

    % Extract values for output 
    Pauto(i) = EnStD.P;

    % gammaT guess for next iteration
    gammaT0    = gammaTauto(i);
end



function f = defineGoal(gammaT,he,fC,atmosphere,Pa,options)

ngammaT = length(gammaT);
f  = zeros(length(gammaT),1);

for i=1:ngammaT
    fC.gammaT   = gammaT(i);
    ePs    = getEpowerState(he,fC,atmosphere,options);
    f(i,1) = Pa - ePs.P;
end
