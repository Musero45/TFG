function varargout = getFlightEnvelope(he,fc,atmosphere,varargin) 
%getFlightEnvelope Gets the flight envelope of an helicopter
%
%   [V,H] = getFlightEnvelope(gammaT,HE,ATM) computes the flight envelope 
%   of an helicopter HE climbing at . The flight envelope represents the combination 
%   of altitude, H, and forward speed, V, that an helicopter is capable 
%   of flying withing performance limits. This function computes forward
%   ceiling as a function of forward speed and maximum forward speed as a
%   function of altitude.
%   
%   [V,H] = getFlightEnvelope(gammaT,HE,ATM, OPTIONS) computes as above with 
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
%   Plot the flight envelope of the SuperPuma helicopter for level
%   forward flight with gross weight of 73550 N, fuel mass of 1600 kg, 
%   atm   = getISA;
%   he    = superPuma(atm);
%   fc    = getFlightCondition(he,'GW',73550,'Mf',1600);
%   [v,h] = getFlightEnvelope(he,fc,atm);
%   figure(1)
%   plot(v*3.6,h*1e-3); hold on;
%   xlabel('V [km/h]');ylabel('h [km]');
%
%   See also setHeroesEnergyOptions, plotPowerState
%
%   TODO
%


% Setup options
options  = parseOptions(varargin,@setHeroesEnergyOptions);


% Set gammaT = 0
gammaT  = 0; % FIXME
GW      = fc.GW;
Mf      = fc.Mf;
Omega   = fc.Omega;
Z       = fc.Z;

if numel(GW) ~= 1 || ...
   numel(Mf) ~= 1 || ...
   numel(Omega) ~= 1 || ...
   numel(Z) ~= 1 
   error('getFlightEnvelope: input argument size is wrong');
end

% Fix flight condition
fcHover = getFlightCondition(he,...
                             'gammaT',gammaT,...
                             'GW',GW,...
                             'Mf',Mf,...
                             'Z',Z,...
                             'Omega',Omega ...
);

% Compute hover ceiling
hHover  = ceilingHoverEnergy(he,fcHover,atmosphere,options);

% Compute maximum ceiling
[hMax,v_hMax]   =  getEnvelopeHmax(fcHover,he,atmosphere,options);


% Define forward velocity v_next to split branches
% These two commented lines are an attempt to split branches using 
% altitute instead forward velocity. It has been shown that 
% v_next produces best results and this is the approach that we follow
% % % % dh_next    = hMax_env - 10*round(hMax_env/10);
% % % % h_next     = hMax_env - dh_next;
% v_next is the forward velocity at sea level for given power
hsl         = 0;
fC1         = getFlightCondition(he,...
                                 'gammaT',gammaT,...
                                 'GW',GW,...
                                 'Mf',Mf,...
                                 'Omega',Omega,...
                                 'H',hsl,...
                                 'Z',Z);

% vmaxSL is the maximum forward speed at sea level (fC1 is 
% cruise sea level flight condition)
vmaxSL      = vGivenPower(he,fC1,atmosphere,options);

% Compute flight envelope
%--------------------------------------------------------------------------
% First branch
% compute branch from hover ceiling to maximum ceiling
% level (if )
nv       = 31;
vspan    = linspace(0,v_hMax,nv)';
fc1a      = getFlightCondition(he,...
                               'V',vspan,...
                               'gammaT',gammaT.*ones(nv,1), ...
                               'GW',GW.*ones(nv,1),...
                               'Mf',Mf.*ones(nv,1),...
                               'Z',Z.*ones(nv,1),...
                               'Omega',Omega.*ones(nv,1), ...
                               'H',NaN(nv,1) ...
);

options.hFzero = [hHover-100,hMax+100];
ceiling  = ceilingEnergy(he,fc1a,atmosphere,options);


% %==========================================================================
% % DEBUGGING CODE
% % hm    = linspace(0,1.2*hMax_env,31);
% % plotHelicopterEnginePerformance(he,hm);
% V        = linspace(0,1.5*v_next,31);
% fh_m     = 0.9;
% fh_p     = 1.01;
% Phmax    = getP(he,V,gammaT,hMax_env,NaN,atmosphere,options);
% Phmax_m  = getP(he,V,gammaT,fh_m*hMax_env,NaN,atmosphere,options);
% Phmax_p  = getP(he,V,gammaT,fh_p*hMax_env,NaN,atmosphere,options);
% 
% 
% if strcmp(options.constrainedEnginePower,'yes')
%    fPmstr  = strcat('fPa_',options.powerEngineMap);
%    fPm    = he.availablePower.(fPmstr);
% elseif strcmp(options.constrainedEnginePower,'no')
%    fPmstr  = strcat('fP',options.powerEngineMap);
%    fPm    = he.engine.(fPmstr);
% else
%    error('getCeilingEnergy: wrong input option');
% end
% 
% Pm_hmax      = fPm(hMax_env)*ones(1,31);
% Pm_hmax_p    = fPm(fh_p*hMax_env)*ones(1,31);
% Pm_hmax_m    = fPm(fh_m*hMax_env)*ones(1,31);
% 
% figure(3)
% plot(V,Phmax,'r-',V,Phmax_m,'r-.',V,Phmax_p,'r--'); hold on;
% legend({'h_{max}','h    ^-_{max}',' h^+_{max}'},'Location','Best')
% plot(V,Pm_hmax,'k-',V,Pm_hmax_m,'k-.',V,Pm_hmax_p,'k--'); hold on;
% 
% % END OF DEBUGGING CODE
% %==========================================================================




% second branch, we compute forward flight ceiling from v_hMax up to
% v_hMax+ dV
alpha     = 0.5;
nv        = 10;
v2        = (1.0 - alpha)*v_hMax + alpha*vmaxSL;
vspan2    = linspace(v_hMax,v2,nv)';
fc2       = getFlightCondition(he,...
                               'V',vspan2,...
                               'gammaT',gammaT.*ones(nv,1), ...
                               'H',NaN(nv,1),...
                               'Z',Z*ones(nv,1), ...
                               'GW',GW*ones(nv,1),...
                               'Mf',Mf*ones(nv,1),...
                               'Omega',Omega*ones(nv,1) ...
);
options.hFzero = ceiling(end);
ceiling2  = ceilingEnergy(he,fc2,atmosphere,options);
    



% third branch
% compute branch from maximum forward velocity at sea level to
% maximum altitude
% Compute maximum velocity
nh_vmax    = 30;
fHeight    = 0.995;
h_vmax     = linspace(0,ceiling(end)*fHeight,nh_vmax)';

fc3       = getFlightCondition(he,...
                               'gammaT',gammaT.*ones(nh_vmax,1), ...
                               'H',h_vmax,...
                               'Z',Z*ones(nh_vmax,1), ...
                               'GW',GW*ones(nh_vmax,1),...
                               'Mf',Mf*ones(nh_vmax,1),...
                               'Omega',Omega*ones(nh_vmax,1) ...
);
v_max      = vGivenPower(he,fc3,atmosphere,options);





% % % % % Define output with three branches
% % % % v          = [vspan';vspan2';flipud(v_max)];
% % % % h          = [ceiling;ceiling2;flipud(h_vmax')];

% Define output with two branches (avoiding branch 2 and improving 
% logical decission about the switching of the branches)
v          = [vspan;flipud(v_max)];
h          = [ceiling;flipud(h_vmax)];


if nargout == 1
   flightEnvelope = struct(...
   'vh',[v,h],...
   'hover2hmax',[vspan,ceiling],...
   'vmaxSL2hmax',[flipud(v_max),flipud(h_vmax)],...
   'branch2',[vspan2,ceiling2],...
   'vh_hMax',[v_hMax,hMax],...
   'vh_vmaxSL',[vmaxSL,0] ...
                          );
   varargout{1} = flightEnvelope; 
elseif nargout == 2
   varargout{1} = v;
   varargout{2} = h;
else
   error('getFlightEnvelope: wrong number of output arguments')
end
 





function [Hmax,Vmax]  = getEnvelopeHmax(fc,he,atmosphere,varargin)

options   = parseOptions(varargin,@setHeroesEnergyOptions);
Z         = fc.Z;

% System resolution
hGuess = 15000; %FIXME
f2min  = @(h) defineGoal(h,fc,he,atmosphere,options);
ops    = optimset('TolX',1e-6,'Display','off');
Hmax   = fzero(f2min,[0,hGuess],ops);

% set altitude
fc.H   = Hmax;
Vmax   = vMaxEndurance(he,fc,atmosphere);


function goal = defineGoal(h,fc,he,atm,options)

fc.H       = h;
[vC,PC]    = vMaxEndurance(he,fc,atm);
PC_ehe     = PC;
engine     = he.engine;
engineMap  = strcat('fP',options.powerEngineMap);
PC_engine  = engine.(engineMap)(h);
goal       = PC_engine - PC_ehe;






