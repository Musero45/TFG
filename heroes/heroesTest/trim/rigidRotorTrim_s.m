function trimState = rigidRotorTrim_s(muT,ndRigidRotor)

CW    = ndRigidRotor.CW;
sigma = ndRigidRotor.sigma0;
cd0   = ndRigidRotor.cddata(1);

CQ_0 = sqrt(CW^3/2) + sigma*cd0/8*(1+3*muT(1)^2);
initialCondition = [0; 0; 0; CQ_0; -sqrt(CW/2)];

fZero     = @(trimTrial)trimEqsRigidRotor(trimTrial,muT,ndRigidRotor);
trimState = fsolve(fZero,initialCondition);

function F = trimEqsRigidRotor(trimState,muT,ndRigidRotor)

ThetaA  = trimState(1);
theta   = trimState(2:3);
CQ      = trimState(4);
lambdai = trimState(5);

TAT = [-cos(ThetaA)  sin(ThetaA);...
       -sin(ThetaA) -cos(ThetaA)];

muA       = TAT*[muT(1);muT(2)];

[CFa,CMa] = getTEPactionCoeffs(lambdai,muA,theta,ndRigidRotor);

CH        = CFa(1);
CT        = CFa(2);
CMaxA     = CMa(1);
CMazA     = CMa(2);

CW        = ndRigidRotor.CW;


F(1)      = CW*sin(ThetaA) + CH;
F(2)      = CT - CW*cos(ThetaA);
F(3)      = CMaxA;
F(4)      = CMazA + CQ;
F(5)      = CT + 2*lambdai*sqrt(muA(1)^2 + (lambdai + muA(2))^2);


function [CFa,CMa]   = getTEPactionCoeffs(lambdai,mu,theta,ndRigidRotor)

theta0  = theta(1);
theta1S = theta(2);


muxA    = mu(1);
muzA    = mu(2);

sigma   = ndRigidRotor.sigma0;
a       = ndRigidRotor.cldata(1);
theta1  = ndRigidRotor.theta1;
cd0     = ndRigidRotor.cddata(1);


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

% Equation (3.120)
CaMxA  = sigma*a/4*(  2*theta0*muxA/3 ...
                    + (1/4 + 3/8*muxA^2)*theta1S ...
                    + lambda/2*muxA ...
                    + theta1*muxA/2);

% Equation (3.122)
CaMzAi = sigma*a/4*(2*theta0/3 + muxA*theta1S/2 + lambda + theta1/2)*lambda;
CaMzA0 = -sigma*cd0/8*(1 + muxA^2);
CaMzA  = CaMzAi + CaMzA0;


CFa    = [CH;CT];
CMa    = [CaMxA;CaMzA];
