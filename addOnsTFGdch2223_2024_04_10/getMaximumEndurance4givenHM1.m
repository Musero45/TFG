function [Emax,VC,ConFWvec] = getMaximumEndurance4givenHM1(r4fRigidHe,H,atm,vWT,FC4,options)
% [Emax,VC,ConFWvec] = getMaximumEndurance4givenHM1(r4fRigidHe,H,atm,vWT,FC4,options)
% provides the maximum Endurance Emax [m] and the corresponding flight
% velocity VC [m/s] for a given altitude H [m], wind velocity vector 
% expressed in the ground reference system vWT [m/s] and
% flight condition 4, FC4.
%
% The function uses getRange4givenVHM1 to calculate the range

negRfun = @(V)(-getEndurance4givenVHM1(r4fRigidHe,V,H,atm,vWT,FC4,options));

         W = r4fRigidHe.inertia.W;
         R = r4fRigidHe.mainRotor.R;
       rho = atm.density(H);

       VC0 = 2.5*sqrt(W/(2*rho*pi*R^2));
       opt = optimset('TolFun',1,'TolX',10^-1);
        VC = fminsearch(negRfun,VC0,opt);
      Emax = -negRfun(VC); 
   
  ConFWvec = [];

end
