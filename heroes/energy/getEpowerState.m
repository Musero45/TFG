function EPowerState  = getEpowerState(he,flightCondition,atmosphere,varargin)
%getEpowerState Gets the dimensional energy power state of an helicopter
%
%   P = getEpowerState(HE,FC,ATM) gets a dimensional power state, P, for a
%   given dimensional energy helicopter, HE, and a given dimensional flight 
%   condition FC using an ISA atmosphere ATM. The dimensional power state P 
%   is a structure with the following fields:
%      class: 'PowerState'
%          V: [1xnv double]
%         Vh: [1xnv double]
%         Vv: [1xnv double]
%     gammaT: [1xnv double]
%          Z: [1xnv double]
%         vi: [1xnv double]
%         Pi: [1xnv double]
%         Pf: [1xnv double]
%       Pcd0: [1xnv double]
%         Pg: [1xnv double]
%        Pmr: [1xnv double]
%        Ptr: [1xnv double]
%       Prmr: [1xnv double]
%       Prtr: [1xnv double]
%          P: [1xnv double]
%
%   where nv is the number of flight conditions which is defined by the 
%   number of elements of each field of the flight condition.
%
%   E = getEpowerState(ndHE,ndFC,OPTIONS) computes as above with default options 
%   replaced by values set in OPTIONS. OPTIONS should be input in the form 
%   of sets of property value pairs. Default OPTIONS is a structure with 
%   the following fields and values:
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
%
%   Examples of usage: 
%   Compute the required power in watts of a Super Puma helicopter
%   at sea level with a forward speed of 200 km/h and for level flight,
%   that is, climb angle is gammaT = 0 degrees.
%   a     = getISA;
%   he    = superPuma(a);
%   v     = 200/3.6;
%   fc    = getFlightCondition(he,'V',v);
%   P     = getEpowerState(he,fc,a);
%
%   The required power P is:
%   P.P
% 
%   ans =
% 
%   1.059898430483660e+06
% 
%   Compute the required power in watts of a Super Puma helicopter
%   at sea level with a horizontal forward speed between 50 km/h upto 
%   200 km/h and climb angle equal to zero (level cruise flight condition)
%   and plot the corresponding energy power state
%   vspan = linspace(50,200,31)/3.6;
%   fc    = getFlightCondition(he,'V',vspan);
%   P     = getEpowerState(he,fc,a);
%   axds    = getaxds('V','$V$ [-]',1);
%   plotPowerState(P,axds,[]);
%
%   See also setHeroesEnergyOptions, plotPowerState
%
%
%   TODO
%   * move function name from getEpowerState to getPowerState
%

options    = parseOptions(varargin,@setHeroesEnergyOptions);

% Atmosphere elements
H          = flightCondition.H;

% Non dimensional Helicopter and flight condition
ndFcener   = fc2ndFC(flightCondition,he,atmosphere);
ndHeener   = he2ndHe(he);

% Get non dimensional power state
if isnan(flightCondition.P)
   % Powered mode
   ndEPowerState = getNdEpowerState(ndHeener,ndFcener,options);
else
   % Autorotation mode
   ndEPowerState = getNdApowerState(ndHeener,ndFcener,options);
end

% Transform to the dimensional power state
tailrotorOpt  = options.tailrotor2cp;
EPowerState   = ndEpowerState2dim(ndEPowerState,he,H,tailrotorOpt);


