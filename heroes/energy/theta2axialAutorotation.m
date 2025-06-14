function [lambda_i,muz]  = theta2axialAutorotation(theta0,ndRotor)
%
% theta0 = pi/180*linspace(2,30,101);
%   Example of usage
% R = struct('sigma',0.05,'cldata',[6.13,0],'cddata',[0.1253,-4.88e-4,0.00671]);
% theta0 = pi/180*linspace(-1,15,11);
% [lambda_i,muz]=theta2axialAutorotation(theta0,R);
% plot(muz,180/pi*theta0)



sigma         = ndRotor.sigma;
a             = ndRotor.cldata(1);

alphaA        = angleOfAttack4autorotation(theta0,ndRotor);

CW            = sigma*a*alphaA/6;

nt            = length(theta0);
lambda_i      = zeros(nt,1);
muz           = zeros(nt,1);

for i =1:nt
faa           = @(x) systemAxialAutorotation(x,ndRotor,CW(i),alphaA(i));
X             = fsolve(faa,[-sqrt(CW(i)/2),0.2]);
lambda_i(i)   = X(1);
muz(i)        = X(2);

end

function F = systemAxialAutorotation(x,ndRotor,CW,alphaA)
lambda_i   = x(1);
muzp       = x(2);

cddata     = ndRotor.cddata;
CD         = polyval(cddata,alphaA);
sigma      = ndRotor.sigma;

F(1) = Cuerva(lambda_i,CW,0,0,0,0,muzp);
F(2) = -(lambda_i + muzp)*CW + sigma*CD/8;

