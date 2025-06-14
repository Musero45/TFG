function io = trimPFCnano(mode)
% 
% This script is a modified copy of trimPFC which is located at
% heroesTest/PFCNano. This test reproduces the following figures
% Figure 4.13 (a) and (b) page 60
% Figure 4.14 (a) page 61
% Figure 4.15 (a) and (b) page 62
%
% for the case labelled as 'Basico' and with less number of nondimensional 
% forward speeds in order to speed up the test (originally 26 nondimensional 
% velocities were considered now only 11 are considered)
%
% [1] Mariano Rubio, Simulacion de la mecanica de vuelo de un 
%     helicoptero convencional, 2011. Proyecto Fin de Carrera, ETSIA,
%     Madrid
% [2] G.D. Padfield Helicopter Flight Dynamics 1996


close all

% Set trim computation options
opt1       = {...
    'armonicInflowModel',@none,...
    'mrForces',@completeF,...
    'mrMoments',@aerodynamicM ...
};
options = parseOptions(opt1,@setHeroesRigidOptions);



%atmosphere variables needed
atm     = getISA;
% % % % % % % % rho0    = atm.rho0;
% % % % % % % % g       = atm.g;

%helicopter model selection
he      = rigidBo105(atm);

% helicopter 2 non-dimensional helicopter
ndHe    = rigidHe2ndHe(he,atm,0);

% Flight condition definition
% Set non dimensional atmospheric wind 
muWT      = [0; 0; 0];

% Define non dimensional forward velocity
ndV       = linspace(0.001,.25,11);

% Define flight condition
fCT = {'VOR',ndV,...
      'betaf0',0,...
      'wTOR',0,...
      'cs',0,...
      'vTOR',0};

% Get trim state
ndts  = getNdHeTrimState(ndHe,muWT,fCT,options);

%==========================================================================
% Plot section
%==========================================================================

%--------------------------------------------------------------------------
% Plot actions by elements. This part of the code replicates the figures of
% Appendix B, pages 100 and 101 of the reference [1], left column that is
% basic model
% FIXME oscar: for the moment being i am not have time to check why this
% figures looks quite different from the original ones, I guess it is a
% matter of plotting the right variable. check this out!
axds        = getaxds({'VOR'},{'V/(\Omega R) [-]'},1);
azds        = getaxds({'CFx'  'CFy'  'CFz' ...
                       'CMtx' 'CMty' 'CMtz'},...
                      {'C_{Fx} [-]' 'C_{Fy} [-]' 'C_{Fz} [-]' ...
                       'C_{Mx} [-]' 'C_{My} [-]' 'C_{Mz} [-]'}, ...
                      [1 1 1 ...
                       1 1 1]);
plotActionsByElement(ndts.actions,axds,ndV,'defaultVars',azds);               

%--------------------------------------------------------------------------
% Comparison between heroes results and flight test data published at [2] 

% First load published flight test data
ndtsFT = getPadfieldFlightTest;

% Then define a legend cell to properly label the figures
legend2 = {'Basic model' 'Flight tests'};

% Define nondimensional variables of the trim state to be plotted
% Figure 4.13 (left) page 60 of reference [1] main rotor collective pitch
% Figure 4.13 (right) page 60 of reference [1] tail rotor collective pitch
% Figure 4.14 (left) page 61 of reference [1] helicopter pitch
% Figure 4.15 (left) page 62 of reference [1] lateral cyclic pitch 
% Figure 4.15 (right) page 62 of reference [1] lateral cyclic pitch 
r2d     = 180/pi;
azds        = getaxds({'theta0' 'theta0tr' 'Theta' ...
                       'theta1C' 'theta1S'},...
                      {'\theta_0 [^o]' '\theta_T [^o]' '\Theta [^o]'...
                       '\theta_{1C} [^o]' '\theta_{1S}' }, ...
                      [r2d r2d r2d ...
                       r2d r2d]);

% Plot the actual variables
plotNdTrimSolution({ndts.solution,ndtsFT},axds,legend2,...
                  'defaultVars',azds,'mark',{'k-','k o'});               


io = 1;



