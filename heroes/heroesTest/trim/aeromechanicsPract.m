function io = aeromechanicsPract

close all
clear all

pairs = {'linearInflow', @wakeEqs, 'uniformInflowModel', @Cuerva, ...
        'armonicInflowModel',@none,'mrForces',@completeF,'mrMoments',@aerodynamicM};

options = parseOptions(pairs,@setHeroesRigidOptions);
aeromechanicModel = options.aeromechanicModel;

atm     = getISA;

he{1}   = practBo105(atm);
he{2}   = practPuma(atm);
he{3}   = practLynx(atm);

n = length(he);

rho0    = atm.rho0;
g       = atm.g;

ndHe = cell(1,n);

for i = 1:n;
    ndHe{i}    = rigidHe2ndHe(he{i},rho0,g);
end
    
muW     = [0; 0; 0];
GA      = [0; 0; -1];
theta   = [10; 1; 0]*pi/180;
theta1S   = -.2:.01:.2;

m = length(theta1S);

beta0    = zeros(1,m);
beta1C   = zeros(1,m);
beta1S   = zeros(1,m);
lambda0  = zeros(1,m);

CT   = zeros(1,m);
CH   = zeros(1,m);
CY   = zeros(1,m);
CMFax = zeros(1,m);
CMFay = zeros(1,m);
CMFaz = zeros(1,m);
CMaEx = zeros(1,m);
CMaEy = zeros(1,m);
CMaEz = zeros(1,m);

aeromechanicState = cell(1,3);
simpAMState = cell(1,6);

nlSolver  = options.nlSolver;
mrF = options.mrForces;
mrM = options.mrMoments;

prefix = {'hover' 'fwd'};

tic;
for k = 1:2
flightCondition = [0.3; 0; -0.01; 0; 0; 0]*(k-1);
ThetaA = -.01/.3*(k-1);
    for i = 1:n;
        ndRotor = ndHe{i}.mainRotor;
        CT0     = ndRotor.CW;
        lambda  = [-sqrt(CT0/2); 0; 0];
        sigma0  = ndRotor.sigma0;
        a       = ndRotor.cldata(1);
        SBeta   = ndRotor.SBeta;
        mBeta   = sigma0*a*SBeta/16;
        initialCondition = [0.01; -0.03; -0.015; lambda; CT0; 0; 0];
        for j = 1:m;
            theta(3) = theta1S(j);
            system2solve = @(x) aeromechanicModel(x,theta,flightCondition,GA,muW,ndRotor,options);
            x = nlSolver(system2solve,initialCondition,options);
            initialCondition = x;
            beta0 (j)    = x(1);
            beta1C (j)   = x(2);
            beta1S (j)   = x(3);
            lambda0 (j)  = x(4);
            [CFai, CFa0, ~, ~] = mrF(x(1:3),theta,x(4:6),flightCondition,muW,GA,ndRotor);
            [CMFai, CMFa0, CMaEi, CMaE0, ~, ~, ~, ~] = mrM(x(1:3),theta,x(4:6),flightCondition,muW,GA,ndRotor);
            CH(j)  = CFai(1)+CFa0(1);
            CY(j)  = CFai(2)+CFa0(2);
            CT(j)  = CFai(3);
            CMFax(j) = CMFai(1)+CMFa0(1);
            CMFay(j) = CMFai(2)+CMFa0(2);
            CMFaz(j) = CMFai(3)+CMFa0(3);
            CMaEx(j) = CMaEi(1)+CMaE0(1);
            CMaEy(j) = CMaEi(2)+CMaE0(2);
            CMaEz(j) = CMaEi(3)+CMaE0(3);
        end
        aeromechanicState{i}.beta0   = beta0;
        aeromechanicState{i}.beta1C  = beta1C;
        aeromechanicState{i}.beta1S  = beta1S;
        aeromechanicState{i}.lambda0 = lambda0;
        aeromechanicState{i}.CH    = CH;
        aeromechanicState{i}.CY    = CY;
        aeromechanicState{i}.CT    = CT;
        aeromechanicState{i}.equil = CH*cos(ThetaA)+CT*sin(ThetaA);
        aeromechanicState{i}.CMFax = CMFax;
        aeromechanicState{i}.CMFay = CMFay; 
        aeromechanicState{i}.CMFaz = CMFaz; 
        aeromechanicState{i}.CMaEx = CMaEx; 
        aeromechanicState{i}.CMaEy = CMaEy; 
        aeromechanicState{i}.CMaEz = CMaEz;
        aeromechanicState{i}.CMax = CMaEx + CMFax; 
        aeromechanicState{i}.CMay = CMaEy + CMFay; 
        aeromechanicState{i}.CMaz = CMaEz + CMFaz; 
        aeromechanicState{i}.CMaz = CMaEz + CMFaz; 
        aeromechanicState{i}.CME2Fx = CMaEx./CMFax; 
        aeromechanicState{i}.CME2Fy = CMaEy./CMFay; 
        aeromechanicState{i}.CME2Fz = CMaEz./CMFaz;
        aeromechanicState{i}.theta1S = theta1S;
        
        simpAMState{i}.CHcomp = CH;
        simpAMState{i}.CYcomp = CY;
        simpAMState{i}.CMaxcomp = CMaEx + CMFax;
        simpAMState{i}.CMaycomp = CMaEy + CMFay;
        simpAMState{i+n}.CHcomp = -beta1C.*CT;
        simpAMState{i+n}.CYcomp = -beta1S.*CT;
        simpAMState{i+n}.CMaxcomp = mBeta*beta1S; 
        simpAMState{i+n}.CMaycomp = -mBeta*beta1C;
        simpAMState{i}.theta1S = theta1S;
        simpAMState{i+n}.theta1S = theta1S;
        
        theta1SMx0(i,k)    = interp1(aeromechanicState{i}.CMax,theta1S,0); 
        theta1SMy0(i,k)    = interp1(aeromechanicState{i}.CMay,theta1S,0);
        theta1Sequil0(i,k) = interp1(aeromechanicState{i}.equil,theta1S,0);
    end

    r2d    = 180/pi;
    legend = {'Bo105','Puma','Lynx'};

    axesData.xvar = 'theta1S';
    axesData.xlab = '\theta_{1S} [?]';
    axesData.xunit = r2d;
    axesData.yvars = {'beta0' 'beta1C' 'beta1S' 'lambda0' ...
            'CH' 'CY' 'CT' 'equil'...
            'CMaEx' 'CMaEy' 'CMaEz' 'CMFax' 'CMFay' 'CMFaz' ...
            'CME2Fx' 'CME2Fy' 'CME2Fz' 'CMax' 'CMay' 'CMaz'};
    axesData.ylabs = {'\beta_0 [?]' '\beta_{1C} [?]' '\beta_{1S} [?]' '\lambda_0 [-]' ...
            'C_{H} [-]' 'C_{Y} [-]' 'C_{T} [-]' 'C_{H}cos\Theta_A +C_{T}sin\Theta_A [-]' ...
            'C_{Mx_A}^{a,E} [-]' 'C_{My_A}^{a,E} [-]' 'C_{Mz_A}^{a,E}'...
            'C_{Mx_A}^{F^a} [-]' 'C_{My_A}^{F^a} [-]' 'C_{Mz_A}^{F^a}'...
            'C_{Mx_A}^{a,E}/C_{Mx_A}^{F^a} [-]'...
            'C_{My_A}^{a,E}/C_{My_A}^{F^a} [-]'...
            'C_{Mz_A}^{a,E}/C_{Mz_A}^{F^a} [-]'...
            'C_{Mx_A}^a [-]' 'C_{My_A}^a [-]' 'C_{Mz_A}^a [-]'};
    axesData.yunits = [r2d r2d r2d 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1];

    pairs = {};
%%%% Uncomment following line in order to generate output files
%     pairs = {'format' {'pdf'} 'prefix' prefix{k} 'closePlot' 'yes'};

    plotOpt = parseOptions(pairs,@setHeroesPlotOptions);
    plotOpt.mode = 'thick';
    plotCellOfStructures(aeromechanicState,axesData,legend,plotOpt);
    
    legend = {'Bo105','Puma','Lynx','Bo105 simp','Puma simp','Lynx simp'};
    axesData.yvars = {'CHcomp' 'CYcomp' 'CMaxcomp' 'CMaycomp'};
    axesData.ylabs = {'C_{H} [-]' 'C_{Y} [-]' 'C_{Mx_A}^a [-]' 'C_{My_A}^a [-]'};
    axesData.yunits = [1 1 1 1];
    
    plotCellOfStructures(simpAMState,axesData,legend,plotOpt);
end
t(1) = toc;

flightConditionT = [0; 0.01; -0.01; 0; 0; 0];
flightConditionA = [0; 0.01; 0.01; 0; 0; 0];
muxA = 0:.01:.3;

m = length(muxA);

b1Coz   = zeros(1,m);
b1Soz   = zeros(1,m);
err     = zeros(1,m);
control = zeros(4,m);
dump    = zeros(6,m);

derivatives = cell(1,n);
tic;
for i = 1:n;
    ndRotor = ndHe{i}.mainRotor;
    CT0     = ndRotor.CW;
	lambda  = [-sqrt(CT0/2); 0; 0];
    initialCondition = [-0.01; 0; 0.18; 0; 0.05; 1e-4; 0; 0; 0; lambda; CT0; 0; 0];
    for j = 1:m;
        % Trim at muxA to get initial conditions for numeric derivatives.
        flightConditionT(1) = -muxA(j);
        system2solve = @(x) isolatedRotorTrim(x,flightConditionT,muW,ndRotor,options);
        x = nlSolver(system2solve,initialCondition,options);
        initialCondition = x;
%         theta  = x(3:5);
%         beta   = x(7:9);
        lambda = x(10:12);
%         CT     = x(13:15);
        flightConditionA(1) = muxA(j);
%         x0 = [beta; lambda; CT];
        % Numeric dump derivative at omegaAdz = 0. Comment from line 191
        % to 196 and 213-214 if speed is required neglecting small effects
%         betaIndex = 2;
%         fun2deriv = @(omegaAdz) betaFomega(betaIndex,x0,omegaAdz,theta,flightConditionA,GA,muW,ndRotor,options);
%         [b1Coz(j), err(j)] = derivest(fun2deriv,0,'Vectorized','no');
%         betaIndex = 3;
%         fun2deriv = @(omegaAdz) betaFomega(betaIndex,x0,omegaAdz,theta,flightConditionA,GA,muW,ndRotor,options);
%         [b1Soz(j), err(j)] = derivest(fun2deriv,0,'Vectorized','no');
        % Control and dump derivatives by identifying matrizx terms
        [control(:,j), dump(:,j)] = flappingDer(lambda,[muxA(j); 0.01; 0.01],GA,muW,ndRotor);
    end
    derivatives{i}.b1Cox  = dump(1,:);
    derivatives{i}.b1Coy  = dump(2,:);
    derivatives{i}.b1Coz  = dump(3,:);
    derivatives{i}.b1Sox  = dump(4,:);
    derivatives{i}.b1Soy  = dump(5,:);
    derivatives{i}.b1Soz  = dump(6,:);
    derivatives{i}.b1Ct1C = control(1,:);
    derivatives{i}.b1Ct1S = control(2,:);
    derivatives{i}.b1St1C = control(3,:);
    derivatives{i}.b1St1S = control(4,:);
    derivatives{i}.muxA   = muxA;
    
%     Omegaz control derivest
%     derivatives{i}.b1Coz  = b1Coz;
%     derivatives{i}.b1Soz  = b1Soz;

end
t(2) = toc;
legend = {'Bo105','Puma','Lynx'};

axesData.xvar = 'muxA';
axesData.xlab = '\mu_{xA} [-]';
axesData.xunit = 1;
axesData.yvars = {'b1Cox' 'b1Coy' 'b1Coz' 'b1Sox' ...
        'b1Soy' 'b1Soz' 'b1Ct1C' 'b1Ct1S'...
        'b1St1C' 'b1St1S'};
axesData.ylabs = {'\Omega?d\beta_{1C}/d\omega_x [-]' '\Omega?d\beta_{1C}/d\omega_y [-]'...
    '\Omega?d\beta_{1C}/d\omega_z [-]' '\Omega?d\beta_{1S}/d\omega_x [-]' '\Omega?d\beta_{1S}/d\omega_y [-]'...
    '\Omega?d\beta_{1S}/d\omega_z [-]' 'd\beta_{1C}/d\theta_{1C} [-]' 'd\beta_{1C}/d\theta_{1S} [-]'...
    'd\beta_{1S}/d\theta_{1C} [-]' 'd\beta_{1S}/d\theta_{1S} [-]'};
axesData.yunits = [1 1 1 1 1 1 1 1 1 1];

pairs = {};
%%%% Uncomment following line in order to generate output files
%     pairs = {'format' {'pdf'} 'prefix' '' 'closePlot' 'yes'};

plotOpt = parseOptions(pairs,@setHeroesPlotOptions);
plotOpt.mode = 'thick';
plotCellOfStructures(derivatives,axesData,legend,plotOpt);

r2d.*theta1SMx0
r2d.*theta1SMy0
r2d.*theta1Sequil0
    
io = t;
end

function betaOmega = betaFomega(betaIndex,x0,omegaAdz,theta,flightCondition,GA,muW,ndRotor,options)
    nlSolver  = options.nlSolver;
    initialCondition = x0;
    flightCondition = [flightCondition(1:5); omegaAdz];
    system2solve = @(x) aeromechanicModel(x,theta,flightCondition,GA,muW,ndRotor,options);
    x = nlSolver(system2solve,initialCondition);
    betaOmega = x(betaIndex);
end
