function io = padfieldFigure4_7(mode)
%% padfieldFigure4_7 
% beta 1C angle in rad for different speeds in kn
%
% Comparison between de results of Helisim and Heroes
%
% Data taken from reference [1]
% Phi digitized from figure 4.7 page 201 of [1]
%
% [1] G.D. Padfield Helicopter Flight Dynamics 2007
%
% Author: Francisco J. Ruiz Fernandez
%


close all
clear all
setPlot;

atm           = getISA;
hsl           = 0;

he            = {rigidLynx(atm),rigidPuma(atm)};
nhe           = length(he);

% Allocation of variables
Om            = zeros(1,nhe);
Rmr           = zeros(1,nhe);
ndHe          = cell(1,nhe);
VORmax        = zeros(1,nhe);
VOR           = cell(1,nhe);
V             = cell(1,nhe);
FC            = cell(1,nhe);
ndts          = cell(1,nhe);

for i=1:nhe;
    Om(i)        = he{i}.mainRotor.Omega;
    Rmr(i)       = he{i}.mainRotor.R;

    ndHe{i}      = rigidHe2ndHe(he{i},atm,hsl);

    options      = setHeroesRigidOptions;

    muWT         = [0; 0; 0];
    VORmax(i)    = 170.*0.5144444./(Rmr(i)*Om(i));
    VOR{i}       = linspace(0.001,VORmax(i),21);
    V{i}         = VOR{i}.*Rmr(i)*Om(i);
    FC{i}        = {'VOR',VOR{i},...
                    'betaf0',0,...
                    'wTOR',0,...
                    'cs',0,...
                    'vTOR',0};        

    % To compute the nondimensional trim state just use the function 
    % getNdHeTrimState.                         
    ndts{i}            = getNdHeTrimState(ndHe{i},muWT,FC{i},options);

    % Overload the solution substructure to get the xvar variable
    ndts{i}.solution.V = V{i};
end

% Load validation data from Padfield
Beta1C   = padfieldFigure4_7_data();

azdsTS   = getaxds(...
           {'beta1C'},...
           {'$$\beta1C$$ [rad]'},...
            1);
 
axds      = getaxds({'V'},{'V[kn]'},1/0.5144444);            

b         = {ndts{1}.solution,...
             Beta1C{1},...
             Beta1C{2},...
             ndts{2}.solution};  

leg       = {'Lynx Heroes',...
             'Lynx Helisim',...
             'Puma Helisim',...
             'Puma Heroes'};
% Plot together Helisim and Heroes results
plotNdTrimSolution(b,axds,leg,...
                   'defaultVars',azdsTS,...
                   'plot2dMode','nFigures');

% Obtain error structures using checkErrors4s
xvar      = 'V';
zvars   = {'beta1C'};               
errLynx = checkError4s(Beta1C{1},ndts{1}.solution,xvar,...
             'metric', 'mean',... 
             'TOL', 1e-10,...
             'zvars',zvars);
errPuma = checkError4s(Beta1C{2},ndts{2}.solution,xvar,...
             'metric', 'mean',... 
             'TOL', 1e-10,...
              'zvars',zvars);   

                         
io = 1;
