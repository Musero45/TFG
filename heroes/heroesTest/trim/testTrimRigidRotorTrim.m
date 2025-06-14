function io = testTrimRigidRotorTrim

close all

% atm     = getISA;
% he      = rigidBo105(atm);
% 
% rho0    = atm.rho0;
% g       = atm.g;
% ndHe    = rigidHe2ndHe(he,rho0,g);

ndRotor   = struct( ...
            'sigma0',0.05, ...
            'theta1',0.0,...
            'cldata',[5.73,0],...
            'cddata',[0.01,0,0],...
            'CW',0.007 ...
);

%ndHe.mainRotor.ead = 0;
gammaT     = 0;
n          = length(gammaT);

muT        = 0:.0125:.5;
m          = length(muT);
ThetaA     = zeros(n,1);
theta      = zeros(n,2);
CQ         = zeros(n,1);
lambdai    = zeros(n,1);


for i = 1:n
    muxT = -muT*cos(gammaT(i));
    muzT = muT*sin(gammaT(i));
    for j = 1:m
        mu(1)          = muxT(j);
        mu(2)          = muzT(j);
        X   = rigidRotorTrim_s(mu,ndRotor);

        ThetaA(j)  = X(1);
        theta(j,:) = X(2:3);
        CQ(j)      = X(4);
        lambdai(j) = X(5);

    end
end

r2d  = 180/pi;

figure(1)
plot(muT,ThetaA*r2d)
ylabel('\Theta_A'); xlabel('V/\Omega R')
v=axis; axis([v(1) v(2) -0.6 0.0])

figure(2)
plot(muT,theta(:,1)*r2d)
ylabel('\theta_0'); xlabel('V/\Omega R')
v=axis; axis([v(1) v(2) 10 15])

figure(3)
plot(muT,theta(:,2)*r2d)
ylabel('\theta_{1S}'); xlabel('V/\Omega R')
v=axis; axis([v(1) v(2) -14 0])

figure(4)
plot(muT,CQ)
ylabel('C_Q'); xlabel('V/\Omega R')
v=axis; axis([v(1) v(2) 0 5e-4])

figure(5)
plot(muT,lambdai)
ylabel('\lambda_i'); xlabel('V/\Omega R')
v=axis; axis([v(1) v(2) -0.06 0.01])

io = 1;
