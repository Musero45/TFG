% test of function getSEndurance


clear all
close all

setPlot;
set(0,'DefaultTextFontSize',16)
set(0,'DefaultAxesFontSize',16)
set(0,'defaultlinelinewidth',3)


options      = setHeroesRigidOptions2223;
atm          = getISA;
rigidHe      = rigidBo105e02223(atm);

%Values for the limiting transmission ratings are defined and other data
%needed to define the transmission

     Pmt     = 530*1000;
     Pmtto   = 580*1000;
     Pmtu    = 590*1000;
     etaTmr  = 0.15;
     etaTtr  = 0.12;
     transmissionType = @standardTransmission;
     name    = 'myTransmission';
     
     transmission = getTransmission4rHe(Pmt,Pmtto,Pmtu,etaTmr,etaTtr,...
                                          transmissionType,name);

%A weight structure is defined
     
     EW      = 1600*atm.g;
     PLW     = 300*atm.g;
     FW      = 400*atm.g;
     CW      = 2*75*atm.g;
     
weightConf   = getWeightConfiguration(EW,PLW,FW,CW);
     
% A power plant is selected

engine      = Arrius_2B2(atm,2);


% Finally the ready 4 flight helicoper is defined

r4fRigidHe   = rigidHe2r4fRigidHe(rigidHe,engine,transmission,weightConf,atm,options);

% Determination of SAR for a given altitude H and a given consumed fuel
% weight for different flight velocities

FC4   = {'gammaT',0,...
         'betaf0',0,...
         'vTOR',0,...
         'cs',0};

H     = 0;
vWT   = [0;0;0];
ConFW = 0;

V = linspace(1,90,20);

Send = getSEndurance(r4fRigidHe,V,H,ConFW,atm,vWT,FC4,options);

figure (1)
plot(V*3.6,Send/3600,'ko-');
xlabel('$V\,\mathrm{[km/h]}$');
ylabel('$\mathrm{SE}\,\mathrm{[h/kg]}$');
grid on


% Determination of SAR for two altitudes, and a grid of consumed fuel
% weight and velocities

Hvec  = [0 3000];
Vvec  = linspace(30,95,45);
CfVec = linspace(0,r4fRigidHe.weightConf.FW,16);

[cfM,vM,hM] = ndgrid(CfVec,Vvec,Hvec);

SEndM = zeros(size(cfM));

tic

for i = 1:numel(cfM)

SEndM(i) = getSEndurance(r4fRigidHe,vM(i),hM(i),cfM(i),atm,vWT,FC4,options);

end

toc

[maxSEnd1_M,i1] = max(SEndM(:,:,1),[],2);
[maxSEnd2_M,i2] = max(SEndM(:,:,2),[],2);

VmaxSEnd1 = Vvec(i1);
VmaxSEnd2 = Vvec(i2);

Emax1 = trapz(CfVec/atm.g,maxSEnd1_M)/3600;% h
Emax2 = trapz(CfVec/atm.g,maxSEnd2_M)/3600;% h


level   = [0.8 0.85 0.9 0.95 0.99];
maxSEnd1 = max(max(SEndM(:,:,1)));
maxSEnd2 = max(max(SEndM(:,:,2)));

lev1    = maxSEnd1*level/3600;
lev2    = maxSEnd2*level/3600;

figure (2)

subplot(1,2,1)
[C1,h1] = contour(cfM(:,:,1)/atm.g,vM(:,:,1)*3.6,SEndM(:,:,1)/3600,...
                  lev1);
clabel(C1,'Color','black');
h1.EdgeColor = 'k';
h1.LineWidth  = 2;
h1.LineStyle  = '-';
hold on
plot(CfVec/atm.g,VmaxSEnd1*3.6,'ro-');
xlabel('$\mathrm{Consumed\,fuel\,mass\,[kg]}$');
ylabel('$V\,\mathrm{[km/h]}$');
%legend([h1,h2],'$H\mathrm=0\,\mathrm{m}$','$H\mathrm=3000\,\mathrm{m}$');
grid on
title('$\mathrm{SE\, 0\,m}\,\mathrm{[h/kg]}$');

subplot(1,2,2)
[C2,h2] = contour(cfM(:,:,1)/atm.g,vM(:,:,1)*3.6,SEndM(:,:,2)/3600,...
                  lev2);
clabel(C2,'Color','black');
h2.EdgeColor = 'k';
h2.LineStyle = '-';
h2.LineWidth  = 2;
hold on
plot(CfVec/atm.g,VmaxSEnd2*3.6,'ro-');
xlabel('$\mathrm{Consumed\,fuel\,mass\,[kg]}$');
ylabel('$V\,\mathrm{[km/h]}$');
%legend([h1,h2],'$H\mathrm=0\,\mathrm{m}$','$H\mathrm=3000\,\mathrm{m}$');
grid on
title('$\mathrm{SE\, 3000\,m}\,\mathrm{[h/kg]}$');
