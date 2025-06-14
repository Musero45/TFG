clear all
close all
clc

opt3 = {'armonicInflowModel',@Coleman,'mrForces',@completeF,'mrMoments',@aerodynamicM,'fInterf',@noneInterf,'lHTPInterf',@linearInterf,'rHTPInterf',@linearInterf};
opt  = parseOptions(opt3,@setHeroesRigidOptions);
%atmosphere variables needed
atm     = getISA;
rho0    = atm.rho0;
g       = atm.g;

%helicopter model selection
he      = rigidBo105(atm);

% helicopter 2 non-dimensional helicopter
ndHe = rigidHe2ndHe(he,rho0,g);

CW = ndHe.inertia.CW;

muWT = [0; 0; 0];
ndV = linspace(0.,.3,4);
n = length(ndV);

fCT = zeros(6,n);
d2r = pi/180;

thetavf = linspace(1,8,21).*d2r;
m = length(thetavf);

trimState = cell(1,n);

tic;
initialCondition = [0.05; -0.05; .25; 0; 0; .25; 0; 0; 0; -sqrt(CW/2); 0; 0; CW; 0; 0;0; 0; 0; -sqrt(CW/20); 0; 0; CW/10; 0; 0; 0];
x = zeros(25,n);
y = zeros(25,n,m);
fCT(1,:) = ndV(:);

nlSolver  = opt.nlSolver;
eps       = opt.TolX;

for j = 1:m
he.verticalFin.theta = thetavf(j);
ndHe = rigidHe2ndHe(he,rho0,g);  
    for i = 1:n
        disp (['Solving trim...  ', num2str(i+n*(j-1)), ' of ', num2str(m*n)]);
        if(norm(fCT(:,i))<eps || atan2(fCT(3,i),fCT(1,i))>86*d2r && atan2(fCT(3,i),fCT(1,i))<104*d2r)
            system2solve = @(x) helicopterTrimAxial(x,fCT(:,i),muWT,ndHe,opt);
            x(1:24,i) = nlSolver(system2solve,initialCondition(1:24),opt);
            x(25,i) = 0;
        else
            system2solve = @(x) helicopterTrim(x,fCT(:,i),muWT,ndHe,opt);
            x(:,i) = nlSolver(system2solve,initialCondition,opt);
        end
        for k = 1:25
            if abs(x(k,i))<eps
                x(k,i) = 0;
            end
        end
        initialCondition = x(:,i);
    end
    
y(:,:,j) = x(:,:);
end
toc
leg  = {'\mu_T = 0.' '\mu_T = 0.1' '\mu_T = 0.2' '\mu_T = 0.3'};
mark = {'k-','r-','b-','g','k-o','k-^',...
          'k-d','k:.','k-*','k-+',...
          'k-v','k->','k-<'};

setPlot
figure (1)
hold on
for i = 1:n
    theta0T(i,:) = y(6,i,:);
    plot(thetavf./d2r,theta0T(i,:)./d2r,mark{i})
end
grid on
box on
xlabel('\theta_{vf} [º]')
ylabel('\theta_{0T} [º]')
legend(leg,'location','Best')
savePlot(gcf,'t0Ttvf',{'pdf'});
unsetPlot



