function [CF, CM] = get2DStabilizerActions(flightConditionStab,ndStab)

%     [CF, CM] = get2DStabilizerActions(flightConditionStab,ndStab) computes
%     the aerodynamic actions of a stabilizer expressed in the stabilizer
%     frame, given the nondimensional advance parameters (flightConditionStab)
%     and the characteristics' struct (ndStab).
%     This model neglects the effects of the sideslip.

muxs  = flightConditionStab(1);
muzs  = flightConditionStab(3);

ndS     = ndStab.ndS;
ndc     = ndStab.ndc;
theta   = ndStab.theta;
airfoil = ndStab.airfoil;

ndVs = sqrt(muxs^2+muzs^2);

phiS   = atan2(-muzs,-muxs);
alphaS = phiS+theta;

[Cl,Cd,Cm] = airfoil(alphaS);

CFx = 0.5*ndS*ndVs^2*(Cl*sin(phiS)-Cd*cos(phiS));%0.5*ndS*ndVs*(Cl*muzs-Cd*muxs); % 
CFy = 0;
CFz = 0.5*ndS*ndVs^2*(-Cl*cos(phiS)-Cd*sin(phiS));%0.5*ndS*ndVs*(-Cl*muxs-Cd*muzs); % 

CMx = 0;
CMy = 0.5*ndS*ndc*ndVs^2*Cm;
CMz = 0;

CF = [CFx; CFy; CFz];
CM = [CMx; CMy; CMz];

end