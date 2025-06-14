function io = stability02(mode)
% This stability test comes from stability01 and differs from it because 
% uses the basic transformation chain:
%   desreq -> stathe -> rigidHe -> trimState

close all

% Set rigid options overriding conveniently gratitational and inertial
% terms
options            = setHeroesRigidOptions;
options.GT         = 0;
options.inertialFM = 0;

% atmosphere variables needed
atm     = getISA;
% % % % % % % % g       = atm.g;
htest   = 0;
% % % % % % % % rho     = atm.density(htest);

% helicopter model selection
he      = getMyRigidHe(atm);
ndHe    = rigidHe2ndHe(he,atm,htest);

% 
muWT    = [0; 0; 0];
ndV     = linspace(.2, .3, 4);

% Define flight condition
fCT = {'VOR',ndV,...
      'betaf0',0,...
      'wTOR',0,...
      'cs',0,...
      'vTOR',0};



% Compute trim state for the flight condition variable
ndts        = getNdHeTrimState(ndHe,muWT,fCT,options);

% Compute nondimensional linear stability state
ndSs        = getndHeLinearStabilityState(ndts,muWT,ndHe,options);


% transform the nondimensional stability state object into a dimensional
% stability state
Ss          = ndHeSs2HeSs(ndSs,he,atm,htest,options);



% Post process stability state to plot stability derivatives
% First extract the structure to be plotted
SsStaDer    = Ss.stabilityDerivatives.staDer.AllElements;

% Then, add indepedent variable to be plotted
SsStaDer.VOR = ndV;

% Next, define the x-axis information 
axds        = getaxds({'VOR'},{'$V/(\Omega R)$ [-]'},1);

% Finally, plot the stability derivatives
plotStabilityDerivatives(SsStaDer,axds,[],...
'plot2dMode','nFigures')

% Post process stability state to plot control derivatives
% First extract the structure to be plotted
SsConDer    = Ss.controlDerivatives.conDer.AllElements;

% Then, add indepedent variable to be plotted
SsConDer.VOR = ndV;

% Next, define the x-axis information 
axds        = getaxds({'VOR'},{'$V/(\Omega R)$ [-]'},1);

% Finally, plot the stability derivatives
plotControlDerivatives(SsConDer,axds,[],...
'plot2dMode','nFigures')


% Next, transforms the nondimensional state into an stabiliy map by
% dimensioning the matrix A
ssMap   = Ss.eigenSolution.eigenValTr;
ssMap.VOR = ndV;
plotStabilityEigenvalues(ssMap,axds,[],'rootLociLabs','ini2end');

io = 1;


function he = getMyRigidHe(atm)
% FIXME this local function is a strong candidate to be a common function
% for flight mechanics tests (there is another instance of this snippet 
% of code at trim02) then it would be nice if this function goes more
% general to establish a common base to test different design requirements
% This is the chain to transform design requirements to statistical 
% helicopter and to rigid helicopter
numEngines = 2;
engine     = Allison250C28C(atm,numEngines);
dr         = cesarDR;

% PL and fuel for missions
PL = 75*atm.g; %N
Mf = 400; % kg
Rf = 50;  % kg

% statistical helicopter
stathe     = desreq2stathe(dr,engine);

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


optF    = struct(...
          'model',@generalFus,...
          'kf',1 ...
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
      'fuselage',optF,...
      'verticalFin',optVF,...
      'leftHTP',optLHTP,...
      'rightHTP',optRHTP,...
      'geometry',optGeom ...
);


he = stathe2rigidhe(stathe,atm,cHTP,Svt,optStatHe);

% Add in weights into the helicopter data 
he = addMissionWeightsRigid(he,PL,Mf,Rf,atm);
