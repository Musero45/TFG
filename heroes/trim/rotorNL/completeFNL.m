function [CFai, CFa0, CFi, CFg] = completeFNL(beta,theta,lambda,flightCondition,muW,GA,ndRotor)

psi  = ndRotor.nlRotor.psi2Dall;
x    = ndRotor.nlRotor.x2Dall;
cad  = ndRotor.nlRotor.c2adDall;
b    = ndRotor.b;
muP  = ndRotor.muP;
aG   = ndRotor.aG;

psi1D    = psi(:,1);
x1D      = x(1,:);

GxA  = GA(1);
GyA  = GA(2);
GzA  = GA(3);

%Aerodynamic forces
zeta = [0;0;0];

Out = basicAeroStateNL(beta,theta,zeta,lambda,flightCondition,muW,ndRotor);

UTad = Out.vaerad.UTad;
UPad = Out.vaerad.UPad;

CPSI = cos(psi);
SPSI = sin(psi);

CBETA = Out.harmFunct.CBETA;
SBETA = Out.harmFunct.SBETA;

CZETA = Out.harmFunct.CZETA;
SZETA = Out.harmFunct.SZETA;

dTabi  = Out.dFab.dTabi;
dTab0  = Out.dFab.dTab0;
dTab   = Out.dFab.dTab;

dFTabi = Out.dFab.dFTabi;
dFTab0 = Out.dFab.dFTab0;
dFTab  = Out.dFab.dFTab;

k     = ((UTad.^2)+(UPad.^2)).*cad/(2*pi);    

dCHbi = k.*(CPSI.*(CBETA.*SZETA.*dFTabi-SBETA.*dTabi)+SPSI.*CZETA.*dFTabi);
dCHb0 = k.*(CPSI.*(CBETA.*SZETA.*dFTab0-SBETA.*dTab0)+SPSI.*CZETA.*dFTab0);
dCYbi = k.*(SPSI.*(CBETA.*SZETA.*dFTabi-SBETA.*dTabi)-CPSI.*CZETA.*dFTabi);
dCYb0 = k.*(SPSI.*(CBETA.*SZETA.*dFTab0-SBETA.*dTab0)-CPSI.*CZETA.*dFTab0);
dCTb  = k.*(SBETA.*SZETA.*dFTab + CBETA.*dTab);  


CHbi = trapz(x1D,dCHbi,2);
CHb0 = trapz(x1D,dCHb0,2);
CYbi = trapz(x1D,dCYbi,2);
CYb0 = trapz(x1D,dCYb0,2);
CTb  = trapz(x1D,dCTb,2);


CHi = (b/(2*pi))*trapz(psi1D,CHbi,1);
CH0 = (b/(2*pi))*trapz(psi1D,CHb0,1);

CYi = (b/(2*pi))*trapz(psi1D,CYbi,1);
CY0 = (b/(2*pi))*trapz(psi1D,CYb0,1);

[a0,CTb1C,CTb1S,CTbs] = FSC(psi1D,CTb,1);
CTb0 = a0/2;
CT0  = b*CTb0;
CT1C = b*CTb1C;
CT1S = b*CTb1S;


%Inertial forces
[dVGBdpsi_Ax, dVGBdpsi_Ay, dVGBdpsi_Az] = getInertialForces(beta,zeta,flightCondition,ndRotor);

CFixA = -b/(2*pi)*muP*trapz(psi1D,dVGBdpsi_Ax,1);
CFiyA = -b/(2*pi)*muP*trapz(psi1D,dVGBdpsi_Ay,1);
CFizA = -b/(2*pi)*muP*trapz(psi1D,dVGBdpsi_Az,1);

%Gravitational forces
CFgxA = b*muP*aG*GxA;
CFgyA = b*muP*aG*GyA;
CFgzA = b*muP*aG*GzA;

CFai = [CHi; CYi; CT0; CT1C; CT1S];
CFa0 = [CH0; CY0; 0; 0; 0];
CFi  = [CFixA; CFiyA; CFizA];
CFg  = [CFgxA; CFgyA; CFgzA];

end

