% test of function getRange4givenVH_AllM


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

FC4   = {'gammaT',0,...
       'betaf0',0,...
       'vTOR',0,...
       'cs',0};

    H = 0;
  vWT = [0;0;0];
    V = linspace(1,90,20);

tic
  RM1 = getRange4givenVHM1(r4fRigidHe,V,H,atm,vWT,FC4,options);
toc

tic
  RM2 = getRange4givenVHM2(r4fRigidHe,V,H,atm,vWT,FC4,options);
toc

figure (1)

plot(V*3.6,RM1/1000,'ko-');
hold on
plot(V*3.6,RM2/1000,'ro-');
xlabel('$V\,\mathrm{[km/h]}$');
ylabel('$\mathrm{R}\,\mathrm{[km]}$');
legend('$\mathrm{M1}$','$\mathrm{M2}$');
grid on


