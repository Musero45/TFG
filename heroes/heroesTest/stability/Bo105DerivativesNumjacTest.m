close all
clear all

options = setHeroesRigidOptions;

%atmosphere variables needed
atm     = getISA;
rho0    = atm.rho0;
g       = atm.g;
htest   = 914.4;
rho     = atm.density(htest);

%helicopter model selection
he      = PadfieldBo105(atm);

% helicopter 2 non-dimensional helicopter
ndHe = rigidHe2ndHe(he,atm,htest);

CW = ndHe.inertia.CW;

O   = he.mainRotor.Omega;
R   = he.mainRotor.R;

muWT = [0; 0; 0];
V = linspace(0.0,140,31); ...
ndV = V./(O*R).*0.5144444;...
n = length(ndV);

flightConditionT      = zeros(6,n);
flightConditionT(1,:) = ndV(:);
nlSolver  = options.nlSolver;

initialCondition = [0.05; -0.05; .25; 0; 0; .25; 0; 0; 0; -sqrt(CW/2); 0; 0; CW; 0; 0;0; 0; 0; -sqrt(CW/20); 0; 0; CW/10; 0; 0];
%initialCondition = [-0.0047;-0.03068;0.222659;-0.002262;-0.019339;0.0356;0.020;-0.02386;-0.009942;-0.018237;-0.01557;-2.25204955597409e-06;0.0049;-0.00100;0.00071;0;0;0;-0.00979;-0.009270;4.36051175061229e-05;0.00262960;-0.00108460;0.00162360];

y = zeros(24,n);
flightConditionT(1,:) = ndV(:);

SA = [1 1 1 1 1 1 1 1 0;...
     1 1 1 1 1 1 1 1 0;...
     1 1 1 1 1 1 1 1 0;...
     0 0 1 0 0 0 0 1 0;...
     1 1 1 1 1 1 1 1 0;...
     1 1 1 1 1 1 1 1 0;...
     0 0 1 0 0 1 0 1 0;...
     1 1 1 1 1 1 1 1 0;...
     0 0 1 0 0 0 0 1 0;...
    ];

SB = [1 1 1 1;...
     1 1 1 1;...
     1 1 1 1;...
     0 0 0 0;...
     1 1 1 1;...
     1 1 1 1;...
     0 0 0 0;...
     1 1 1 1;...
     0 0 0 0;...
    ];

A = zeros(9,9,n);
ndA = zeros(9,9,n);
d = zeros(9,n);
d1 = zeros(9,n);
treshold = cell(2);
B = zeros(9,4,n);

tic;
for i = 1:n
    disp (['Solving trim...  ', num2str(i), ' of ', num2str(n)]);
    system2solve = @(x) helicopterTrim(x,flightConditionT(:,i),muWT,ndHe);
    y(:,i) = nlSolver(system2solve,initialCondition,options);
    initialCondition = y(:,i);
    control = y(3:6,i);
    y0      = y(7:24,i);
    
    MFT = TFT(0,y(1,i),y(2,i));
    muV = MFT*flightConditionT(1:3,i);
    
    disp (['Calculating A... ', num2str(i), ' of ', num2str(n)]);
    F = @(t,X) getStabilityEquations(t,X,control,muWT,y0,ndHe);
    X0 = [muV(1);muV(3);0;y(1,i);muV(2);0;y(2,i);0;0];
    t0 = 0;
    treshold{1} = ones(size(X0)).*1e-6;
    treshold{2} = X0;
    fac = [];
    G = [];
    Fty = F(t0,X0);
    A1 = numjac(F,t0,X0,Fty,treshold,fac,1,SA,G);
    ndA(:,:,i) = zeros(9)+A1;
    A(:,:,i) = ndA2A (ndA(:,:,i), O, R);
    d(:,i) = O.*eig(ndA(:,:,i));
    d1(:,i) = eig(A(:,:,i));

    disp (['Calculating B... ', num2str(i), ' of ', num2str(n)]);
    X = [muV(1);muV(3);0;y(1,i);muV(2);0;y(2,i);0;0];
    F = @(t,controlVect) getStabilityEquations(t,X,controlVect,muWT,y0,ndHe);
    control0 = [y(3,i);y(4,i);y(5,i);y(6,i)]; 
    t0 = 0;
    treshold{1} = ones(size(control0)).*1e-6;
    treshold{2} = control0;
    fac = [];
    G = [];
    Fty = F(t0,control0);
    B(:,:,i) = numjac(F,t0,control0,Fty,treshold,fac,0,SB,G);
end
toc

M = getPadfieldEigenvaluesMap('Bo105');

figure(1)
plot(real(d),imag(d),'bo','Markersize',4);
grid on
hold on
plot(real(M),imag(M),'ks','Markersize',4);

sS{1}   = getStabilityState(ndA,B);
sS{1}.V = ndV;

sS{2}   = getPadfieldStabilityState('Bo105D');

pairs = {};
%%% Uncomment following line in order to generate output files
%pairs = {'format' {'pdf'} 'prefix' '1' 'closePlot' 'yes'};

legend = {'heroes' 'helisim'};
% plotStabilityDerivatives(sS,legend,pairs);
% plotControlDerivatives(sS,legend,pairs)

tS{1} = getHeTrimState(y,flightConditionT,muWT,ndHe);
% plotActionsByElement(tS{1});