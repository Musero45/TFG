
function [VVmaxmax,VHmaxVV] = getMaxMaxROC(r4fHe,vWT,FC3,atm,H,options)
% 
% getMaxMaxROC(r4fHe,vWT,FC3,atm,H,VH0,options)
% provides the maximum of maxima vertical velocity VVmax in trim condition
% atmosphere atm, altitude H, wind velocity vector in ground reference 
% system vWT and extra flight conditions FC3 (three extra flight conditions).
%
% Calcutation options are specified in variable options.
% The initial iteration condition for the flight horizontal velocity 
% component is VH0.  

 negVVmaxfun = @(VH)(-getMaximumROC4givenVH(r4fHe,vWT,FC3,atm,H,VH,options));
 
    W    = r4fHe.inertia.W;
    R    = r4fHe.mainRotor.R;
    rho  = atm.density(H);

     VH0 = 2.5*sqrt(W/(2*rho*pi*R^2));
    opt  = optimset('TolFun',1,'TolX',10^-1,'Display','iter');
 VHmaxVV = fminsearch(negVVmaxfun,VH0,opt);

VVmaxmax = getMaximumROC4givenVH(r4fHe,vWT,FC3,atm,H,VHmaxVV,options);

end






