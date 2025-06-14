%% Trim and Stability analysis of parametric rigid helicopters
%
% TODO LIST
% * Fix the number of output graphics using defaultVars option. Currently
% almost 100 figures are created
% * Fix the number of elements of vector ltr parameter design 
%
%
% 
% This demo shows how to use trim and stability functions in order to 
% understand how to analyse helicopter design parameters and their 
% potential impact on the helicopter trim and stability characteristics. 
% The main goal of this demo is to show how to consider variation 
% of helicopter parameters and how to analyse the influence of the 
% parameter variation on the helicopter trim and stability behaviour.
%
% As an example, we are going to analyse the influence of the longitudinal
% positioning of the tail rotor with respect to the center of gravity of
% the helicopter. We use a rigid helicopter model of Bo-105 and we are
% interested in understanding how the variation of the longitudinal
% positioning of the tail rotor influences the trim state and stability
% characteristics of the helicopter. We analise two flight conditions. The
% first one is a sea level hovering and the second one is a set of sea
% level forward flights at different velocity moduli. 
close all
setPlot

%% Setup atmosphere and computation options
%
% First, we setup heroes environment by defining and ISA+0 atmosphere, 
% the analysis altitude is sea level, hsl=0. Trim and stability analysis 
% of rigid helicopters require some computation options to be setup.
% Default options are defined by setHeroesRigidOptions. Finally, the
% nondimensional wind velocity acting on the helicopter expressed in the
% ground reference system is setup to zero, i.e. atmosphere at rest.
atm           = getISA;
hsl           = 0;
rho0          = atm.rho0;
g             = atm.g;
options       = setHeroesRigidOptions;
muWT          = [0; 0; 0];

%% Define helicopter data
% For trim and stability analysis we require to define both nondimensional
% and dimensional helicopters. We are going to load the rigid Bo-105
% helicopter as the reference helicopter. Then we use the function 
% rigidHe2ndHe to transform the rigid dimensional helicopter to a
% nondimensional helicopter. Because we need to use characteristic forces
% and moments which depends on the density and therefore on the altitude 
% rigidHe2ndHe inputs the analysis altitude density, i.e. rho0. 
he            = rigidBo105(atm);
ndHe          = rigidHe2ndHe(he,atm,hsl);

%%
% To analyse the influence of the longitudinal positioning of the tail
% rotor we need to define a cell vector of helicopters varying this lenght.
% The longitudinal positioning of the tail rotor is defined by the variable
% ltr which belongs to the helicopter substructure geometry. Now, to
% understand how this variable influences both trim and stability
% characteristics we consider a 20% variation above and below of the 
% nominal value of the reference helicopter considering nl values. Next, we
% also define the corresponding nondimensional length vector, ndltr_i.
nl          = 3;% 11
ltr_i       = he.geometry.ltr*linspace(0.8,1.2,nl);
ndltr_i     = ndHe.geometry.ndltr*linspace(0.8,1.2,nl);

%%
% To obtain the cell vector of rigid helicopters with the variation in ltr
% and ndltr we use the function getParametricCellHe. This function
% generates cell arrays of not only dimensional rigid helicopters but also 
% nondimensional rigid helicopters. getParametricCellHe inputs a scalar
% helicopter, the reference helicopter, and outputs a cell vector of
% helicopters by changing the parameter defined by the string 
% 'geometry.ltr' denoting the field to be changed and assigning the 
% corresponding values defined by the vector ltr_i. Note that we can access
% to sustructures by adding the corresponding dot to the string field. 
ltrstr      = 'geometry.ltr';
hei         = getParametricCellHe(he,ltrstr,ltr_i);
ndltrstr    = 'geometry.ndltr';
ndHei       = getParametricCellHe(ndHe,ndltrstr,ndltr_i);





%%
% Compute trim state of a cell vector of helicopters 
% with a scalar flight condition
%

% Hover flight condition definition (scalar flight condition)
FC = {'VOR',0.00001,...
      'betaf0',0,...
      'wTOR',0,...
      'cs',0,...
      'vTOR',0};


% Compute trim state for the cell of the helicopters
ndts        = getNdHeTrimState(ndHei,muWT,FC,options);

% Postprocess solution
% From a trim state the following substructures are important
% solution
% actions
ndtsol      = cosws2coswmf(ndts,'solution');
ndtsh       = coswmf_cos2swmf(ndtsol,ndHei,ndltrstr);


% Define x axis
axds        = getaxds({'ndltr'},{'$l_{ra}/R$ [-]'},1);

% Define output axis
azds        = getaxds({'Theta','Phi'},{'$\Theta$ [$^o$]','$\Phi$ [$^o$]'},[180/pi,180/pi]);

% Plot trim state solution
plotNdTrimSolution(ndtsh,axds,[],...
                  'defaultVars',azds,...
                  'plot2dMode','nFigures');               

% Plot lateral actions by elements of the helicopter
ndtact      = cosws2coswmf(ndts,'actions');
axds        = getaxds({'ndltr'},{'$l_{ra}/R$ [-]'},1);
azds        = getaxds({'CFy' 'CMtx' 'CMtz'},...
                      {'C_{Fy} [-]' 'C_{Mx}^{sum} [-]' 'C_{Mz}^{sum} [-]'}, ...
                       [1 1 1 ]);
plotActionsByElement(ndtact,axds,ndltr_i,...
                    'defaultVars',azds);               


% Compute nondimensional linear stability state
ndSs        = getndHeLinearStabilityState(ndts,muWT,ndHei,options);


% transform the nondimensional stability state object into a dimensional
% stability state
Ss          = ndHeSs2HeSs(ndSs,hei,atm,hsl,options);


% Post process stability state to plot eigen vectors
sss         = cosws2coswmf(Ss,'eigenSolution.eigW');
sss         = addfield2coswmf(sss,'ltr',ltr_i);

axds        = getaxds({'ltr'},{'$l_{ra}$ [-]'},1);
plotStabilityEigenvectors(sss,axds,[]);

% Post process stability state to plot root locus
sss         = cosws2coswmf(Ss,'eigenSolution.eigenValTr');
ssss        = coswmf_cos2swmf(sss,hei,ltrstr);
plotStabilityEigenvalues(ssss,axds,[],'rootLociLabs','ini2end');

% Post process stability state to plot mode characteristics 
sss         = cosws2coswmf(Ss,'eigenSolution.charValTr');
sss         = addfield2coswmf(sss,'ltr',ltr_i);
plotStabilityEigencharacteristics(sss,axds,[]);

% Post process stability state to plot stability derivatives
sss         = cosws2coswmf(Ss,'stabilityDerivatives.staDer.AllElements');
ssss        = coswmf_cos2swmf(sss,hei,ltrstr);
axds        = getaxds({'ltr'},{'$l_{ra}$ [-]'},1);
plotStabilityDerivatives(ssss,axds,[],...
'plot2dMode','nFigures')

% Post process stability state to plot control derivatives
sss         = cosws2coswmf(Ss,'controlDerivatives.conDer.AllElements');
ssss        = coswmf_cos2swmf(sss,hei,ltrstr);
axds        = getaxds({'ltr'},{'$l_{ra}$ [-]'},1);
plotControlDerivatives(ssss,axds,[],...
'plot2dMode','nFigures')


%%
% Cell vector of helicopters together with a vector of flight conditions
%
% 

nv             = 5;
VOR            =linspace(0.01,0.25,nv);
FCi = {'VOR',VOR,...
      'betaf0',0,...
      'wTOR',0,...
      'cs',0,...
      'vTOR',0};


% Compute trim state for the cell of the helicopters
ndtsij      = getNdHeTrimState(ndHei,muWT,FCi,options);



% Compute nondimensional linear stability state
ndSsij      = getndHeLinearStabilityState(ndtsij,muWT,ndHei,options);


% transform the nondimensional stability state object into a dimensional
% stability state
Ss          = ndHeSs2HeSs(ndSsij,hei,atm,hsl,options);


%%
% Plot 2D trim states
% Postprocess solution
ndtsolij    = cosws2coswmf(ndtsij,'solution');
ndtsij      = coswmf_cos2swmf(ndtsolij,ndHei,ndltrstr);

% Define y -axis
ayds        = getaxds({'VOR'},{'$V/(\Omega R)$ [-]'},1);
axds        = getaxds({'ndltr'},{'$l_{ra}/R$ [-]'},1);

% Define output axis
azds        = getaxds(...
              {'theta0','theta1C','theta1S','theta0tr'},...
              {'theta0 [o]','theta1C [o]','theta1S [o]','theta0tr [o]'},...
              [180/pi,180/pi,180/pi,180/pi]);

% Plot trim state bidimensional contour (default behavior)
plotNdTrimSolution(ndtsij,axds,ayds,...
                  'defaultVars',azds);               

% Plot trim state parametric wrt y-axis
plotNdTrimSolution(ndtsij,ayds,axds,...
                  'plot3dMode','parametric',...
                  'defaultVars',azds);               

% Plot trim state parametric wrt x-axis
plotNdTrimSolution(ndtsij,ayds,axds,...
                  'plot3dMode','parametric',...
                  'defaultVars',azds);

% Post process stability state to plot root locus
sss_1         = cosws2coswmf(Ss,'eigenSolution.eigenValTr');
sss_1         = addfield2coswmf(sss_1,'VOR',VOR');
ssss_1        = coswmf_cos2swmf(sss_1,hei,ltrstr);
axds        = getaxds({'ltr'},{'$l_{ra}$ [-]'},1);
ayds        = getaxds({'VOR'},{'$V/(\Omega R)$ [-]'},1);
plotStabilityEigenvalues(ssss_1,axds,ayds,'rootLociLabs','ini2end');
plotStabilityEigenvalues(ssss_1,axds,ayds,'rootLociLabs','ini2end','plot2dMode','nFigures');
plotStabilityEigenvalues(ssss_1,ayds,axds,'rootLociLabs','ini2end');

%% WORK IN PROGRESS
% the next commented lines should be checked
% % Post process stability state to plot eigen vectors
% sss_2         = cosws2coswmf(Ss,'eigenSolution.eigW');
% sss_2         = addfield2coswmf(sss_2,'ltr',ltr_i);
% 
% axds        = getaxds({'ltr'},{'$l_{ra}$ [-]'},1);
% plotStabilityEigenvectors(sss,axds,[]);
% 
% % Post process stability state to plot root locus
% sss         = cosws2coswmf(Ss,'eigenSolution.eigenValTr');
% ssss        = coswmf_cos2swmf(sss,hei,ltrstr);
% plotStabilityEigenvalues(ssss,axds,[],'rootLociLabs','ini2end');
% 
% % Post process stability state to plot mode characteristics 
% sss         = cosws2coswmf(Ss,'eigenSolution.charValTr');
% sss         = addfield2coswmf(sss,'ltr',ltr_i);
% plotStabilityEigencharacteristics(sss,axds,[]);
% 
% % Post process stability state to plot stability derivatives
% sss         = cosws2coswmf(Ss,'stabilityDerivatives.staDer.AllElements');
% ssss        = coswmf_cos2swmf(sss,hei,ltrstr);
% axds        = getaxds({'ltr'},{'$l_{ra}$ [-]'},1);
% plotStabilityDerivatives(ssss,axds,[],...
% 'plot2dMode','nFigures')
% 
% % Post process stability state to plot control derivatives
% sss         = cosws2coswmf(Ss,'controlDerivatives.conDer.AllElements');
% ssss        = coswmf_cos2swmf(sss,hei,ltrstr);
% axds        = getaxds({'ltr'},{'$l_{ra}$ [-]'},1);
% plotControlDerivatives(ssss,axds,[],...
% 'plot2dMode','nFigures')






%% References
%
% [1] Alvaro Cuerva Tejero, Jose Luis Espino Granado, Oscar Lopez Garcia,
% Jose Meseguer Ruiz, and Angel Sanz Andres. Teoria de los Helicopteros.
% Serie de Ingenieria y Tecnologia Aeroespacial. Universidad Politecnica
% de Madrid, 2008.
%
% DEVELOPMENT NOTES
%
% * From a development point of view and regarding the functionality of the 
%   plot functions one important thing to be done is to cover the case of 
%   a cell array of helicopters together with a scalar flight condition 
%   (hover flight condition)
%


% % % % % % % % % % options.uniformInflowModel = @Cuerva;
% % % % % % % % % % options.armonicInflowModel = @none;
% % % % % % % % % % options.mrForces           = @thrustF;
% % % % % % % % % % options.trForces           = @completeF;
