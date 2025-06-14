function io = flightDynamics3DVisualizationTest(mode)

%% Flight Dynamics 3D visualization

clc
clear all
close all

%% FLIGHT MODE
%

FlightMode = 1;

% 1: Takeoff
% 2: Hover, tail rotor off
% 3: Avance, lateral cyclic control
% 4: Avance - Aceleraci?n y maniobra para viraje
% 5: Viraje
% 6: Avance con resbalamiento a Avance sin resbalamiento
% 7: Ascenso reduciendo theta0 y theta0tr
% 8: Descenso y aumento de theta0 y theta0tr

%% SIMULATION PARAMETERS AND CONDITIONS
% options
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


% Initial flight condition
if FlightMode==1
    % VUELO A PUNTO FIJO
    FC0 = {'VOR',0.001,...
          'betaf0',0,...
          'gammaT',0,...
          'cs',0,...
          'vTOR',0};
      
elseif FlightMode==2
    % VUELO A PUNTO FIJO
    FC0 = {'VOR',0.001,...
          'betaf0',0,...
          'gammaT',0,...
          'cs',0,...
          'vTOR',0};
      
elseif FlightMode==3
    % VUELO AVANCE VOR 0.1
    FC0 = {'VOR',0.1,...
          'betaf0',0,...
          'gammaT',0,...
          'cs',0,...
          'vTOR',0};
      
elseif FlightMode==4
    % VUELO AVANCE VOR 0.1
    FC0 = {'VOR',0.1,...
          'betaf0',0,...
          'gammaT',0,...
          'cs',0,...
          'vTOR',0};  
  
elseif FlightMode==5
    % VIRAJE  
     FC0 = {'uTOR',0.1,...
            'vTOR',0,...
            'betaf0',0,...
            'wTOR',0,...
            'cs',-1/25};

elseif FlightMode==6        
    % VUELO AVANCE CON RESBALAMIENTO
    FC0 = {'VOR',0.3,...
          'betaf0',10*pi/180,...
          'gammaT',0,...
          'cs',0,...
          'vTOR',0};
      
elseif FlightMode==7        
    % VUELO DE TRAYECTORIA ASCENDENTE
    FC0 = {'VOR',0.1,...
          'betaf0',0,...
          'gammaT',10*pi/180,...
          'cs',0,...
          'vTOR',0};
      
      
elseif FlightMode==8        
    % VUELO DE TRAYECTORIA DESCENDENTE
    FC0 = {'VOR',0.1,...
          'betaf0',0,...
          'gammaT',-10*pi/180,...
          'cs',0,...
          'vTOR',0};
      
end


% Time vector
tdata = linspace(0,10,1001);          % 10 seconds

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
for i = 1:length(taudata)
    DeltamuWT(:,i) = muWT(:,i)-muWT0;
end

% Non dimensional Trim State:
ndTs0 = getNdHeTrimState(ndHe,muWT0,FC0,options);
ts0   = ndHeTrimState2HeTrimState(ndTs0,he,atm,H,options);


% Additional control to Trim State:
Deltaup    =  zeros(4, length(taudata));

if FlightMode==1
% CASO 1: STEP POSITIVO + NEGATIVO EN COLECTIVO Y ANTIPAR
for i=101:300
    Deltaup(1,i) = pi/180;
    Deltaup(4,i) = pi/180;
end

for i=301:500
    Deltaup(1,i) = -pi/360;
    Deltaup(4,i) = -pi/360;
end

elseif FlightMode==2
% CASO 2: FUERA ANTIPAR
    for i = 300:length(taudata)
        Deltaup(4,i) = -ts0.solution.theta0tr;
    end

elseif FlightMode==3
%  CASO 3: C?CLICO LATERAL
    for i=101:300
        Deltaup(3,i) = -pi/180;
    end
    
    for i=301:500
        Deltaup(3,i) = pi/360;
    end
    
elseif FlightMode==4
%  CASO 4: ACELERACI?N Y VIRAJE A LA IZQUIERDA EN VUELO DE AVANCE
    for i=101:300
        Deltaup(2,i) = -pi/360;
    end

    for i=301:500
        Deltaup(2,i) = pi/720;
        Deltaup(4,i) = pi/360;
    end

elseif FlightMode==5
    for i=101:300
        Deltaup(1,i) = pi/180;
        Deltaup(4,i) = pi/180;
    end

    for i=301:500
        Deltaup(1,i) = -pi/360;
        Deltaup(4,i) = -pi/360;
    end
    
elseif FlightMode==6
% CASO 6: CAMBIO A LEY DE CONTROL DE OTRO TRIM STATE
    FC2 = {'VOR',0.3,...
          'betaf0',0,...
          'gammaT',0,...
          'cs',0,...
          'vTOR',0};
    ndTs2 = getNdHeTrimState(ndHe,muWT0,FC2,options);
    ts2   = ndHeTrimState2HeTrimState(ndTs2,he,atm,H,options);

    for i = 300:length(taudata)
        Deltaup(1,i) = ts2.solution.theta0-ts0.solution.theta0;
        Deltaup(2,i) = ts2.solution.theta1S-ts0.solution.theta1S;
        Deltaup(3,i) = ts2.solution.theta1C-ts0.solution.theta1C;
        Deltaup(4,i) = ts2.solution.theta0tr-ts0.solution.theta0tr;
    end  
    
elseif FlightMode==7
% CASO 7: TRAYECTORIA DE ASCENSO CAMBIO DE THETA0 Y THETA0TR
    for i=401:length(taudata)
        Deltaup(1,i) = -2*pi/180;
        Deltaup(4,i) = -3*pi/180;
    end

elseif FlightMode==8
% CASO 8: TRAYECTORIA DE DESCENSO CAMBIO DE THETA0 Y THETA0TR
    for i=401:length(taudata)
        Deltaup(1,i) = 2*pi/180;
        Deltaup(4,i) = 3*pi/180;
    end
        
end

% Matrix for the Stability Augmentation System
ndkSAS = zeros(7,12);

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
plot(NonLinearDynamics.time.solution,NonLinearDynamics.state.u)
xlabel('$$t$$(s)')
ylabel('$$u$$ (m/s)')

figure
plot(NonLinearDynamics.time.solution,NonLinearDynamics.state.w)
xlabel('$$t$$(s)')
ylabel('$$w$$ (m/s)')

figure
plot(NonLinearDynamics.time.solution,NonLinearDynamics.state.omy)
xlabel('$$t$$(s)')
ylabel('$$\omega_y$$ (rad/s)')

figure
plot(NonLinearDynamics.time.solution,NonLinearDynamics.state.Theta)
xlabel('$$t$$(s)')
ylabel('$$\Theta$$ (rad)')

figure
plot(NonLinearDynamics.time.solution,NonLinearDynamics.state.v)
xlabel('$$t$$(s)')
ylabel('$$v$$ (m/s)')

figure
plot(NonLinearDynamics.time.solution,NonLinearDynamics.state.omx)
xlabel('$$t$$(s)')
ylabel('$$\omega_x$$ (rad/s)')

figure
plot(NonLinearDynamics.time.solution,NonLinearDynamics.state.Phi)
xlabel('$$t$$(s)')
ylabel('$$\Phi$$ (rad)')

figure
plot(NonLinearDynamics.time.solution,NonLinearDynamics.state.omz)
xlabel('$$t$$(s)')
ylabel('$$\omega_z$$ (rad/s)')

figure
plot(NonLinearDynamics.time.solution,NonLinearDynamics.state.Psi)
xlabel('$$t$$(s)')
ylabel('$$\Psi$$ (rad)')

figure 
plot3(NonLinearDynamics.trajectory.xG,NonLinearDynamics.trajectory.yG,...
       NonLinearDynamics.trajectory.zG)
grid on
xlabel('$$x_{G}$$(m)')
ylabel('$$y_{G}$$(m)')
zlabel('$$z_{G}$$(m)') 
axis equal


%% Aerospace Toolbox: 3D Representation
if FlightMode==1
    simdata = [NonLinearDynamics.time.solution,...
               NonLinearDynamics.trajectory.xG,...
               NonLinearDynamics.trajectory.yG,...
               NonLinearDynamics.trajectory.zG,...
               NonLinearDynamics.state.Phi,...               % Positive
               -NonLinearDynamics.state.Theta,...            % Negative
               -NonLinearDynamics.state.Psi];                % Negative
else
    simdata = [NonLinearDynamics.time.solution,...
               NonLinearDynamics.trajectory.xG,...
               NonLinearDynamics.trajectory.yG,...
               NonLinearDynamics.trajectory.zG+20,...
               NonLinearDynamics.state.Phi,...               % Positive
               -NonLinearDynamics.state.Theta,...            % Negative
               -NonLinearDynamics.state.Psi];                % Negative
end
    
h = Aero.VirtualRealityAnimation;
h.FramesPerSecond = 10;
h.TimeScaling = 1;

h.VRWorldFilename = 'heroesTest/flightDynamics/3DworldMountains.wrl';

% Copy file to temporary directory
% copyfile(h.VRWorldFilename,[tempdir,'3DworldMountains.wrl'],'f');
% Set world filename to the copied .wrl file.
% h.VRWorldFilename = [tempdir,'3DworldMountains.wrl'];
h.VRWorldFilename = ['3DworldMountains.wrl'];
h.initialize();

[~, idxHelicopter] = find(strcmp('Helicopter',h.nodeInfo));

h.Nodes{idxHelicopter}.TimeseriesSource = simdata;
h.Nodes{idxHelicopter}.CoordTransformFcn = @vranimCustomTransform;

if FlightMode==1
    set(h.VRFigure,'Viewpoint','See Whole Trajectory');  % Vista exterior
else
    set(h.VRFigure,'Viewpoint','View from Tail');        % Vista helicoptero
end


h.Nodes{idxHelicopter}.VRnode.translation = [NonLinearDynamics.trajectory.yG(1),...
                                        NonLinearDynamics.trajectory.zG(1),...
                                        NonLinearDynamics.trajectory.xG(1)];

%% Recording options                                    
% h.VideoRecord = 'on';
% h.VideoQuality = 100;
% h.VideoCompression = 'Motion JPEG AVI';
% h.VideoFilename = 'astMotion_JPEG';
% h.TSTart = 0;
% h.TFinal = 10;
                                    
h.play;   

io = 1;
