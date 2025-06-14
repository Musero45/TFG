function [Rmax,VB,ConFW] = getMaximumRange4givenHM2(r4fRigidHe,H,atm,...
                                                    vWT,FC4,options)
% [Rmax,VB,ConFW] = getMaximumRange4givenHM2(r4fRigidHe,H,atm,vWT,FC4,options)
% provides the maximum range Rmax [m] and the corresponding flight
% velocity VB [m/s] for a given altitude H, wind velocity vector vWT and
% flight condition 4, FC4. 
% 
% The function uses getRange4givenVHM2 to
% calculate the range

ConFW = [];

negRfun = @(V)(-getRange4givenVHM2(r4fRigidHe,V,H,atm,vWT,FC4,options));

W    = r4fRigidHe.inertia.W;
R    = r4fRigidHe.mainRotor.R;
rho  = atm.density(H);

VB0  = 5*sqrt(W/(2*rho*pi*R^2));

opt  = optimset('TolFun',1,'TolX',10^-1);

VB   = fminsearch(negRfun,VB0,opt);
Rmax = -negRfun(VB); 

end
