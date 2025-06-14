% testGetTrimmedFlightEnvelope


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

     Pmt     = 515*1000;
     Pmtto   = 580*1000;
     Pmtu    = 590*1000;
     etaTmr  = 0.15;
     etaTtr  = 0.12;
     transmissionType = @standardTransmission;
     name    = 'myTransmission';
     
     transmission = getTransmission4rHe(Pmt,Pmtto,Pmtu,etaTmr,etaTtr,...
                                          transmissionType,name);

%A weight structure is defined
     
     EW      = 1400*atm.g;
     PLW     = 300*atm.g;
     FW      = 400*atm.g;
     CW      = 2*75*atm.g;
     
weightConf   = getWeightConfiguration(EW,PLW,FW,CW);
     
% A power plant is selected

engine      = Allison250C28C(atm,2);


% Finally the ready 4 flight helicoper is defined

r4fHe   = rigidHe2r4fRigidHe(rigidHe,engine,transmission,weightConf,atm,options);

vWT   = [0;0;0];
FC4   = {'gammaT',0,...
       'betaf0',0,...
       'vTOR',0,...
       'cs',0};

N = 40;

FE = getTrimmedFlightEnvelope(r4fHe,vWT,FC4,atm,N,options);


figure (1)
plot(FE.Vmax*3.6,FE.Hmax,'o-');
xlabel('$V_{\mathrm{max}}\,\mathrm{[km/h]}$');
ylabel('$H_{\mathrm{max}}\,\mathrm{[m]}$');
grid on
