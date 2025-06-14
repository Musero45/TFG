function [irg0zA1,irg1CzA1,irg1SzA1] = getFourierIrgzA1(irgz,ndRotor)
%getFourierIrgA1 Summary of this function goes here
%   Detailed explanation goes here

PSI      = ndRotor.nlRotor.psi2Dall;

PSI1D     = PSI(:,1);
[a0,irg1CzA1,irg1SzA1,irgzs] = FSC(PSI1D,irgz,1);
irg0zA1 = a0/2;


end