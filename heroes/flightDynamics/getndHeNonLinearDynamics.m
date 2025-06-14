function ndHeNonLinearDynamics = getndHeNonLinearDynamics(taudata,Deltandx0,Deltaup,ndkSASlin,muWT,ndts,ndHe,varargin)
% getndHeNonLinearDynamics integrates the 9 nonlinear equations of the
% nondimensional helicopter flight Dynamics from an initial ndTrimState.
% The problem to solve can be written as it follows:
% 
%                dx
%               ----  = F(x(t),u(t)) 
%                dt
% 
% where x(t) is the state vector and u(t) is the control vector.
% 
% Furthermore, getndHeNonLinearDynamics calculates the nondimensional trim 
% trajectory (based on the initial ndTrimState) and the perturbation due 
% to the selected flight conditions and control.
% 
% 
% NLDYN = getndHeNonLinearDynamics(TAU,DNDX0,DUP,NDKSAS,MUWT,NDTS,NDHE)
% solves the nonlinear Dynamics problem for a NDHE nondimensional 
% helicopter, from a ndTrimState (NDTS), whose initial conditions are 
% perturbed by DNDX0, for an interval of nondimensional time 
% (t*he.mainRotor.Omega) given by TAU, in which the control of the pilot 
% DUP is known, and MUWT is the wind state. NDKSAS is the matrix for the 
% Stability Augmentation System for the linear problem [7x12].
% 
% NLDYN = getndHeNonLinearDynamics(TAU,DNDX0,DUP,NDKSAS,MUWT,NDTS,NDHE,OPT)
% computes as above with default options replaced by values set in OPT.
% 
% 
% *NOTE: State and control vectors have the flight dynamics order:
%               X = (uOR,wOR,omyad,Theta,vOR,omxad,Phi,omzad,Psi)
%               U = (theta0,theta1S,theta1C,theta0tr)
% 
% 
% Example of usage
% 
%     % Options and atmosphere definition
%     OPT     = setHeroesRigidOptions;
%     OPT.GT  = 0;
%     atm     = getISA;
%     g       = atm.g;
%     H       = 0;
%     rho     = atm.density(H);
%     
%     % Helicopter model selection
%     he      = PadfieldBo105(atm);
%     he.tailRotor.bm = 0.1;
%     
%     % Helicopter to Nondimensional Helicopter
%     NDHE    = rigidHe2ndHe(he,rho,g);
%     
%     % Initial flight condition
%     FC0 = {'VOR',0.05,'betaf0',0,'gammaT',0,'cs',0,'vTOR',0};
%     
%     % Nondimensional time vector
%     TAU = linspace(0,100,1001);
%     
%     % Perturbation from initial condition
%     DNDX0     = zeros (12,1);
%     
%     % Wind state
%     MUWT      = zeros(3,length(TAU));
%     muWT0     = MUWT(:,1);
%     
%     % ndTrimState calculation
%     NDTS   = getNdHeTrimState(NDHE,muWT0,FC0,OPT);
%     
%     % Additional control to ndTrimState:
%     DUP    =  zeros(4, length(TAU));
%     DUP(1,101:300) = pi/180;
%     
%     % Matrix for the Stability Augmentation System
%     NDKSAS = zeros(7,12);
%     
%     % NonLinear Dynamics solution
%     ndNlD=getndHeNonLinearDynamics(TAU,DNDX0,DUP,NDKSAS,MUWT,NDTS,NDHE,OPT)
% 
% See also ndDynamicSolution2DynamicSolution, getndHeLinDynSolution,
% getNonLinearDynamicsEquations


% Setup options
options = parseOptions(varargin,@setHeroesRigidOptions);

% Trim variables to vector initial_x
if strcmp(ndts.class,'ndHeTrimState')
   % ts input is a full ndHeTrimState (included solution substructure)
   ndtssol = ndts.solution;
elseif strcmp(ndts.class,'GeneralNdHeTrimSolution')
   % ts input is the solution substructure of a ndHeTrimState
   ndtssol = ndts;
else
   error('getndHeLinearStabilityState: wrong data class input')
end
x_ts          = struct2cell(ndtssol);
x_ts          = x_ts(2:end);

xM2D = zeros(length(x_ts),numel(x_ts{1}));
 
for xi = 1:length(x_ts);
     
    xM = x_ts{xi};
     
    for m = 1:numel(xM)
     
    xM2D(xi,m) = xM(m);
     
    end
     
end

y0 = xM2D;
aeromec_y0 = y0(7:end);
x0 = zeros(12,1);
u0 = zeros(4,1);

% Addition of initial perturbation to trim solution:
% a) For longitudinal variables (ueOR,weOR,omyad,Theta)
x0(1) = y0(30)+Deltandx0(1);                   % ueOR
x0(2) = y0(32)+Deltandx0(2);                   % weOR
x0(3) = y0(34)+Deltandx0(3);                   % omyad
x0(4) = y0(1)+Deltandx0(4);                    % Theta

% b) For lateral directional variables (veOR,omxad,Phi,omzad,Psi)
x0(5) = y0(31)+Deltandx0(5);                   % veOR
x0(6) = y0(33)+Deltandx0(6);                   % omxad
x0(7) = y0(2)+Deltandx0(7);                    % Phi
x0(8) = y0(35)+Deltandx0(8);                   % omzad
x0(9) = y0(26)+Deltandx0(9);                   % Psi


% Initial position:
x0(10) = Deltandx0(10);                        % xTad
x0(11) = Deltandx0(11);                        % yTad
x0(12) = Deltandx0(12);                        % zTad


% Initial condition for control:
u0(1) = y0(3);                                 % theta0
u0(2) = y0(5);                                 % theta1S
u0(3) = y0(4);                                 % theta1C
u0(4) = y0(6);                                 % thetatr0


% Interpolation of wind vector
muWTfun = @(tau)([interp1(taudata,muWT(1,:),tau) ...
                  interp1(taudata,muWT(2,:),tau) ...
                  interp1(taudata,muWT(3,:),tau)]');
    

% Interpolation of Control data to obtain controlFunction in the flight
% mechanic order Theta0 Theta1S Theta1C Theta0tr
PilotControlFunction = @(tau)([u0(1)+interp1(taudata,Deltaup(1,:),tau) ...
                               u0(2)+interp1(taudata,Deltaup(2,:),tau) ...
                               u0(3)+interp1(taudata,Deltaup(3,:),tau) ...
                               u0(4)+interp1(taudata,Deltaup(4,:),tau)]');
% Stability Augmentation System(SAS), ndkSAS matrix is required as an input
ndkSAS = ndkSASlin(1:4,1:12);
ControlSAS = @(x) (-(ndkSAS*(x-x0)));
   
% ControlFun as an addition of Pilot control and SAS
ControlFun = @(tau,x)(PilotControlFunction(tau)+ControlSAS(x));                     

% Definition of the funtion F(x,u,t)= dx/dt
F = @(tau,x) getNonLinearDynamicsEquations(tau,x,ControlFun(tau,x),...
                                    muWTfun(tau),aeromec_y0,ndHe,options);


% INTEGRATION
tauspan = [taudata(1) max(taudata)];
initialCondition = x0;

disp (['Solving Nonlinear problem...']);
[tausol,ndxsol] = ode45(F,tauspan,initialCondition);


% Trajectory solution for trim state
ndxtraj_e = zeros(length(tausol),1);
ndytraj_e = zeros(length(tausol),1);
ndztraj_e = zeros(length(tausol),1);
uTOR_0e  = zeros(length(tausol),1);
vTOR_0e  = zeros(length(tausol),1);
wTOR_0e  = zeros(length(tausol),1);

% Trajectory solution incluiding perturbations from trim state
ndxtraj = zeros(length(tausol),1);
ndytraj = zeros(length(tausol),1);
ndztraj = zeros(length(tausol),1);


OmegaAdzT = y0(36);                             % OmegaAdzT (fixed axes)
uTORe     = y0(27);                             % uTOR
vTORe     = y0(28);                             % vTOR
wTORe     = y0(29);                             % wTOR

% Angle with fixed Earth axes
InitialPsiT0 = 0;
PsiT_T0 = zeros(length(tausol),1);

for i = 1:length(tausol)
    PsiT_T0(i) = InitialPsiT0 + OmegaAdzT*tausol(i);
    uTOR_0e(i)  = uTORe*cos(PsiT_T0(i)) - vTORe*sin(PsiT_T0(i));
    vTOR_0e(i)  = uTORe*sin(PsiT_T0(i)) + vTORe*cos(PsiT_T0(i));
    wTOR_0e(i)  = wTORe;
    
    ndxtraj(i) = ndxsol(i,10);
    ndytraj(i) = ndxsol(i,11);
    ndztraj(i) = ndxsol(i,12);
    
    if i>1.5
        ndxtraj_e(i) = trapz(tausol(1:i),uTOR_0e(1:i)) + Deltandx0(10);
        ndytraj_e(i) = trapz(tausol(1:i),vTOR_0e(1:i)) + Deltandx0(11);
        ndztraj_e(i) = trapz(tausol(1:i),wTOR_0e(1:i)) + Deltandx0(12);
    end
end
ndtrimtraj_e = zeros (length(tausol),3);
ndtrimtraj_e(1,:)= [Deltandx0(10) Deltandx0(11) Deltandx0(12)];
ndtrimtraj_e(:,1)= ndxtraj_e;
ndtrimtraj_e(:,2)= ndytraj_e;
ndtrimtraj_e(:,3)= ndztraj_e;

ndtraj      = zeros (length(tausol),3);
ndtraj(1,:)= [Deltandx0(10) Deltandx0(11) Deltandx0(12)];
ndtraj(:,1) = ndxtraj;
ndtraj(:,2) = ndytraj;
ndtraj(:,3) = ndztraj;

% Trajectory to Ground axes (180º rotation around x: y -> -y ;  z -> -z)
ndGroundtraj = zeros(size(ndtraj));
ndGroundtraj(:,1) = ndtraj(:,1);
ndGroundtraj(:,2) = -ndtraj(:,2);
ndGroundtraj(:,3) = -ndtraj(:,3);

% Solution presentation
Deltandxsol     = zeros(length(tausol),9);
Deltandtraj     = zeros(length(tausol),3);
controlsol      = zeros(length(tausol),4);
pilotcontrolsol = zeros(length(tausol),4);
SAScontrolsol   = zeros(length(tausol),4);

for i=1:length(tausol)
    Deltandxsol(i,:) = ndxsol(i,1:9) - ndxsol(1,1:9);
    Deltandtraj(i,:) = ndtraj(i,:) - ndtrimtraj_e(i,:);
    controlsol(i,:)  = ControlFun(tausol(i),ndxsol(i,:)')';
    pilotcontrolsol(i,:) = PilotControlFunction(tausol(i));
    SAScontrolsol(i,:) = ControlSAS(ndxsol(i));    
end
                             
statesolution           =  struct('uOR',ndxsol(:,1),...
                                  'wOR',ndxsol(:,2),...
                                  'omyad',ndxsol(:,3),...
                                  'Theta',ndxsol(:,4),...
                                  'vOR',ndxsol(:,5),...
                                  'omxad',ndxsol(:,6),...
                                  'Phi',ndxsol(:,7),...
                                  'omzad',ndxsol(:,8),...
                                  'Psi',ndxsol(:,9),...
                                  'Delta_uOR',Deltandxsol(:,1),...
                                  'Delta_wOR',Deltandxsol(:,2),...
                                  'Delta_omyad',Deltandxsol(:,3),...
                                  'Delta_Theta',Deltandxsol(:,4),...
                                  'Delta_vOR',Deltandxsol(:,5),...
                                  'Delta_omxad',Deltandxsol(:,6),...
                                  'Delta_Phi',Deltandxsol(:,7),...
                                  'Delta_omzad',Deltandxsol(:,8),...
                                  'Delta_Psi',Deltandxsol(:,9));
                                   
trajectorysolution      =  struct('ndxT0trim',ndtrimtraj_e(:,1),...
                                  'ndyT0trim',ndtrimtraj_e(:,2),...
                                  'ndzT0trim',ndtrimtraj_e(:,3),...
                                  'DeltandxT0',Deltandtraj(:,1),...
                                  'DeltandyT0',Deltandtraj(:,2),...
                                  'DeltandzT0',Deltandtraj(:,3),...
                                  'ndxG',ndGroundtraj(:,1),...
                                  'ndyG',ndGroundtraj(:,2),...
                                  'ndzG',ndGroundtraj(:,3));

controlsolution         =  struct('theta0',controlsol(:,1),...
                                  'theta1S',controlsol(:,2),...
                                  'theta1C',controlsol(:,3),...
                                  'theta0tr',controlsol(:,4),...
                                  'Pilot_theta0',pilotcontrolsol(:,1),...
                                  'Pilot_theta1S',pilotcontrolsol(:,2),...
                                  'Pilot_theta1C',pilotcontrolsol(:,3),...
                                  'Pilot_theta0tr',pilotcontrolsol(:,4),...
                                  'SAS_theta0',SAScontrolsol(:,1),...
                                  'SAS_theta1S',SAScontrolsol(:,2),...
                                  'SAS_theta1C',SAScontrolsol(:,3),...
                                  'SAS_theta0tr',SAScontrolsol(:,4));
                              
tausolution             =  struct('solution',tausol);


ndHeNonLinearDynamics   =  struct('ndstate',statesolution,...
                                  'ndtrajectory',trajectorysolution,...
                                  'control',controlsolution,...
                                  'tau',tausolution); 
                              
end    
