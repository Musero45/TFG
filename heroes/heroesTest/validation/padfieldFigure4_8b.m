function io = padfieldFigure4_8b(mode)
%% padfieldFigure4_8b 
% Phi angle in degrees for different turn rate (rad/s) for lynx helicopter
% Comparison between de results of Helisim and Heroes
% Flight speed: 80 kn
%
% Data taken from reference [1]
% Phi digitize from figure 4.8(b) page 202 of [1]
%
% [1] G.D. Padfield Helicopter Flight Dynamics 2007

% IMPORTANT: This trim analysis is only for - Lynx -

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
omegaAdzT     = linspace(-0.4,0.4,31)./Om;
VOR           = 80.*0.5144444./(Rmr*Om);
FC            = {'omegaAdzT',omegaAdzT,...
                 'betaf0',0,...
                 'gammaT',0,...
                 'VOR',VOR,...
                 'vTOR',0};
             
% To compute the nondimensional trim state just use the function 
% getNdHeTrimState.                         
ndts          = getNdHeTrimState(ndHe,muWT,FC,options);

% Define analytic result to compare with
X.Phi         = atan(omegaAdzT.*Om.*80.*0.5144444./atm.g);
X.omegaAdzT   = omegaAdzT;

azdsTS        = getaxds(...
                {'Phi'},...
                {'$\Phi$ [rad]'},...
                 1);
axds          = getaxds({'omegaAdzT'},{'turn rate[rad/s]'},Om);
b             = {X,ndts.solution};               
plotNdTrimSolution(b,axds,{'Phi=atan(Omega*V/g)','Heroes'},...
                   'defaultVars',azdsTS,...
                   'plot2dMode','nFigures');

xvar          = 'omegaAdzT';
zvars         = {'Phi'};               
err           = checkError4s(X,ndts.solution,xvar,...
                'metric', 'mean',... 
                'TOL', 1e-10,'zvars',zvars);   
        
io = 1;
