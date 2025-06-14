% test of function getSAR(r4fRigidHe,V,H,ConFW,atm,vWT,FC4,options);


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

% A weight structure is defined
     
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

  FC4 = {'gammaT',0,...
         'betaf0',0,...
         'vTOR',0,...
         'cs',0};

    H = 0;
  vWT = [0;0;0];
ConFW = 0;

    V = linspace(1,90,20);
  SAR = getSAR(r4fRigidHe,V,H,ConFW,atm,vWT,FC4,options);

figure (1)
plot(V*3.6,SAR/1000,'ko-');
xlabel('$V\,\mathrm{[km/h]}$');
ylabel('$\mathrm{SAR}\,\mathrm{[km/kg]}$');
grid on

% Determination of SAR for two altitudes, and a grid of consumed fuel
% weight and velocities

       Hvec = [0 3000];
       Vvec = linspace(30,95,43);
      CfVec = linspace(0,r4fRigidHe.weightConf.FW,24);
[cfM,vM,hM] = ndgrid(CfVec,Vvec,Hvec);

       SARM = zeros(size(cfM));

tic

for i = 1:numel(cfM)

SARM(i) = getSAR(r4fRigidHe,vM(i),hM(i),cfM(i),atm,vWT,FC4,options);

end

toc

[maxSAR1_M,i1] = max(SARM(:,:,1),[],2);
[maxSAR2_M,i2] = max(SARM(:,:,2),[],2);

VmaxSAR1 = Vvec(i1);
VmaxSAR2 = Vvec(i2);

Rmax1 = trapz(CfVec/atm.g,maxSAR1_M)/1000;% km
Rmax2 = trapz(CfVec/atm.g,maxSAR2_M)/1000;% km


level   = [0.8 0.85 0.9 0.95 0.99];
maxSAR1 = max(max(SARM(:,:,1)));
maxSAR2 = max(max(SARM(:,:,2)));

lev1    = maxSAR1*level/1000;
lev2    = maxSAR2*level/1000;

figure (2)

subplot(1,2,1)
[C1,h1] = contour(cfM(:,:,1)/atm.g,vM(:,:,1)*3.6,SARM(:,:,1)/1000,...
                  lev1);
clabel(C1,'Color','black');
h1.EdgeColor = 'k';
h1.LineWidth  = 2;
h1.LineStyle  = '-';
hold on
plot(CfVec/atm.g,VmaxSAR1*3.6,'ro-');
xlabel('$\mathrm{Consumed\,fuel\,mass\,[kg]}$');
ylabel('$V\,\mathrm{[km/h]}$');
grid on
title('$\mathrm{SAR\, 0\,m}\,\mathrm{[km/kg]}$');

subplot(1,2,2)
[C2,h2] = contour(cfM(:,:,1)/atm.g,vM(:,:,1)*3.6,SARM(:,:,2)/1000,...
                  lev2);
clabel(C2,'Color','black');
h2.EdgeColor = 'k';
h2.LineStyle = '-';
h2.LineWidth  = 2;
hold on
plot(CfVec/atm.g,VmaxSAR2*3.6,'ro-');
xlabel('$\mathrm{Consumed\,fuel\,mass\,[kg]}$');
ylabel('$V\,\mathrm{[km/h]}$');
grid on
title('$\mathrm{SAR\, 3000\,m}\,\mathrm{[km/kg]}$');
