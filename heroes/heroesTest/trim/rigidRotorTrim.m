function trimState = rigidRotorTrim(muT,ndRigidHe)

CW   = ndRigidHe.CW;
% initialCondition = [-0.01; 0; 0.18; 0; 0.05; 1e-4; -sqrt(CW/2)];
initialCondition = [0; 0; 0; 0; 0; sqrt(CW^3/2); -sqrt(CW/2)];
fZero   = @(trimTrial)trimEqsRigidRotor(trimTrial,muT,ndRigidHe);

[trimState,F,io] = fsolve(fZero,initialCondition,optimset('Display','iter'));
io = 1;

function F = trimEqsRigidRotor(trimState,muT,ndRigidHe)

ThetaA  = trimState(1);
PhiA    = trimState(2);
theta   = trimState(3:5);
CQ      = trimState(6);
lambdai = trimState(7);

TAT = irTAT(ThetaA,PhiA);

muA       = TAT*[muT(1);muT(2);muT(3)];

[CFa,CMa] = getTEPactionCoeffs(lambdai,muA,theta,ndRigidHe);

CH        = CFa(1);
CY        = CFa(2);
CT        = CFa(3);
CMaxA     = CMa(1);
CMayA     = CMa(2);
CMazA     = CMa(3);

CW        = ndRigidHe.CW;

F(1)      = CW*sin(ThetaA) + CH;
F(2)      = CY;
F(3)      = CT - CW*cos(ThetaA);
F(4)      = CMaxA;
F(5)      = CMayA;
F(6)      = CMazA + CQ;
F(7)      = CT + 2*lambdai*sqrt(muA(1)^2 + (lambdai + muA(3))^2);

function [CFa,CMa]   = getTEPactionCoeffs(lambdai,mu,theta,ndRigidHe)

theta0  = theta(1);
theta1C = theta(2);
theta1S = theta(3);


muxA    = mu(1);
muyA    = mu(2);
muzA    = mu(3);

mr      = ndRigidHe.mainRotor;
sigma   = mr.sigma0;
a       = mr.cldata(1);
theta1  = mr.theta1;
cd0     = mr.cddata(1);


lambda  = lambdai + muzA;

% Equation (3.117)
CT     = sigma*a/4*(  theta0*(2/3 + muxA^2)  ...
                    + theta1*(1   + muxA^2) ...
                    + theta1S*muxA ...
                    + lambda);

% Equation (3.118)
CHi    = -sigma*a/4*(muxA*(theta0 + theta1/2) + theta1S/2)*lambda;
CH0    = sigma*cd0*muxA/4;
CH     = CH0 + CHi;

% Equation (3.119)
CYi    = sigma*a*lambda*theta1C/8;
CY0    = 0;
CY     = CYi + CY0;

% Equation (3.120)
CaMxA  = sigma*a/4*(  2*theta0*muxA/3 ...
                    + (1/4 + 3/8*muxA^2)*theta1S ...
                    + lambda/2*muxA ...
                    + theta1*muxA/2);

% Equation (3.121)
CaMyA  = -sigma*a/4*(1/4 + muxA^2/8)*theta1C;

% Equation (3.122)
CaMzAi = sigma*a/4*(2*theta0/3 + muxA*theta1S/2 + lambda + theta1/2)*lambda;
CaMzA0 = -sigma*cd0/8*(1 + muxA^2);
CaMzA  = CaMzAi + CaMzA0;

CFa    = [CH;CY;CT];
CMa    = [CaMxA;CaMyA;CaMzA];