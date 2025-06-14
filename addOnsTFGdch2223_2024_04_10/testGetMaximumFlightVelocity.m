% testGetMaxiumFlightVelocity

clear all
close all

setPlot;
set(0,'DefaultTextFontSize',16)
set(0,'DefaultAxesFontSize',16)
set(0,'defaultlinelinewidth',3)


options          = setHeroesRigidOptions2223;
atm              = getISA;
rigidHe          = rigidBo105e02223(atm);


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

r4fHe   = rigidHe2r4fRigidHe(rigidHe,engine,transmission,weightConf,atm,options);


% Plot of available power (maximum continuous) and required power at 
% H1 = 1000 m for horizontal wind velocities [50,100] m/s

vWT   = [0;0;0];
FC4   = {'gammaT',0,...
       'betaf0',0,...
       'vTOR',0,...
       'cs',0};
H1  = 1000;
VH1 = linspace(50,100,20);
ap  = getAvailablePowerFuns(r4fHe,options);
avp = ap.aPMC(H1);
rep = getRequiredPower(r4fHe,vWT,FC4,VH1,atm,H1,options);

figure (1)
plot(VH1,rep/1000,'ko-');
hold on
plot(VH1,ones(size(VH1))*avp/1000,'r-');


% Maximum horizontal velocity for heights [0,7000] m
Hv  = linspace(0,1000,10);
W   = r4fHe.inertia.W;
R   = r4fHe.mainRotor.R;
rho = atm.density(Hv(1)); 

VH0 = 5*sqrt(W/(2*rho*pi*R^2));
VH = getMaximumFlightVelocity(r4fHe,vWT,FC4,atm,Hv,VH0,options);
 
figure (2)
plot(VH*3.6,Hv,'ko-')
xlabel('$V_{\mathrm{max}}\,\mathrm{[km/h]}$');
ylabel('$H\,\mathrm{[m]}$');
grid on




   

