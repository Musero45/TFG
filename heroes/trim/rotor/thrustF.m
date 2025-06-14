function [CFai, CFa0, CFi, CFg] = thrustF(beta,theta,lambda,flightCondition,muW,GA,ndRotor)

% FIXME To be documented and tested.
% FIXME To be documented and tested.
% Big bug detected and solved by ALVARO: 2015/01: Inertial forces contained
% muW vector components. Now these components have been removed from
% the inertial force coeffients expressions.

beta0  = beta(1);
beta1C = beta(2);
beta1S = beta(3);

theta0  = theta(1);
theta1C = theta(2);
theta1S = theta(3);

lambda0  = lambda(1);
lambda1C = lambda(2);
lambda1S = lambda(3);

muxA = flightCondition(1);
muyA = flightCondition(2);
muzA = flightCondition(3);

omegaAdxA = flightCondition(4);
omegaAdyA = flightCondition(5);
omegaAdzA = flightCondition(6);

muWxA = muW(1);
muWyA = muW(2);
muWzA = muW(3);

rotor = ndRotor;

GxA = GA(1);
GyA = GA(2);
GzA = GA(3);

b      = rotor.b;
sigma0 = rotor.sigma0;
sigma1 = rotor.sigma1;
a      = rotor.cldata(1);
theta1 = rotor.theta1;
ead    = rotor.ead;
aG     = rotor.aG;
muP    = rotor.muP;

%Aerodynamic forces
CT0  = ((1/4*muzA+1/4*muWzA+1/4*lambda0+1/4*theta1S*muxA+1/4*theta1S*muWxA-1/8*omegaAdxA*muxA+1/8*lambda1S*muWxA+1/8*lambda1S*muxA-1/8*omegaAdxA*muWxA+1/8*theta1*muWxA^2+1/8*theta1*muxA^2+1/8*theta1*muWyA^2+1/6*theta0+1/8*theta1+1/2*theta0*muxA*muWxA+1/4*theta1S*omegaAdzA*muxA+1/4*theta1S*omegaAdzA*muWxA+1/3*theta0*omegaAdzA+1/4*lambda0*omegaAdzA-1/8*muyA*omegaAdyA+1/4*theta1*omegaAdzA+1/4*muzA*omegaAdzA-1/4*theta1C*muyA-1/4*muWyA*theta1C-1/8*lambda1C*muyA+1/4*muWzA*omegaAdzA-1/8*muWyA*lambda1C-1/8*muWyA*omegaAdyA-1/8*beta1C*omegaAdzA*muxA-1/8*beta1C*omegaAdzA*muWxA+1/4*theta1*muxA*muWxA-1/4*ead*muWyA*beta1S-1/4*ead*beta1C*muWxA-1/4*ead*beta1C*muxA-1/4*ead*theta0*muWxA^2-1/4*ead*theta0*muWyA^2-1/4*ead*theta0*muxA^2-1/4*ead*beta1S*muyA+1/4*theta0*muWyA^2+1/4*theta0*muxA^2+1/4*theta0*muWxA^2-1/8*muWzA*beta1C*omegaAdxA-1/8*muWzA*beta1S*omegaAdyA+1/2*muWyA*theta0*muyA+1/8*muWzA*beta1S*lambda1C-1/8*muWzA*beta1C*lambda1S-1/8*muWyA*beta1S*omegaAdzA-1/4*muWyA*theta1C*omegaAdzA+1/4*muWyA*theta1*muyA+1/4*ead*muWzA*beta1S*omegaAdyA+1/4*ead*muWzA*beta1C*omegaAdxA-1/2*ead*muWyA*theta0*muyA-1/2*ead*theta0*muxA*muWxA)*sigma0+(1/6*muzA+1/6*muWzA+1/6*lambda0+1/6*theta1S*muxA+1/6*theta1S*muWxA-1/12*omegaAdxA*muxA+1/12*lambda1S*muWxA+1/12*lambda1S*muxA-1/12*omegaAdxA*muWxA+1/12*theta1*muWxA^2+1/12*theta1*muxA^2+1/12*theta1*muWyA^2+1/8*theta0+1/10*theta1+1/4*theta0*muxA*muWxA+1/6*theta1S*omegaAdzA*muxA+1/6*theta1S*omegaAdzA*muWxA+1/4*theta0*omegaAdzA+1/6*lambda0*omegaAdzA-1/12*muyA*omegaAdyA+1/5*theta1*omegaAdzA+1/6*muzA*omegaAdzA-1/6*theta1C*muyA-1/6*muWyA*theta1C-1/12*lambda1C*muyA+1/6*muWzA*omegaAdzA-1/12*muWyA*lambda1C-1/12*muWyA*omegaAdyA-1/12*beta1C*omegaAdzA*muxA-1/12*beta1C*omegaAdzA*muWxA+1/6*theta1*muxA*muWxA-1/8*ead*muWyA*beta1S-1/8*ead*beta1C*muWxA-1/8*ead*beta1C*muxA-1/8*ead*beta1S*muyA+1/8*theta0*muWyA^2+1/8*theta0*muxA^2+1/8*theta0*muWxA^2-1/12*muWzA*beta1C*omegaAdxA-1/12*muWzA*beta1S*omegaAdyA+1/4*muWyA*theta0*muyA+1/12*muWzA*beta1S*lambda1C-1/12*muWzA*beta1C*lambda1S-1/12*muWyA*beta1S*omegaAdzA-1/6*muWyA*theta1C*omegaAdzA+1/6*muWyA*theta1*muyA+1/8*ead*muWzA*beta1S*omegaAdyA+1/8*ead*muWzA*beta1C*omegaAdxA)*sigma1)*a;
CT1C = ((-1/2*muWyA*theta0*omegaAdzA-1/6*beta1S+1/6*omegaAdyA+1/6*lambda1C-1/4*muWzA*beta0*omegaAdxA+1/4*muWyA*beta1S*muyA+1/2*muWzA*lambda0*beta1S+3/4*muWyA*theta1C*muyA-1/8*beta1S*muWxA^2-1/8*beta1S*muxA^2+1/8*theta1C*muxA^2+1/8*theta1C*muWxA^2+1/8*beta1S*muWyA^2+3/8*theta1C*muWyA^2-1/2*muyA*muzA-1/2*muWyA*lambda0+1/6*lambda1C*omegaAdzA-1/2*theta0*muyA+1/4*ead*beta1S-1/6*beta1S*omegaAdzA-1/2*muWyA*muWzA-1/2*lambda0*muyA-1/2*muWzA*muyA-1/4*ead*beta1C*muyA*muWxA-3/4*ead*muWyA*theta1C*muyA+1/4*ead*theta1S*muyA*muWxA-1/4*ead*theta1C*muxA*muWxA-1/4*ead*muWyA*beta1C*muxA-1/4*ead*muWyA*beta1S*muyA-1/4*ead*beta1C*muyA*muxA+1/4*ead*beta1S*muxA*muWxA+1/4*ead*muWyA*theta1S*muxA+1/4*ead*muWyA*theta1S*muWxA-1/2*ead*muWzA*lambda0*beta1S+1/4*ead*theta1S*muyA*muxA+1/2*ead*muWzA*beta0*omegaAdxA-1/4*ead*muWyA*beta1C*muWxA+1/6*theta1C-1/4*beta0*omegaAdzA*muxA-1/4*beta0*omegaAdzA*muWxA-1/2*muWyA*muzA-1/4*theta1S*muyA*muxA-1/4*theta1S*muyA*muWxA+1/4*theta1C*muxA*muWxA-1/4*beta0*muWxA-1/4*beta0*muxA-1/2*muWyA*theta0-1/4*muWyA*theta1S*muxA-1/4*muWyA*theta1S*muWxA+1/4*muWyA*beta1C*muxA+1/4*muWyA*beta1C*muWxA+1/4*beta1C*muyA*muxA+1/4*beta1C*muyA*muWxA-1/4*beta1S*muxA*muWxA-1/3*muWyA*theta1+1/2*ead*muyA*muzA-3/8*ead*theta1C*muWyA^2-1/8*ead*beta1S*muWyA^2-1/8*ead*theta1C*muWxA^2-1/8*ead*theta1C*muxA^2+1/8*ead*beta1S*muxA^2+1/8*ead*beta1S*muWxA^2+1/2*ead*muWyA*muzA+1/2*ead*muWzA*muyA+1/2*ead*muWyA*lambda0+1/2*ead*lambda0*muyA+1/2*ead*muWyA*muWzA+1/4*ead*beta1S*omegaAdzA-1/3*muWyA*theta1*omegaAdzA-1/3*theta1*muyA+1/3*theta1C*omegaAdzA)*sigma0+(-1/3*muWyA*theta0*omegaAdzA-1/8*beta1S+1/8*omegaAdyA+1/8*lambda1C-1/6*muWzA*beta0*omegaAdxA+1/8*muWyA*beta1S*muyA+1/4*muWzA*lambda0*beta1S+3/8*muWyA*theta1C*muyA-1/16*beta1S*muWxA^2-1/16*beta1S*muxA^2+1/16*theta1C*muxA^2+1/16*theta1C*muWxA^2+1/16*beta1S*muWyA^2+3/16*theta1C*muWyA^2-1/4*muyA*muzA-1/4*muWyA*lambda0+1/8*lambda1C*omegaAdzA-1/3*theta0*muyA+1/6*ead*beta1S-1/8*beta1S*omegaAdzA-1/4*muWyA*muWzA-1/4*lambda0*muyA-1/4*muWzA*muyA+1/4*ead*muWzA*beta0*omegaAdxA+1/8*theta1C-1/6*beta0*omegaAdzA*muxA-1/6*beta0*omegaAdzA*muWxA-1/4*muWyA*muzA-1/8*theta1S*muyA*muxA-1/8*theta1S*muyA*muWxA+1/8*theta1C*muxA*muWxA-1/6*beta0*muWxA-1/6*beta0*muxA-1/3*muWyA*theta0-1/8*muWyA*theta1S*muxA-1/8*muWyA*theta1S*muWxA+1/8*muWyA*beta1C*muxA+1/8*muWyA*beta1C*muWxA+1/8*beta1C*muyA*muxA+1/8*beta1C*muyA*muWxA-1/8*beta1S*muxA*muWxA-1/4*muWyA*theta1+1/6*ead*beta1S*omegaAdzA-1/4*muWyA*theta1*omegaAdzA-1/4*theta1*muyA+1/4*theta1C*omegaAdzA)*sigma1)*a;
CT1S = ((1/6*beta1C-1/6*omegaAdxA+1/6*lambda1S+1/3*theta1*muxA+1/6*theta1S+1/3*theta1S*omegaAdzA-1/4*ead*beta1C+1/6*beta1C*omegaAdzA-1/4*muWzA*beta0*omegaAdyA-1/2*muWzA*lambda0*beta1C+1/4*muWyA*theta1S*muyA+3/8*theta1S*muWxA^2+1/4*muWyA*beta1C*muyA+3/8*theta1S*muxA^2-1/4*muWyA*beta0*omegaAdzA+1/2*theta0*muxA+1/6*lambda1S*omegaAdzA-1/4*beta0*muyA+1/4*ead*theta1C*muyA*muWxA+1/4*ead*beta1C*muxA*muWxA-3/4*ead*theta1S*muxA*muWxA+1/4*ead*beta1S*muyA*muWxA+1/4*ead*beta1S*muyA*muxA+1/2*ead*muWzA*lambda0*beta1C+1/4*ead*muWyA*beta1S*muWxA+1/4*ead*muWyA*theta1C*muxA+1/4*ead*muWyA*theta1C*muWxA+1/2*ead*muWzA*beta0*omegaAdyA+1/3*theta1*muWxA+1/2*theta0*muWxA+1/4*ead*theta1C*muyA*muxA-1/4*ead*muWyA*theta1S*muyA-1/4*ead*muWyA*beta1C*muyA+1/4*ead*muWyA*beta1S*muxA+1/3*theta1*omegaAdzA*muxA+1/3*theta1*omegaAdzA*muWxA+1/2*theta0*omegaAdzA*muxA+1/2*theta0*omegaAdzA*muWxA+1/2*muWxA*muWzA+1/2*muxA*muWzA-1/4*muWyA*beta0+1/8*ead*beta1C*muWxA^2-1/8*ead*beta1C*muWyA^2-1/2*ead*muWxA*muWzA-3/8*ead*theta1S*muxA^2-1/2*ead*muzA*muWxA-1/2*ead*muzA*muxA-1/2*ead*muxA*muWzA-1/4*ead*beta1C*omegaAdzA-3/8*ead*theta1S*muWxA^2-1/2*ead*lambda0*muWxA-1/2*ead*lambda0*muxA+1/8*ead*beta1C*muxA^2-1/8*ead*theta1S*muWyA^2+1/2*muzA*muxA+1/2*muzA*muWxA+1/8*beta1C*muWyA^2-1/8*beta1C*muxA^2-1/8*beta1C*muWxA^2+1/8*theta1S*muWyA^2-1/4*muWyA*theta1C*muxA-1/4*muWyA*theta1C*muWxA-1/4*muWyA*beta1S*muxA-1/4*muWyA*beta1S*muWxA-1/4*theta1C*muyA*muxA-1/4*theta1C*muyA*muWxA-1/4*beta1C*muxA*muWxA-1/4*beta1S*muyA*muxA-1/4*beta1S*muyA*muWxA+3/4*theta1S*muxA*muWxA+1/2*lambda0*muxA+1/2*lambda0*muWxA)*sigma0+(1/8*beta1C-1/8*omegaAdxA+1/8*lambda1S+1/4*theta1*muxA+1/8*theta1S+1/4*theta1S*omegaAdzA-1/6*ead*beta1C+1/8*beta1C*omegaAdzA-1/6*muWzA*beta0*omegaAdyA-1/4*muWzA*lambda0*beta1C+1/8*muWyA*theta1S*muyA+3/16*theta1S*muWxA^2+1/8*muWyA*beta1C*muyA+3/16*theta1S*muxA^2-1/6*muWyA*beta0*omegaAdzA+1/3*theta0*muxA+1/8*lambda1S*omegaAdzA-1/6*beta0*muyA+1/4*ead*muWzA*beta0*omegaAdyA+1/4*theta1*muWxA+1/3*theta0*muWxA+1/4*theta1*omegaAdzA*muxA+1/4*theta1*omegaAdzA*muWxA+1/3*theta0*omegaAdzA*muxA+1/3*theta0*omegaAdzA*muWxA+1/4*muWxA*muWzA+1/4*muxA*muWzA-1/6*muWyA*beta0-1/6*ead*beta1C*omegaAdzA+1/4*muzA*muxA+1/4*muzA*muWxA+1/16*beta1C*muWyA^2-1/16*beta1C*muxA^2-1/16*beta1C*muWxA^2+1/16*theta1S*muWyA^2-1/8*muWyA*theta1C*muxA-1/8*muWyA*theta1C*muWxA-1/8*muWyA*beta1S*muxA-1/8*muWyA*beta1S*muWxA-1/8*theta1C*muyA*muxA-1/8*theta1C*muyA*muWxA-1/8*beta1C*muxA*muWxA-1/8*beta1S*muyA*muxA-1/8*beta1S*muyA*muWxA+3/8*theta1S*muxA*muWxA+1/4*lambda0*muxA+1/4*lambda0*muWxA)*sigma1)*a;

CHi  = -CT0*beta1C;
CH0  = 0;
CYi  = -CT0*beta1S;
CY0  = 0;

%Inertial forces
CFixA = b*muP*(muzA*omegaAdyA-muyA*omegaAdzA);% FIXED BY ALVARO, 2015/01 muWi removed from inertial force coefficients.
CFiyA = b*muP*(-(muzA)*omegaAdxA+omegaAdzA*(muxA));% FIXED BY ALVARO, 2015/01 muWi removed from inertial force coefficients.
CFizA = b*muP*(muyA*omegaAdxA-omegaAdyA*muxA);% FIXED BY ALVARO, 2015/01 muWi removed from inertial force coefficients.

%Gravitational forces
CFgxA = b*muP*aG*GxA;
CFgyA = b*muP*aG*GyA;
CFgzA = b*muP*aG*GzA;

CFai = [CHi; CYi; CT0; CT1C; CT1S];
CFa0 = [CH0; CY0; 0; 0; 0];
CFi  = [CFixA; CFiyA; CFizA];
CFg  = [CFgxA; CFgyA; CFgzA];