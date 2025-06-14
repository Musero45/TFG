function [CMaEb0yA1,CMaEb1CyA1,CMaEb1SyA1] = getFourierCMaEbyA1(vaerad,dFab,harmFunct,ndRotor)
%getFourierCMaEbya1 Summary of this function goes here
%   Detailed explanation goes here

PSI    = ndRotor.nlRotor.psi2Dall;
X      = ndRotor.nlRotor.x2Dall;
C      = ndRotor.nlRotor.c2adDall;
eada   = ndRotor.ead;

UTad = vaerad.UTad;
UPad = vaerad.UPad;

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
    
dCMaEbyA1 = k.*(-CZETA.*(X-eada).*dTab);   


X1D     = X(1,:);
CMaEbyA1 = trapz(X1D,dCMaEbyA1,2);

PSI1D   = PSI(:,1);
[a0,CMaEb1CyA1,CMaEb1SyA1,CMaEbyA1s] = FSC(PSI1D,CMaEbyA1,1);
CMaEb0yA1 = a0/2;
       
end

