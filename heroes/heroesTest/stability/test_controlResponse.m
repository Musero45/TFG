function io = test_controlResponse(mode)

close all

% Set rigid options overriding conveniently gratitational and inertial
% terms
options            = setHeroesRigidOptions;
options.GT         = 0;
options.inertialFM = 0;

% atmosphere variables needed
atm     = getISA;
% % % % % g       = atm.g;
htest   = 0;
% % % % % rho     = atm.density(htest);

% helicopter model selection
he      = PadfieldBo105(atm);
ndHe    = rigidHe2ndHe(he,atm,htest);

% 
muWT    = [0; 0; 0];
ndV     = 0.2;

fCT     = zeros(6,1);
fCT(1)  = ndV;


% Compute trim state for the flight condition variable
ts       = getTrimState(fCT,muWT,ndHe,options);

% Compute linear stability state
lsAB     = getLinearStabilityState(ts,fCT,muWT,ndHe,options);


% Extract the nondimensional matrices ndA and ndB
ndA    = lsAB.ndA;
ndB    = lsAB.ndB;

% Transforms to a dimensional linear stability state
% Characteristic frequency and length of helicopter
Omega   = he.mainRotor.Omega;
R       = he.mainRotor.R;

% Get the dimensional matrices A and B
A       = ndA2A(ndA,Omega,R);
B       = ndB2B(ndB,Omega,R);

% Build up the MIMO model
% Variables set up 
neq     = size(A,1);
ssv     = size(A,2);
scv     = size(B,2);
C       = eye(neq);
D       = zeros(neq,scv);

states  = {'u' 'w' 'pitch rate' 'pitch' 'v' 'roll rate' 'roll' 'yaw rate' 'yaw'};
inputs  = {'theta0' 'theta1C' 'theta1S' 'theta0T'};
outputs = {'u' 'w' 'pitch rate' 'pitch' 'v' 'roll rate' 'roll' 'yaw rate' 'yaw'};

% Build up a non dimensional continuous-time state-space representation
% of the dynamical system
dmSsHe  = ss(A,B,C,D, ...
'statename',states,...
'inputname',inputs,...
'outputname',outputs ...
);

% Build up a non dimensional continuous-time state-space representation
% of the dynamical system
ndSsHe  = ss(ndA,ndB,C,D, ...
'statename',states,...
'inputname',inputs,...
'outputname',outputs ...
);


% Computing open-loop eigenvalues of both nondimensional and dimensional
% state-space representations
[dmW,dmZeta] = damp(dmSsHe);
[ndW,ndZeta] = damp(ndSsHe);

% Please, note that the difference between both eigenvalues, i.e. the ones
% corresponding to dimensional matrix A, and the ones corresponding to
% nondimensional matrix ndA is practically zero when the characteristic time
% 1/Omega is used. 
Error = mean([dmW-ndW]);


% define dimensional and nondimensional time vectors
time    = linspace(0,150,101);
tau     = Omega*time;


% Now we check that the step responses, both dimensional and nondimensional
% are the same, at least graphically. Check figures 3 and 4 out
% Dimensional step response
figure(3)
step(dmSsHe,time);


% Nondimensional step response
figure(4)
step(ndSsHe,tau);



% % % % % % % % % % % % Bode plot
% figure(2)
% bodeplot(dmSsHe);
% % % % % % Impulse response
% % % % % impulse(ssMimoHe);
% % % % % % % % % % % Transforms the state-space representation to transfer function
% % % % % % % % % % % representation
% % % % % % % % % % tfMimoHe = tf(ssMimoHe);
% % % % % % % % % % 
% % % % % % % % % % 
% % % % % % % % % % figure(3)
% % % % % % % % % % nyquistplot(ssMimoHe)

io = 1;
