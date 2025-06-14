function linearDynamicSolution = getndHeLinDynSolution(taudata,ndA,ndB,ndC,ndD,ndBwind,Deltandx0,Deltaup,ndkSAS,DeltamuWT,ndts,varargin)
% getndHeLinDynSolution obtains the linear solution for the dynamics of a
% non dimensional helicopter from an initial ndTrimState.
% This problem can be written as it follows:
% 
%                dx
%               ----  = Ax(t) + Bu(t)
%                dt
% 
% where x(t) is the perturbation of the state vector from the initial nd
% Trim State one, and u(t) is the perturbation of the control vector. A and
% B are stability and control matrices.
% 
% Furthermore, getndHeLinDynSolution calculates trim nondimensional trim 
% trajectory (based on the initial ndTrimState) and the perturbation due 
% to the flight conditions and control.
%
% 
% LDYN = getndHeLinDynSolution(TAU,A,B,C,D,BW,DX0,DUP,KSAS,DMUWT,NDTS)
% solves the linear Dynamics problem for a NDHE nondimensional helicopter,
% from a ndTrimState (NDTS), whose initial conditions are perturbed by DX0,
% for an interval of nondimensional time (t*he.mainRotor.Omega) given by 
% TAU, in which the control of the pilot DUP is known, and DMUWT is the 
% wind state perturbation. A is the stability matrix, B is the control 
% matrix, C and D are matrices for the linear control problem and BW is the
% control matrix related to wind. KSAS is the nondimensional matrix for the
% Stability Augmentation System [7x12].
% 
% LDYN = getndHeLinDynSolution(TAU,A,B,C,D,BW,DX0,DUP,KSAS,DMUWT,NDTS,OPT)
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
%     DX0     = zeros (12,1);
%     
%     % Wind state
%     MUWT      = zeros(3,length(TAU));
%     muWT0     = MUWT(:,1);
%     for i = 1:length(TAU)
%         DMUWT(:,i) = MUWT(:,i)-muWT0;
%     end
%     
%     % ndTrimState calculation
%     NDTS   = getNdHeTrimState(NDHE,muWT0,FC0,OPT);
%     
%     % Additional control to ndTrimState:
%     DUP    =  zeros(4, length(TAU));
%     DUP(1,101:300) = pi/180;
%     
%     % Matrices for linear control
%     ndSs = getndHeLinearStabilityState(NDTS,muWT0,NDHE,OPT);
%     A = ndSs.ndA;
%     B = ndSs.ndB;
%     C = eye(9);
%     D = zeros(9,4);  
%     BW = zeros(9,3);
% 
%     % Matrix for the Stability Augmentation System
%     KSAS = zeros(7,12);
%     
%     % NonLinear Dynamics solution
%     LDYN = getndHeLinDynSolution(TAU,A,B,C,D,BW,DX0,DUP,KSAS,DMUWT,NDTS,OPT)
% 
% See also ndDynamicSolution2DynamicSolution, getndHeNonLinearDynamics



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

% Trim state variables
ueORe  = y0(30);                                % ueOR
weORe  = y0(32);                                % weOR
omyade = y0(34);                                % omyad
Thetae = y0(1);                                 % Theta
veORe  = y0(31);                                % veOR
omxade = y0(33);                                % omxad
Phie   = y0(2);                                 % Phi
omzade = y0(35);                                % omzad
Psie   = y0(26);                                % Psi

OmegaAdzT = y0(36);                             % OmegaAdzT (fixed axes)
uTORe     = y0(27);                             % uTOR
vTORe     = y0(28);                             % vTOR
wTORe     = y0(29);                             % wTOR

% Trim state control vector
theta0e = y0(3);                                % theta0
theta1Ce = y0(4);                               % theta1C
theta1Se = y0(5);                               % theta1S
theta0tre = y0(6);                              % theta0tr

% Trajectory solution for trim state
ndxtraj_e = zeros(length(taudata),1);
ndytraj_e = zeros(length(taudata),1);
ndztraj_e = zeros(length(taudata),1);
uTOR_0  = zeros(length(taudata),1);
vTOR_0  = zeros(length(taudata),1);
wTOR_0  = zeros(length(taudata),1);

% Angle with fixed Earth axes
InitialPsiT0 = 0;
PsiT_T0 = zeros(length(taudata),1);


for i = 1:length(taudata)
    PsiT_T0(i) = InitialPsiT0 + OmegaAdzT*taudata(i);
    uTOR_0(i)  = uTORe*cos(PsiT_T0(i)) - vTORe*sin(PsiT_T0(i));
    vTOR_0(i)  = uTORe*sin(PsiT_T0(i)) + vTORe*cos(PsiT_T0(i));
    wTOR_0(i)  = wTORe;
    
    if i>1.5
        ndxtraj_e(i) = trapz(taudata(1:i),uTOR_0(1:i)) + Deltandx0(10);
        ndytraj_e(i) = trapz(taudata(1:i),vTOR_0(1:i)) + Deltandx0(11);
        ndztraj_e(i) = trapz(taudata(1:i),wTOR_0(1:i)) + Deltandx0(12);
    end
end
ndtrimtraj_e = zeros (length(taudata),3);
ndtrimtraj_e(1,:)= [Deltandx0(10) Deltandx0(11) Deltandx0(12)];
ndtrimtraj_e(:,1)= ndxtraj_e;
ndtrimtraj_e(:,2)= ndytraj_e;
ndtrimtraj_e(:,3)= ndztraj_e;

% Matrix A with no System of Augmentation of Stability
ndA_SASoff = zeros(12,12);
ndA_SASoff(1:9,1:9)= ndA;
ndAtr = getndAtrajmatrix(ueORe,weORe,Thetae,veORe,Phie,Psie);
ndA_SASoff(10:12,1:9) = ndAtr;

% Matrix B
B          = zeros(12,7);
B(1:9,1:4) = ndB;
B(1:9,5:7) = ndBwind;

% Final matrix A
ndA_SAS    = ndA_SASoff - (B*ndkSAS);

% Matrix C with no System of Augmentation of Stability
ndC_SASoff = zeros(12,12);
ndC_SASoff(1:9,1:9)= ndC;
ndC_SASoff(10:12,10:12)= eye(3);

% Matrix B
D          = zeros(12,7);
D(1:9,1:4) = ndD;

% Final matrix C
ndC_SAS = ndC_SASoff-(D*ndkSAS); 

% Linearized system:
syslin = ss(ndA_SAS,B,ndC_SAS,D);

% Control vector incluiding wind
Delta_u = zeros(7,length(taudata));
Delta_u(1:4,:) = Deltaup;
Delta_u(5:7,:) = DeltamuWT;


% Solution for Deltandx
disp (['Solving Linear problem...']);
Deltandxlin = lsim(syslin,Delta_u,taudata,Deltandx0);

% Addition of trim state variables:
ndxlin  = zeros(size(Deltandxlin(:,1:9)));
ndxlin0 = [ueORe weORe omyade Thetae veORe omxade Phie omzade Psie];
pilotcontrolsol  = zeros(length(taudata),4);
pilotcontrolsol0 = [theta0e theta1Ce theta1Se theta0tre];
SAScontrolsol    = zeros(length(taudata),7);
totalcontrolsol  = zeros(length(taudata),4);
Deltandtraj      = zeros(length(taudata),3);
for i = 1:length(taudata)
    % State
    ndxlin(i,:)= ndxlin0 + Deltandxlin(i,1:9);
    % Control
    pilotcontrolsol(i,:) = pilotcontrolsol0 + Deltaup(:,i)';
    SAScontrolsol(i,:)   = ndkSAS*(Deltandxlin(i,:)');
    totalcontrolsol(i,:) = pilotcontrolsol(i,:)+SAScontrolsol(i,1:4);
    % Trajectory
    Deltandtraj(i,1)     = Deltandxlin(i,10)*cos(PsiT_T0(i))- ...
                           Deltandxlin(i,11)*sin(PsiT_T0(i));
    Deltandtraj(i,2)     = Deltandxlin(i,10)*sin(PsiT_T0(i))+ ...
                           Deltandxlin(i,11)*cos(PsiT_T0(i));
    Deltandtraj(i,3)     = Deltandxlin(i,12);                   
end

% Trajectory to Ground axes (180º rotation around x: y -> -y ;  z -> -z)
ndGroundtraj = zeros(size(Deltandtraj));
ndGroundtraj(:,1) = ndtrimtraj_e(:,1)+Deltandtraj(:,1);
ndGroundtraj(:,2) = -(ndtrimtraj_e(:,2)+Deltandtraj(:,2));
ndGroundtraj(:,3) = -(ndtrimtraj_e(:,3)+Deltandtraj(:,3));


statesolution           =  struct('uOR',ndxlin(:,1),...
                                  'wOR',ndxlin(:,2),...
                                  'omyad',ndxlin(:,3),...
                                  'Theta',ndxlin(:,4),...
                                  'vOR',ndxlin(:,5),...
                                  'omxad',ndxlin(:,6),...
                                  'Phi',ndxlin(:,7),...
                                  'omzad',ndxlin(:,8),...
                                  'Psi',ndxlin(:,9),...
                                  'Delta_uOR',Deltandxlin(:,1),...
                                  'Delta_wOR',Deltandxlin(:,2),...
                                  'Delta_omyad',Deltandxlin(:,3),...
                                  'Delta_Theta',Deltandxlin(:,4),...
                                  'Delta_vOR',Deltandxlin(:,5),...
                                  'Delta_omxad',Deltandxlin(:,6),...
                                  'Delta_Phi',Deltandxlin(:,7),...
                                  'Delta_omzad',Deltandxlin(:,8),...
                                  'Delta_Psi',Deltandxlin(:,9));
                                   
trajectorysolution      =  struct('ndxT0trim',ndtrimtraj_e(:,1),...
                                  'ndyT0trim',ndtrimtraj_e(:,2),...
                                  'ndzT0trim',ndtrimtraj_e(:,3),...
                                  'DeltandxT0',Deltandtraj(:,1),...
                                  'DeltandyT0',Deltandtraj(:,2),...
                                  'DeltandzT0',Deltandtraj(:,3),...
                                  'ndxG',ndGroundtraj(:,1),...
                                  'ndyG',ndGroundtraj(:,2),...
                                  'ndzG',ndGroundtraj(:,3));

controlsolution         =  struct('theta0',totalcontrolsol(:,1),...
                                  'theta1S',totalcontrolsol(:,2),...
                                  'theta1C',totalcontrolsol(:,3),...
                                  'theta0tr',totalcontrolsol(:,4),...
                                  'Pilot_theta0',pilotcontrolsol(:,1),...
                                  'Pilot_theta1S',pilotcontrolsol(:,2),...
                                  'Pilot_theta1C',pilotcontrolsol(:,3),...
                                  'Pilot_theta0tr',pilotcontrolsol(:,4),...
                                  'SAS_theta0',SAScontrolsol(:,1),...
                                  'SAS_theta1S',SAScontrolsol(:,2),...
                                  'SAS_theta1C',SAScontrolsol(:,3),...
                                  'SAS_theta0tr',SAScontrolsol(:,4));
                              
tausolution             =  struct('solution',taudata);


linearDynamicSolution   =  struct('ndstate',statesolution,...
                                  'ndtrajectory',trajectorysolution,...
                                  'control',controlsolution,...
                                  'tau',tausolution); 
end

