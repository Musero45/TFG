function r = rigidRotor2ndRotor(rotor,atm,H)
%RIGIDROTOR2NDROTOR  Transforms a dimensional rigid rotor into a nondimensional one
%
%   P = RIGIDROTOR2NDROTOR(R,atm,H) computes a nondimensional rigid rotor P
%   from a dimensional rotor R given an atmosphere and a vector of
%   altitudes
%
%
%   The nondimensional rigid rotor is a structure with the following
%   fields:
%       active: 'yes'
%            b: integer
%       sigma0: float
%       sigma1: float
%       cddata: [1x3]
%       cldata: [1x2]
%       theta1: float
%          ead: float
%     epsilonR: float
%           aG: float
%        gamma: float
%        SBeta: float
%         RITB: float
%         RIZB: float
%          XGB: float
%          muP: float
%            k: integer
%           CW: float
%
%  active - active mode  [ {'yes'} | 'no' ]
%     This logical switch sets or unsets the active mode. If active mode 
%     is yes it means that heroes is going to compute actions on this
%     helicopter element.
%
%  b - number of rotor blades [integer]
%
%  sigma0 - constant term of rotor solidity [float]
%
%  sigma1 - linear term of rotor solidity [float]
%
%     Rotor solidity is defined by sigma(x)=sigma0 + sigma1*x where rotor
%     solidity, sigma, is defined by sigma = b*chord/pi/R. The current
%     implementation of heroes considers only linear variation of blade 
%     chord.
% 

g          = atm.g;
density    = atm.density;
rho        = density(H);
dVisco     = atm.dynamicViscosity;
dVis       = dVisco(H);
soundSpeed = atm.soundSpeed;
sS         = soundSpeed(H);

% rotor data
R          = rotor.R;
c0         = rotor.c0;
c1         = rotor.c1;
b          = rotor.b;
e          = rotor.e;
Omega      = rotor.Omega;
IBeta      = rotor.IBeta;
ITheta     = rotor.ITheta;
IZeta      = rotor.IZeta;
kBeta      = rotor.kBeta;
xGB        = rotor.xGB;
bm         = rotor.bm;
a          = rotor.cldata(1);

Re         = rho*Omega*R*R/dVis;
M          = Omega*R/sS;

% Nondimensional variables
sigma0      = c0*b/(pi*R);
sigma1      = c1*b/(pi*R);
ead         = e/R;
epsilonR    = bm*R*xGB/IBeta;
aG          = g/(Omega^2*R);
gamma       = rho*c0*a*R^4/IBeta; %'Till new definition, gamma based on root chord
lambdaBeta2 = 1+(xGB*bm*e)/IBeta+kBeta/(IBeta*Omega^2);
SBeta       = 8/gamma*(lambdaBeta2-1); %'Till new definition, gamma based on root chord
RITB        = ITheta/IBeta;
RIZB        = IZeta/IBeta;
XGB         = xGB/R;
muP         = bm/(rho*pi*R^3);
Kbeta       = kBeta/(rho*pi*R^2*(Omega*R)^2*R);

r     = struct(...
        'active',rotor.active,...
        'b',b,...
        'sigma0',sigma0,...
        'sigma1',sigma1,...
        'cddata',rotor.cddata,...
        'cldata',rotor.cldata,...
        'theta1',rotor.theta1,...
        'ead',ead,...
        'epsilonR',epsilonR,...
        'aG',aG,...
        'Kbeta',Kbeta,...
        'lambdaBeta2',lambdaBeta2,...
        'gamma',gamma,...
        'SBeta',SBeta,...
        'RITB',RITB,...
        'RIZB',RIZB,...
        'XGB',XGB,...
        'muP',muP,...
        'Re',Re,...
        'M',M,...
        'k',rotor.k ...
);

%--------------------------------------------------------------------------
% Non linear rotor data structure
%--------------------------------------------------------------------------
if isfield(rotor,'nlRotor')
psi2D      = rotor.nlRotor.psi2D;
r2D        = rotor.nlRotor.r2D;
c2D        = rotor.nlRotor.c2D;
thetaG2D   = rotor.nlRotor.thetaG2D;
airfoil    = rotor.nlRotor.airfoil;
nr         = length(r2D);
x2D        = cell(nr,1);
cad2D      = cell(nr,1);

for nli = 1:nr;
    x2D{nli}   = r2D{nli}/R;
    cad2D{nli} = c2D{nli}/R;
end

psi2Dall    = rotor.nlRotor.psi2Dall;
x2Dall      = rotor.nlRotor.r2Dall/R;
c2adDall    = rotor.nlRotor.c2Dall/R;
thetaG2Dall = rotor.nlRotor.thetaG2Dall;

nlRotor = struct('psi2D',{psi2D},'x2D',{x2D},'cad2D',{c2D},...
                 'thetaG2D',{thetaG2D},'airfoil',{airfoil},...
                 'psi2Dall',{psi2Dall},'x2Dall',{x2Dall},...
                 'c2adDall',{c2adDall},'thetaG2Dall',{thetaG2Dall});

r.nlRotor  = nlRotor;
end