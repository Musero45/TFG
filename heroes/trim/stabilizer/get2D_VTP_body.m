function [CF, CM] = get2D_VTP_GazelleActions(flightConditionStab,ndStab)

%     [CF, CM] = get2D_VTP_GazelleActions(flightConditionStab,ndStab) computes
%     the aerodynamic actions of a stabilizer expressed in the stabilizer
%     frame, given the nondimensional advance parameters (flightConditionStab)
%     and the characteristics' struct (ndStab).
%     This model neglects the effects of the sideslip.

muxs  = flightConditionStab(1);
muys = flightConditionStab(2);
muzs  = flightConditionStab(3);

ndS     = ndStab.ndS;
ndc     = ndStab.ndc;
% theta   = ndStab.theta;
% airfoil = ndStab.airfoil;

ndVs = sqrt(muxs^2+muys^2+muzs^2);

% alphaF = atan2(-muzf,-muxf);
if ndVs ~= 0
    betaF  = asin(-muys/ndVs);
else
    betaF = 0;
end


CFx = 0;
CFy = 0.5*ndS*ndVs^2*(-0.3787-2.141*sin(2.*betaF)-0.8533*sin(2.*betaF)^2-3.035*sin(2.*betaF)^3)./100 ; %0.5*ndS*ndVs*(Cl*muzs-Cd*muxs); % ;
CFz = 0;

CMx = -0.5*ndS*ndc*ndVs^2*(-0.1145-0.4673*sin(2*betaF))./100;
CMy = 0;
CMz = -0.5*ndS*ndc*ndVs^2*(0.4292+2.43*sin(2*betaF)+0.8842*sin(2*betaF)^2+3.206.*sin(2*betaF).^3)./100;

CF = [CFx; CFy; CFz];
CM = [CMx; CMy; CMz];

end