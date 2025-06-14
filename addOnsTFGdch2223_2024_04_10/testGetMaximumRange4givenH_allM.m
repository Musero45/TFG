% test of function getMaximumRange4givenH_allM


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

FC4   = {'gammaT',0,...
       'betaf0',0,...
       'vTOR',0,...
       'cs',0};

H     = 0;
vWT   = [0;0;0];
ConFW = 0;


% First the R(V) for the given height is calculated
V = linspace(1,90,20);
R1 = getRange4givenVHM1(r4fRigidHe,V,H,atm,vWT,FC4,options);
R2 = getRange4givenVHM2(r4fRigidHe,V,H,atm,vWT,FC4,options);


% Then, the maximum value for Range and the corresponding velocity is
% calculated

[Rmax1,VB1,ConFWvec1] = getMaximumRange4givenHM1(r4fRigidHe,H,atm,vWT,FC4,options);
[Rmax2,VB2,ConFWvec2] = getMaximumRange4givenHM2(r4fRigidHe,H,atm,vWT,FC4,options);
[Rmax3,VB3,ConFWvec3] = getMaximumRange4givenHVariational(r4fRigidHe,H,atm,vWT,FC4,options);

figure (1)

plot(V*3.6,R1/1000,'ko-');
hold on
plot(V*3.6,R2/1000,'b.-');
plot(VB1*3.6,Rmax1/1000,'rs');
plot(VB2*3.6,Rmax2/1000,'gs');
xlabel('$V\,\mathrm{[km/h]}$');
ylabel('$\mathrm{R}\,\mathrm{[km]}$');
grid on

figure (2)

plot(ConFWvec3/atm.g,VB3*3.6,'ko-');
hold on
xlabel('$\mathrm{Consumed\,Fuel\,Weight\,[kg]}$');
ylabel('$V_\mathrm{maxSAR}\,\mathrm{[km/h]}$');
grid on

