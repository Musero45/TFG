clear all
close all

options = setHeroesRigidOptions;

%atmosphere variables needed
atm     = getISA;
% % % % % % % rho0    = atm.rho0;
% % % % % % % g       = atm.g;

%helicopter model selection
he      = rigidBo105(atm);

% helicopter 2 non-dimensional helicopter
ndHe = rigidHe2ndHe(he,atm,0);

CW = ndHe.inertia.CW;

muWT = [0; 0; 0];
ndV = linspace(0.0,0.3,75);
n = length(ndV);

flightConditionT = zeros(6,n);
j = 1;
m = 1;

trimState = cell(1,m);
nlSolver  = options.nlSolver;

tic;
initialCondition = [0.05; -0.05; .25; 0; 0; .25; 0; 0; 0; -sqrt(CW/2); 0; 0; CW; 0; 0;0; 0; 0; -sqrt(CW/20); 0; 0; CW/10; 0; 0];

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

% Aest = zeros(9,9,n);
% err = zeros(9,9,n);
% dest = zeros(9,n);
% dloest = zeros(4,n);
% dlaest = zeros(5,n);

A = zeros(9,9,n);
d = zeros(8,n);
dlo = zeros(4,n);
dla = zeros(5,n);
treshold = cell(2);

B = zeros(9,4,n);

fac = [];
G = [];

for i = 1:n
    system2solve = @(x) helicopterTrim(x,flightConditionT(:,i),muWT,ndHe);
    y(:,i) = nlSolver(system2solve,initialCondition,options);
    initialCondition = y(:,i);
    control = y(3:6,i);
    y0      = y(7:24,i);
    
    MFT = TFT(0,y(1,i),y(2,i));
    muV = MFT*flightConditionT(1:3,i);
    
%     F = @(X) getStabilityEquations(0,X,control,muWT,y0,ndHe);
%     X0 = [muV(1);muV(3);0;y(1,i);muV(2);0;y(2,i);0;0];
%     [Aest(:,:,i),err(:,:,i)] = jacobianest(F,X0);
%     dest(:,i) = eig(Aest(:,:,i));
%     dloest(:,i) = eig(Aest(1:4,1:4,i));
%     dlaest(:,i) = eig(Aest(5:9,5:9,i));
    
    
    F = @(t,X) getStabilityEquations(t,X,control,muWT,y0,ndHe);
    X0 = [muV(1);muV(3);0;y(1,i);muV(2);0;y(2,i);0;0];

    t0 = 0;
    treshold{1} = ones(size(X0)).*1e-6;
    treshold{2} = X0;
    fac = [];
    G = [];
    Fty = F(t0,X0);
    A1 = numjac(F,t0,X0,Fty,treshold,fac,1,SA,G);
    A(:,:,i) = zeros(9)+A1;
    
    d(:,i) = eig(A(1:8,1:8,i));
%     dlo(:,i) = eig(A(1:4,1:4,i));
%     dla(:,i) = eig(A(5:9,5:9,i));
    
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

d1 = d.*he.mainRotor.Omega;
% d1lo = dlo.*he.mainRotor.Omega;
% d1la = dla.*he.mainRotor.Omega;

% d1est = dest.*he.mainRotor.Omega;

sS{1}   = getStabilityState(A,B);
sS{1}.V = ndV;

figure(1)
    plot(real(d1),imag(d1),'ks','Markersize',4);
    grid on

O   = he.mainRotor.Omega;
R   = he.mainRotor.R;
OR  = O*R;
O2  = O*O;
O2R = O2*R;
    
axesData.xvar = 'V';
axesData.xlab = 'V [knots]';
axesData.xunit = OR/.514444;
axesData.yvars = {'Xu' 'Xw' 'Xq' 'Xv' 'Xp' 'Xr' ...
                  'Zu' 'Zw' 'Zq' 'Zv' 'Zp' 'Zr' ...
                  'Mu' 'Mw' 'Mq' 'Mv' 'Mp' 'Mr' ...
                  'Yu' 'Yw' 'Yq' 'Yv' 'Yp' 'Yr' ...
                  'Lu' 'Lw' 'Lq' 'Lv' 'Lp' 'Lr' ...
                  'Nu' 'Nw' 'Nq' 'Nv' 'Np' 'Nr' ...
                  'Xt0' 'Xt1C' 'Xt1S' 'Xt0T'...
                  'Zt0' 'Zt1C' 'Zt1S' 'Zt0T'...
                  'Mt0' 'Mt1C' 'Mt1S' 'Mt0T'...
                  'Yt0' 'Yt1C' 'Yt1S' 'Yt0T'...
                  'Lt0' 'Lt1C' 'Lt1S' 'Lt0T'...
                  'Nt0' 'Nt1C' 'Nt1S' 'Nt0T'...
                  };
axesData.ylabs = {'X_u [1/s]' 'X_w [1/s]' 'X_q [m/s]' 'X_v [1/s]' 'X_p [m/s]' 'X_r [m/s]' ...
                  'Z_u [1/s]' 'Z_w [1/s]' 'Z_q [m/s]' 'Z_v [1/s]' 'Z_p [m/s]' 'Z_r [m/s]' ...
                  'M_u [m/s]' 'M_w [m/s]' 'M_q [1/s]' 'M_v [m/s]' 'M_p [1/s]' 'M_r [1/s]' ...
                  'Y_u [1/s]' 'Y_w [1/s]' 'Y_q [m/s]' 'Y_v [1/s]' 'Y_p [m/s]' 'Y_r [m/s]' ...
                  'L_u [m/s]' 'L_w [m/s]' 'L_q [1/s]' 'L_v [m/s]' 'L_p [1/s]' 'L_r [1/s]' ...
                  'N_u [m/s]' 'N_w [m/s]' 'N_q [1/s]' 'N_v [m/s]' 'N_p [1/s]' 'N_r [1/s]' ...
                  'X_{\theta_0} [m/s^2]' 'X_{\theta_{1C}} [m/s^2]' 'X_{\theta_{1S}} [m/s^2]' 'X_{\theta_{0T}} [m/s^2]'...
                  'Z_{\theta_0} [m/s^2]' 'Z_{\theta_{1C}} [m/s^2]' 'Z_{\theta_{1S}} [m/s^2]' 'Z_{\theta_{0T}} [m/s^2]'...
                  'M_{\theta_0} [1/s^2]' 'M_{\theta_{1C}} [1/s^2]' 'M_{\theta_{1S}} [1/s^2]' 'M_{\theta_{0T}} [1/s^2]'...
                  'Y_{\theta_0} [m/s^2]' 'Y_{\theta_{1C}} [m/s^2]' 'Y_{\theta_{1S}} [m/s^2]' 'Y_{\theta_{0T}} [m/s^2]'...
                  'L_{\theta_0} [1/s^2]' 'L_{\theta_{1C}} [1/s^2]' 'L_{\theta_{1S}} [1/s^2]' 'L_{\theta_{0T}} [1/s^2]'...
                  'N_{\theta_0} [1/s^2]' 'N_{\theta_{1C}} [1/s^2]' 'N_{\theta_{1S}} [1/s^2]' 'N_{\theta_{0T}} [1/s^2]'...
                  };
              
axesData.yunits = [O O OR O OR OR ...
                   O O OR O OR OR ...
                   OR OR O OR O O ...
                   O O OR O OR OR ...
                   OR OR O OR O O ...
                   OR OR O OR O O ...
                   O2R O2R O2R O2R ...
                   O2R O2R O2R O2R ...
                   O2 O2 O2 O2 ...
                   O2R O2R O2R O2R ...
                   O2 O2 O2 O2 ...
                   O2 O2 O2 O2 ...
                   ];
               
sS{2}   = getPadfieldStabilityState(O, R);

pairs = {};
%%%% Uncomment following line in order to generate output files
%     pairs = {'format' {'pdf'} 'prefix' prefix{k} 'closePlot' 'yes'};

plotOpt = parseOptions(pairs,@setHeroesPlotOptions);
plotOpt.mode = 'thick';

legend = {'heroes' 'helisim'};

plotCellOfStructures(sS,axesData,legend,plotOpt);
    
% figure(2)
%     plot(real(d1est(2:9,:)),imag(d1est(2:9,:)),'ko','Markersize',4);
%     grid on

% figure(3)
%     plot(real(d1la(2:5,:)),imag(d1la(2:5,:)),'bo','Markersize',4);
%     grid on
%     hold on
%     plot(real(d1lo(1:4,:)),imag(d1lo(1:4,:)),'ro','Markersize',4);



