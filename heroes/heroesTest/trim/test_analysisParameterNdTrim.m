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

%% Hover flight condition
% 

% Hover flight condition definition (scalar flight condition)
FCref =  {'VOR',0.00001,...
      'betaf0',0,...
      'wTOR',0,...
      'cs',0,...
      'vTOR',0};

% Compute trim state for the reference configuration of the helicopter
ndtsRef     = getNdHeTrimState(ndHe,muWT,FCref,options);

% Define x axis
axds        = getaxds({'VOR'},{'$$V/\omega R$$ [-]'},1);

% Define output axis
azds        = getaxds({'Theta','Phi'},{'$\Theta$ [$^o$]','$\Phi$ [$^o$]'},[180/pi,180/pi]);


% Plot trim state solution
plotNdTrimSolution(ndtsRef.solution,axds,[],...
                  'defaultVars',azds,...
                  'plot2dMode','nFigures');    
           
%% Forward leveled flight condition
% 
% Hover flight condition definition (scalar flight condition)
FCi =  {'VOR',linspace(0.00001,0.2,5) ,...
      'betaf0',0,...
      'wTOR',0,...
      'cs',0,...
      'vTOR',0};

% Compute trim state for the reference configuration of the helicopter
ndtsi      = getNdHeTrimState(ndHe,muWT,FCi,options);

% Plot trim state solution
plotNdTrimSolution(ndtsi.solution,axds,[],...
                  'defaultVars',azds,...
                  'plot2dMode','nFigures');    


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




io = 1;

