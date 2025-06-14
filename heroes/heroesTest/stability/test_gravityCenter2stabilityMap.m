function io = test_gravityCenter2stabilityMap(mode)
% This stability test comes from gravityCenterTest.m at PFCNano
% 


close all

% Set rigid options overriding conveniently gratitational and inertial
% terms
options            = setHeroesRigidOptions;
options.GT         = 0;
options.inertialFM = 0;

% atmosphere variables needed
atm     = getISA;
% % % % % % g       = atm.g;
htest   = 0;
% % % % % % % % rho     = atm.density(htest);

% helicopter model selection
he      = PadfieldBo105(atm);

% Transform the dimensional helicopter to nondimensional helicopter
ndHe     = rigidHe2ndHe(he,atm,htest);

% Define the parameter variation, in this case the longitudinal position of
% center of gravity
xcg      = [.1; 0;-.1];
ndxcg    = xcg./he.mainRotor.R;

% Get a cell of parametric nondimensional helicopters
ndxcgstr    = 'geometry.ndxcg';
ndHei       = getParametricCellHe(ndHe,ndxcgstr,ndxcg);

% Get a cell of physical helicopters
xcgstr      = 'geometry.xcg';
hei         = getParametricCellHe(he,xcgstr,xcg);

% 
muWT    = [0; 0; 0];
ndV     = linspace(.2, .3, 4);

% Define flight condition
fCTj    = {'VOR',ndV,...
           'betaf0',0,...
           'wTOR',0,...
           'cs',0,...
           'vTOR',0};



% Compute trim state for the cell of the helicopters
ndtsij      = getNdHeTrimState(ndHei,muWT,fCTj,options);


% Compute nondimensional linear stability state
ndSsij      = getndHeLinearStabilityState(ndtsij,muWT,ndHei,options);



% transform the nondimensional stability state object into a dimensional
% stability state
Ssij        = ndHeSs2HeSs(ndSsij,hei,atm,htest,options);

% Post process stability state to plot root locus
sss         = cosws2coswmf(Ssij,'eigenSolution.eigenValTr');
sss         = addfield2coswmf(sss,'VOR',ndV');
ssss        = coswmf_cos2swmf(sss,hei,xcgstr);
axds        = getaxds({'xcg'},{'$x_{cg}$ [m]'},1);
ayds        = getaxds({'VOR'},{'$V/(\Omega R)$ [-]'},1);
plotStabilityEigenvalues(ssss,axds,ayds,'rootLociLabs','ini2end');
plotStabilityEigenvalues(ssss,axds,ayds,'rootLociLabs','ini2end','plot2dMode','nFigures');
plotStabilityEigenvalues(ssss,ayds,axds,'rootLociLabs','ini2end');



io = 1;




% % % % % % % % % % % % % % % % % % % % Characteristic frequency and meter of helicopter
% % % % % % % % % % % % % % % % % % % Omega   = he.mainRotor.Omega;
% % % % % % % % % % % % % % % % % % % Radius  = he.mainRotor.R;
% % % % % % % % % % % % % % % % % % % 
% % % % % % % % % % % % % % % % % % % % Allocate trim, stability state cells together with stability map 
% % % % % % % % % % % % % % % % % % % % and legend cells 
% % % % % % % % % % % % % % % % % % % ts       = cell(nxcg,1);
% % % % % % % % % % % % % % % % % % % ss       = cell(nxcg,1);
% % % % % % % % % % % % % % % % % % % sm       = cell(nxcg,1);
% % % % % % % % % % % % % % % % % % % leg      = cell(nxcg,1);
% % % % % % % % % % % % % % % % % % % 
% % % % % % % % % % % % % % % % % % % for i = 1:nxcg
% % % % % % % % % % % % % % % % % % % 
% % % % % % % % % % % % % % % % % % %     % Define new helicopter dinamically imposing the new value of xcg
% % % % % % % % % % % % % % % % % % %     ndHe.geometry.Xcg = xcg(i)/Radius;
% % % % % % % % % % % % % % % % % % % 
% % % % % % % % % % % % % % % % % % %     % Define dynamical legends
% % % % % % % % % % % % % % % % % % %     leg{i}   = strcat('x_{cg} = ',num2str(xcg(i)));
% % % % % % % % % % % % % % % % % % % 
% % % % % % % % % % % % % % % % % % %     % Compute trim state for the flight condition variable
% % % % % % % % % % % % % % % % % % %     ts{i}    = getTrimState(fCT,muWT,ndHe,options);
% % % % % % % % % % % % % % % % % % % 
% % % % % % % % % % % % % % % % % % %     % Compute linear stability state
% % % % % % % % % % % % % % % % % % %     ss{i}    = getLinearStabilityState(ts{i},fCT,muWT,ndHe,options);
% % % % % % % % % % % % % % % % % % % 
% % % % % % % % % % % % % % % % % % %     % Next, transforms the nondimensional state into an stabiliy map by
% % % % % % % % % % % % % % % % % % %     % dimensioning the matrix A
% % % % % % % % % % % % % % % % % % %     sm{i}   = getStabilityMap(ss{i},Omega,Radius);
% % % % % % % % % % % % % % % % % % % 
% % % % % % % % % % % % % % % % % % % end
% % % % % % % % % % % % % % % % % % % 
% % % % % % % % % % % % % % % % % % % % Output graphical information about stability, control derivatives and
% % % % % % % % % % % % % % % % % % % % stability map
% % % % % % % % % % % % % % % % % % % % plotStabilityDerivatives(ss,leg);
% % % % % % % % % % % % % % % % % % % % plotControlDerivatives(ss,leg);
% % % % % % % % % % % % % % % % % % % plotStabilityMap(sm,leg,'rootLociLabsFmt','ini2end');
% % % % % % % % % % % % % % % % % % % 


