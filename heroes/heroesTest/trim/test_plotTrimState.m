function io = test_plotTrimState(mode)
% In order to select the rigid helicopter the following chain of
% transformations are followed:
%   desreq -> stathe -> rigidHe (without any option)

options            = setHeroesRigidOptions;
options.GT         = 0;
options.inertialFM = 0;


close all

% First load the ISA atmosphere
atm = getISA;


% Then, define the engine
numEngines = 1;
engine     = Arriel2C1(atm,numEngines);

% Set the design requirements
dr         = cesarDR;

% Get the statistical helicopter
stathe     = desreq2stathe(dr,engine);

%=========================================================================
% Define the rigid helicopter using options to set a realistic rigid he

% vertical fin surface
Svt = .805;

% horizontal tail plane chord
cHTP = .4;


% Define the option structures to define the properly the data for 
% Bo105 that it is required for 
optMR   = struct(...
          'e',0.0,...
          'theta1',-8*pi/180,...
          'cldata',[6.113 0],...
          'cddata',[0.0074 0.00961 0.29395],...
          'kBeta', 113330 ...
);

optTR   = struct(...
          'e',0.0,...
          'theta1',0,...
          'cldata',[5.7 0],...
          'cddata',[0.008 0.00961 0.29395],...
          'kBeta', 1e100 ...
);

optVF = struct(...
          'airfoil',@naca0012,...
          'theta',4.6501*pi/180 ...
);

optLHTP = struct(...
          'airfoil',@naca0012,...
          'theta',4.*pi/180 ...
);

optRHTP = struct(...
          'airfoil',@naca0012,...
          'theta',4.*pi/180 ...
);

optGeom = struct(...
          'xcg',0.08033,...
          'epsilony',-3*pi/180, ...
          'dtr',-0.3 ...
);


optStatHe = struct(...
      'mainRotor',optMR,...
      'tailRotor',optTR,...
      'verticalFin',optVF,...
      'leftHTP',optLHTP,...
      'rightHTP',optRHTP,...
      'geometry',optGeom ...
);

% Get rigid helicopter
he   = stathe2rigidhe(stathe,atm,cHTP,Svt,optStatHe);

% Transform physicla helicopter to nondimensional helicopter at sea level
ndHe = rigidHe2ndHe(he,atm,0);

%==========================================================================
% Set the flight condition for the trim problem (hover flight condition)
%==========================================================================

% Set the nondimensional forward velocity
ndV = linspace(0.01, 0.25, 11);

% Set nondimensional wind to zero, 
muWT = [0; 0; 0];

% hover flight condition
fc   = {'VOR',ndV,...
        'betaf0',0,...
        'wTOR',0,...
        'cs',0,...
        'vTOR',0};


% Compute the actual nondimensional trim state
ndts  = getNdHeTrimState(ndHe,muWT,fc,options);


% Post process the nondimensional trim state and check plotNdTrimSolution
% First define x-axis
axds        = getaxds({'VOR'},{'$V/(\Omega R)$ [-]'},1);

% Then, plot nondimensional trim state using default behaviour
plotNdTrimSolution(ndts.solution,axds,[],'plot2dMode','nFigures');

% now, as it is observed each of the nondimensional rtim state solution
% variables are plot in the same figure because this is the default
% behaviour set by setHeroesPlotOptions (the default value for the 
% plot2dMode field is set to oneFigure). To plot each variable of the trim
% state just overwrite this value by setting it to nFigures
plotNdTrimSolution(ndts.solution,axds,[],'plot2dMode','nFigures');



io = 1;
