function io = flightDynamicsTest(mode)
%% FLIGHT DYNAMICS TEST
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
tdata = linspace(0,10,1001);

% Non Dimensional time (tau=t*Omega)
OmegaRated = he.mainRotor.Omega;
R   = he.mainRotor.R;

taudata = tdata*OmegaRated;

% Initial perturbation
Deltandx0   = zeros (12,1);
% Deltandx0(5)= 2/(OmegaRated*R);          % Velocity perturbation
% Deltandx0(2)= 0.25/(OmegaRated*R);       % Angular velocity perturbation


% Wind condition
muWT      = zeros(3,length(taudata));
muWT0     = muWT(:,1);
DeltamuWT = zeros(3,length(taudata));
for i = 1:length(taudata)
    DeltamuWT(:,i) = muWT(:,i)-muWT0;
end

% Non dimensional Trim State:
ndTs0 = getNdHeTrimState(ndHe,muWT0,FC0,options);
ts0   = ndHeTrimState2HeTrimState(ndTs0,he,atm,H,options);

% Additional control to Trim State:
Deltaup    =  zeros(4, length(taudata));

for i=101:300
    Deltaup(1,i) = pi/180;
end

for i=301:500
    Deltaup(1,i) = -pi/180;
end

% Matrix for the Stability Augmentation System
ndkSAS = zeros(7,12);

%% LINEARIZED SYSTEM
ndSs       = getndHeLinearStabilityState(ndTs0,muWT0,ndHe,options);

ndA = ndSs.ndA;
ndB = ndSs.ndB;
ndC = eye(9);
ndD = zeros(9,4);  
ndBwind = zeros(9,3);


ndlinearSolution = getndHeLinDynSolution(taudata,ndA,ndB,ndC,ndD,ndBwind,...
                                       Deltandx0,Deltaup,ndkSAS,...
                                       DeltamuWT,ndTs0,options); 
                                   
LinearDynamics   = ndDynamicSolution2DynamicSolution(ndlinearSolution,he);
                                   

%% NONLINEAR SOLUTION
ndNlD  = getndHeNonLinearDynamics(taudata,Deltandx0,Deltaup,ndkSAS,muWT,ndTs0,ndHe,options);        

NonLinearDynamics = ndDynamicSolution2DynamicSolution(ndNlD,he);


%% RESTULTS REPRESENTATION
set(0,'defaultlinelinewidth', 2);
set(0,'DefaultAxesFontsize',14,'DefaultAxesFontname','Times New Roman');

figure
plot(NonLinearDynamics.time.solution,NonLinearDynamics.control.theta0,...
     NonLinearDynamics.time.solution,NonLinearDynamics.control.theta1S,...
     NonLinearDynamics.time.solution,NonLinearDynamics.control.theta1C,...
     NonLinearDynamics.time.solution,NonLinearDynamics.control.theta0tr)  
 title('Control')
 legend('$$\theta_0$$','$$\theta_{1S}$$',...
        '$$\theta_{1C}$$','$$\theta_{a}$$')


figure
plot(LinearDynamics.time.solution,LinearDynamics.state.u,...
     NonLinearDynamics.time.solution,NonLinearDynamics.state.u)
xlabel('$$t$$(s)')
ylabel('$$u$$ (m/s)')
legend('Linear','Nonlinear')

figure
plot(LinearDynamics.time.solution,LinearDynamics.state.w,...
     NonLinearDynamics.time.solution,NonLinearDynamics.state.w)
xlabel('$$t$$(s)')
ylabel('$$w$$ (m/s)')
legend('Linear','Nonlinear')

figure
plot(LinearDynamics.time.solution,LinearDynamics.state.omy,...
     NonLinearDynamics.time.solution,NonLinearDynamics.state.omy)
xlabel('$$t$$(s)')
ylabel('$$\omega_y$$ (rad/s)')
legend('Linear','Nonlinear')

figure
plot(LinearDynamics.time.solution,LinearDynamics.state.Theta,...
     NonLinearDynamics.time.solution,NonLinearDynamics.state.Theta)
xlabel('$$t$$(s)')
ylabel('$$\Theta$$ (rad)')
legend('Linear','Nonlinear')

figure
plot(LinearDynamics.time.solution,LinearDynamics.state.v,...
     NonLinearDynamics.time.solution,NonLinearDynamics.state.v)
xlabel('$$t$$(s)')
ylabel('$$v$$ (m/s)')
legend('Linear','Nonlinear')

figure
plot(LinearDynamics.time.solution,LinearDynamics.state.omx,...
     NonLinearDynamics.time.solution,NonLinearDynamics.state.omx)
xlabel('$$t$$(s)')
ylabel('$$\omega_x$$ (rad/s)')
legend('Linear','Nonlinear')

figure
plot(LinearDynamics.time.solution,LinearDynamics.state.Phi,...
     NonLinearDynamics.time.solution,NonLinearDynamics.state.Phi)
xlabel('$$t$$(s)')
ylabel('$$\Phi$$ (rad)')
legend('Linear','Nonlinear')

figure
plot(LinearDynamics.time.solution,LinearDynamics.state.omz,...
     NonLinearDynamics.time.solution,NonLinearDynamics.state.omz)
xlabel('$$t$$(s)')
ylabel('$$\omega_z$$ (rad/s)')
legend('Linear','Nonlinear')

figure
plot(LinearDynamics.time.solution,LinearDynamics.state.Psi,...
     NonLinearDynamics.time.solution,NonLinearDynamics.state.Psi)
xlabel('$$t$$(s)')
ylabel('$$\Psi$$ (rad)')
legend('Linear','Nonlinear')

%% TRAJECTORY REPRESENTATION
figure 
comet3(LinearDynamics.trajectory.xG,LinearDynamics.trajectory.yG,...
       LinearDynamics.trajectory.zG)
hold on
comet3(NonLinearDynamics.trajectory.xG,NonLinearDynamics.trajectory.yG,...
       NonLinearDynamics.trajectory.zG)

figure 
plot3(LinearDynamics.trajectory.xG,LinearDynamics.trajectory.yG,...
      LinearDynamics.trajectory.zG,...
      NonLinearDynamics.trajectory.xG,NonLinearDynamics.trajectory.yG,...
       NonLinearDynamics.trajectory.zG)
legend('Linear', 'Nonlinear')
grid on
xlabel('$$x_{G}$$(m)')
ylabel('$$y_{G}$$(m)')
zlabel('$$z_{G}$$(m)') 

figure
plot(LinearDynamics.time.solution,LinearDynamics.trajectory.xG,...
     NonLinearDynamics.time.solution,NonLinearDynamics.trajectory.xG)
xlabel('$$t$$(s)')
ylabel('$$x_{G}$$ (m)')
legend('Linear','Nonlinear')

figure
plot(LinearDynamics.time.solution,LinearDynamics.trajectory.yG,...
     NonLinearDynamics.time.solution,NonLinearDynamics.trajectory.yG)
xlabel('$$t$$(s)')
ylabel('$$y_{G}$$ (m)')
legend('Linear','Nonlinear')

figure
plot(LinearDynamics.time.solution,LinearDynamics.trajectory.zG,...
     NonLinearDynamics.time.solution,NonLinearDynamics.trajectory.zG)
xlabel('$$t$$(s)')
ylabel('$$z_{G}$$ (m)')
legend('Linear','Nonlinear')


io = 1;