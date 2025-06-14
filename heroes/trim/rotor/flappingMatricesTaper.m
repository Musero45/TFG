function [ABeta,ATheta,AOmega,VInd] = flappingMatricesTaper(lambda,mu,GA,muW,ndRotor)
%
%FIXME To be documented and tested
%
lambda0  = lambda(1);
lambda1C = lambda(2);
lambda1S = lambda(3);

muxA = mu(1);
muyA = mu(2);
muzA = mu(3);

GxA = GA(1);
GyA = GA(2);
GzA = GA(3);

muWxA = muW(1);
muWyA = muW(2);
muWzA = muW(3);

ead      = ndRotor.ead;
theta1   = ndRotor.theta1;
SBeta    = ndRotor.SBeta;
epsilonR = ndRotor.epsilonR;
aG       = ndRotor.aG;
gamma    = ndRotor.gamma;
RITB     = ndRotor.RITB;
RIZB     = ndRotor.RIZB;

m        = ndRotor.sigma1/ndRotor.sigma0;

%Inertial beta-matrix
AIBeta11 = (8*RIZB-8*RITB+SBeta*gamma)/gamma;
AIBeta12 = 4/gamma*epsilonR*aG*GxA;
AIBeta13 = 4/gamma*epsilonR*aG*GyA;

AIBeta21 = 8/gamma*epsilonR*aG*GxA;
AIBeta22 = (-8+SBeta*gamma+8*RIZB-8*RITB)/gamma;
AIBeta23 = 0;

AIBeta31 = 8/gamma*epsilonR*aG*GyA;
AIBeta32 = 0;
AIBeta33 = (-8+SBeta*gamma+8*RIZB-8*RITB)/gamma;

AIBeta = [AIBeta11,AIBeta12,AIBeta13; ...
          AIBeta21,AIBeta22,AIBeta23; ...
          AIBeta31,AIBeta32,AIBeta33];

%Inertial theta-matrix
AITheta11 = 0;
AITheta12 = 0;
AITheta13 = 0;

AITheta21 = 0;
AITheta22 = 0;
AITheta23 = -(8*(-RIZB+1+RITB))/gamma;

AITheta31 = 0;
AITheta32 = (8*(-RIZB+1+RITB))/gamma;
AITheta33 = 0;

AITheta = [AITheta11,AITheta12,AITheta13; ...
           AITheta21,AITheta22,AITheta23; ...
           AITheta31,AITheta32,AITheta33];

%Inertial omega-matrix
AIOmega11 = -8*epsilonR*muyA/gamma;
AIOmega12 = 8*epsilonR*muxA/gamma;
AIOmega13 = 0;

AIOmega21 = (8*(2*ead*epsilonR+1+RIZB-RITB))/gamma;
AIOmega22 = 0;
AIOmega23 = 0;

AIOmega31 = 0;
AIOmega32 = (8*(2*ead*epsilonR+1+RIZB-RITB))/gamma;
AIOmega33 = 0;

AIOmega = [AIOmega11,AIOmega12,AIOmega13; ...
           AIOmega21,AIOmega22,AIOmega23; ...
           AIOmega31,AIOmega32,AIOmega33];

%Inertial independent term
VIInd1 = -8*epsilonR*aG*GzA/gamma;
VIInd2 = 0;
VIInd3 = 0;

VIInd = [VIInd1; VIInd2; VIInd3];

C1 = 1+2*m/3;
C2 = 4/3+m;
C3 = 1+4*m/5;

%Aerodynamic beta-matrix
AAbeta11 = 0;
AAbeta12 = ead*muxA*C1;
AAbeta13 = 0;

AAbeta21 = -2*ead*muxA*C1+(muxA+muWxA)*C2;
AAbeta22 = -muxA*(muyA+muWyA)*C1;
AAbeta23 = -2*ead*C2+muxA*muWxA*C1+(1/2)*muxA^2*C1+C3;

AAbeta31 = (muyA+muWyA)*C2;
AAbeta32 = 2*ead*C2+muxA*muWxA*C1+(1/2)*muxA^2*C1-C3;
AAbeta33 = muxA*(muyA+muWyA)*C1;

AAbeta = [AAbeta11,AAbeta12,AAbeta13; ...
          AAbeta21,AAbeta22,AAbeta23; ...
          AAbeta31,AAbeta32,AAbeta33];

%Aerodynamic theta-matrix
AATheta11 = ead*C2-muxA^2*C1-2*muxA*muWxA*C1-C3;
AATheta12 = (muWyA+muyA)*C2;
AATheta13 = 2*muxA*ead*C1-(muxA+muWxA)*C2;

AATheta21 = 2*(muWyA+muyA)*C2;
AATheta22 = ead*C2-1/2*muxA^2*C1-muxA*muWxA*C1-C3;
AATheta23 = muxA*(muWyA+muyA)*C1;

AATheta31 = 4*muxA*ead*C1-2*(muWxA+muxA)*C2;
AATheta32 = muxA*(muWyA+muyA)*C1;
AATheta33 = ead*C2-3*muxA*muWxA*C1-3/2*muxA^2*C1-C3;

AATheta = [AATheta11,AATheta12,AATheta13; ...
           AATheta21,AATheta22,AATheta23; ...
           AATheta31,AATheta32,AATheta33];

%Aerodynamic omega-matrix
AAOmega11 = -muxA*ead*C1+1/2*(muWxA+muxA)*C2;
AAOmega12 = 1/2*(muWyA+muyA)*C2;
AAOmega13 = -(lambda0+muzA+muWzA)*C2-(8/5+4/3*m)*theta1;

AAOmega21 = 0;
AAOmega22 = ead*C2-C3;
AAOmega23 = -lambda1C*C3;

AAOmega31 = -ead*C2+C3;
AAOmega32 = 0;
AAOmega33 = (-2*theta1*muxA-lambda1S)*C3;

AAOmega = [AAOmega11,AAOmega12,AAOmega13; ...
           AAOmega21,AAOmega22,AAOmega23; ...
           AAOmega31,AAOmega32,AAOmega33];

%Aerodynamic independent term
VAInd1 = -(4/5+2/3*m)*theta1-(1/2*muxA*lambda1S+lambda0+muWzA+muzA+1/2*muxA^2*theta1)*C2;
VAInd2 = -lambda1C*C3;
VAInd3 = (-lambda1S-2*theta1*muxA)*C3-2*muxA*C1*(muzA+lambda0+muWzA);

VAInd = [VAInd1; VAInd2; VAInd3];

%Complete matrix
ABeta  = AIBeta+AAbeta;
ATheta = AITheta+AATheta;
AOmega = AIOmega+AAOmega;
VInd   = VIInd+VAInd;

end