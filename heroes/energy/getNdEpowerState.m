function ndPowerState  = getNdEpowerState(ndHEener,ndFCener,varargin)
%getNdEpowerState Gets the nondimensional power state of an helicopter
%
%   E = getNdEpowerState(ndHE,ndFC) gets a nondimensional power state for a given
%   nondimensional energy helicopter, ndHE, and a given nondimensional
%   flight condition ndFC. The nondimensiona power state E is a structure 
%   with the following fields:
%           class: 'ndEnergyState'
%         lambdaI: [1xnv double]
%              mu: [1xnv double]
%            Z_nd: [1xnv double]
%          gammaT: [1xnv double]
%             CPi: [1xnv double]
%             CPf: [1xnv double]
%           CPcd0: [1xnv double]
%             CPg: [1xnv double]
%           CPrmr: [1xnv double]
%           CPrtr: [1xnv double]
%            CPmr: [1xnv double]
%            CPtr: [1xnv double]
%              CP: [1xnv double]
%
%   where nv is the number of flight conditions which is defined by the 
%   number of elements of each field of the flight condition.
%
%   E = getNdEpowerState(ndHE,ndFC,OPTIONS) computes as above with default options 
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
%   Examples of usage: 
%   Generate a nondimensional power state by first creating a 
%   nondimensional helicopter at sea level and a nondimensional 
%   flight condition corresponding a level, gammaT=0, cruise of 200 km/h. 
%   Then, create a nondimensional power state corresponding 
%   to a horizontal forward flight of 200 km/h, that is
%   a       = getISA;
%   he      = superPuma(a);
%   ndhe    = he2ndHe(he,a.rho0,he.mainRotor.Omega,he.weights.MTOW);
%   v       = 200/3.6;
%   fc      = getFlightCondition(he,'V',v,'H',0);
%   ndfc    = fc2ndFC(fc,he,a);
%   ndpe    = getNdEpowerState(ndhe,ndfc);
%
%   The required power coefficient CP is:
%   p.CP
% 
%   ans =
% 
%   3.931518270796777e-04
%
%   Plot the power coefficient variation with level nondimensional 
%   forward velocity from 50 km/h upto 250 km/h, at sea level
%   nv      = 31;
%   vspan   = linspace(50,250,nv)./3.6;
%   H       = zeros(1,nv);
%   fcv     = getFlightCondition(he,'V',vspan,'H',H);
%   ndfcv   = fc2ndFC(fcv,he,a);
%   ndpsv   = getNdEpowerState(ndhe,ndfcv);
%   plot(vspan,ndpsv.CP); hold on;
%   xlabel('V/(\Omega R) [-]');ylabel('C_P [-]');
%
%   However, there exists the function plotNdPowerState that plots power
%   state objects and by default plots as follows
%   plotNdPowerState(ndpsv);
% 
%   Plot nondimensional power state variation with forward speed and 
%   altitude. Consider an interval of forward speed between 50 and 180 km/h,
%   altitude between sea level and 2000 m.
%   nv       = 21;
%   vspan    = linspace(50,250,nv)./3.6;
%   nh       = 11;
%   hspan    = linspace(0,2000,nh);  
%   [V,H]    = ndgrid(vspan,hspan);
%   fchv     = getFlightCondition(he,'V',V,'H',H);
%   ndfchv   = fc2ndFC(fchv,he,a);
%   ndpshv   = getNdEpowerState(ndhe,ndfchv);
%   VOR      = ndfchv.VOR;
%   CW       = ndfchv.CW;
%   figure(2)
%   [D,g] = contour(VOR*3.6,CW,ndpshv.CP);
%   set(g,'ShowText','on');
%   set(g,'LevelList',linspace(3e-4,5e-4,11));
%   colormap cool
%   title('C_P [-]')
%   xlabel('V/(\Omega R) [-]');ylabel('C_W [-]')
%
%   As above plotNdPowerState can be also used to plot 3d power state
%   plotNdPowerState(ndpshv);
%
%   See also setHeroesEnergyOptions, plotNdPowerState
%
%   TODO
%


% Setup options
options = parseOptions(varargin,@setHeroesEnergyOptions);

if iscell(ndHEener)
    % Dimensions of the output ndHe
    n            = numel(ndHEener);
    s            = size(ndHEener);
    ndPowerState = cell(s);

    % Loop using linear indexing
    for i = 1:n
        ndPowerState{i}    = getEpowerState_i(ndHEener{i},ndFCener{i},options);
    end

else
    ndPowerState    = getEpowerState_i(ndHEener,ndFCener,options);
end



function ndPowerState = getEpowerState_i(ndHEener,ndFCener,varargin)

% Set helicopter variables
sigma   = ndHEener.mainRotor.sigma;
Cd0     = ndHEener.mainRotor.cd0;
kappa   = ndHEener.mainRotor.kappa;
K       = ndHEener.mainRotor.K;
fS      = ndHEener.fuselage.fS;
etaRA   = ndHEener.tailRotor.eta;
etaTrp  = ndHEener.transmission.etaTrp;
etaTra  = ndHEener.transmission.etaTra;

% Set flight condition variables
VOR     = ndFCener.VOR;
gammaT  = ndFCener.gammaT;
Z_nd    = ndFCener.Z_nd;
CW      = ndFCener.CW;
mu      = ndFCener.VOR;

% Setup options
options = parseOptions(varargin,@setHeroesEnergyOptions);

% Dimensions of the output power state object
n         = numel(VOR);
s         = size(VOR);

% Get ground effect parameter kG by evaluation of function handle @igeModel
kG       = options.igeModel(Z_nd,mu);


% Allocation of output variables
CPi      = zeros(s);
CPf      = zeros(s);
CPcd0    = zeros(s);
CPg      = zeros(s);
CPmr     = zeros(s);
CPtr     = zeros(s);
CP       = zeros(s);
CPrmr    = zeros(s);
CPrtr    = zeros(s);
lambdaI  = zeros(s);

% System resolution
x0         = [sqrt(CW(1)^3/2); -sqrt(CW(1)/2)];% Fix me

for i = 1:n
    system     = @(x) energyEquations (CW(i),VOR(i),gammaT(i),x(2),...
                                   kappa,fS,sigma,Cd0,K,x(1),kG(i),options);
    opt        = optimset('Display','off');
    x          = fsolve(system,x0,opt);                         
    CPmr(i)    = x(1);
    lambdaI(i) = x(2);


    % Energy terms calculation
    CPt       = energyTermsCalculation(CW(i),VOR(i),gammaT(i),lambdaI(i),...
                                       kappa,fS,sigma,Cd0,K,kG(i));
    CPi(i)    = CPt(1);
    CPf(i)    = CPt(2);
    CPcd0(i)  = CPt(3);
    CPg(i)    = CPt(4);
    CPtr(i)   = etaRA*CPmr(i);

    CPrmr(i)  = CPmr(i)/(1-etaTrp);
    CPrtr(i)  = CPtr(i)/(1-etaTra);
    CP(i)     = CPrmr(i) + CPrtr(i);
    x0        = x;
end



% Define output nondimensional power state 
ndPowerState = struct(...
                'class','ndPowerState', ...
                'VOR',VOR,...
                'gammaT',gammaT,...
                'VhOR',ndFCener.VhOR,...
                'VvOR',ndFCener.VvOR,...
                'sigmaISA',ndFCener.sigmaISA,...
                'deltaISA',ndFCener.deltaISA,...
                'thetaISA',ndFCener.thetaISA,...
                'CW',CW,...
                'omega',ndFCener.omega,...
                'lambdaI',lambdaI,...
                'Z_nd',Z_nd,...
                'CPi',CPi,...
                'CPf',CPf,...
                'CPcd0',CPcd0,...
                'CPg',CPg,...
                'CPrmr',CPrmr,...
                'CPrtr',CPrtr,...
                'CPmr',CPmr,...
                'CPtr',CPtr,...
                'CP',CP...
);
