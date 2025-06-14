function [CMaEb0zA1,CMaEb1CzA1,CMaEb1SzA1] = getFourierCMaEbzA1(vaerad,dFab,harmFunct,ndRotor)
%getFourierCMaEbza1 Summary of this function goes here
%   Detailed explanation goes here

PSI    = ndRotor.nlRotor.psi2Dall;
X      = ndRotor.nlRotor.x2Dall;
C      = ndRotor.nlRotor.c2adDall;
eada   = ndRotor.ead;
eadb   = ndRotor.ead;

UTad = vaerad.UTad;
UPad = vaerad.UPad;

dFTab  = dFab.dFTab;
dTab   = dFab.dTab;

CPSI        = harmFunct.CPSI;
SPSI        = harmFunct.SPSI;
   
CPHI        = harmFunct.CPHI;
SPHI        = harmFunct.SPHI;

CBETA       = harmFunct.CBETA;
SBETA       = harmFunct.SBETA;
     
CZETA       = harmFunct.CZETA;
SZETA       = harmFunct.SZETA;

k    = ((UTad.^2)+(UPad.^2)).*C/(2*pi);     
    
dCMaEbzA1 = k.*(SBETA.*SZETA.*(X-eada).*dTab-CBETA.*(X-eada).*dFTab-...
        eadb*CZETA.*dFTab);   


x1D     = X(1,:);
CMaEbzA1 = trapz(x1D,dCMaEbzA1,2);

PSI1D   = PSI(:,1);
[a0,CMaEb1CzA1,CMaEb1SzA1,CMaEbzA1s] = FSC(PSI1D,CMaEbzA1,1);
CMaEb0zA1 = a0/2;
       
end

