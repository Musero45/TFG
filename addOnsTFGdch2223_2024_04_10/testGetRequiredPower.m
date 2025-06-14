% Tets of function getRequiredPower(he_ln,vWT,FC4,V,atm,H,options)

% A ready for flight ridig helicopter is a rigid helicopter with
% incorporated power plant, detailed transmission and weight data
% 


clear all
close all

setPlot;
set(0,'DefaultTextFontSize',16)
set(0,'DefaultAxesFontSize',16)
set(0,'defaultlinelinewidth',3)


options = setHeroesRigidOptions2223;
options.armonicInflowModel = @none;

atm          = getISA;
he_ln     = rigidBo105e02223(atm);
he_nl     = rigidNLBo105e02223(atm);

FC4 = {'gammaT',0,...
       'betaf0',0,...
       'vTOR',0,...
       'cs',0};

H   = 0;
vWT = [0;0;0];

Vvec = linspace(1,120,20);

tic

for i = 1:length(Vvec)
    
    V = Vvec(i);

PMl(i)  = getRequiredPower(he_ln,vWT,FC4,V,atm,H,options);


end
toc

options.aeromechanicModel = @aeromechanicsNL;
options.mrForces          = @completeFNL;
options.mrMoments         = @aerodynamicMNL;
options.trForces          = @completeFNL;
options.trMoments         = @aerodynamicMNL;

tic
for i = 1:length(Vvec)
    
    V = Vvec(i);

PMnl(i)  = getRequiredPower(he_nl,vWT,FC4,V,atm,H,options);


end

toc

tic
PMnl2 = getRequiredPower(he_nl,vWT,FC4,Vvec,atm,H,options);
toc

figure (1)

plot(Vvec,PMl/1000,'k-')
hold on
plot(Vvec,PMnl/1000,'b-')
plot(Vvec,PMnl2/1000,'ro')


  







   

