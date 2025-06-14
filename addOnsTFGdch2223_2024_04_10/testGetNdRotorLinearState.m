% test of function getNdRotorLinearState

clear all
close all
setPlot

r2d = 180/pi;
options = setHeroesRigidOptions; 
options.armonicInflowModel = @none;

atm     = getISA;
H       = 0;

%Rigid helicopter for linear analysis
he      = rigidBo105(atm);
%he.mainRotor.e = 0.1*he.mainRotor.R;
ndHe    = rigidHe2ndHe(he,atm,H);
ndRotor = ndHe.mainRotor;

%Rotor flight condition
muxA   = 0.3;
muyA   = 0;
muzA   = 0;
omxAad = 0;
omyAad = 0;
omzAad = 0;

fC    = [muxA;muyA;muzA;omxAad;omyAad;omzAad];

%Rotor control angles
theta0  = 14*pi/180;
theta1C = 0*pi/180;
theta1S = 0*pi/180;

theta = [theta0;theta1C;theta1S];

%Gravity in reference system xA,yA,zA
GA    = [0; 0; -1];

%Non dimensional (natural) wind velocity in reference system xA,yA,zA
muWA   = [0; 0; 0];

x00lin = [0;0;0;...
                -sqrt(ndRotor.CW/2);0;0;...
                ndRotor.CW;0;0];
               
% Linear aeromechanics solution
ndRotLASol = getNdRotorAeromechSolution(ndRotor,theta,...
                                        fC,GA,muWA,options,x00lin);

nx   = 50;
npsi = 50;

cv = struct('alphaLin',10*pi/180,...% [rad]. Maximun angle of attack of linear region of cl
            'alphaMax',25*pi/180,...% [rad]. Angle of attack for máximum cl
            'Minc',0.3,...          % [-]. Maximum incompressibe flow Mach number 
            'Mcrit',0.8,...         % [-]. Critical Mach number
            'Mdd',0.9,...           % [-]. Drag divergence Mach number
            'kRedLim',0.2);         % [-]. Maximum reduced frequency for stationarity
        
ndRlState = getNdRotorLinearState(ndRotLASol,ndRotor,cv,nx,npsi,options);

xAM = ndRlState.xAM;
yAM = ndRlState.yAM;

figure (1)

pcolor(xAM,yAM,ndRlState.ndUT);
shading flat
xlabel('$x_{A}\,[-]$');
ylabel('$y_{A}\,[-]$');
a = colorbar;
a.Label.String = 'nd\itU_T\rm [-]';
hold on
[m,h] = contour(xAM,yAM,ndRlState.ndUT,'ShowText','on');
h.LineColor = 'k';
xlim([-1 1]);
ylim([-1 1]);
axis square
xlabel('$x_{A}\,[-]$');
ylabel('$y_{A}\,[-]$');
grid on
title('$\mathrm{nd}U_T\mathrm{[-]}$');


figure (2)

subplot(1,2,1)
pcolor(xAM,yAM,ndRlState.alpha*r2d);
caxis([-5 30]);
shading flat
xlabel('$x_{A}\,[-]$');
ylabel('$y_{A}\,[-]$');
a = colorbar;
a.Label.String = '\it\alpha\rm [deg]';
hold on
[m,h] = contour(xAM,yAM,ndRlState.alpha*r2d,[-10:1:10 11:2:20],'ShowText','on');
h.LineColor = 'k';
xlim([-1 1]);
ylim([-1 1]);
axis square
xlabel('$x_{A}\,[-]$');
ylabel('$y_{A}\,[-]$');
grid on
title('$\alpha\mathrm{[deg]}$');

subplot(1,2,2)
pcolor(xAM,yAM,ndRlState.alphaSim*r2d);
caxis([-5 30]);
shading flat
xlabel('$x_{A}\,[-]$');
ylabel('$y_{A}\,[-]$');
a = colorbar;
a.Label.String = '\it\alpha_{Sim}\rm [deg]';
hold on
[m,h] = contour(xAM,yAM,ndRlState.alphaSim*r2d,[-10:1:10 11:2:20],'ShowText','on');
h.LineColor = 'k';
[m1,h1] = contour(xAM,yAM,ndRlState.alphaSim*r2d,[cv.alphaLin*r2d cv.alphaLin*r2d],'ShowText','on');
h1.LineColor = 'r';
h1.LineWidth = 2;
xlim([-1 1]);
ylim([-1 1]);
axis square
xlabel('$x_{A}\,[-]$');
ylabel('$y_{A}\,[-]$');
grid on
title('$\alpha_{Sim}\mathrm{[deg]}$');

figure (3)

pcolor(xAM,yAM,ndRlState.ndUP);
caxis([-5 10]);
shading flat
xlabel('$x_{A}\,[-]$');
ylabel('$y_{A}\,[-]$');
a = colorbar;
a.Label.String = 'nd\itU_P\rm [-]';
hold on
[m,h] = contour(xAM,yAM,ndRlState.ndUP,'ShowText','on');
h.LineColor = 'k';
xlim([-1 1]);
ylim([-1 1]);
axis square
xlabel('$x_{A}\,[-]$');
ylabel('$y_{A}\,[-]$');
grid on
title('$\mathrm{nd}U_P\mathrm{[-]}$');

figure (4)

subplot(1,2,1)
pcolor(xAM,yAM,ndRlState.phiang*r2d);
caxis([-90 10]);
shading flat
xlabel('$x_{A}\,[-]$');
ylabel('$y_{A}\,[-]$');
a = colorbar;
a.Label.String = '\it\phi\rm [-]';
hold on
[m,h] = contour(xAM,yAM,ndRlState.phiang*r2d,[-10:1:10],'ShowText','on');
h.LineColor = 'k';
xlim([-1 1]);
ylim([-1 1]);
axis square
xlabel('$x_{A}\,[-]$');
ylabel('$y_{A}\,[-]$');
grid on
title('$\phi\mathrm{[deg]}$');

subplot(1,2,2)
pcolor(xAM,yAM,ndRlState.phiangSim*r2d);
caxis([-90 10]);
shading flat
xlabel('$x_{A}\,[-]$');
ylabel('$y_{A}\,[-]$');
a = colorbar;
a.Label.String = '\it\phi_{Sim}\rm [-]';
hold on
[m,h] = contour(xAM,yAM,ndRlState.phiangSim*r2d,[-10:1:10],'ShowText','on');
h.LineColor = 'k';
xlim([-1 1]);
ylim([-1 1]);
axis square
xlabel('$x_{A}\,[-]$');
ylabel('$y_{A}\,[-]$');
grid on
title('$\phi_{Sim}\mathrm{[deg]}$');


figure (5)

pcolor(xAM,yAM,ndRlState.cl);
caxis([-0.5 2]);
shading flat
xlabel('$x_{A}\,[-]$');
ylabel('$y_{A}\,[-]$');
a = colorbar;
a.Label.String = '\itc_l\rm [-]';
hold on
[m,h] = contour(xAM,yAM,ndRlState.cl,[-1:0.2:2],'ShowText','on');
h.LineColor = 'k';
xlim([-1 1]);
ylim([-1 1]);
axis square
xlabel('$x_{A}\,[-]$');
ylabel('$y_{A}\,[-]$');
grid on
title('$c_l\mathrm{[-]}$');

figure (6)

pcolor(xAM,yAM,ndRlState.Mloc);
shading flat
a = colorbar;
a.Label.String = 'M [-]';
hold on
[m,h] = contour(xAM,yAM,ndRlState.Mloc,[0:0.1:1.5],'ShowText','on');
h.LineColor = 'k';
xlim([-1 1]);
ylim([-1 1]);
axis square
xlabel('$x_{A}\,[-]$');
ylabel('$y_{A}\,[-]$');
grid on
title('$\mathrm{M} [-]$');

figure (7)

subplot(1,2,1)
pcolor(xAM,yAM,ndRlState.dCTb_dx);
caxis([min(min(ndRlState.dCTb_dx)) 0.05*max(max(ndRlState.dCTb_dx))]);
shading flat
b = colorbar;
b.Label.String = 'd\itC_{Tb}\rm/d\itx\rm [-]';
hold on
[m1,h1] = contour(xAM,yAM,ndRlState.dCTb_dx,[10],'ShowText','on');
h1.LineColor = 'k';
xlim([-1 1]);
ylim([-1 1]);
axis square
xlabel('$x_{A}\,[-]$');
ylabel('$y_{A}\,[-]$');
grid on
title('$\mathrm{d}C_{Tb}\mathrm{/d}x\mathrm{ [-]}$');

subplot(1,2,2)
pcolor(xAM,yAM,ndRlState.dCTb_dxSim);
caxis([min(min(ndRlState.dCTb_dx)) 0.05*max(max(ndRlState.dCTb_dx))]);
shading flat
b = colorbar;
b.Label.String = 'd\itC_{TbSim}\rm/d\itx\rm [-]';
hold on
[m1,h1] = contour(xAM,yAM,ndRlState.dCTb_dxSim,[10],'ShowText','on');
h1.LineColor = 'k';
xlim([-1 1]);
ylim([-1 1]);
axis square
xlabel('$x_{A}\,[-]$');
ylabel('$y_{A}\,[-]$');
grid on
title('$\mathrm{d}C_{TbSim}\mathrm{/d}x\mathrm{ [-]}$');


figure (8)

pcolor(xAM,yAM,ndRlState.betaM*r2d);
%caxis([min(min(ndRlState.betaM)) 0.05*max(max(ndRlState.betaM))]);
shading flat
b = colorbar;
b.Label.String = '\it\beta\rm [deg]';
hold on
[m1,h1] = contour(xAM,yAM,ndRlState.betaM*r2d,[10],'ShowText','on');
h1.LineColor = 'k';
xlim([-1 1]);
ylim([-1 1]);
axis square
xlabel('$x_{A}\,[-]$');
ylabel('$y_{A}\,[-]$');
grid on
title('$\beta\mathrm{ [deg]}$');


figure (9)

pcolor(xAM,yAM,ndRlState.dCHb_dx);
caxis([min(min(ndRlState.dCHb_dx)) 0.05*max(max(ndRlState.dCHb_dx))]);
shading flat
b = colorbar;
b.Label.String = 'd\itC_{Hb}\rm/d\itx\rm [-]';
hold on
[m1,h1] = contour(xAM,yAM,ndRlState.dCHb_dx,[10],'ShowText','on');
h1.LineColor = 'k';
xlim([-1 1]);
ylim([-1 1]);
axis square
xlabel('$x_{A}\,[-]$');
ylabel('$y_{A}\,[-]$');
grid on
title('$\mathrm{d}C_{Hb}\mathrm{/d}x\mathrm{ [-]}$');

figure (10)

pcolor(xAM,yAM,ndRlState.dCYb_dx);
caxis([min(min(ndRlState.dCYb_dx)) 0.05*max(max(ndRlState.dCYb_dx))]);
shading flat
b = colorbar;
b.Label.String = 'd\itC_{Yb}\rm/d\itx\rm [-]';
hold on
[m1,h1] = contour(xAM,yAM,ndRlState.dCYb_dx,[10],'ShowText','on');
h1.LineColor = 'k';
xlim([-1 1]);
ylim([-1 1]);
axis square
xlabel('$x_{A}\,[-]$');
ylabel('$y_{A}\,[-]$');
grid on
title('$\mathrm{d}C_{Yb}\mathrm{/d}x\mathrm{ [-]}$');


figure (11)

pcolor(xAM,yAM,ndRlState.dCFTb_dx);
caxis([0.01*min(min(ndRlState.dCFTb_dx)) max(max(ndRlState.dCFTb_dx))]);
shading flat
b = colorbar;
b.Label.String = 'd\itC_{FTb}\rm/d\itx\rm [-]';
hold on
[m1,h1] = contour(xAM,yAM,ndRlState.dCFTb_dx,[-20:2.5:50]*10^(-5),'ShowText','on');
h1.LineColor = 'k';
xlim([-1 1]);
ylim([-1 1]);
axis square
xlabel('$x_{A}\,[-]$');
ylabel('$y_{A}\,[-]$');
grid on
title('$\mathrm{d}C_{FTb}\mathrm{/d}x\mathrm{ [-]}$');


figure (12)

pcolor(xAM,yAM,ndRlState.dCPb_dx);
caxis([0.1*min(min(ndRlState.dCPb_dx)) max(max(ndRlState.dCPb_dx))]);
shading flat
b = colorbar;
b.Label.String = 'd\itC_{Pb}\rm/d\itx\rm [-]';
hold on
[m1,h1] = contour(xAM,yAM,ndRlState.dCPb_dx,[-20:2.5:50]*10^(-5),'ShowText','on');
h1.LineColor = 'k';
xlim([-1 1]);
ylim([-1 1]);
axis square
xlabel('$x_{A}\,[-]$');
ylabel('$y_{A}\,[-]$');
grid on
title('$\mathrm{d}C_{Pb}\mathrm{/d}x\mathrm{ [-]}$');

figure (13)

pcolor(xAM,yAM,ndRlState.lambdai);
%caxis([0.1*min(min(ndRlState.lambdai)) max(max(ndRlState.lambdai))]);
shading flat
b = colorbar;
b.Label.String = '\it\lambda_i\rm [-]';
hold on
[m1,h1] = contour(xAM,yAM,ndRlState.lambdai,[10],'ShowText','on');
h1.LineColor = 'k';
xlim([-1 1]);
ylim([-1 1]);
axis square
xlabel('$x_{A}\,[-]$');
ylabel('$y_{A}\,[-]$');
grid on
title('$\lambda_i\mathrm{ [-]}$');









