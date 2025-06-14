function io = AxialDerivativesTest(mode)

close all
clear all

options = setHeroesRigidOptions;
options.GT         = 0;
options.inertialFM = 0;
opt{1} = options;
opt{2} = options;

opt{1}.uniformInflowModel = @Cuerva;
opt{2}.uniformInflowModel = @Rand;

%atmosphere variables needed
atm     = getISA;
g       = atm.g;
htest   = 0;
rho     = atm.density(htest);

%helicopter model selection
he = rigidBo105(atm);
ndHe = rigidHe2ndHe(he,rho,g);

muWT = [0; 0; 0];
ndV = linspace(0, .07, 31); ...
n = length(ndV);
m  = length(opt);

CW = ndHe.inertia.CW;
O   = he.mainRotor.Omega;
R   = he.mainRotor.R;

fCT      = zeros(6,n);
fCT(3,:) = ndV(:);
d2r = pi/180;

y    = zeros(25,n);
ndA  = zeros(9,9,n);
errA = zeros(9,9,n);
ndd  = zeros(9,n);
A    = zeros(9,9,n);
eigV = zeros(9,9,n);
dM   = zeros(9,9,n);
d    = zeros(9,n,m);
B    = zeros(9,4,n);
errB = zeros(9,4,n);


sS = cell(1,m);
tS = cell(1,m);

setPlot

for j = 1:m
options  = opt{j};
nlSolver = options.nlSolver;
eps      = options.TolX;
initialCondition = [0.05; -0.05; .25; 0.004; 0.0078; 0.135; 0.036; -0.005; 0.006; -sqrt(CW/2); 0; 0; CW; 0; 0;0; 0; 0; -0.05; 0; 0; 0.007; 0; 0; 0];
    for i = 1:n
        tic;
        disp (['Solving trim...  ', num2str(n*(j-1)+i), ' of ', num2str(m*n)]);
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
        disp (['Calculating A... ', num2str(n*(j-1)+i), ' of ', num2str(m*n)]);
        F = @(X) getStabilityEquations(0,X,control,muWV,y0,ndHe,options);
        X0 = [muV(1);muV(3);0;y(1,i);0;0;y(2,i);0;0];
        [ndA(:,:,i),errA(:,:,i)] = jacobianest(F,X0);
        A(:,:,i) = ndA2A (ndA(:,:,i), O, R);
        [eigV(:,:,i),dM(:,:,i)] = eig(A(:,:,i));
        d(:,i,j) = diag(dM(:,:,i));
        
%         disp (['Calculating B... ', num2str(n*(j-1)+i), ' of ', num2str(m*n)]);
%         X = [muV(1);muV(3);0;y(1,i);0;0;y(2,i);0;0];
%         F = @(control) getStabilityEquations(0,X,control,muWV,y0,ndHe,options);
%         control0 = [y(3,i);y(4,i);y(5,i);y(6,i)];
%         [B(:,:,i),errB(:,:,i)] = jacobianest(F,control0);
        toc
    end

figure(j)
plot(real(d(2:9,:,j)),imag(d(2:9,:,j)),'ko','Markersize',4);
grid on
axis([-15 .5 0 2.5])
axis 'autox'
xlabel('Re (s) [1/s]')
ylabel('Im (s) [1/s]')
name = strcat('eigMapAx',num2str(j));
% savePlot(gcf,name,{'pdf'});
    
sS{j}   = getStabilityState(ndA,B);
sS{j}.V = ndV;

tS{j} = getHeTrimState(y,fCT,muWT,ndHe,options);
% plotActionsByElement(tS{j});
end

pairs = {'format' {'pdf'} 'prefix' 'axial' 'closePlot' 'yes'};

leg = {'Cuerva' 'Rand'};

figure(j+1)
plot(ndV,tS{1,1}.lambda0,'b-')
hold on
plot(ndV,tS{1,2}.lambda0,'r-')
grid on
box on
legend(leg)
xlabel('V/(\Omega R) [-]')
ylabel('\lambda_0 [-]')
% savePlot(gcf,'lambdaAx',{'pdf'});

figure(j+2)
plot(ndV,tS{1,1}.theta0./d2r,'b-')
hold on
plot(ndV,tS{1,2}.theta0./d2r,'r-')
box on
grid on
legend(leg)
xlabel('V/(\Omega R) [-]')
ylabel('\theta_0 [?]')
% savePlot(gcf,'theta0Ax',{'pdf'});

figure(j+3)
plot(ndV,sS{1,1}.Zw,'b-')
hold on
plot(ndV,sS{1,2}.Zw,'r-')
box on
grid on
legend(leg)
xlabel('V/(\Omega R) [-]')
ylabel('\partial C_z / \partial \mu_w [-]')
% savePlot(gcf,'ZwAx',{'pdf'});

figure(j+4)
plot(real(d(2:9,:,2)),imag(d(2:9,:,2)),'rs','Markersize',4);
hold on
box on
plot(real(d(2:9,:,1)),imag(d(2:9,:,1)),'bo','Markersize',4);
grid on
axis([-.8 .5 0 .15])
xlabel('Re (s) [1/s]')
ylabel('Im (s) [1/s]')
name = strcat('eigMapAx',num2str(j+1));
% savePlot(gcf,name,{'pdf'});

figure(j+5)
plot(real(d(2:9,:,2)),imag(d(2:9,:,2)),'rs','Markersize',4);
hold on
box on
plot(real(d(2:9,:,1)),imag(d(2:9,:,1)),'bo','Markersize',4);
grid on
axis([-.8 .5 0 3])
axis 'autox'
xlabel('Re (s) [1/s]')
ylabel('Im (s) [1/s]')
name = strcat('eigMapAx',num2str(j+2));
% savePlot(gcf,name,{'pdf'});

% plotStabilityDerivatives(sS,leg,pairs);
% plotControlDerivatives(sS,leg,pairs)



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Arrangement of Cuerva eigenvectors ndV = linspace(0, .07, 31)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% % [eigV(:,4,1),eigV(:,5,1),eigV(:,6,1),eigV(:,7,1)]= deal(eigV(:,6,1),eigV(:,7,1),eigV(:,4,1),eigV(:,5,1));
% % [eigV(:,6,1:3),eigV(:,8,1:3)]= deal(eigV(:,8,1:3),eigV(:,6,1:3));
% % [eigV(:,6,23:24),eigV(:,8,23:24)]= deal(eigV(:,8,23:24),eigV(:,6,23:24));
% % [eigV(:,6,26:31),eigV(:,8,26:31)]= deal(eigV(:,8,26:31),eigV(:,6,26:31));
% % [eigV(:,7,1:3),eigV(:,9,1:3)]= deal(eigV(:,9,1:3),eigV(:,7,1:3));
% % [eigV(:,7,23:24),eigV(:,9,23:24)]= deal(eigV(:,9,23:24),eigV(:,7,23:24));
% % [eigV(:,7,26:31),eigV(:,9,26:31)]= deal(eigV(:,9,26:31),eigV(:,7,26:31));
% % [eigV(:,8,1:2),eigV(:,9,1:2)]= deal(eigV(:,9,1:2),eigV(:,8,1:2));
% % 
% % [d(4,1),d(5,1),d(6,1),d(7,1)]= deal(d(6,1),d(7,1),d(4,1),d(5,1));
% % [d(6,1:3),d(8,1:3)]= deal(d(8,1:3),d(6,1:3));
% % [d(6,23:24),d(8,23:24)]= deal(d(8,23:24),d(6,23:24));
% % [d(6,26:31),d(8,26:31)]= deal(d(8,26:31),d(6,26:31));
% % [d(7,1:3),d(9,1:3)]= deal(d(9,1:3),d(7,1:3));
% % [d(7,23:24),d(9,23:24)]= deal(d(9,23:24),d(7,23:24));
% % [d(7,26:31),d(9,26:31)]= deal(d(9,26:31),d(7,26:31));
% % [d(8,1:2),d(9,1:2)]= deal(d(9,1:2),d(8,1:2));

io = 1;
