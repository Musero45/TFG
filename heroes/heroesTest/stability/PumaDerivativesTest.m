close all
clear all

options = setHeroesRigidOptions;

%atmosphere variables needed
atm     = getISA;
g       = atm.g;
htest   = 0;
rho     = atm.density(htest);

%helicopter model selection
he{1} = rigidPuma(atm);
% he{2} = he{1};

he{1}.fuselage.model = @PadPumaFus;
% he{2}.fuselage.model = @generalFus;

muWT = [0; 0; 0];
V = linspace(0, 140, 31); ...
n = length(V);

flightConditionT = zeros(6,n);
nlSolver  = options.nlSolver;

y    = zeros(24,n);
ndA  = zeros(9,9,n);
errA = zeros(9,9,n);
ndd  = zeros(9,n);
A    = zeros(9,9,n);
eigV = zeros(9,9,n);
dM   = zeros(9,9,n);
d    = zeros(9,n);
B    = zeros(9,4,n);
errB = zeros(9,4,n);

m  = length(he);
sS = cell(m+1);
tS = cell(m);

% M       = getPadfieldEigenvaluesMap('Bo105');
sS{m+1} = getPadfieldStabilityState('PumaD');

for j = 1:m
ndHe = rigidHe2ndHe(he{j},rho,g);

CW = ndHe.inertia.CW;

O   = he{j}.mainRotor.Omega;
R   = he{j}.mainRotor.R;
ndV = V./(O*R).*0.5144444;...
flightConditionT(1,:) = ndV(:);

initialCondition = [0.08; -0.05; .27; 0.03; -0.01; 0.221; 0.088; -0.002; 0.011; -sqrt(CW/2); 0; 0; CW; 0; 0;0; 0; 0; -0.05; 0; 0; 0.011; 0; 0];

    for i = 1:n
        tic;
        disp (['Solving trim...  ', num2str(n*(j-1)+i), ' of ', num2str(m*n)]);
        system2solve = @(x) helicopterTrim(x,flightConditionT(:,i),muWT,ndHe,options);
        y(:,i) = nlSolver(system2solve,initialCondition,options);
%         for k=1:25
%         if abs(y(k,i))<1e-12
%             y(k,i)=0;
%         end
%         end
        initialCondition = y(:,i);
        control = y(3:6,i);
        y0      = y(7:24,i);
        MFT  = TFT(0,y(1,i),y(2,i));
        muV  = MFT*flightConditionT(1:3,i);
        muWV = MFT*muWT;
        disp (['Calculating A... ', num2str(n*(j-1)+i), ' of ', num2str(m*n)]);
        F = @(X) getStabilityEquations(0,X,control,muWV,y0,ndHe,options);
%         X0 = [y(26,i);y(28,i);0;y(1,i);y(27,i);0;y(2,i);0;0];
        X0 = [muV(1);muV(3);0;y(1,i);muV(2);0;y(2,i);0;0];
        [ndA(:,:,i),errA(:,:,i)] = jacobianest(F,X0);
        A(:,:,i) = ndA2A (ndA(:,:,i), O, R);
        [eigV(:,:,i),dM(:,:,i)] = eig(A(:,:,i));
        d(:,i) = diag(dM(:,:,i));
%         dlo(:,i) = eig(A(1:4,1:4,i));
%         dla(:,i) = eig(A(5:8,5:8,i));
        ndd(:,i) = O.*eig(ndA(:,:,i));

%         disp (['Calculating B... ', num2str(n*(j-1)+i), ' of ', num2str(m*n)]);
%         X = [muV(1);muV(3);0;y(1,i);muV(2);0;y(2,i);0;0];
%         X = [muV(1);muV(3);0;y(1,i);0;0;y(2,i);0;0];
%         F = @(control) getStabilityEquations(0,X,control,muWV,y0,ndHe,options);
%         control0 = [y(3,i);y(4,i);y(5,i);y(6,i)];
%         [B(:,:,i),errB(:,:,i)] = jacobianest(F,control0);
        toc
    end

figure(j)
plot(real(d),imag(d),'bo','Markersize',4,'MarkerFaceColor','blue');
grid on
% axis([-15 .5 0 4.5])
xlabel('Re (\lambda) [1/s]')
ylabel('Im (\lambda) [1/s]')
% hold on
% plot(real(M),imag(M),'ks','Markersize',4);
% savePlot(gcf,'eigMap',{'pdf'});

% figure(j+m)
% plot(real(dlo),imag(dlo),'ro','Markersize',4);
% grid on
% hold on
% plot(real(dla),imag(dla),'co','Markersize',4);
    
sS{j}   = getStabilityState(ndA,B);
sS{j}.V = ndV;

tS{j} = getHeTrimState(y,flightConditionT,muWT,ndHe,options);
% plotActionsByElement(tS{j});
end

pairs = {};
%%% Uncomment following line in order to generate output files
% pairs = {'format' {'pdf'} 'prefix' '1' 'closePlot' 'yes'};

legend = {'Padfield' 'gen' 'helisim'};
legend = {'Padfield' 'helisim'};
% plotStabilityDerivatives(sS,legend,pairs);
% plotControlDerivatives(sS,legend,pairs)