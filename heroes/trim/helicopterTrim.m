function F = helicopterTrim (x,muWT,ndHe,trimSetUp,varargin)
% helicopterTrim defines the system of non dimensional equations
% to solve the general trim problem (including spiral flight and
% autorrotation).
%
% helicopterTrim (x,muWT,ndHe,options,trimSetUp) defines the system
% of 42 non dimensional equations to solve the general trim problem
% F(Xe,Ue)=0, where Xe is the nondimensional state vector and Ue is
% the non dimensional control vector.
%
% x:         is the generalised flight state vector. Pay attention to
%            the fact that x in helicopterTrim(x,...) is a vector formed
%            by 43 flight state varaibles, so it includes Xe, Ue and many
%            more variables following defined.
%
% muWT:      is the nondimensional wind velocity vector expressed in
%            the ground reference system.
% 
% options:   is a structure specifiying the HeroesRigidOptions,
%            see also: setHeroesRigidOptions
%
% trimSetUp: is a structure specifiying the five components of the
%            the generalised flight state vector x provided by the user
%            to solve the general trim problem.
%      
%
% The basic system of 9 equations that define the general trim
% problem has been generasiled (to totalize 43) including:
%   3 force equilibrium equations
%   3 moment equilibrium equations with respect to the gravity center
%   1 engineState equation (motorised or autorrotation flight).
%   9 aeromechanic equations for the main rotor.
%   9 aeromechanic equations for the tail rotor.
%   3 equations to relate nondimensional angular velocities at body
%   reference system with the omegaAdzT nondimensional angular velocity
%   3 equations to relate the flight velocity in ground and body
%     reference systems.
%   3 equations to relate the two ways of expresing the flight
%     velocicity in the ground reference system, (uTOR,vTOR,wTOR)=
%     f(V/OR,betaT,gammaT).
%   2 equations to relate the fuselage slip angle and angle of attack
%     to the ground velocidy components.
%   1 equation to relate the curvature of the flight path, cs, with
%     the longitudinal component of the flight velocity uT/OR and 
%     constant angular velociy omegaAdzT.
%   All these equations sum up to 37 equations. Therefore the number of
%   degrees of freedom of the system is 5, that is, the number of unknowns
%   (42) minus the number of equations (39). Then a set of 5 equations
%   fixing 5 unknowns should be added:
%   5 equations for prescribing (by the user) in a flexible way the 
%     trimSetUp variables (known variables in vector x for which the
%     general trim problem is soved.
%
% The components in the generalised flight state vector x(i) are
% x(1): Theta       
% x(2): Phi             
% x(3): theta0                 
% x(4): theta1C            
% x(5): theta1S           
% x(6): the2ta0tr               
% x(7): beta0                  
% x(8): beta1C                 
% x(9): beta1S                 
% x(10): lambda0               
% x(11): lambda1C               
% x(12): lambda1S              
% x(13): CT0                   
% x(14): CT1C                   
% x(15): CT1S                   
% x(16): beta0tr                
% x(17): beta1Ctr 
% x(18): beta1Str       
% x(19): lambda0tr
% x(20): lambda1Ctr
% x(21): lambda1Str
% x(22): CT0tr
% x(23): CT1Ctr
% x(24): CT1Str
% x(25): omega
% x(26): Psi
% x(27): uTOR
% x(28): vTOR
% x(29): wTOR
% x(30): ueOR
% x(31): veOR
% x(32): weOR 
% x(33): omxad
% x(34): omyad
% x(35): omzad 
% x(36): omegaAdzT
% x(37): VOR 
% x(38): gammaT  
% x(39): betaT
% x(40): betaf0
% x(41): alphaf0
% x(42): cs

  


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%Big transformation due to the generalisation of the trim problem. Since
%%the flight condition fCT (with velocity components in the ground axis and
%%the angular velocities in the body frame are not directly specified, but
%%they are part of the general trim state vecto x some the fCV is directy
%%defined from the x components ueOR, veOR, weOR, omxad, omyad and omzad%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

options    = parseOptions(varargin,@setHeroesRigidOptions);
aeromechanicModel = options.aeromechanicModel;

%==========================================================================
% Required desing data
%--------------------------------------------------------------------------
%Nominal weight coefficient
CWrated = ndHe.inertia.CW;

%Linear and angular dynamic coefficients
gammay = ndHe.inertia.gammay;
aG = ndHe.mainRotor.aG;

%Non dimensional inertia tensor
RIxy = ndHe.inertia.RIxy;
RIzy = ndHe.inertia.RIzy;
RIxyy = ndHe.inertia.RIxyy;
RIxzy = ndHe.inertia.RIxzy;
RIyzy = ndHe.inertia.RIyzy;

Iad = [[RIxy -RIxyy -RIxzy];[-RIxyy 1 -RIyzy];[-RIxzy -RIyzy RIzy]];

%Non dimensional characterisitcs of the main rotor
ndMR = ndHe.mainRotor;

%Non dimensional characterisitcs of the tail rotor
ndTR = ndHe.tailRotor;

%Gravity factor
GT   = options.GT;

%Engine state
EngineState = options.engineState;

%==========================================================================
% Definition of the known FC data. This must be changed to allow for vector
% inputs

%Variables in x prescribed by the used
FC1 = trimSetUp.FC1;
FC2 = trimSetUp.FC2;
FC3 = trimSetUp.FC3;
FC4 = trimSetUp.FC4;
FC5 = trimSetUp.FC5;

%Values of the varaibles in x prescribed by the used
valFC1 = trimSetUp.valFC1;
valFC2 = trimSetUp.valFC2;
valFC3 = trimSetUp.valFC3;
valFC4 = trimSetUp.valFC4;
valFC5 = trimSetUp.valFC5;

n = size(FC1);

%==========================================================================
%Variables asignments

ueOR = x(30);
veOR = x(31);
weOR = x(32);

betaf0  = x(40);
alphaf0 = x(41);

omxad = x(33);
omyad = x(34);
omzad = x(35);

omegaAdzT = x(36);

cs = x(42);%Spiral path defined by non-dimensional spiral curvature

uTOR = x(27);
vTOR = x(28);
wTOR = x(29);

VOR = x(37); 
gammaT = x(38);  
betaT = x(39);

Psi   = x(26);
Theta = x(1);
Phi   = x(2);

theta      = [x(3); x(4); x(5)];
thetatr    = [x(6);0;0];
beta       = [x(7); x(8); x(9)];
lambda     = [x(10); x(11); x(12)];

omega = x(25);
%CW = x(25);

CW = (CWrated*omega^-2);

GA   = zeros(3,1);
GAtr = zeros(3,1);

epsx    = ndHe.geometry.epsilonx;
epsy    = ndHe.geometry.epsilony;
epstr   = ndHe.geometry.thetatr;

MAF   = TAF(epsx,epsy);
MAtrF = TAtrF(epstr);


    MFT      = TFT(Psi,Theta,Phi);
    fCV      = [ueOR;veOR;weOR;omxad;omyad;omzad];
    muWV     = MFT*muWT;
    GA       = MAF*MFT*[0;0;GT];
    GAtr     = MAtrF*MFT*[0;0;GT];


vel = velocities(fCV,muWV,lambda,beta,ndHe,options);

flightConditionA   = vel.A;
muWA               = vel.WA;
flightConditionAtr = vel.Atr;
muWAtr             = vel.WAtr;

[CFW,CFmr,CMmr,CMFmr,CFtr,CMtr,CMFtr,CFf,CMf,CMFf,CFvf,CMvf,CMFvf,...
CFlHTP,CMlHTP,CMFlHTP,CFrHTP,CMrHTP,CMFrHTP] =  getHeForcesAndMoments(x,vel,ndHe,options);


%==========================================================================
% BASIC SYSTEM OF 9 EQUATIONS DEFINING THE GENERAL TRIM PROBLEM
% (1:3) 3 force equations. (4:6) 3 moment equations. (34:36) 3 kinematic equations
%--------------------------------------------------------------------------
%Inertial terms
InertialF = -(1/aG)*CW*cross([omxad,omyad,omzad],[ueOR,veOR,weOR]); 
InertialM = -(1/gammay)*cross([omxad,omyad,omzad],Iad*[omxad;omyad;omzad]);

F(1) = CFmr(1)+CFtr(1)+CFf(1)+CFvf(1)+CFlHTP(1)+CFrHTP(1)+CFW(1)+InertialF(1);
F(2) = CFmr(2)+CFtr(2)+CFf(2)+CFvf(2)+CFlHTP(2)+CFrHTP(2)+CFW(2)+InertialF(2);
F(3) = CFmr(3)+CFtr(3)+CFf(3)+CFvf(3)+CFlHTP(3)+CFrHTP(3)+CFW(3)+InertialF(3);
F(4) = CMmr(1)+CMFmr(1)+CMtr(1)+CMFtr(1)+CMf(1)+CMFf(1)+CMvf(1)+CMFvf(1)+CMlHTP(1)+CMFlHTP(1)+CMrHTP(1)+CMFrHTP(1)+InertialM(1);
F(5) = CMmr(2)+CMFmr(2)+CMtr(2)+CMFtr(2)+CMf(2)+CMFf(2)+CMvf(2)+CMFvf(2)+CMlHTP(2)+CMFlHTP(2)+CMrHTP(2)+CMFrHTP(2)+InertialM(2);
F(6) = CMmr(3)+CMFmr(3)+CMtr(3)+CMFtr(3)+CMf(3)+CMFf(3)+CMvf(3)+CMFvf(3)+CMlHTP(3)+CMFlHTP(3)+CMrHTP(3)+CMFrHTP(3)+InertialM(3);

omegaAdFromTurn = TFT(Psi,Theta,Phi)*[0;0;omegaAdzT];

F(34) = omegaAdFromTurn(1)-omxad;
F(35) = omegaAdFromTurn(2)-omyad;
F(36) = omegaAdFromTurn(3)-omzad;
%==========================================================================


%==========================================================================
% F(7:15) 9 aeromechanic equations for the main rotor.
%--------------------------------------------------------------------------
F(7:15)  = aeromechanicModel(x(7:15),theta,flightConditionA,GA,muWA,ndMR,options);
%==========================================================================


%==========================================================================
% F(16:24) 9 aeromechanic equations for the tail rotor.
%--------------------------------------------------------------------------
F(16:24) = aeromechanicModel(x(16:24),thetatr,flightConditionAtr,GAtr,muWAtr,ndTR,options);
%==========================================================================


 
 
%==========================================================================
% F(25) 1 engineState equation (motorised or autorrotation flight).
%--------------------------------------------------------------------------
 CMmrA =  MAF*CMmr;
 CMtrAtr = MAtrF*CMtr;
 
 CQmr = -CMmrA(3);
 CQtr = -CMtrAtr(3);
 
F(25) =  EngineState(CWrated,omega,CQmr,CQtr,ndHe);
%==========================================================================


%==========================================================================
% F(26:28) 3 equations to relate the flight velocity in ground and body
% reference systems.
%--------------------------------------------------------------------------
VFOR = MFT*[uTOR;vTOR;wTOR];

ueORfromT = VFOR(1);
veORfromT = VFOR(2);
weORfromT = VFOR(3);

F(26:28) = [ueOR;veOR;weOR]-[ueORfromT;veORfromT;weORfromT];
%==========================================================================


%==========================================================================
% F(29:33) 5 equations for prescribing (by the user) in a flexible way the 
% TrimSetUp variables (known variables in vector x for which the
% general trim problem is soved.
%--------------------------------------------------------------------------
F(29) = x(FC1)-valFC1;
F(30) = x(FC2)-valFC2;
F(31) = x(FC3)-valFC3;
F(32) = x(FC4)-valFC4;
F(33) = x(FC5)-valFC5;
%==========================================================================


%==========================================================================
% F(37:39) 3 equations to relate the two ways of expresing the flight
% velocicity in the ground reference system, (uTOR,vTOR,wTOR)=
% f(V/OR,betaT,gammaT).
%--------------------------------------------------------------------------
F(37) = VOR*cos(gammaT)*cos(betaT)-uTOR;
F(38) = VOR*cos(gammaT)*sin(betaT)-vTOR;
%F(38) = VOR-abs(sqrt(uTOR^2+vTOR^2+wTOR^2));
F(39) = VOR*sin(gammaT)+wTOR;
%==========================================================================


%==========================================================================
% F(40:41) 2 equations to relate the fuselage slip angle and angle of attack
% to the ground velocidy components.
%--------------------------------------------------------------------------
F(40) = VOR*sin(betaf0)-veOR;
F(41) = VOR*cos(betaf0)*sin(alphaf0)-weOR;
%==========================================================================



%==========================================================================
% F(42) 1 equation to relate the curvature of the flight path, cs, with
% the longitudinal component of the flight velocity uT/OR and 
% constant angular velociy omegaAdzT.
%--------------------------------------------------------------------------
F(42) = omegaAdzT-cs*uTOR;
%==========================================================================


%==========================================================================
% F(43) 1 equation to define CW-CWrated*(omega)^-2
%--------------------------------------------------------------------------
%F(43) = CW*omega^2-CWrated;




