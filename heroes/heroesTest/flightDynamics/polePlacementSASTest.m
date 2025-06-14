function io = polePlacementSASTest(mode)
%% POLE PLACEMENT FOR STABILITY AUGMENTATION SYSTEM (SAS) TEST
clc
clear all
close all

options            = setHeroesRigidOptions;

options.GT = 0;

% atmosphere variables needed
atm     = getISA;
rho0    = atm.rho0;
g       = atm.g;
H       = 0;

% helicopter model selection
he      = PadfieldBo105(atm);

% Reduced value of tail rotor blade mass
he.tailRotor.bm = 0.1;                      

% helicopter 2 non-dimensional helicopter
ndHe = rigidHe2ndHe(he,atm,H);


% % Initial flight condition
FC0 = {'VOR',0.05,...
      'betaf0',0,...
      'gammaT',0,...
      'cs',0,...
      'vTOR',0};  

% Time vector
tdata = linspace(0,100,1001);

% Non Dimensional time (tau=t*Omega)
OmegaRated = he.mainRotor.Omega;
R   = he.mainRotor.R;

taudata = tdata*OmegaRated;

% Initial perturbation
Deltandx0   = zeros (12,1);

% Wind condition
muWT      = zeros(3,length(taudata));
muWT0     = muWT(:,1);
DeltamuWT = zeros(3,length(taudata));
for j = 1:length(taudata)
    DeltamuWT(:,j) = muWT(:,j)-muWT0;
end

% Non dimensional Trim State:
ndTs0 = getNdHeTrimState(ndHe,muWT0,FC0,options);

% Additional control to Trim State:
Deltaup    =  zeros(4, length(taudata));

% Matrix for the Stability Augmentation System
ndkSAS = zeros(7,12);

%% LINEARIZED SYSTEM
ndSs       = getndHeLinearStabilityState(ndTs0,muWT0,ndHe,options);

ndA = ndSs.ndA;
ndB = ndSs.ndB;
ndC = eye(9);
ndD = zeros(9,4);  
ndBwind = zeros(9,3);


%% RESPONSE WITH FIXED CONTROLS

DeltaVelocity = 2/(OmegaRated*R);        % Velocity perturbation

Deltandx0(1)= DeltaVelocity; 

ndlinearSolution = getndHeLinDynSolution(taudata,ndA,ndB,ndC,ndD,ndBwind,...
                                       Deltandx0,Deltaup,ndkSAS,...
                                       DeltamuWT,ndTs0,options); 
                                   
LinearDynamics   = ndDynamicSolution2DynamicSolution(ndlinearSolution,he);
 

% Longitudinal variables
figure
subplot(2,2,1)
plot(LinearDynamics.time.solution,LinearDynamics.state.u)
xlabel('$$t$$(s)')
title(['$$u(t)$$ for $$\Delta u(0)=$$ ',...
        num2str(DeltaVelocity*(OmegaRated*R)),' m/s'])

subplot(2,2,2)
plot(LinearDynamics.time.solution,LinearDynamics.state.w)
xlabel('$$t$$(s)')
title(['$$w(t)$$ for $$\Delta u(0)=$$ ',...
        num2str(DeltaVelocity*(OmegaRated*R)),' m/s'])

subplot(2,2,3)
plot(LinearDynamics.time.solution,LinearDynamics.state.omy)
xlabel('$$t$$(s)')
title(['$$\omega_y$$(t) for $$\Delta u(0)=$$ ',...
        num2str(DeltaVelocity*(OmegaRated*R)), ' m/s'])

subplot(2,2,4)
plot(LinearDynamics.time.solution,LinearDynamics.state.Theta)
xlabel('$$t$$(s)')
title(['$$\Theta$$(t) for $$\Delta u(0)=$$ ',...
        num2str(DeltaVelocity*(OmegaRated*R)), ' m/s'])
    
% Lateral variables
figure
subplot(2,2,1)
plot(LinearDynamics.time.solution,LinearDynamics.state.v)
xlabel('$$t$$(s)')
title(['$$v(t)$$ for $$\Delta u(0)=$$ ',...
        num2str(DeltaVelocity*(OmegaRated*R)),' m/s'])

subplot(2,2,2)
plot(LinearDynamics.time.solution,LinearDynamics.state.omx)
xlabel('$$t$$(s)')
title(['$$\omega_x$$(t) for $$\Delta u(0)=$$ ',...
        num2str(DeltaVelocity*(OmegaRated*R)),' m/s'])

subplot(2,2,3)
plot(LinearDynamics.time.solution,LinearDynamics.state.Phi)
xlabel('$$t$$(s)')
title(['$$\Phi$$(t) for $$\Delta u(0)=$$ ',...
        num2str(DeltaVelocity*(OmegaRated*R)), ' m/s'])

subplot(2,2,4)
plot(LinearDynamics.time.solution,LinearDynamics.state.omz)
xlabel('$$t$$(s)')
title(['$$\omega_z$$(t) for $$\Delta u(0)=$$ ',...
        num2str(DeltaVelocity*(OmegaRated*R)), ' m/s'])
    
    
%% RESPONSE WITH STABILITY AUGMENTATION SYSTEM (SAS)
% As the linear system is unstable, it is possible to use KSAS matrix
% (Stability Augmentation System) for additional control. A way to obtain
% this matrix is pole placement method.

eigVals = eig(ndA);
 
% Change of poles with a positive real part:
P = -abs(real(eigVals))+(imag(eigVals)*1i);

% Matrix ndkSAS:
ndK = place (ndA,ndB,P);
ndkSAS = zeros(7,12);
ndkSAS(1:4,1:9) = ndK;


ndlinearSolution2 = getndHeLinDynSolution(taudata,ndA,ndB,ndC,ndD,ndBwind,...
                                       Deltandx0,Deltaup,ndkSAS,...
                                       DeltamuWT,ndTs0,options); 
                                   
LinearDynamics2   = ndDynamicSolution2DynamicSolution(ndlinearSolution2,he);



% Longitudinal variables
figure
subplot(2,2,1)
plot(LinearDynamics2.time.solution,LinearDynamics2.state.u)
xlabel('$$t$$(s)')
title(['$$u(t)$$ for $$\Delta u(0)=$$ ',...
        num2str(DeltaVelocity*(OmegaRated*R)),' m/s'])

subplot(2,2,2)
plot(LinearDynamics2.time.solution,LinearDynamics2.state.w)
xlabel('$$t$$(s)')
title(['$$w(t)$$ for $$\Delta u(0)=$$ ',...
        num2str(DeltaVelocity*(OmegaRated*R)),' m/s'])

subplot(2,2,3)
plot(LinearDynamics2.time.solution,LinearDynamics2.state.omy)
xlabel('$$t$$(s)')
title(['$$\omega_y$$(t) for $$\Delta u(0)=$$ ',...
        num2str(DeltaVelocity*(OmegaRated*R)), ' m/s'])

subplot(2,2,4)
plot(LinearDynamics2.time.solution,LinearDynamics2.state.Theta)
xlabel('$$t$$(s)')
title(['$$\Theta$$(t) for $$\Delta u(0)=$$ ',...
        num2str(DeltaVelocity*(OmegaRated*R)), ' m/s'])    
    
% Lateral variables
figure
subplot(2,2,1)
plot(LinearDynamics2.time.solution,LinearDynamics2.state.v)
xlabel('$$t$$(s)')
title(['$$v(t)$$ for $$\Delta u(0)=$$ ',...
        num2str(DeltaVelocity*(OmegaRated*R)),' m/s'])

subplot(2,2,2)
plot(LinearDynamics2.time.solution,LinearDynamics2.state.omx)
xlabel('$$t$$(s)')
title(['$$\omega_x$$(t) for $$\Delta u(0)=$$ ',...
        num2str(DeltaVelocity*(OmegaRated*R)),' m/s'])

subplot(2,2,3)
plot(LinearDynamics2.time.solution,LinearDynamics2.state.Phi)
xlabel('$$t$$(s)')
title(['$$\Phi$$(t) for $$\Delta u(0)=$$ ',...
        num2str(DeltaVelocity*(OmegaRated*R)), ' m/s'])

subplot(2,2,4)
plot(LinearDynamics2.time.solution,LinearDynamics2.state.omz)
xlabel('$$t$$(s)')
title(['$$\omega_z$$(t) for $$\Delta u(0)=$$ ',...
        num2str(DeltaVelocity*(OmegaRated*R)), ' m/s'])


io = 1;
