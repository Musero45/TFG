function [Vautorrot,Pautorrot] = MYgammaT2Vautorrotation(he,fC,...
                                                       atmosphere,varargin)

% Setup options
options   = parseOptions(varargin,@setHeroesEnergyOptions);

% Get the main variable of the flight condition fC, altitude, H.
H         = fC.H;

% Dimensions of the output power state object
n         = numel(H);
s         = size(H);

% Allocate of output variables
Vautorrot = zeros(s);
Pautorrot = zeros(s);

% Set constrained or unconstrained engine map due to transmission power
% limitation
if strcmp(options.constrainedEnginePower,'yes')
   fPmstr  = strcat('fPa_',options.powerEngineMap);
   fPm    = he.availablePower.(fPmstr);
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
   error('vGivenPower: wrong input option');
end


v0  = 0;

for i=1:n
    % Slice flight condition data
    fCi    = getSliceFC(i,fC);

    % Define function handled 
    fixedPower  = @(v) defineGoal(v,he,fCi,atmosphere,Pa(i),options);
    ops = optimset('Display','off');

    % Get solution
    Vautorrot(i)       = fzero(fixedPower,v0,ops);

    % Get power for corresponding V given power
    % Set flight condition velocity
    fCi.V       = Vautorrot(i);

    % Get power state
    EnStD   = getEpowerState(he,fCi,atmosphere,options);

    % Extract values for output 
    Pautorrot(i) = EnStD.P;

    % velocity guess for next iteration
    v0    = Vautorrot(i);
end

end


function f = defineGoal(V,he,fC,atmosphere,Pa,options)

nv = length(V);
f  = zeros(length(V),1);

for i=1:nv
    fC.V   = V(i);
    ePs    = getEpowerState(he,fC,atmosphere,options);
    f(i,1) = Pa - ePs.P;
end

end


