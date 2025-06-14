function ndEnergyState  = getNdApowerState(ndHEener,ndFCener,varargin)
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
%                               Z: NaN
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
%   1. Generate a nondimensional power state by first creating a 
%   nondimensional helicopter at sea level and a nondimensional 
%   flight condition corresponding a leveled, gammaT=0, cruise of 200 km/h. 
%   Then, create a nondimensional power state corresponding 
%   to a horizontal forward flight of 200 km/h, that is
%   a     = getISA;
%   he    = superPuma(a);
%   b     = he2ndHe(he);
%   v     = 200/3.6;
%   fc    = getLevelFC(v,0);
%   c     = fc2ndFC(fc,he,a);
%   p     = getNdEpowerState(b,c);
%
%   The required power coefficient CP is:
%   p.CP
% 
%   ans =
% 
%   3.707409370422951e-04
%
%   2. Plot a nondimensional power state by first creating a 
%   nondimensional helicopter at sea level and a nondimensional 
%   flight condition corresponding a leveled, gammaT=0, cruise from 50 km/h
%   upto 200 km/h, that is
%   a     = getISA;
%   he    = superPuma(a);
%   b     = he2ndHe(he);
%   vspan = linspace(50,200,31)./3.6;
%   fc    = getLevelFC(vspan,zeros(1,31));
%   c     = fc2ndFC(fc,he,a);
%   p     = getNdEpowerState(b,c);
%   plotNdPowerState(p,'SuperPuma')
%
%   See also setHeroesEnergyOptions, plotNdPowerState
%
%   TODO
%





% Set helicopter variables
sigma   = ndHEener.mainRotor.sigma;
Cd0     = ndHEener.mainRotor.cd0;
kappa   = ndHEener.mainRotor.kappa;
K       = ndHEener.mainRotor.K;
fS      = ndHEener.fuselage.fS;
etaRA   = ndHEener.tailRotor.eta;
etaTrp  = ndHEener.transmission.etaTrp;
etaTra  = ndHEener.transmission.etaTra;
etaM    = ndHEener.transmission.etaM;

% Set flight condition variables
VHOR    = ndFCener.VhOR;
CW      = ndFCener.CW;
Z_nd    = ndFCener.Z_nd;

% Setup options
options = parseOptions(varargin,@setHeroesEnergyOptions);

% options.inducedVelocity = @Cuerva;

% Dimensions of the output power state object
n         = numel(VHOR);
s         = size(VHOR);

% Get ground effect parameter kG by evaluation of function handle @igeModel
kG       = options.igeModel(Z_nd,VHOR);

% Autorotation initial guess (axial flight assumption)
% We are going to test if this initial condition is robust enough to
% compute the solution for a wide range of horizontal speeds.
CQAT      = ndFCener.CP;
% VORAT_0   = 2*sqrt(CW./2);
% gammaAT_0 = -pi/2;
% gammaAT_0 =-0.208170306575086;
% Power coefficient of main rotor objective
CPmr     = CQAT./etaM;
CPtr     = CPmr*etaRA;

% Allocation of output variables
CPi      = zeros(s);
CPf      = zeros(s);
CPcd0    = zeros(s);
CPg      = zeros(s);
CP       = zeros(s);
CPrmr    = zeros(s);
CPrtr    = zeros(s);
lambdaI  = zeros(s);
gammaT   = zeros(s);
VOR      = zeros(s);
VVOR     = zeros(s);

% Compute power coefficient for hover
CQ0      = etaM.*(kappa.*kG.*sqrt(CW.^3./2) + sigma*Cd0/8);
% sgnCQ    = sign(CQAT - CQ0);

% System resolution
opt         = optimset('Display','off');

for i = 1:n
    system      = @(x) autorotationEquations (VHOR(i),CW(i),...
                                              x(1),x(2),...
                                              kappa,fS,sigma,...
                                              Cd0,K,CPmr(i),...
                                              kG(i),options);

    x0          = [(CQAT(i) - CQ0(i))/CW(i); -sqrt(CW(i)/2)];% Fixme
    x           = fsolve(system,x0,opt);                         
    VVOR(i)     = x(1);
    lambdaI(i)  = x(2);

    gammaT(i)   = atan(VVOR(i)/VHOR(i));
    VOR(i)      = (VVOR(i).^2 + VHOR(i).^2).^(1/2);


    % Energy terms calculation
    CPt       = energyTermsCalculation(CW(i),VOR(i),gammaT(i),lambdaI(i),...
                                       kappa,fS,sigma,Cd0,K,kG(i));
    CPi(i)    = CPt(1);
    CPf(i)    = CPt(2);
    CPcd0(i)  = CPt(3);
    CPg(i)    = CPt(4);

    CPrmr(i)  = CPmr(i)/(1-etaTrp);
    CPrtr(i)  = CPtr(i)/(1-etaTra);
    CP(i)     = CPrmr(i) + CPrtr(i);
end


ndEnergyState = struct(...
                'class','ndPowerState', ...
                'VOR',VOR,...
                'gammaT',gammaT,...
                'VhOR',VHOR,...
                'VvOR',VVOR,...
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


function F = autorotationEquations (VHOR,CW,VVOR,lambdaI,kappa,...
                                    fS,sigma,Cd0,K,CP,kG,options)
F      = zeros(2,1);

% f2     = energyEquations (CW,VOR,gammaT,lambdaI,kappa,fS,sigma,...
%                           Cd0,K,CQ,kG,options);
% 
% F(1,1) = f2(1);
% F(2,1) = f2(2);

gammaT      = atan(VVOR/VHOR);
VOR         = (VVOR.^2 + VHOR.^2).^(1/2);
% Get induced velocity model
indVelModel = options.inducedVelocity;

% Pass Vor and gammaT to mu terms
[mux,muWx,muy,muWy,muzp]  = VORgammaT2mu(VOR,gammaT);

% First equation: induced velocity
F(1,1) = indVelModel(lambdaI,CW,mux,muWx,muy,muWy,muzp);

% second equation: power terms for main rotor
CPi        = - lambdaI.*CW.*kappa*kG;
CPf        =   fS/2*(VOR).^3;
CPcd0      =   sigma*Cd0/8*(1+K*(VOR*cos(gammaT)).^2);
CPg        =   VOR*sin(gammaT)*CW;

F(2,1)     = CPi + CPf + CPcd0 + CPg - CP;

