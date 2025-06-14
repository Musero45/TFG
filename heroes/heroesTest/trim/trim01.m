function io = trim01(mode)
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
[he,parstr,parval,tsField,tsLabel,tsUnit] = getTrim01data(atm);

% np is the number of parameters (4)
% nv is the number of values of the parameter
[nv,np]     = size(parval);

% Build up a cell of nondimensional helicopters of nv rows and np columns
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

muWT = [0; 0; 0];

% Hover flight condition
%flightConditionT = zeros(6,1);
ndtrimState        = cell(1,nv);

FC = {'uTOR',0,...
      'wTOR',0,...
      'Psi',0,...
      'cs',0,...
      'vTOR',0};

%==========================================================================
% Solve the baseline reference trim problem
%==========================================================================
% Get the nondimensional helicopter
ndHeRef        = rigidHe2ndHe(he,atm,0);

disp ('Solving Reference trim ...  ');

%tsRef          = getTrimState(flightConditionT,muWT,ndHeRef,options);
ndTsRef = getNdHeTrimState(ndHeRef,muWT,FC,options);
ndTsRef.solution.('CP') = ndTsRef.ndPow.CP;

A  = setTrimPracVars;
%ny = length(A.yvars);ALVARO
ny = length(A.var);%ALVARO

for i=1:ny
    %var = tsRef.(A.yvars{i})*A.yunits(i);
    var = ndTsRef.solution.(A.var{i})*A.unit(i);
    %dispstr=strcat(A.ylabs{i},'=',num2str(var));ALVARO
    dispstr=strcat(A.lab{i},'=',num2str(var));%ALVARO
    disp(dispstr)
end


%==========================================================================
% Solve the parametric trim problem
%==========================================================================

tic
for j = 1:np

    for i = 1:nv
        disp (['Solving trim...  ', num2str(i), ' of ', num2str(nv)]);
        %trimState{i}   = getTrimState(flightConditionT,muWT,ndHe{i,j},options);
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
    %A.xvar   = {tsField{j}};ALVARO
    %A.xlab   = {tsLabel{j}};ALVARO
    %A.xunit  = tsUnit(j);ALVARO
    %plotTrimState(trimStateParam,[],'defaultVars',A);ALVARO
    
    axds   = getaxds(tsField{j},tsLabel{j},tsUnit(j));%ALVARO
    ax = plotNdTrimSolution(trimStateParam,axds,[],'defaultVars',A,...
                 'plot2dMode','nFigures');%ALVARO

    disp('Plotting one parameter: press any key to continue')
%     pause
    %close all
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
     
% yvars  = {...
%          'Theta','Phi', ...
%          'lambda0','lambda0tr', ...
%          'theta0','theta1C','theta1S',...
%          'theta0tr',....
%          'beta0','beta1C','beta1S' ...
%             };
     
ylabs  = { ...
         '\Theta [^o]','\Phi [^o]',...
         '\lambda_i [-]','\lambda_{ia} [-]',...
         '\theta_0 [^o]','\theta_{1C} [^o]','\theta_{1S} [^o]',...
         '\theta_{0tr} [^o]',...
         '\beta_0 [^o]','\beta_{1C} [^o]','\beta_{1S} [^o]'...
         'C_P [-]'
         };
     
% ylabs  = { ...
%          '\Theta [^o]','\Phi [^o]',...
%          '\lambda_i [-]','\lambda_{ia} [-]',...
%          '\theta_0 [^o]','\theta_{1C} [^o]','\theta_{1S} [^o]',...
%          '\theta_{0tr} [^o]',...
%          '\beta_0 [^o]','\beta_{1C} [^o]','\beta_{1S} [^o]'...         
%          };
     
yunits = [ ...
          r2d r2d ...
          1   1   ...
          r2d r2d r2d ...
          r2d ...
          r2d r2d r2d ...
          1
         ];
     
%      yunits = [ ...
%           r2d r2d ...
%           1   1   ...
%           r2d r2d r2d ...
%           r2d ...
%           r2d r2d r2d ...
%            ];

% X      = struct(...
%          'xvar',{xvar},...
%          'xlab',{xlab},...
%          'xunit',xunit,...
%          'yvars',{yvars},...
%          'ylabs',{ylabs},...
%          'yunits',yunits...
% );ALVARO

X      = getaxds(yvars,ylabs,yunits);%ALVARO


function [he,parstr,parval,tsField,tsLabel,tsUnit] = getTrim01data(atm)
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
% trim01 DATA
%==========================================================================

% base helicopter
he         = practLynx(atm);

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
tsLabel    = {'x_{CG} [m]','\theta_1 [^o]','\epsilon_x  [^o]','k_{\beta}'};
tsUnit     = [1,r2d,r2d,1];

