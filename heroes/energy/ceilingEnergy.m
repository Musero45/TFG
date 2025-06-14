function ceiling  = ceilingEnergy(he,fc,atmosphere,varargin)
%ceilingHoverEnergy  Computes ceiling at hovering
%
%   C = ceilingEnergy(HE,FC,ATM) gets the ceiling, C, of an energy 
%   helicopter HE for a given flight condition FC in an ISA atmosphere 
%   ATM. By default the engine map which is selected to obtain the 
%   ceiling is the maximum continuous 'mc' map.
%
%   C = ceilingEnergy(HE,FC,ATM,OPTIONS) computes as above with default 
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
%   Example of usage
%   Compute the ceiling of SuperPuma helicopter for a leveled forward 
%   flight, gammaT=0, and for forward speeds between 100 km/h upto 250 km/h
%   a  = getISA;
%   he = superPuma(a);
%   nv = 21;
%   V  = linspace(100,250,nv)/3.6;
%   fc = getFlightCondition(he,'V',V,'gammaT',zeros(1,nv));
%   c  = ceilingEnergy(he,fc,a);
%   plot(V*3.6,c/1000); hold on;
%   xlabel('V [km/h]'); ylabel('Ceiling [km]');
%
%   See also setHeroesEnergyOptions, ceilingHoverEnergy
%
%   TODO

options   = parseOptions(varargin,setHeroesEnergyOptions);

% Dimensions of the output power state object
n         = numel(fc.V);
s         = size(fc.V);

% Allocation of output variables
ceiling     = zeros(s);

% The first guess was an interval covering the whole troposphere but we are
% also trying to improve robustness by using only one initial guess
% initialHguess = [0,12000];
% initialHguess = 5000;
initialHguess = options.hFzero;

for j=1:n
    fc_i          = getSliceFC(j,fc);
    fCeiling      = @(H) getCeilingEnergy(H,he,fc_i,atmosphere,options);
    ceiling(j)    = fzero(fCeiling,initialHguess);
    initialHguess = ceiling(j);
end


function f = getCeilingEnergy(H,he,flightCondition,atmosphere,options)

f  = zeros(length(H),1);

if strcmp(options.constrainedEnginePower,'yes')
   fPmstr  = strcat('fPa_',options.powerEngineMap);
   fPm    = he.availablePower.(fPmstr);
elseif strcmp(options.constrainedEnginePower,'no')
   fPmstr  = strcat('fP',options.powerEngineMap);
   fPm    = he.engine.(fPmstr);
else
   error('getCeilingEnergy: wrong input option');
end

availablePower = fPm;

for i=1:length(H)
    % Override flight condition altitude
    flightCondition.H = H(i);
    ePowerState     = getEpowerState(he,flightCondition,atmosphere,options);

    % Available power
    Pa    = availablePower(H(i));
    % equation
    f(i,1) = Pa - ePowerState.P;
end




