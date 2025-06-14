function [CTb0,CTb1C,CTb1S] = getFourierCTb(vaerad,dFab,harmFunct,ndRotor)
%getFourierCTb Summary of this function goes here
%   Detailed explanation goes here

PSI    = ndRotor.nlRotor.psi2Dall;
X      = ndRotor.nlRotor.x2Dall;
C      = ndRotor.nlRotor.c2adDall;

UTad = vaerad.UTad;
UPad = vaerad.UPad;

dTab   = dFab.dTab;
dFTab  = dFab.dFTab;

CPSI        = harmFunct.CPSI;
SPSI        = harmFunct.SPSI;
   
CPHI        = harmFunct.CPHI;
SPHI        = harmFunct.SPHI;

CBETA       = harmFunct.CBETA;
SBETA       = harmFunct.SBETA;
     
CZETA       = harmFunct.CZETA;
SZETA       = harmFunct.SZETA;

k    = ((UTad.^2)+(UPad.^2)).*C/(2*pi);     
    
dCTb = k.*([-SZETA.*SBETA].*(-dFTab) + CBETA.*dTab);  


x1D     = X(1,:);
CTb = trapz(x1D,dCTb,2);

PSI1D   = PSI(:,1);
[a0,CTb1C,CTb1S,CTbs] = FSC(PSI1D,CTb,1);
CTb0 = a0/2;
       
end

