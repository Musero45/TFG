close all
clear all

pairs = {'linearInflow', @wakeEqs, 'uniformInflowModel', @Cuerva, ...
        'armonicInflowModel',@Coleman,'mrForces',@completeF,'mrMoments',@aerodynamicM};

options = parseOptions(pairs,@setHeroesRigidOptions);
aeromechanicModel = options.aeromechanicModel;

atm     = getISA;

he   = rigidBo105(atm);
%he.mainRotor.e = .31;


c1c0 = [0,-1/2,-1];
n = length(c1c0);

rho0    = atm.rho0;
g       = atm.g;

ndHe = cell(1,n);

for i = 1:n;
    R = he.mainRotor.R;
    M = he.mainRotor.bm;
    he.mainRotor.c1    = he.mainRotor.c0*c1c0(i);
    he.mainRotor.xGB   = R*c1c0(i)/3+R/2;
    he.mainRotor.bm    = M*(1+c1c0(i)/2);
    he.mainRotor.IBeta = M*R^2*(c1c0(i)/4+1/3);
    he.mainRotor.IZeta = he.mainRotor.IBeta + he.mainRotor.ITheta;
    ndHe{i}    = rigidHe2ndHe(he,rho0,g);
end

muW     = [0; 0; 0];
GA      = [0; 0; -1];
theta   = [14; 1; 0]*pi/180;
theta1S   = linspace(-.2,.2,16);

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

aeromechanicState = cell(1,n);
simpAMState = cell(1,2*n);

nlSolver  = options.nlSolver;
mrF = options.mrForces;
mrM = options.mrMoments;

prefix = 'chord';

tic;
flightCondition = [0; 0; 0.; 0; 0; 0];
ThetaA = 0;
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
end

legend = {'c_1 = 0','c_1 = -c_0/2','c_1 = -c_0'};
plotSimpAMPract(aeromechanicState,legend,{'format' {'pdf'} 'prefix' prefix 'closePlot' 'yes'});

toc

