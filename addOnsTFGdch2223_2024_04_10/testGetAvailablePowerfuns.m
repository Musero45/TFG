% Tets ready for flight rigid helicopter r4fRigidHe and getAvailablePowerFuns

% A ready for flight ridig helicopter is a rigid helicopter with
% incorporated power plant, detailed transmission and weight data

% getAvailablePowerFuns(r4fRigidHe,options)
% functions handles @(H) where H is the altitude of the
% power available for maximum continous regime, take off regime and urgency
% regime. The available power is calculated considering the limitations 
% due to transmission rating for each regime
% 
% In this case a basic comparison of the available power in the maximum
% continuous power regime is ploted versus altitude and it is compared with
% required power in hover
%
%


clear all
close all

setPlot;
set(0,'DefaultTextFontSize',16)
set(0,'DefaultAxesFontSize',16)
set(0,'defaultlinelinewidth',3)


options      = setHeroesRigidOptions;
options.armonicInflowModel = @none;
options.mrForces = @completeF;
optionsNL    = options;

optionsNL.aeromechanicModel = @aeromechanicsNL;
optionsNL.mrForces          = @completeFNL;
optionsNL.mrMoments         = @aerodynamicMNL;
optionsNL.trForces          = @completeFNL;
optionsNL.trMoments         = @aerodynamicMNL;

atm          = getISA;
rigidHeLin   = rigidBo105e02223(atm);
rigidHeNLin  = rigidNLBo105e02223(atm);

%Values for the limiting transmission ratings are defined and other data
%needed to define the transmission

     Pmt     = 540*1000;
     Pmtto   = 580*1000;
     Pmtu    = 590*1000;
     etaTmr  = 0.15;
     etaTtr  = 0.07;
     transmissionType = @standardTransmission;
     name    = 'myTransmission';
     
     transmission = getTransmission4rHe(Pmt,Pmtto,Pmtu,etaTmr,etaTtr,...
                                        transmissionType,name);

%A weight structure is defined
     
     EW      = 1500*atm.g;
     PLW     = 300*atm.g;
     FW      = 400*atm.g;
     CW      = 2*75*atm.g;
     
weightConf   = getWeightConfiguration(EW,PLW,FW,CW);
     
% A power plant is selected

engine      = Arrius_2B2(atm,2);


% Finally the ready 4 flight helicoper is defined

r4fHeLin   = rigidHe2r4fRigidHe(rigidHeLin,engine,transmission,weightConf,atm,options);
r4fHeNLin  = rigidHe2r4fRigidHe(rigidHeNLin,engine,transmission,weightConf,atm,optionsNL);

%As an example of use, the function getAvailablePowerFuns is tested. This
%function provides functions handles @(H) (where H is the altitude) of the
%power available for maximum continous regime, take off regime and urgency
%regime. The available power is calculated considering the limitations 
%due to transmission rating for each regime

%The power required for flight in hover for differen altitudes H, is
%calculated both by a linear an non-linear trim analysis and it is
%compared with the evolution of the available power for the three regimes,
%maximum continuous, maximum take off and maximum urgency, considering the
%corresponding power ratings (mechanical limitations in the transmission).
%The intersecions of PM and the available power allows to identify the 
%maximum ceiling service, maximum height for take off and maximum height
%for hovering in urgency conditions.



Hv     = linspace(0,10000,10);
apfuns = getAvailablePowerFuns(r4fHeLin,options);
muWT   = [0;0;0];

FC     = {'VOR',0.005,...
          'gammaT',0,...
          'betaf0',0,...
          'Psi',0,...
          'cs',0};


apMCfun = apfuns.aPMC;
apTOfun = apfuns.aPTO;
apURfun = apfuns.aPUR;
Hv2     = linspace(0,Hv(end),2000);


%Hover analysis

for hi = 1:length(Hv)
    
    H  = Hv(hi);
    
    ndr4fHeLin  = rigidHe2ndHe(r4fHeLin,atm,H);
    ndr4fHeNLin = rigidHe2ndHe(r4fHeNLin,atm,H);
    
    ndTsLin     = getNdHeTrimState(ndr4fHeLin,muWT,FC,options);
    ndS0        = ndTsLin.solution;
    
    optionsNL.IniTrimCon = ndS0;
    ndTsNLin    = getNdHeTrimState(ndr4fHeNLin,muWT,FC,optionsNL);
    
    tSLin       = ndHeTrimState2HeTrimState(ndTsLin,r4fHeLin,...
                                            atm,H,options);
                                        
    tSNLin       = ndHeTrimState2HeTrimState(ndTsNLin,r4fHeNLin,...
                                            atm,H,optionsNL); 
                                        
    PMlin(hi)    = tSLin.Pow.PM;
    PMnLin(hi)   = tSNLin.Pow.PM;  
    
end


%The power required for levelled flight at H=0 m for differen altitudes 
%is calculated both by a linear an non-linear trim analysis and it is
%compared with the evolution of the available power for the three regimes,
%maximum continuous, maximum take off and maximum urgency, considering the
%corresponding power ratings (mechanical limitations in the transmission).
%The intersection of the required power PM and the available power at H=0 m
%corresponds to the maximum flight speed.

%level flight analysis at H=0 m.

H      = 0;
muWT   = [0;0;0];
V      = linspace(2,350/3.6,20);
VOR    = V/(r4fHeLin.mainRotor.Omega*r4fHeLin.mainRotor.R);

FC     = {'VOR',VOR,...
          'wTOR',0,...
          'betaf0',0,...
          'vTOR',0,...
          'cs',0};
      
FC0    = {'VOR',VOR(1),...
          'wTOR',0,...
          'betaf0',0,...
          'vTOR',0,...
          'cs',0};      

ndr4fHeLin  = rigidHe2ndHe(r4fHeLin,atm,H);
ndr4fHeNLin = rigidHe2ndHe(r4fHeNLin,atm,H);
    
ndTsLinLF0  = getNdHeTrimState(ndr4fHeLin,muWT,FC0,options);
ndS0LF      = ndTsLinLF0.solution;

ndTsLinLF   = getNdHeTrimState(ndr4fHeLin,muWT,FC,options);

optionsNL.IniTrimCon = ndS0LF;
ndTsNLinLF         = getNdHeTrimState(ndr4fHeNLin,muWT,FC,optionsNL);

    
tSLinLF        = ndHeTrimState2HeTrimState(ndTsLinLF,r4fHeLin,...
                                           atm,H,options); 
tSNLinLF       = ndHeTrimState2HeTrimState(ndTsNLinLF,r4fHeNLin,...
                                           atm,H,optionsNL); 
                                        
PMlinLF    = tSLinLF.Pow.PM;
PMnLinLF   = tSNLinLF.Pow.PM;  



figure (1)

plot(apMCfun(Hv2)/1000,Hv2);
hold on
plot(apTOfun(Hv2)/1000,Hv2);
plot(apURfun(Hv2)/1000,Hv2);
plot(PMlin/1000,Hv);
plot(PMnLin/1000,Hv);
xlabel('$\mathrm{Available\,power\,[kW]}$');
ylabel('$H\,\mathrm{[m]}$');
legend('$\mathrm{Max. Cont.}$','$\mathrm{Max. Take Off}$',...
       '$\mathrm{Max. Urg.}$','$P_{M\mathrm{l}}$','$P_{M\mathrm{nl}}$',...
       'Location','Best');
grid on

figure (2)

plot(V*3.6,ones(size(PMlinLF))*apMCfun(H)/1000);
hold on
plot(V*3.6,ones(size(PMlinLF))*apTOfun(H)/1000);
plot(V*3.6,ones(size(PMlinLF))*apURfun(H)/1000);
plot(V*3.6,PMlinLF/1000);
plot(V*3.6,PMnLinLF/1000);
xlabel('$V\,\mathrm{[km/h]}$');
ylabel('$\mathrm{Available\,power\,[kW]}$');
legend('$\mathrm{Max. Cont.}$','$\mathrm{Max.\,Take\,Off}$',...
       '$\mathrm{Max. Urg.}$','$P_{M\mathrm{l}}$','$P_{M\mathrm{nl}}$',...
       'Location','Best');
grid on


