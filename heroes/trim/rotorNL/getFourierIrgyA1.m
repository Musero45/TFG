function [irg0yA1,irg1CyA1,irg1SyA1] = getFourierIrgyA1(irgyA1,ndRotor)
%getFourierIrgA1 Summary of this function goes here
%   Detailed explanation goes here

PSI      = ndRotor.nlRotor.psi2Dall;

PSI1D     = PSI(:,1);
[a0,irg1CyA1,irg1SyA1,irgyA1s] = FSC(PSI1D,irgyA1,1);
irg0yA1 = a0/2;


end