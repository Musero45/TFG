function io = Bo105DerivativesTest(mode)
% This stability test comes from fuselageDerivativesTest.m 
% at PFCNano
% 

close all

options = setHeroesRigidOptions;

%atmosphere variables needed
atm     = getISA;
htest   = 0;
% % % % % % % % % % % g       = atm.g;
% % % % % % % % % % % rho     = atm.density(htest);

%helicopter model selection
he{1}                = rigidBo105(atm);
he{2}                = rigidBo105(atm);
he{1}.fuselage.model = @PadBo105Fus;
he{2}.fuselage.model = @generalFus;
m                    = length(he);




% Transform the dimensional helicopter to nondimensional helicopter
ndHe     = rigidHe2ndHe(he,atm,htest);

% Define flight condition
muWT   = [0; 0; 0];
V      = linspace(0.01, 140, 5);
ndV    = V./(he{1}.mainRotor.R*he{1}.mainRotor.Omega);
% Define flight condition
fCT = {'VOR',ndV,...
      'betaf0',0,...
      'wTOR',0,...
      'cs',0,...
      'vTOR',0};

% Compute trim state for the cell of the helicopters
ndtsij      = getNdHeTrimState(ndHe,muWT,fCT,options);


% Compute nondimensional linear stability state
ndSsij      = getndHeLinearStabilityState(ndtsij,muWT,ndHe,options);

% transform the nondimensional stability state object into a dimensional
% stability state
Ssij        = ndHeSs2HeSs(ndSsij,he,atm,htest,options);

% Post process stability state to plot root locus
% FIXME: this part of the code shows a bad design of postprocessing
% solutions because we have to add a dummy helicopter parameter to generate
% the stability state to be processed when it is not needed because we have
% generated the helicopter not by geometric variation but running to
% different helicopters and there is no meaningful parameter to be added
sss         = cosws2coswmf(Ssij,'eigenSolution.eigenValTr');
sss         = addfield2coswmf(sss,'VOR',ndV');
ssss        = coswmf_cos2swmf(sss,he,'geometry.xcg');
axds        = getaxds({'xcg'},{'$x_{cg}$ [m]'},1);
ayds        = getaxds({'VOR'},{'$V/(\Omega R)$ [-]'},1);
plotStabilityEigenvalues(ssss,axds,ayds,'rootLociLabs','ini2end');



% BROKEN VISUAL VALIDATION TO BE FIXED: FIXME
ts  = cell(m+1,1);
ss  = cell(m+1,1);
sm  = cell(m+1,1);

sm{m+1}  = getPadfieldEigenvaluesMap('Bo105');
ss{m+1}  = getPadfieldLinearStabilityState('Bo105D');
leg                  = {'fslg: padfield' 'fslg: general' 'helisim'};


io = 1;

% % % % % % % % % % % % % % % % % % % % for i = 1:m
% % % % % % % % % % % % % % % % % % % %     ndHe     = rigidHe2ndHe(he{i},rho,g);
% % % % % % % % % % % % % % % % % % % %     Omega    = he{i}.mainRotor.Omega;
% % % % % % % % % % % % % % % % % % % %     Radius   = he{i}.mainRotor.R;
% % % % % % % % % % % % % % % % % % % %     ndV      = V./(Omega*Radius).*0.5144444;...
% % % % % % % % % % % % % % % % % % % %     fCT(1,:) = ndV(:);
% % % % % % % % % % % % % % % % % % % % 
% % % % % % % % % % % % % % % % % % % %     % Compute trim state for the flight condition variable
% % % % % % % % % % % % % % % % % % % %     ts{i}    = getTrimState(fCT,muWT,ndHe,options);
% % % % % % % % % % % % % % % % % % % % 
% % % % % % % % % % % % % % % % % % % %     % Compute linear stability state
% % % % % % % % % % % % % % % % % % % %     ss{i}    = getLinearStabilityState(ts{i},fCT,muWT,ndHe,options);
% % % % % % % % % % % % % % % % % % % % 
% % % % % % % % % % % % % % % % % % % %     % Next, transforms the nondimensional state into an stabiliy map by
% % % % % % % % % % % % % % % % % % % %     % dimensioning the matrix A
% % % % % % % % % % % % % % % % % % % %     sm{i}   = getStabilityMap(ss{i},Omega,Radius);
% % % % % % % % % % % % % % % % % % % % 
% % % % % % % % % % % % % % % % % % % % 
% % % % % % % % % % % % % % % % % % % % end
% % % % % % % % % % % % % % % % % % % % 
% % % % % % % % % % % % % % % % % % % % 
% % % % % % % % % % % % % % % % % % % % 
% % % % % % % % % % % % % % % % % % % % pairs = {'plotReimEigenValues','no',...
% % % % % % % % % % % % % % % % % % % %          'plotLongLatEigenValues','no',...
% % % % % % % % % % % % % % % % % % % %          'plotEigenValues','no', ...
% % % % % % % % % % % % % % % % % % % %          'rootLociLabs','yes', ...
% % % % % % % % % % % % % % % % % % % %          'rootLociLabsFmt','ini2end' ...
% % % % % % % % % % % % % % % % % % % % };
% % % % % % % % % % % % % % % % % % % % 
% % % % % % % % % % % % % % % % % % % % 
% % % % % % % % % % % % % % % % % % % % plotStabilityMap(sm,leg,pairs);
% % % % % % % % % % % % % % % % % % % % plotStabilityDerivatives(ss,leg);
% % % % % % % % % % % % % % % % % % % % plotControlDerivatives(ss,leg);



