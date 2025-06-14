function flappingtest

atm     = getISA;
he      = rigidBo105(atm);
rho0    = atm.rho0;
g       = atm.g;
ndHe    = rigidHe2ndHe(he,rho0,g);
ndRotor = ndHe.mainRotor;

%Simplifications
ndRotor.ead = 0;
ndRotor.RIZB = 1;
ndRotor.RITB = 0;
ndRotor.theta1 = 0;


CT0    = ndHe.inertia.CW;
lambda = [-sqrt(CT0/2); 0; 0]; %Does not matter in this test
mu     = [0; 0; 0];
muW    = [0; 0; 0];
GA     = [0; 0; 1];

%Test #1 Figures 5.33 (a) & (b) Teoría de los Helicópteros page 240
%DIFERENCES OBSERVED BETWEEN BOOK AND MAPLE PLOTS. SEE
%HEROES/MWS/MATRICES_BATIMIENTO_SEPARADAS.MW
SBeta = [0; .5; 1];
ndRotor.gamma = 7;

muxA = 0:.001:.5;

figure(1)
axis([0 .5 -1.5 1.5])
xlabel('\mu_{xA}'); ylabel('d\beta_{1C}/d\theta_{1S}  d\beta_{1S}/d\theta_{1C}');

figure(2)
axis([0 .5 -.4 .6])
xlabel('\mu_{xA}'); ylabel('d\beta_{1C}/d\theta_{1C}  d\beta_{1S}/d\theta_{1S}');

for i = 1:length(SBeta);
    ndRotor.SBeta = SBeta(i);
    for j =1:length(muxA);
        mu(1) = muxA(j);
        [control, dump] = flappingDer(lambda,mu,GA,muW,ndRotor);
        b1ct1c(i,j) = control(1);
        b1ct1s(i,j) = control(2);
        b1st1c(i,j) = control(3);
        b1st1s(i,j) = control(4);
    end
    figure(1)
    hold on
    plot(muxA,b1ct1s(i,:),'--k','LineWidth',2);
    plot(muxA,b1st1c(i,:),'-k','LineWidth',2);
    hold off
    figure(2)
    hold on
    plot(muxA,b1ct1c(i,:),'-k','LineWidth',2);
    plot(muxA,b1st1s(i,:),'--k','LineWidth',2);
    hold off
    
end

%Test #2 Figures 5.33 (c) & (d) Teoría de los Helicópteros page 240
%DIFERENCES OBSERVED BETWEEN BOOK AND MAPLE PLOTS. SEE
%HEROES/MWS/MATRICES_BATIMIENTO_SEPARADAS.MW
gamma = [6; 10; 14];
ndRotor.SBeta = .2;

muxA = 0:.001:.5;

figure(3)
axis([0 .5 .8 1.5])
xlabel('\mu_{xA}'); ylabel('-d\beta_{1C}/d\theta_{1S}  d\beta_{1S}/d\theta_{1C}');

figure(4)
axis([0 .5 -.4 .25])
xlabel('\mu_{xA}'); ylabel('d\beta_{1C}/d\theta_{1C}  d\beta_{1S}/d\theta_{1S}');

for i = 1:length(gamma);
    ndRotor.gamma = gamma(i);
    for j =1:length(muxA);
        mu(1) = muxA(j);
        [control, dump] = flappingDer(lambda,mu,GA,muW,ndRotor);
        b1ct1c(i,j) = control(1);
        b1ct1s(i,j) = control(2);
        b1st1c(i,j) = control(3);
        b1st1s(i,j) = control(4);
    end
    figure(3)
    hold on
    plot(muxA,-b1ct1s(i,:),'--k','LineWidth',2);
    plot(muxA,b1st1c(i,:),'-k','LineWidth',2);
    hold off
    figure(4)
    hold on
    plot(muxA,b1ct1c(i,:),'-k','LineWidth',2);
    plot(muxA,b1st1s(i,:),'--k','LineWidth',2);
    hold off
end

end