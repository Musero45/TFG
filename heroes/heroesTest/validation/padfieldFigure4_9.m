function io = padfieldFigure4_9(mode)
%% padfieldFigure4_9
% Phi, beta1C, beta1S angles in rad, and CTtr 
% for different sideslip angle(betaf0) fliying with a speed of 100kn for a
% lynx helicopter
%
% Comparison between de results of Helisim and Heroes
%
% Data taken from reference [1]
% Phi, beta1C, beta1S and CTtr digitize from figure 4.9 page 203 of [1]
%
% [1] G.D. Padfield Helicopter Flight Dynamics 2007
%
% Author: Francisco J. Ruiz Fernandez
%

close all
clear all
setPlot;

atm           = getISA;
he            = rigidLynx(atm);
Om            = he.mainRotor.Omega;
Rmr           = he.mainRotor.R;

hsl           = 0;
ndHe          = rigidHe2ndHe(he,atm,hsl);

options       = setHeroesRigidOptions;

muWT          = [0; 0; 0];
VOR           = 100.*0.5144444./(Rmr*Om);
betaf0        = linspace(0.001,0.6,31);
FC            = {'VOR',VOR,...
                 'betaf0',betaf0,...
                 'wTOR',0,...
                 'cs',0,...
                 'vTOR',0};
             
% To compute the nondimensional trim state just use the function 
% getNdHeTrimState.                         
ndts          = getNdHeTrimState(ndHe,muWT,FC,options);


zvars         = {'Phi','beta1C','beta1S','CT0tr'};
leg           = {'$$\Phi$$ [rad]',...
                 '($$\beta1C$$)x10 [rad]',...
                 '($\beta1S$)x10^2 [rad]',...
                 '(CTtr)x10[-]'};
scalefactor   = [1,10,-100,10];
azdsTS        = getaxds(zvars,leg,scalefactor);
axds          = getaxds({'betaf0'},{'sideslip$\beta$(rad)'},1);
                              
plotNdTrimSolution(ndts.solution,axds,[],...
                   'defaultVars',azdsTS,...
                   'plot2dMode','oneFigure',...
                   'titleplot','Heroes');               
               
ssH           = padfieldFigure4_9_data();
TempSSH       = ssH ;

err           = struct('Phi',[],...
                       'beta1C',[],...
                       'beta1S',[],...
                       'CT0tr',[]);

xvar          = 'betaf0';               
for i=1:4;

    azdsTS          = getaxds({zvars(i)},{leg(i)},...
                              scalefactor(i));

    TempSSH.betaf0  = ssH.betaf0(:,:,i);    
    b               = {ndts.solution,TempSSH};   
    plotNdTrimSolution(b,axds,{'Heroes','Helisim'},...
                       'defaultVars',azdsTS,...
                       'plot2dMode','nFigures');

    TempErr         = checkError4s(ndts.solution,TempSSH,xvar,... 
                      'metric', 'mean',... 
                      'TOL', 1e-10,'zvars',zvars(i)); 
    err.(zvars{i})  = TempErr.(zvars{i});
  
end               

io = 1;

