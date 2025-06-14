function [vC,PC]    = vMaxEndurance(he,flightCondition,atm,varargin)
%vMaxEndurance  Computes the velocity of maximum endurance for a
%               level forward flight
%
%   [vE,PE] = vMaxEndurance(HE,FC,ATM) returns the forward speed of a level
%   cruise for maximum endurance, vE, and the required power for this 
%   condition, PE, for a given helicopter, HE, an altitude defined 
%   by the flight condition, FC, and flying into an ISA amosphere ATM.
%
%   [vE,PE] = vMaxEndurance(HE,FC,ATM,OPTIONS) computes as above with 
%   default options replaced by values set in OPTIONS. OPTIONS should
%   be input in the form of sets of property value pairs. Default 
%   OPTIONS is a structure defined by setHeroesEnergyOptions with the 
%   following fields and values:
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
%   Compute the forward speed for maximum endurance of a Super Puma
%   helicopter at 500 m altitude.
%   atm       = getISA;
%   he        = superPuma(atm);
%   fC        = getFlightCondition(he,'H',500);
%   [vB,PB]   = vMaxEndurance(he,fC,atm);
%
%   
%   [For debugging pourposes the velocity for maximum endurance is:
%    vB = 1.286734948818062e+04
%    and the corresponding power is:
%    PB = 1.862007193285404e+06]
%
%   Plot the variation of forward speed for maximum endurance and 
%   the corresponding required power of a SuperPuma helicopter for 
%   altitudes between sea level (SL) and 2000 m. 
%   nh        = 31;
%   hspan     = linspace(0,2000,nh);
%   fCh       = getFlightCondition(he,'H',hspan);
%   [VB,PB]   = vMaxEndurance(he,fCh,atm);
%   figure(1)
%   plot(hspan*1e-3,VB*3.6,'b-o'); hold on
%   xlabel('H [km]'); ylabel('$v_E$ [km/h]')
%   figure(2)
%   plot(hspan*1e-3,PB*1e-6,'b-o'); hold on
%   xlabel('H [km]'); ylabel('$P_E$ [MW]')
%
%
%
%
%   See also setHeroesEnergyOptions, vMaxRange
%
%   TODO



% Setup options
options   = parseOptions(varargin,@setHeroesEnergyOptions);
vGuess    = options.vFzero;

% Dimensions of the output power
H         = flightCondition.H;
n         = numel(H);
s         = size(H);

% Allocate outputs
PC         = zeros(s);
vC         = zeros(s);


% gammaT    = fC.gammaT;
% h         = fC.H;
% Z         = fC.Z;


% nh        = length(h);
% vC        = zeros(size(h));
% PC        = zeros(size(h));
% Optimset for fminbnd
ops            = optimset('TolX',1e-6,'Display','off'); % FIXME
for i=1:n
        % Slice flight condition data
        fC             = getSliceFC(i,flightCondition);

        f2min          = @(V) getPfunctioOfV(V,he,fC,atm,options);
% % % % %     f2min          = @(V) getP(he,V,gammaT,h(i),Z,atm,options);

        [vC(i),PC(i)]  = fminbnd(f2min,0,vGuess,ops);
end




function P = getPfunctioOfV(V,he,fC,atm,options)

% Overwrite flight condition velocity 
fC.V  = V;
P     = getP(he,fC,atm,options);
