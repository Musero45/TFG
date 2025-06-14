function [vD,PD]    = vGivenPower(he,fC,atmosphere,varargin)
%vGivenPower     Computes velocity for a given power
%
%   VD = vGivenPower(HE,FC,ATM) gets the velocity, VD, of an energy 
%   helicopter HE for a given powered flight condition FC in an 
%   ISA atmosphere ATM. By default the given power is specified
%   as the maximum continuous power engine map at the corresponding
%   flight condition. 
%
%   VD = ceilingEnergy(HE,FC,ATM,OPTIONS) computes as above with default 
%   options replaced by values set in OPTIONS. OPTIONS should be input 
%   in the form of sets of property value pairs. Default OPTIONS is 
%   a structure defined by setHeroesEnergyOptions with the following 
%   fields and values:
%                        igeModel: @kGoge
%                     excessPower: 'no'
%      forwardFlightApproximation: 'none'
%     fuselageVelocityCalculation: 'none'
%          constrainedEnginePower: 'yes'
%                  powerEngineMap: 'mc'
%                          hGuess: [0 12000]
%                          vGuess: 600
%                    tailrotor2cp: 'eta'
%                 inducedVelocity: @Glauert
%                 externalPLinPLR:'yes'
%
%   There are two ways of input the given power. The first one is to 
%   specify the power engine map to maximum continuous, take-off, or
%   urgency. The other one is to specify an arbitrary value of power by
%   setting up the power field of the flight condition.
%
%   Example of usage
%   atm = getISA;
%   he  = superPuma(atm);
%   fC  = getFlightCondition(he);
%   [vD,PD]  = vGivenPower(he,fC,atm)
%
%   [For debugging purposes the maximum velocity for 
%    given power of PD = 2410000 is vD = 96.982017823761240]
%
%   The maximum velocity  can be also computed for a altitude 
%   vector
%   vspan   = linspace(0,120,31);
%   fCi     = getFlightCondition(he,'V',vspan);
%   ps      = getEpowerState(he,fCi,atm);
%   axds    = getaxds('V','$V$ [m/s]',1);
%   azds    = getaxds({'P'},{'$P$ [W]'},1);
%   axps    = plotPowerState(ps,axds,[],'defaultVars',azds); hold on;
%
%   Now, plot the maximum continuous power at sea level
%   pmcc   = he.availablePower.fPa_mc(0)*ones(1,31);
%   plot(axps{1},vspan,pmcc,'r-')
%
%   and then plot vD and PD in the power horizontal velocity plane
%   plot(axps{1},vD,PD,'r o')
%

% Setup options
options   = parseOptions(varargin,@setHeroesEnergyOptions);

% Get the main variable of the flight condition fC, altitude, H.
H      = fC.H;

% Dimensions of the output power state object
n         = numel(H);
s         = size(H);

% Allocate of output variables
vD = zeros(s);
PD = zeros(s);

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

% To get the maximum velocity our experiments have shown that it is better
% to define an initial guess as high as possible
vmax        = options.vFzero;
v0          = vmax;

for i=1:n
    % Slice flight condition data
    fCi    = getSliceFC(i,fC);

    % Define function handled 
    fixedPower  = @(v) defineGoal(v,he,fCi,atmosphere,Pa(i),options);
    ops = optimset('Display','off');

    % Get solution
    vD(i)       = fzero(fixedPower,v0,ops);

    % Get power for corresponding V given power
    % Set flight condition velocity
    fCi.V       = vD(i);

    % Get power state
    EnStD   = getEpowerState(he,fCi,atmosphere,options);

    % Extract values for output 
    PD(i) = EnStD.P;

    % velocity guess for next iteration
    v0    = vD(i);
end



function f = defineGoal(V,he,fC,atmosphere,Pa,options)

nv = length(V);
f  = zeros(length(V),1);

for i=1:nv
    fC.V   = V(i);
    ePs    = getEpowerState(he,fC,atmosphere,options);
    f(i,1) = Pa - ePs.P;
end
