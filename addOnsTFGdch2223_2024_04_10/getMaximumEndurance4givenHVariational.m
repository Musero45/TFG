function [Emax,VC,ConFWvec] = getMaximumEndurance4givenHVariational(r4fRigidHe,H,atm,vWT,FC4,options)
% [Emax,VC,ConFWvec] = getMaximumEndurance4givenHVariational(r4fRigidHe,H,atm,vWT,FC4,options)
% provides the maximum range Emax [s] and the corresponding vector of flight
% velocities VC [m/s] for a given altitude H, wind velocity vector vWT and
% flight condition 4, FC4.

% In this case, variational calculus is applied. The solution of the
% Euler-Langrange equation applied to the functional that provides the
% endurance as an integral of the specific endurance SE(V,mc) 
% along the interval mc = [0,FW/atm.g], being mc the consumed fuel mass.
%
% As a result, the law VC(mc) is obtained, that is, how the flight velocity
% must change as the consumed fuel mass grows to keep the maximum endurance
% cruise.

     rho = atm.density(H);
       R = r4fRigidHe.mainRotor.R;
      W0 = r4fRigidHe.inertia.W;
      FW = r4fRigidHe.weightConf.FW;
ConFWvec = linspace(0,FW,15);

 for i = 1:length(ConFWvec)
     
       ConFW = ConFWvec(i);
    negSEfun = @(V)(-getSEndurance(r4fRigidHe,V,H,ConFW,atm,vWT,FC4,options));
    
         VC0 = 2.5*sqrt((W0-ConFW)/(2*rho*pi*R^2));
         opt = optimset('TolFun',1,'TolX',10^-1);
       VC(i) = fminsearch(negSEfun,VC0,opt);
       
       SE(i) = getSAR(r4fRigidHe,VC(i),H,ConFW,atm,vWT,FC4,options);
    
         VC0 = VC(i);

 
 end

        Emax = (1/atm.g)*trapz(ConFWvec,SE,2);

end
