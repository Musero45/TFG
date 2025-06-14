function alpha = angleOfAttack4autorotation(theta,ndRotor)
% Example of usage:
% Plot the diagram of autorotation of the blades of the SuperPuma main
% rotor 
%
% atm   = getISA;
% he    = superPuma(atm);
% ndHe  = he2ndHe(he);
% theta0 = pi/180*linspace(2,30,101);
% alpha = angleOfAttack4autorotation(theta0,ndHe.mainRotor);
% phi   = alpha-theta0;
% figure(1)
% plot(180/pi*alpha,180/pi*phi)
% xlabel('$\alpha [^o]$'); ylabel('$\phi [^o]$')
%
% TODO
%

alpha  = zeros(size(theta));

delta2 = ndRotor.cddata(1);
delta1 = ndRotor.cddata(2);
delta0 = ndRotor.cddata(3);

a      = ndRotor.cldata(1);

p2        = delta2-a;
p0        = delta0;

for  i = 1:length(theta)
    p1        = delta1 + theta(i)*a;
    r         = roots([p2 p1 p0]);
    alpha(i)  = getRealPositive(r);
end
