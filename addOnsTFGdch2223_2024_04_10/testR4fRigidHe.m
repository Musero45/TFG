% Tets ready for flight rigid helicopter r4fRigidHe

% A ready for flight ridig helicopter is a rigid helicopter with
% incorporated power plant, detailed transmission and weight data
% 


clear all
close all

setPlot;
set(0,'DefaultTextFontSize',16)
set(0,'DefaultAxesFontSize',16)
set(0,'defaultlinelinewidth',3)


options      = setHeroesRigidOptions;
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


%As an example of use, the function getAvailablePowerFuns is tested. This
%function provides functions handles @(H) where H is the altitude of the
%power available for maximum continous regime, take off regime and urgency
%regime. The available power is calculated considering the limitations 
%due to transmission rating for each regime

H = linspace(0,10000);

%apMC = getAvailableMaxContPower(r4fRigidHe,H,options);
%apTO = getAvailableTakeOffPower(r4fRigidHe,H,options);
%apUR = getAvailableMaxUrgencyPower(r4fRigidHe,H,options);
apfuns = getAvailablePowerFuns(r4fRigidHe,options);

apMCfun = apfuns.aPMC;
apTOfun = apfuns.aPTO;
apURfun = apfuns.aPUR;


figure (1)

plot(apMCfun(H)/1000,H);
hold on
plot(apTOfun(H)/1000,H);
plot(apURfun(H)/1000,H);
xlabel('$\mathrm{Available\,power\,[kW]}$');
ylabel('$H\,\mathrm{[m]}$');
legend('$\mathrm{Max. Cont.}$','$\mathrm{Max. Take Off}$',...
    '$\mathrm{Max. Urg.}$','Location','Best');
grid on





% 
% function ap = getAvailableMcPowerfun(r4fRigidHe,atm,H,options)
% 
% ap = @(H)(max(r4fRigidHe.engine.fPmc(H),r4fRigidHe.transmission.Pmt));
% 
% end
% 






% %Analisis of Specific Air Range testGetTrimSAR
% 
% FC4     = {'betaf0',0,...
%           'wTOR',0,...
%           'cs',0,...
%           'vTOR',0};
% 
% muWT      = [0; 0; 0];
      
% %SARfun = @(V,FW1)MygetSARfun(r4fRigidHe,V,FW1,atm,H,muWT,FC4,options);
% 
% 
% %Vvect = [linspace(1,90,20)]';
% 
% 
% 
% FWv = linspace(0,r4fRigidHe.weightConf.FW,10);
% 
% for FWi = 1:length(FWv)
%     
%     SAR(:,FWi) = SARfun(Vvect,FWv(FWi));
%     
% end
% 
% plot(Vvect,SAR)
% hold on
% grid on
