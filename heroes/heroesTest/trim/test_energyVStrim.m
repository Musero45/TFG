function io = test_energyVStrim
% This script compares the non dimensional power curve obtained from 
% (i) energy method with
% (ii) trim method. 
% From a common design requirement an energy helicopter and a rigid 
% helicopter are built in. The design requirements correspond
% to the Bo-105
%
% TODO
% * Compute the power curve in a nondimensional form CQ instead of power in
%   kW.




close all

% Load atmosphere
atm   = getISA;


% Define common part from desreq
numEngines = 1;
engine     = Arriel2C1(atm,numEngines);
dr         = cesarDR;

% statistical helicopter
stathe     = desreq2stathe(dr,engine);


% Set trim computation options
opt1       = {...
    'linearInflow',@LMTGlauert,...
    'uniformInflowModel',@Glauert,...
    'armonicInflowModel',@none,...
    'mrForces',@thrustF,...
    'mrMoments',@aerodynamicM, ...
    'trForces',@thrustF,...
    'trMoments',@aerodynamicM, ...
    'GT',1, ...
    'inertialFM',0 ...
};

options    = parseOptions(opt1,@setHeroesRigidOptions);

% Define base line rigid helicopter
rhe        = getBaseRigidHe(stathe,atm);


OR         = rhe.mainRotor.R*rhe.mainRotor.Omega;
% Get common flight condition
[gammaT,H,Z,V,fCT,muWT]  = getLeveledForwardFlightCondition(OR);


%==========================================================================
% Define energy helicopter without fuselage f = 0, and no tail rotor,
% eta_ra = 0
%
kappa       = 1.0;
ehe_notrf1  = getkappaEheNO_tr_f(stathe,kappa,atm);
PA1         = getP(ehe_notrf1,V,gammaT,H,Z,atm);

kappa       = 1.15;
ehe_notrf2  = getkappaEheNO_tr_f(stathe,kappa,atm);
PA2         = getP(ehe_notrf2,V,gammaT,H,Z,atm);

%==========================================================================
% Define energy helicopter without fuselage f = 0, but with tail rotor,
% eta_ra = 0.1 and with kappa = 1.15 which it seems to be an adecuate value
% for fitting power values at hover and low fowrward velocities
eta_ra    = 0.05;
ehe_nof1  = getEheNO_f(stathe,eta_ra,atm);
PB1       = getP(ehe_nof1,V,gammaT,H,Z,atm);

eta_ra    = 0.20;
ehe_nof2  = getEheNO_f(stathe,eta_ra,atm);
PB2       = getP(ehe_nof2,V,gammaT,H,Z,atm);

% Define rigid helicopter without fuselage, and with tail rotor because a
% rigid helicopter without tail rotor is quite difficult of being trimmed
% it requires a big roll angle plus a higher consumption of power 
rhe_nof                    = rhe;
rhe_nof.fuselage.active    = 'no';
rhe_nof.tailRotor.active   = 'yes';
rhe_nof.verticalFin.active = 'no';
rhe_nof.leftHTP.active     = 'no';
rhe_nof.rightHTP.active    = 'no';

% helicopter 2 non-dimensional helicopter
ndHe_nof    = rigidHe2ndHe(rhe_nof,atm.rho0,atm.g);

% Define rigid helicopter with fuselage and with tail rotor. Model for
% fuselage coefficients is the general fuselage model
rhe_f1                    = rhe;
rhe_f1.fuselage.active    = 'yes';
rhe_f1.tailRotor.active   = 'yes';
rhe_f1.verticalFin.active = 'no';
rhe_f1.leftHTP.active     = 'no';
rhe_f1.rightHTP.active    = 'no';

% helicopter 2 non-dimensional helicopter
ndHe_f1    = rigidHe2ndHe(rhe_f1,atm.rho0,atm.g);

% Define rigid helicopter with fuselage and with tail rotor. Model for
% fuselage coefficients is the Padfield Bo-105 fuselage model
rhe_f2                    = rhe;
rhe_f2.fuselage.active    = 'yes';
rhe_f2.tailRotor.active   = 'yes';
rhe_f2.verticalFin.active = 'no';
rhe_f2.leftHTP.active     = 'no';
rhe_f2.rightHTP.active    = 'no';
rhe_f2.fuselage.model     = @PadBo105Fus;

% helicopter 2 non-dimensional helicopter
ndHe_f2    = rigidHe2ndHe(rhe_f2,atm.rho0,atm.g);

% Define rigid helicopter with all the subcomponents active. Model for
% fuselage coefficients is the Padfield Bo-105 fuselage model
rhe_full                    = rhe;
rhe_full.fuselage.active    = 'yes';
rhe_full.tailRotor.active   = 'yes';
rhe_full.verticalFin.active = 'yes';
rhe_full.leftHTP.active     = 'yes';
rhe_full.rightHTP.active    = 'yes';
rhe_full.fuselage.model     = @generalFus;

% helicopter 2 non-dimensional helicopter
ndHe_full      = rigidHe2ndHe(rhe_full,atm,0);

% Get trim state
ts_nof         = getTrimState(fCT,muWT,ndHe_nof,options);

% Get trim state
ts_f1         = getTrimState(fCT,muWT,ndHe_f1,options);

% Get trim state
ts_f2         = getTrimState(fCT,muWT,ndHe_f2,options);

% Get trim state
ts_full         = getTrimState(fCT,muWT,ndHe_full,options);

figure(1)
plot(...
V*3.6,PA1/1e3,'r-s',...
V*3.6,PA2/1e3,'r-.s',...
V*3.6,PB1/1e3,'k-o',...
V*3.6,PB2/1e3,'k-.o',...
V*3.6,ts_nof.power/1e3,'b--o',...
V*3.6,ts_f1.power/1e3,'b--s',...
V*3.6,ts_f2.power/1e3,'b--*',...
V*3.6,ts_full.power/1e3,'b--'...
);
hold on;
xlabel('V [km/h]'); ylabel('P [kW]')
v = axis;
axis([v(1) v(2) 0 1200])

legend({...
'Energy \kappa = 1.0 no:tr,f',...
'Energy \kappa = 1.15 no:tr,f',...
'\kappa = 1.15 \eta_{ra}=0.05 no:f',...
'\kappa = 1.15 \eta_{ra}=0.2 no:f',...
'Trim method no:f'...
'Trim method f=@generalFus'...
'Trim method f=@PadBo105'...
'Trim method all active f=@generalFus'...
},'Location','Best');

io = 1;







function [gammaT,H,Z,V,fCT,muWT]  = getLeveledForwardFlightCondition(OR)


% Define flight condition common variables
gammaT = 0;
H      = 0;
Z      = NaN;

% Define forward speed
n      = 11;
V      = linspace(0,70,n);


% Flight condition definition
% Set non dimensional atmospheric wind 
muWT      = [0; 0; 0];

% Define non dimensional forward velocity
ndV       = V./(OR);

% Allocate flight condition matrix
fCT       = zeros(6,n);

% Assign nondimensional forward velocity to flight condition matrix
fCT(1,:)  = ndV(:);


function ehe = getkappaEheNO_tr_f(stathe,kappa,atm)


% Override energy values in the statistical helicopter in order to 
% ensure a valid comparison with trim and to assure that transmission 
% field is safe to override 
stathe.energyEstimations.etaTra  = 0;
stathe.energyEstimations.etaTrp  = 0;
stathe.energyEstimations.kappa   = kappa;
% dr.energyEstimations.f       = 10*(0.3048)^2;% actual f of Bo-105
stathe.energyEstimations.f       = 0*(0.3048)^2;
stathe.energyEstimations.eta_ra  = 0.0;
stathe.energyEstimations.K      = 5;

%==========================================================================
% Energy computations
% Get energy helicopter
% ehe   = superPuma(atm);

% Transform statistical helicopter to energy helicopter
ehe   = stathe2ehe(atm,stathe);

function ehe  = getEheNO_f(stathe,eta_ra,atm);
% Override energy values in the statistical helicopter in order to 
% ensure a valid comparison with trim and to assure that transmission 
% field is safe to override 
stathe.energyEstimations.etaTra  = 0;
stathe.energyEstimations.etaTrp  = 0;
stathe.energyEstimations.kappa   = 1.15;
stathe.energyEstimations.f       = 0*(0.3048)^2;
stathe.energyEstimations.eta_ra  = eta_ra ;
stathe.energyEstimations.K       = 5;


%==========================================================================
% Energy computations
% Get energy helicopter
% ehe   = superPuma(atm);

% Transform statistical helicopter to energy helicopter
ehe   = stathe2ehe(atm,stathe);

function rhe = getBaseRigidHe(stathe,atm)


% vertical fin surface
Svt = .805;

% horizontal tail plane chord
cHTP = .4;

rhe = stathe2rigidhe(stathe,atm,cHTP,Svt);