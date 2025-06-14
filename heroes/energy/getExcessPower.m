function DP = getExcessPower(he,fc,atm,varargin)
%getExcessPower Gets the flight envelope of an helicopter
%
%   DP = getExcessPower(HE,FC,ATM) computes the excess power,
%   DP defined as the difference between the available and required power,
%   for a given energy helicopter HE, flight condition FC, defined by the
%   forward speed, V, gammaT, altitude H, height above ground, Z, into an
%   ISA atmosphere, ATM.
%   
%   DP = getExcessPower(HE,FC,ATM,OPTIONS) computes as above with 
%   default options replaced by values set in OPTIONS. OPTIONS should 
%   be input in the form of sets of property value pairs. Default OPTIONS 
%   is a structure with the following fields and values:
% 
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
%   Examples of usage: 
%   Compute the excess power of the SuperPuma for a level flight,
%   gammaT = 0, for forward speeds between 0 and 360 km/h and altitudes
%   between 0 and 1000 m. Plot the excess power as a contour plot of
%   iso-excess-of-power.
%
%   atm    = getISA;
%   he     = superPuma(atm);
%   nh     = 21;
%   h      = linspace(0,10000,nh);
%   nv     = 31;
%   v      = linspace(0,100,nv);
%   [V,H]  = ndgrid(v,h);
%   GW     = 73550*ones(nv,nh);
%   FM     = 1600*ones(nv,nh);
%   OmegaN = he.mainRotor.Omega*ones(nv,nh);
%   fc     = getFlightCondition(he,'V',V,'H',H);
%   P      = getExcessPower(he,fc,atm);
%   figure(1); hold on;
%   [D,g] = contour(V,H,P);
%   set(g,'ShowText','on');
%   set(g,'LevelList',linspace(-1800000,1800000,11));
%   colormap cool
%
%   See also setHeroesEnergyOptions, plotNdPowerState, 
%   plotHelicopterEnginePerformance, getP 
%
%   TODO
%

options   = parseOptions(varargin,@setHeroesEnergyOptions);

% Assign flight conditions variables
% V            = fc.V;
% gammaT       = fc.gammaT;

% Z            = fc.Z;

% Compute the required power (aerodynamic side)
reqPower     = getP(he,fc,atm,options);



% Select the corresponding engine power map according to options
if strcmp(options.constrainedEnginePower,'yes')
   fPmstr  = strcat('fPa_',options.powerEngineMap);
   fPm    = he.availablePower.(fPmstr);
elseif strcmp(options.constrainedEnginePower,'no')
   fPmstr  = strcat('fP',options.powerEngineMap);
   fPm    = he.engine.(fPmstr);
else
   error('getExcessPower: wrong input option');
end

% Compute the available power (engine side)
h            = fc.H;
avaPower     = fPm(h);

% and because currently engine power does not depend on forward speed we
% can repeat the available power for the different forward speeds
% % % % % % nv           = length(V);
% % % % % % avaPower     = repmat(avaPower(:),1,nv);

% Just define excess power as available power minus required power
% This definition states that DP > 0 when the flight is possible and the
% other way around
DP           = avaPower - reqPower;
