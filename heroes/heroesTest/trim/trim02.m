function io = trim02(mode)
% This trim test differs from trim01 at the following key aspects
% - uses the basic transformation chain:
%   desreq -> stathe -> rigidHe -> trimState
% Example of usage
% trim01
%

%==========================================================================
% Set up the options structure to guarantee agreement with the maple
% results
%==========================================================================
opt1       = {... 
              'linearInflow',@LMTCuerva,...
              'mrForces',@thrustF,...
              'trForces',@thrustF,...
              'mrMoments',@aerodynamicM,...
              'trMoments',@aerodynamicM,...
              'GT',0};
options    = parseOptions(opt1,@setHeroesRigidOptions);


%==========================================================================
% Parameter study
%==========================================================================
atm        = getISA;

% parstr is a cell of strings which specifies the parameters to be changed
% parval is a matrix with the values of the parameter set
% tsField, tsLabel and tsUnit are cell strings to define the x-axis to be 
% used by plotTrimState 
[he,parstr,parval,tsField,tsLabel,tsUnit] = getTrim02data(atm);

% np is the number of parameters (4)
% nv is the number of values of the parameter
[nv,np]     = size(parval);

% % % % TO BE REMOVED old code before getTrimState function (23/02/2014)
% % % % Get characteristic power and ratio of angular speed of rotors 
% % % % (just to compute the power)
% % % [Pu,Wmr_tr]    = getPuW(he,atm);

% Build up a cell of nv rows and np columns
ndHe       = cell(nv,np);
for i=1:np

    He           = getParametricCellHe(he,parstr{i},parval(:,i));
    nh           = rigidHe2ndHe(He,atm,0);
    for j=1:nv
        ndHe{j,i}  = nh{j};
    end
end


%==========================================================================
% Set the initial condition for the trim problem
%==========================================================================
% % % % % % CW   = ndHe{1,1}.inertia.CW;

muWT = [0; 0; 0];

% Hover flight condition
% flightConditionT = zeros(6,1);
% trimState        = cell(1,nv);
ndtrimState        = cell(1,nv);

FC = {'uTOR',0,...
      'wTOR',0,...
      'Psi',0,...
      'cs',0,...
      'vTOR',0};


% % % % % initialCondition = [ 0.05; ... % Theta
% % % % %                     -0.05;...  % Phi
% % % % %                     .25; 0; 0; ... % theta0 theta1C theta1S 
% % % % %                     .25; ... % theta0tr
% % % % %                     0; 0; 0; ... % beta0 beta1C beta1S
% % % % %                     -sqrt(CW/2); 0; 0; % lambda0 lambda1C lambda1S
% % % % %                     CW; 0; 0; ... % CT0 CT1C CT1S
% % % % %                     0; 0; 0;  ... % beta0tr beta1Ctr beta1Str
% % % % %                     -sqrt(CW/20); 0; 0; ... % lambda0tr lambda1Ctr lambda1Str
% % % % %                     CW/10; 0; 0 ... % CT0tr CT1Ctr CT1Str
% % % % %                    ];
% % % % % 

%==========================================================================
% Solve the baseline reference trim problem
%==========================================================================
% Get the nondimensional helicopter
ndHeRef        = rigidHe2ndHe(he,atm,0);

disp ('Solving Reference trim ...  ');
% tsRef          = getTrimState(flightConditionT,muWT,ndHeRef,options);
ndTsRef = getNdHeTrimState(ndHeRef,muWT,FC,options);
ndTsRef.solution.('CP') = ndTsRef.ndPow.CP;


% TO BE REMOVED old code before getTrimState function (23/02/2014)
% system2solve = ...
% @(x) helicopterTrim(...
%      x,flightConditionT,muWT,ndHeRef,options ...
%                    );
% xRef  = options.nlSolver(system2solve,initialCondition,options);
% %     initialCondition = x(:,i);
% tsRef = getHeTrimState(xRef,flightConditionT,...
%                               muWT,ndHeRef,options);

% tsRef.power = getPowerHe(ndHeRef,tsRef,options,Pu,Wmr_tr);

A  = setTrimPracVars;
%ny = length(A.yvars);OSCAR
ny = length(A.var);%OSCAR

for i=1:ny
%     var = tsRef.(A.yvars{i})*A.yunits(i);
    var = ndTsRef.solution.(A.var{i})*A.unit(i);
    %dispstr=strcat(A.ylabs{i},'=',num2str(var));oscar
    dispstr=strcat(A.lab{i},'=',num2str(var));%oscar
    disp(dispstr)
end


%==========================================================================
% Solve the parametric trim problem
%==========================================================================

tic
for j = 1:np

    for i = 1:nv
        disp (['Solving trim...  ', num2str(i), ' of ', num2str(nv)]);
%         trimState{i}   = getTrimState(flightConditionT,muWT,ndHe{i,j},options);
        ndTs = getNdHeTrimState(ndHe{i,j},muWT,FC,options);
        ndTs.solution.('CP') = ndTs.ndPow.CP;
        ndtrimState{i} = ndTs;

    end
    toc
    %==========================================================================
    % Postprocess the solution
    %==========================================================================

    ndHeParam   = cell(nv,1);
    for i = 1:nv
        ndHeParam{i}  = ndHe{i,j};
    end
    % this function generates a valid trimstate for a cell of ndHe
    %trimStateParam = pndHe2trimState(ndHeParam,trimState,tsField{j},parval(:,j));
    trimStateParam = pndHe2trimState(ndHeParam,ndtrimState,tsField{j},parval(:,j));

    % First select the default trim state vars
    A = setTrimPracVars;

    % Then, change the x variable
%     A.xvar   = {tsField{j}};
%     A.xlab   = {tsLabel{j}};
%     A.xunit  = tsUnit(j);
%     plotTrimState(trimStateParam,[],'defaultVars',A)
    axds   = getaxds(tsField{j},tsLabel{j},tsUnit(j));%oscar
    ax = plotNdTrimSolution(trimStateParam,axds,[],'defaultVars',A,...
                 'plot2dMode','nFigures');%oscar

% uncomment this line to check plots
%     disp('Plotting one parameter: press any key to continue')
%     pause
%     close all
end

io = 1;


function X = setTrimPracVars


r2d    = 180/pi;

xvar   = {'mux'};
xlab   = {'V/(\Omega R) [-]'};
xunit  = 1;

yvars  = {...
         'Theta','Phi', ...
         'lambda0','lambda0tr', ...
         'theta0','theta1C','theta1S',...
         'theta0tr',....
         'beta0','beta1C','beta1S', ...
         'CP' ...
         };
ylabs  = { ...
         '\Theta [^o]','\Phi [^o]',...
         '\lambda_i [-]','\lambda_{ia} [-]',...
         '\theta_0 [^o]','\theta_{1C} [^o]','\theta_{1S} [^o]',...
         '\theta_{0tr} [^o]',...
         '\beta_0 [^o]','\beta_{1C} [^o]','\beta_{1S} [^o]'...
         'C_P [-]'
         };
yunits = [ ...
          r2d r2d ...
          1   1   ...
          r2d r2d r2d ...
          r2d ...
          r2d r2d r2d ...
          1
         ];

% X      = struct(...
%          'xvar',{xvar},...
%          'xlab',{xlab},...
%          'xunit',xunit,...
%          'yvars',{yvars},...
%          'ylabs',{ylabs},...
%          'yunits',yunits...
% );
X      = getaxds(yvars,ylabs,yunits);%oscar


function [he,parstr,parval,tsField,tsLabel,tsUnit] = getTrim02data(atm)
% The following snippet code should be implemented into a helper function
% to automatically create parameter variation 
%==========================================================================
% Automatic build up of parameter values
% for i=1:np
%     S            = struct('type','.','subs',regexp(parstr{i},'\.','split'));
%     parNom       = subsref(he, S);
%     if parNom == 0
%        parval(:,i)  = parNom + linspace(0.9,1.1,nv);
%     else
%        parval(:,i)  = parNom*linspace(0.9,1.1,nv);
%     end
% end
%==========================================================================
% In what follows a more feasible approach has been adopted. It has been
% preferred to input directly the students parameter variation instead of
% an automatic one


%==========================================================================
% trim02 DATA
%==========================================================================
% This is the chain to transform design requirements to statistical 
% helicopter and to rigid helicopter
numEngines = 1;
engine     = Arriel2C1(atm,numEngines);
dr         = cesarDR;

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



r2d        = 180/pi;
% input parameter definition
parstr      = {'geometry.xcg',...
               'mainRotor.theta1',...
               'geometry.epsilonx',...
               'mainRotor.kBeta'};

nv          = 11;
np          = length(parstr);
% rows define the values of the parameters
% the choice of the values are user-dependent
parval      = zeros(nv,np);
parval(:,1) = linspace(-1-0.126,1-0.126,nv);
parval(:,2) = linspace(-19.48,3.44,nv)/r2d;
parval(:,3) = linspace(-7.5,7.5,nv)/r2d;
parval(:,4) = linspace(0,332704,nv);

% output parameter definition
tsField    = {'xcg','theta1','epsilon','kBeta'};
tsLabel    = {'x_{CG} [m]','\theta_1 [^o]','\epsilon_x  [^o]','K_{\beta}'};
tsUnit     = [1,r2d,r2d,1];

