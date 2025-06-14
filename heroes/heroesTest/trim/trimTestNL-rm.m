%clear all
close all

% default optiosns are set
options = setHeroesRigidOptions;

%engineState
%options.engineState = @mainShaftBroken;

% uniformInflowModel options are updated with
% @Cuerva model for induced velocity
options.uniformInflowModel = @Cuerva;
options.armonicInflowModel = @none;

% engineState options are updated for the 
%options.engineState = @EngineOffTransmissionOn;

% mrForces options are updated for 
%options.mrForces = @completeF;


% atmosphere variables needed
atm     = getISA;
rho0    = atm.rho0;
g       = atm.g;
H       = 0;
% helicopter model selection
%he      = rigidNLBo105Simple(atm);
he = rigidNLBo105(atm);

%he.mainRotor.kBeta = 0;

%he.mainRotor.kBeta = 500;

% helicopter 2 non-dimensional helicopter
ndHe = rigidHe2ndHe(he,atm,H);

ndHe.ndRotor.aG = 0;


ndRotor = ndHe.mainRotor;



% wind velocity in ground reference system
muWT = [0; 0; 0];

tic
%'betaf0'
FC = {'VOR',0.0001,...
      'theta1S',linspace(-5*pi/180,5*pi/180,3),...
      'wTOR',0,...
      'cs',0,...
      'vTOR',0};

ndTS = getNdHeTrimState(ndHe,muWT,FC,options);  

xNL0 = ndTS.solution;

%options.IniTrimCon = xNL0;

FCNL = {'VOR',0.0001,...
      'theta1S',linspace(-5*pi/180,5*pi/180,3),...
      'wTOR',0,...
      'cs',0,...
      'vTOR',0};


options.mrForces  = @completeFNL;
options.mrMoments = @aerodynamicMNL;

% trForces options are updated
options.trForces  = @completeFNL;
options.trMoments = @aerodynamicMNL;


ndTSNL = getNdHeTrimState(ndHe,muWT,FCNL,options);  

toc

%axds           = getaxds({'VOR'},{'VOR [-]'},1);
%ayds           = getaxds('betaf0','betaf0 [o]',180/pi);

axds           = getaxds({'theta1S'},{'\theta_{1S}'},180/pi);

% axATa          = plotRotorActions(res,axds,[]);    

axATa          = plotNdTrimSolution(ndTSNL.solution,axds,ayds,'defaultVars','yes',...
                'plot3dMode','parametric');               



