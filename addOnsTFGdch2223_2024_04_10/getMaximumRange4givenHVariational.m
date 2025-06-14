function [Rmax,VB,ConFWvec] = getMaximumRange4givenHVariational(r4fRigidHe,H,atm,vWT,FC4,options);
% [Rmax,VB,ConFWvec] = getMaximumRange4givenHVariational(r4fRigidHe,H,atm,vWT,FC4,options)
% provides the maximum range Rmax [m] and the corresponding vector of flight
% velocities VB [m/s] for a given altitude H, wind velocity vector vWT and
% flight condition 4, FC4.

% In this case, variational calculus is applied. The solution of the
% Euler-Langrange equation applied to the functional that provides the
% range as an integral of the SAR(V,mc) across the interval mc =
% [0,FW/atm.g], being mc the consumed fuel mass.
%
% As a result, the law VB(mc) is obtained, that is, how the flight velocity
% must change as the consumed fuel mass grows to keep the maximum range
% cruise.

rho      = atm.density(H);
R        = r4fRigidHe.mainRotor.R;
W0       = r4fRigidHe.inertia.W;
FW       = r4fRigidHe.weightConf.FW;
ConFWvec = linspace(0,FW,15);

 for i = 1:length(ConFWvec)
     
        ConFW = ConFWvec(i);
    negSARfun = @(V)(-getSAR(r4fRigidHe,V,H,ConFW,atm,vWT,FC4,options));
    
          VB0 = 5*sqrt((W0-ConFW)/(2*rho*pi*R^2));

          opt = optimset('TolFun',1,'TolX',10^-1);
        VB(i) = fminsearch(negSARfun,VB0,opt);
       SAR(i) = getSAR(r4fRigidHe,VB(i),H,ConFW,atm,vWT,FC4,options);
    
          VB0 = VB(i);

 
 end

         Rmax = (1/atm.g)*trapz(ConFWvec,SAR,2);

end
