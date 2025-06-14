function io = padfieldFigure4_8a(mode)
%% padfieldFigure4_8a 
% Phi angle in degrees for different speeds in kn for Lynx helicopter
%
% Comparison between de results of Helisim and Heroes
%
% Data taken from reference [1]
% Phi digitized from figure 4.8(a) page 202 of [1]
%
% [1] G.D. Padfield Helicopter Flight Dynamics 2007
%
% Author: Francisco J. Ruiz Fernandez
%

close all
clear all
setPlot;

% Define atmosphere
atm           = getISA;

% define rigid helicopter
he            = rigidLynx(atm);
Om            = he.mainRotor.Omega;
Rmr           = he.mainRotor.R;

% Get the nondimensional rigid helicopter
hsl           = 0;
ndHe          = rigidHe2ndHe(he,atm,hsl);

options       = setHeroesRigidOptions;

muWT          = [0; 0; 0];
VORmax        = 150.*0.5144444./(Rmr*Om);
VOR           = linspace(0.001,VORmax,31);
FC            = {'VOR',VOR,...
                 'betaf0',0,...
                 'wTOR',0,...
                 'cs',0,...
                 'vTOR',0};
             
% To compute the nondimensional trim state just use the function 
% getNdHeTrimState.                         
ndts          = getNdHeTrimState(ndHe,muWT,FC,options);



azdsTS        = getaxds(...
                {'Phi'},...
                {'$\Phi$ [$^o$]'},...
                 180/pi);
axds          = getaxds({'VOR'},{'V[kn]'},(Rmr*Om)./0.5144444);

% Load validation data from Padfield
Phi           = padfieldFigure4_8a_data;

% Define cell of structures to be plotted
b             = {Phi,ndts.solution};
plotNdTrimSolution(b,axds,{'Helisim(lift forces excluded)','Heroes'},...
                   'defaultVars',azdsTS,...
                   'plot2dMode','nFigures');

% Get error structure using checkErrors4s
xvar          = 'VOR';
zvars         = {'Phi'};               
err           = checkError4s(Phi,ndts.solution,xvar,...
                'metric', 'mean',... 
                'TOL', 1e-10,'zvars',zvars);   
                        
io = 1;
