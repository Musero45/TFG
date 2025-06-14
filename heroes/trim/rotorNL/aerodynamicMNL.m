function [CMFai, CMFa0, CMaEi, CMaE0, CMFi, CMiE, CMgE, CMel] = aerodynamicMNL(beta,theta,lambda,flightCondition,muW,GA,ndRotor)

% FIXME To be documented and tested.
% FIXME To be documented and tested.
% Big bug detected and solved by ALVARO: 2015/01: Inertial forces contained
% muW vector components. Now these components have been removed from
% the inertial force coeffients expressions.

zeta = [0;0;0];

psi  = ndRotor.nlRotor.psi2Dall;
x    = ndRotor.nlRotor.x2Dall;
cad  = ndRotor.nlRotor.c2adDall;
eada = ndRotor.ead;
eadb = ndRotor.ead;
b    = ndRotor.b;


psi1D    = psi(:,1);
x1D      = x(1,:);


%Aerodynamic forces moments

Out = basicAeroStateNL(beta,theta,zeta,lambda,flightCondition,muW,ndRotor);

UTad = Out.vaerad.UTad;
UPad = Out.vaerad.UPad;

CPSI = cos(psi);
SPSI = sin(psi);

CPSI1D = CPSI(:,1);
SPSI1D = SPSI(:,1);

CBETA = Out.harmFunct.CBETA;
SBETA = Out.harmFunct.SBETA;

CZETA = Out.harmFunct.CZETA;
SZETA = Out.harmFunct.SZETA;

dTabi  = Out.dFab.dTabi;
dTab0  = Out.dFab.dTab0;

dFTabi = Out.dFab.dFTabi;
dFTab0 = Out.dFab.dFTab0;

k     = ((UTad.^2)+(UPad.^2)).*cad/(2*pi); 

% dCMFaxAbi = k.*((SPSI*eadb+CPSI.*(eada-eadb)).*(SBETA.*SZETA.*dFTabi+CBETA.*dTabi));
% dCMFaxAb0 = k.*((SPSI*eadb+CPSI.*(eada-eadb)).*(SBETA.*SZETA.*dFTab0+CBETA.*dTab0));
% dCMFayAbi = k.*(-(CPSI*eadb-SPSI*(eada-eadb)).*(SBETA.*SZETA.*dFTabi+CBETA.*dTabi));
% dCMFayAb0 = k.*(-(CPSI*eadb-SPSI*(eada-eadb)).*(SBETA.*SZETA.*dFTab0+CBETA.*dTab0));
% dCMFazAbi = k.*((CPSI*eadb-SPSI*(eada-eadb)).*(SPSI.*(CBETA.*SZETA.*dFTabi-...
%     SBETA.*dTabi)-CPSI.*CZETA.*dFTabi)-(SPSI*eadb+CPSI*(eada-eadb)).*...
%     (CPSI.*(CBETA.*SZETA.*dFTabi-SBETA.*dTabi)+SPSI.*CZETA.*dFTabi));
% dCMFazAb0 = k.*((CPSI*eadb-SPSI*(eada-eadb)).*(SPSI.*(CBETA.*SZETA.*dFTab0-...
%     SBETA.*dTab0)-CPSI.*CZETA.*dFTab0)-(SPSI*eadb+CPSI*(eada-eadb)).*...
%     (CPSI.*(CBETA.*SZETA.*dFTab0-SBETA.*dTab0)+SPSI.*CZETA.*dFTab0));
%
% dCMFaxAi = trapz(x1D,dCMFaxAbi,2);
% dCMFaxA0 = trapz(x1D,dCMFaxAb0,2);
% dCMFayAi = trapz(x1D,dCMFayAbi,2);
% dCMFayA0 = trapz(x1D,dCMFayAb0,2);
% dCMFazAi = trapz(x1D,dCMFazAbi,2);
% dCMFazA0 = trapz(x1D,dCMFazAb0,2);
% 
% CMFaxAi = b/(2*pi)*trapz(psi1D,dCMFaxAi,1);
% CMFaxA0 = b/(2*pi)*trapz(psi1D,dCMFaxA0,1);
% CMFayAi = b/(2*pi)*trapz(psi1D,dCMFayAi,1);
% CMFayA0 = b/(2*pi)*trapz(psi1D,dCMFayA0,1);
% CMFazAi = b/(2*pi)*trapz(psi1D,dCMFazAi,1);
% CMFazA0 = b/(2*pi)*trapz(psi1D,dCMFazA0,1);


dCFaxAbi = k.*(CPSI.*(CBETA.*SZETA.*dFTabi-SBETA.*dTabi)+SPSI.*CZETA.*dFTabi);
dCFaxAb0 = k.*(CPSI.*(CBETA.*SZETA.*dFTab0-SBETA.*dTab0)+SPSI.*CZETA.*dFTab0);
dCFayAbi = k.*(SPSI.*(CBETA.*SZETA.*dFTabi-SBETA.*dTabi)-CPSI.*CZETA.*dFTabi);
dCFayAb0 = k.*(SPSI.*(CBETA.*SZETA.*dFTab0-SBETA.*dTab0)-CPSI.*CZETA.*dFTab0);
dCFazAbi = k.*(SBETA.*SZETA.*dFTabi+CBETA.*dTabi);
dCFazAb0 = k.*(SBETA.*SZETA.*dFTab0+CBETA.*dTab0);

CFaxAbi = trapz(x1D,dCFaxAbi,2);
CFaxAb0 = trapz(x1D,dCFaxAb0,2);
CFayAbi = trapz(x1D,dCFayAbi,2);
CFayAb0 = trapz(x1D,dCFayAb0,2);
CFazAbi = trapz(x1D,dCFazAbi,2);
CFazAb0 = trapz(x1D,dCFazAb0,2);

CMFaxAbi = (SPSI1D*eadb+CPSI1D*(eada-eadb)).*CFazAbi;
CMFaxAb0 = (SPSI1D*eadb+CPSI1D*(eada-eadb)).*CFazAb0;
CMFayAbi = -(CPSI1D*eadb-SPSI1D*(eada-eadb)).*CFazAbi;
CMFayAb0 = -(CPSI1D*eadb-SPSI1D*(eada-eadb)).*CFazAb0;
CMFazAbi = (CPSI1D*eadb-SPSI1D*(eada-eadb)).*CFayAbi-(SPSI1D*eadb+CPSI1D*(eada-eadb)).*CFaxAbi;
CMFazAb0 = (CPSI1D*eadb-SPSI1D*(eada-eadb)).*CFayAb0-(SPSI1D*eadb+CPSI1D*(eada-eadb)).*CFaxAb0;

CMFaxAi = b/(2*pi)*trapz(psi1D,CMFaxAbi,1);
CMFaxA0 = b/(2*pi)*trapz(psi1D,CMFaxAb0,1);
CMFayAi = b/(2*pi)*trapz(psi1D,CMFayAbi,1);
CMFayA0 = b/(2*pi)*trapz(psi1D,CMFayAb0,1);
CMFazAi = b/(2*pi)*trapz(psi1D,CMFazAbi,1);
CMFazA0 = b/(2*pi)*trapz(psi1D,CMFazAb0,1);


%Aerodynamic moments in E: CMaE
dCMaExAbi = k.*(CPSI.*(CBETA.*SZETA.*(x-eada).*dTabi+SBETA.*(x-eada).*dFTabi)...
    +SPSI.*CZETA.*(x-eada).*dTabi);
dCMaExAb0 = k.*(CPSI.*(CBETA.*SZETA.*(x-eada).*dTab0+SBETA.*(x-eada).*dFTab0)...
    +SPSI.*CZETA.*(x-eada).*dTab0);
dCMaEyAbi = k.*(SPSI.*(CBETA.*SZETA.*(x-eada).*dTabi+SBETA.*(x-eada).*dFTabi)...
    -CPSI.*CZETA.*(x-eada).*dTabi);
dCMaEyAb0 = k.*(SPSI.*(CBETA.*SZETA.*(x-eada).*dTab0+SBETA.*(x-eada).*dFTab0)...
    -CPSI.*CZETA.*(x-eada).*dTab0);
dCMaEzAbi = k.*(SBETA.*SZETA.*(x-eada).*dTabi-CBETA.*(x-eada).*dFTabi);
dCMaEzAb0 = k.*(SBETA.*SZETA.*(x-eada).*dTab0-CBETA.*(x-eada).*dFTab0);

dCMaExAi = trapz(x1D,dCMaExAbi,2);
dCMaExA0 = trapz(x1D,dCMaExAb0,2);
dCMaEyAi = trapz(x1D,dCMaEyAbi,2);
dCMaEyA0 = trapz(x1D,dCMaEyAb0,2);
dCMaEzAi = trapz(x1D,dCMaEzAbi,2);
dCMaEzA0 = trapz(x1D,dCMaEzAb0,2);

CMaExAi = b/(2*pi)*trapz(psi1D,dCMaExAi,1);
CMaExA0 = b/(2*pi)*trapz(psi1D,dCMaExA0,1);
CMaEyAi = b/(2*pi)*trapz(psi1D,dCMaEyAi,1);
CMaEyA0 = b/(2*pi)*trapz(psi1D,dCMaEyA0,1);
CMaEzAi = b/(2*pi)*trapz(psi1D,dCMaEzAi,1);
CMaEzA0 = b/(2*pi)*trapz(psi1D,dCMaEzA0,1);


CMFai = [CMFaxAi; CMFayAi; CMFazAi];
CMFa0 = [CMFaxA0; CMFayA0; CMFazA0];
CMaEi = [CMaExAi; CMaEyAi; CMaEzAi];
CMaE0 = [CMaExA0; CMaEyA0; CMaEzA0];

[CMFi,CMgE,CMiE,CMel] = basicIrgAStateNL(beta,theta,zeta,flightCondition,GA,ndRotor);

end


