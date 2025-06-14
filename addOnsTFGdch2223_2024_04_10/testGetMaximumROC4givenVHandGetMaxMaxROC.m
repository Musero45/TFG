% testGetMaximumROC4givenVHandGetMaxMaxROC

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

% A weight structure is defined
     
     EW      = 1400*atm.g;
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
FC3   = {'betaf0',0,...
         'vTOR',0,...
         'cs',0};
     
H = 1000;
VH = linspace(1,90,20);
   

             VVmax = getMaximumROC4givenVH(r4fHe,vWT,FC3,atm,H,VH,options);  

% Now, the horizontal flight velocity component for maximum of maxima
% vertical velocity flight component is calculated             
             
[VVmaxmax,VHmaxVV] = getMaxMaxROC(r4fHe,vWT,FC3,atm,H,options);

figure (1)
plot(VH*3.6,VVmax,'ko-');
hold on
plot(VHmaxVV*3.6,VVmaxmax,'ro-');
xlabel('$V_H\,\mathrm{[km/h]}$');
ylabel('$V_V\,\mathrm{[m/s]}$');
grid on

   



   

