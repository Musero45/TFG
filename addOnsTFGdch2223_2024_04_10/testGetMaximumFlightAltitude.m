% testGetMaximumFlightAltitude

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


% Example of required power for flight at V = 1 m/s at altitudes 
% H = [0,8000] m, and available power at those altitudes

vWT   = [0;0;0];
FC4   = {'gammaT',0,...
       'betaf0',0,...
       'vTOR',0,...
       'cs',0};

Hv    = linspace(0,8000,10);
V     = 1;
ap    = getAvailablePowerFuns(r4fHe,options);
avp   = ap.aPMC(Hv);

for hi = 1:length(Hv)
    
    H = Hv(hi);
    
rep(hi) = getRequiredPower(r4fHe,vWT,FC4,V,atm,H,options);

end

figure (1)
plot(Hv,rep/1000,'ko-');
hold on
plot(Hv,avp/1000,'r-');
xlabel('$H\,\mathrm{[m]}$');
ylabel('$P\,\mathrm{[kW]}$');
legend('$\mathrm{Required}$','$\mathrm{Available}$','Location','Best');
grid on

% Maximum flight altitude for flight velocitites V = [1,100] m/s
Vvec  = linspace(1,100,10);

Hmax0 = 4000; 
Hmax = getMaximumFlightAltitude(r4fHe,vWT,FC4,atm,Vvec,Hmax0,options);

   
figure (3)

plot(Vvec(1:length(Hmax))*3.6,Hmax,'ko-');
xlim([0 500]);
ylim([0 15000]);
xlabel('$V\,\mathrm{[km/h]}$');
ylabel('$H_{\mathrm{max}}\,\mathrm{[m]}$');
grid on





   

