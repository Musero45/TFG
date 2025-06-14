close all
clear all

options            = setHeroesRigidOptions;
options.GT         = 0;
options.inertialFM = 0;

%atmosphere variables needed
atm     = getISA;
g       = atm.g;
htest   = 0;
rho     = atm.density(htest);

%helicopter model selection
he = PadfieldBo105(atm);

muWT = [0; 0; 0];
V = linspace(0.0, 140, 31); ...
n = length(V);
m  = length(he);

fCT = zeros(6,n);
d2r = pi/180;

nlSolver = options.nlSolver;
eps      = options.TolX;

y    = zeros(25,n);
ndA  = zeros(9,9,n);
errA = zeros(9,9,n);
ndd  = zeros(9,n);
A    = zeros(9,9,n);
eigV = zeros(9,9,n);
dM   = zeros(9,9,n);
d    = zeros(9,n);
B    = zeros(9,4,n);
errB = zeros(9,4,n);

sS = cell(1,m+1);
tS = cell(1,m);


ndHe = rigidHe2ndHe(he,rho,g);

CW = ndHe.inertia.CW;

O   = he.mainRotor.Omega;
R   = he.mainRotor.R;
ndV = V./(O*R).*0.5144444;...
fCT(1,:) = ndV(:);

initialCondition = [0.05; -0.05; .25; 0.004; 0.0078; 0.135; 0.036; -0.005; 0.006; -sqrt(CW/2); 0; 0; CW; 0; 0;0; 0; 0; -0.05; 0; 0; 0.007; 0; 0;0];... ;0;0;0];
    for i = 1:n
        tic;
        disp (['Solving trim...  ', num2str(i), ' of ', num2str(n)]);
        if(norm(fCT(:,i))<eps || atan2(fCT(3,i),fCT(1,i))>86*d2r && atan2(fCT(3,i),fCT(1,i))<104*d2r)
            system2solve = @(x) helicopterTrimAxial(x,fCT(:,i),muWT,ndHe,options);
            y(1:24,i) = nlSolver(system2solve,initialCondition(1:24),options);
            y(25,i) = 0;
        else
            system2solve = @(x) helicopterTrim(x,fCT(:,i),muWT,ndHe,options);
            y(:,i) = nlSolver(system2solve,initialCondition,options);
        end
        for k = 1:25
            if abs(y(k,i))<eps
                y(k,i) = 0;
            end
        end
        initialCondition = y(:,i);
        
        control = y(3:6,i);
        y0      = y(7:24,i);
        MFT  = TFT(0,y(1,i),y(2,i));
        muV  = MFT*fCT(1:3,i);
        muWV = MFT*muWT;
        disp (['Calculating A... ', num2str(i), ' of ', num2str(n)]);
        F = @(X) getStabilityEquations(0,X,control,muWV,y0,ndHe,options);
        X0 = [muV(1);muV(3);0;y(1,i);0;0;y(2,i);0;0];
        [ndA(:,:,i),errA(:,:,i)] = jacobianest(F,X0);
        A(:,:,i) = ndA2A (ndA(:,:,i), O, R);
        [eigV(:,:,i),dM(:,:,i)] = eig(A(:,:,i));
        d(:,i) = diag(dM(:,:,i));
        toc
    end
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Arrangement of eigenvectors V = linspace(0, 140, 31)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    

[eigV(:,4,1:2),eigV(:,5,1:2),eigV(:,8,1:2),eigV(:,9,1:2)]= deal(eigV(:,8,1:2),eigV(:,9,1:2),eigV(:,4,1:2),eigV(:,5,1:2));
[eigV(:,6,8:28),eigV(:,8,8:28)]= deal(eigV(:,8,8:28),eigV(:,6,8:28));
[eigV(:,8,3:4),eigV(:,9,3:4)]= deal(eigV(:,9,3:4),eigV(:,8,3:4));

[d(4,1:2),d(5,1:2),d(8,1:2),d(9,1:2)]= deal(d(8,1:2),d(9,1:2),d(4,1:2),d(5,1:2));
[d(6,8:28),d(8,8:28)]= deal(d(8,8:28),d(6,8:28));
[d(8,3:4),d(9,3:4)]= deal(d(9,3:4),d(8,3:4));




