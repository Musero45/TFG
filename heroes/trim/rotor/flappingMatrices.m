function [ABeta,ATheta,AOmega,VInd] = flappingMatrices(lambda,mu,GA,muW,ndRotor,varargin)
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

AIBeta = [AIBeta11,AIBeta12,AIBeta13; AIBeta21,AIBeta22,AIBeta23; AIBeta31,AIBeta32,AIBeta33];

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

AITheta = [AITheta11,AITheta12,AITheta13; AITheta21,AITheta22,AITheta23; AITheta31,AITheta32,AITheta33];

%Inertial omega-matrix
AIOmega11 = -8*epsilonR*muyA/gamma;
AIOmega12 = 8*epsilonR*muxA/(gamma);
AIOmega13 = 0;

AIOmega21 = (8*(2*ead*epsilonR+1+RIZB-RITB))/gamma;
AIOmega22 = 0;
AIOmega23 = 0;

AIOmega31 = 0;
AIOmega32 = (8*(2*ead*epsilonR+1+RIZB-RITB))/gamma;
AIOmega33 = 0;

AIOmega = [AIOmega11,AIOmega12,AIOmega13; AIOmega21,AIOmega22,AIOmega23; AIOmega31,AIOmega32,AIOmega33];

%Inertial independent term
VIInd1 = -8*epsilonR*aG*GzA/gamma;
VIInd2 = 0;
VIInd3 = 0;

VIInd = [VIInd1; VIInd2; VIInd3];


%Aerodynamic beta-matrix
AAbeta11 = 0;
AAbeta12 = ead*muxA;
AAbeta13 = 0;

AAbeta21 = -2*ead*muxA+(4/3)*muxA+(4/3)*muWxA;
AAbeta22 = -muxA*(muyA+muWyA);
AAbeta23 = -(8/3)*ead+muxA*muWxA+1+(1/2)*muxA^2;

AAbeta31 = (4/3)*muyA+(4/3)*muWyA;
AAbeta32 = (8/3)*ead+(1/2)*muxA^2+muxA*muWxA-1;
AAbeta33 = muxA*(muyA+muWyA);

AAbeta = [AAbeta11,AAbeta12,AAbeta13; AAbeta21,AAbeta22,AAbeta23; AAbeta31,AAbeta32,AAbeta33];

%Aerodynamic theta-matrix
AATheta11 = 4/3*ead-muxA^2-2*muxA*muWxA-1;
AATheta12 = 4/3*muWyA+4/3*muyA;
AATheta13 = 2*muxA*ead-4/3*muxA-4/3*muWxA;

AATheta21 = 8/3*muWyA+8/3*muyA;
AATheta22 = 4/3*ead-1/2*muxA^2-muxA*muWxA-1;
AATheta23 = muxA*(muWyA+muyA);

AATheta31 = 4*muxA*ead-8/3*muWxA-8/3*muxA;
AATheta32 = muxA*(muWyA+muyA);
AATheta33 = 4/3*ead-1-3*muxA*muWxA-3/2*muxA^2;

AATheta = [AATheta11,AATheta12,AATheta13; AATheta21,AATheta22,AATheta23; AATheta31,AATheta32,AATheta33];

%Aerodynamic omega-matrix
AAOmega11 = -muxA*ead+2/3*muWxA+2/3*muxA;
AAOmega12 = 2/3*muWyA+2/3*muyA;
AAOmega13 = -4/3*lambda0-8/5*theta1-4/3*muzA-4/3*muWzA;

AAOmega21 = 0;
AAOmega22 = 4/3*ead-1;
AAOmega23 = -lambda1C;

AAOmega31 = -4/3*ead+1;
AAOmega32 = 0;
AAOmega33 = -2*theta1*muxA-lambda1S;

AAOmega = [AAOmega11,AAOmega12,AAOmega13; AAOmega21,AAOmega22,AAOmega23; AAOmega31,AAOmega32,AAOmega33];

%Aerodynamic independent term
VAInd1 = -4/5*theta1-2/3*muxA*lambda1S-4/3*lambda0-4/3*muWzA-2/3*muxA^2*theta1-4/3*muzA;
VAInd2 = -lambda1C;
VAInd3 = -lambda1S-2*muxA*muzA-2*theta1*muxA-2*muxA*lambda0-2*muxA*muWzA;

VAInd = [VAInd1; VAInd2; VAInd3];

%Complete matrix
ABeta  = AIBeta+AAbeta;
ATheta = AITheta+AATheta;
AOmega = AIOmega+AAOmega;
VInd   = VIInd+VAInd;

end
