%Test of getNdRotorAeromechSolution

clear all
close all
setPlot
set(0,'DefaultTextFontSize',16)
set(0,'DefaultAxesFontSize',16)


r2d = 180/pi;
options = setHeroesRigidOptions; 
options.armonicInflowModel = @none;
options.MaxIter = 400;
atm     = getISA;
H       = 0;

%Rigid helicopter for linear analysis
he1      = rigidBo105e02223(atm);
ndHe1    = rigidHe2ndHe(he1,atm,H);
ndRotor1 = ndHe1.mainRotor;

%Rigid helicopter for non-linear analysis
%he2      = rigidNLBo105(atm);

lmr = linspace(0,1,29);
psimrvect = linspace(0,2*pi,181);
%he2      = rigidNLGazelle(atm,lmr,psimrvect);
he2      = rigidNLBo105e02223(atm);
ndHe2    = rigidHe2ndHe(he2,atm,H);
ndRotor2 = ndHe2.mainRotor;

%Rotor flight condition
muxA   = 0.001;
muyA   = 0;
muzA   = 0;
omxAad = 0;
omyAad = 0;
omzAad = 0;

fC    = [muxA;muyA;muzA;omxAad;omyAad;omzAad];

%Rotor control angles
theta0  = 10*pi/180;
theta1C = 0;
theta1S = 0;

theta = [theta0;theta1C;theta1S];

%Gravity in reference system xA,yA,zA
GA    = [0; 0; -1];

%Non dimensional (natural) wind velocity in reference system xA,yA,zA
muW   = [0; 0; 0];

x00lin = [0;0;0;...
                -sqrt(ndRotor1.CW/2);0;0;...
                ndRotor1.CW;0;0];
               
% Linear aeromechanics solution
ndRotLASol = getNdRotorAeromechSolution(ndRotor1,theta,...
                                        fC,GA,muW,options,x00lin);
                                    
% Non linear aeromechanics solution 
% Since the solution of the non-linear problem is more computationaly
% costly, we provide as iniial condition, the solution of the linear
% problem to facilitate the non linear solution

options.aeromechanicModel = @aeromechanicsNL;

x00Nl = [ndRotLASol.beta0;ndRotLASol.beta1C;ndRotLASol.beta1S;...
                ndRotLASol.lambda0;ndRotLASol.lambda1C;ndRotLASol.lambda1S;...
                ndRotLASol.CT0;ndRotLASol.CT1C;ndRotLASol.CT1S];

ndRotNLASol = getNdRotorAeromechSolution(ndRotor2,theta,...
                                        fC,GA,muW,options,x00Nl);
                                    
                                    
%Linear and non-linear analysis of CT when increasing theta0  

theta0v = pi/180*linspace(0,90,41);

for ti = 1:length(theta0v);
    
    theta(1) = theta0v(ti);
    
    options.aeromechanicModel = @aeromechanicsLin;
    
    ndRotLASol = getNdRotorAeromechSolution(ndRotor1,theta,...
                                        fC,GA,muW,options,x00lin);
                                    
    x00lin = [ndRotLASol.beta0;ndRotLASol.beta1C;ndRotLASol.beta1S;...
                ndRotLASol.lambda0;ndRotLASol.lambda1C;ndRotLASol.lambda1S;...
                ndRotLASol.CT0;ndRotLASol.CT1C;ndRotLASol.CT1S];                         

% Non linear aeromechanics solution 
% Since the solution of the non-linear problem is more computationaly
% costly, we provide as initial condition, the solution of the linear
% problem to facilitate the non linear solution

options.aeromechanicModel = @aeromechanicsNL;

            
ndRotNLASol = getNdRotorAeromechSolution(ndRotor2,theta,...
                                        fC,GA,muW,options,x00Nl);
                                    
x00Nlin = [ndRotNLASol.beta0;ndRotNLASol.beta1C;ndRotNLASol.beta1S;...
                ndRotNLASol.lambda0;ndRotNLASol.lambda1C;ndRotNLASol.lambda1S;...
                ndRotNLASol.CT0;ndRotNLASol.CT1C;ndRotNLASol.CT1S];                                    
 
                                    
CTlin(ti)      = ndRotLASol.CT0; 
beta0lin(ti)   = ndRotLASol.beta0;
lambdaiLin(ti) = ndRotLASol.lambda0;
flaglin(ti)    = ndRotLASol.flag;

CTnLin(ti)      = ndRotNLASol.CT0; 
beta0nLin(ti)   = ndRotNLASol.beta0;
lambdaiNlin(ti) = ndRotNLASol.lambda0;
flagNlin(ti)    = ndRotNLASol.flag;

end

figure (1)

subplot(1,4,1)
plot(theta0v*r2d,CTlin,'r-');
hold on
plot(theta0v*r2d,CTnLin,'ko-');
xlabel('$\theta_{0}\,\mathrm{[deg]}$');
ylabel('$C_{T}\,\mathrm{[-]}$');
legend('$\mathrm{Lin}$','$\mathrm{Nlin}$');

grid on

subplot(1,4,2)
plot(theta0v*r2d,lambdaiLin,'r-');
hold on
plot(theta0v*r2d,lambdaiNlin,'k-');
xlabel('$\theta_{0}\,\mathrm{[deg]}$');
ylabel('$\lambda_{i}\,\mathrm{[-]}$');
legend('$\mathrm{Lin}$','$\mathrm{Nlin}$');
grid on


subplot(1,4,3)
plot(theta0v*r2d,beta0lin*r2d,'r-');
hold on
plot(theta0v*r2d,beta0nLin*r2d,'k-');
xlabel('$\theta_{0}\,\mathrm{[deg]}$');
ylabel('$\beta_{0}\,\mathrm{[deg]}$');
legend('$\mathrm{Lin}$','$\mathrm{Nlin}$');

grid on

subplot(1,4,4)
plot(theta0v*r2d,flaglin,'r-');
hold on
plot(theta0v*r2d,flagNlin,'ko-');
xlabel('$\theta_{0}\,\mathrm{[deg]}$');
ylabel('$Flags\,\mathrm{[-]}$');
legend('$\mathrm{Lin}$','$\mathrm{Nlin}$');

grid on

Hv = linspace(0,8000,5);


[THM,HM] = ndgrid(theta0v,Hv);
Re1      = zeros(size(THM));
Re2      = zeros(size(THM));
CTMlin   = zeros(size(THM));
CTMnLin  = zeros(size(THM));
Tu1      = zeros(size(THM));
Tu2      = zeros(size(THM));



for i = 1:numel(THM)
    
   H        = HM(i);
   theta(1) = THM(i);
    
   ndHe1    = rigidHe2ndHe(he1,atm,H);
   ndRotor1 = ndHe1.mainRotor; 
   
   ndHe2    = rigidHe2ndHe(he2,atm,H);
   ndRotor2 = ndHe2.mainRotor;
   
   options.aeromechanicModel = @aeromechanicsLin;
    
    ndRotLASol = getNdRotorAeromechSolution(ndRotor1,theta,...
                                        fC,GA,muW,options,x00lin);
                                    
    x00lin = [ndRotLASol.beta0;ndRotLASol.beta1C;ndRotLASol.beta1S;...
                ndRotLASol.lambda0;ndRotLASol.lambda1C;ndRotLASol.lambda1S;...
                ndRotLASol.CT0;ndRotLASol.CT1C;ndRotLASol.CT1S];                         

% Non linear aeromechanics solution 
% Since the solution of the non-linear problem is more computationaly
% costly, we provide as initial condition, the solution of the linear
% problem to facilitate the non linear solution

options.aeromechanicModel = @aeromechanicsNL;

            
ndRotNLASol = getNdRotorAeromechSolution(ndRotor2,theta,...
                                        fC,GA,muW,options,x00Nl);
                                    
x00Nlin = [ndRotNLASol.beta0;ndRotNLASol.beta1C;ndRotNLASol.beta1S;...
                ndRotNLASol.lambda0;ndRotNLASol.lambda1C;ndRotNLASol.lambda1S;...
                ndRotNLASol.CT0;ndRotNLASol.CT1C;ndRotNLASol.CT1S]; 
   
   
   Re1(i)     = ndHe1.mainRotor.Re;
   Re2(i)     = ndHe2.mainRotor.Re;
   CTMlin(i)  = ndRotLASol.CT0;
   CTMnLin(i) = ndRotNLASol.CT0;
   
   Tu1(i)     = ndHe1.Tu;
   Tu2(i)     = ndHe2.Tu;
   
   
end
   
figure (2)

subplot(1,2,1)
[m,h]   = contour(THM*r2d,CTMlin,HM,[Hv],'ShowText','on');
h.LineColor = 'r';
h.LineWidth = 2;
hold on
[m1,h1] = contour(THM*r2d,CTMnLin,HM,[Hv],'ShowText','on');
h1.LineColor = 'k';
h1.LineWidth = 2;
xlabel('$\theta_{0}\,\mathrm{[deg]}$');
ylabel('$C_{T}\,\mathrm{[-]}$');
legend('$\mathrm{Lin}$','$\mathrm{Nlin}$');
grid on

subplot(1,2,2)
[m,h]   = contour(THM*r2d,Re1,HM,[Hv],'ShowText','on');
h.LineColor = 'r';
h.LineWidth = 2;
hold on
[m1,h1] = contour(THM*r2d,Re2,HM,[Hv],'ShowText','on');
h1.LineColor = 'k';
h1.LineWidth = 2;
xlabel('$\theta_{0}\,\mathrm{[deg]}$');
ylabel('$C_{T}\,\mathrm{[-]}$');
legend('$\mathrm{Lin}$','$\mathrm{Nlin}$');
grid on

figure (3)

[m,h]   = contour(THM*r2d,CTMlin.*Tu1,HM,[Hv],'ShowText','on');
h.LineColor = 'r';
h.LineWidth = 2;
hold on
[m1,h1] = contour(THM*r2d,CTMnLin.*Tu2,HM,[Hv],'ShowText','on');
h1.LineColor = 'k';
h1.LineWidth = 2;
plot(THM(:,1)*r2d,ones(size(THM,1))*he1.inertia.W,'b--');
ylim([-10^3 10^5]);
xlabel('$\theta_{0}\,\mathrm{[deg]}$');
ylabel('$T\,\mathrm{[N]}$');
legend('$\mathrm{Lin}$','$\mathrm{Nlin}$','$\mathrm{MTOW}$');
grid on
