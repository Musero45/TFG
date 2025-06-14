function io = aeromechanicsTest

options = setHeroesRigidOptions;
aeromechanicModel = options.aeromechanicModel;

atm     = getISA;
he      = rigidBo105(atm);
%he.mainRotor.kBeta = 1e30;
rho0    = atm.rho0;
g       = atm.g;
ndHe    = rigidHe2ndHe(he,rho0,g);
ndRotor = ndHe.mainRotor;

CT0     = ndRotor.CW;
lambda  = [-sqrt(CT0/2); 0; 0]; 
muW     = [0; 0; 0];
GA      = [0; 0; -1];
theta   = [10; 0; 0]*pi/180;

flightCondition = [0; 0; 0; 0; 0; 0];

muxA = 0:.05:.5;
omegaAdyA = 0:.005:.01;
% sigma1 = 0: -ndRotor.sigma0/2: -ndRotor.sigma0;

n = length(omegaAdyA);
% n = length(sigma1);
m = length(muxA);

beta0    = zeros(n,m);
beta1C   = zeros(n,m);
beta1S   = zeros(n,m);
lambda0  = zeros(n,m);
lambda1C = zeros(n,m);
lambda1S = zeros(n,m);

CT   = zeros(n,m);
CH   = zeros(n,m);
CY   = zeros(n,m);
CMax = zeros(n,m);
CMay = zeros(n,m);
CMaz = zeros(n,m);

nlSolver  = options.nlSolver;

tic;
for i = 1:n;
    initialCondition = [0.01; -0.03; -0.015; lambda(1); lambda(2); lambda(3); CT0; 0; 0];
%     ndRotor.sigma1 = sigma1(i);
    flightCondition(5) = omegaAdyA(i);
    for j =1:m;
        flightCondition(1) = muxA(j);
        system2solve = @(x) aeromechanicModel(x,theta,flightCondition,GA,muW,ndRotor,'linearInflow',@wakeEqs,'armonicInflowModel',@Drees);
        x = nlSolver(system2solve,initialCondition);
        initialCondition = x;
        beta0 (i,j)    = x(1);
        beta1C (i,j)   = x(2);
        beta1S (i,j)   = x(3);
        lambda0 (i,j)  = x(4);
        lambda1C (i,j) = x(5);
        lambda1S (i,j) = x(6);        
    end
end
toc

% for i = 1:n;
%     flightCondition(5) = omegaAdyA(i);
%     for j =1:m;
%         flightCondition(1) = muxA(j);
%         betasol = [beta0(i,j); beta1C(i,j); beta1S(i,j)];
%         lambdasol = [lambda0(i,j); lambda1C(i,j); lambda1S(i,j)];
%         [CFai,CFa0,CMFai,CMFa0,CMaEi,CMaE0] = aerodCoeffs(betasol,theta,lambdasol,flightCondition,muW,ndRotor);
% %         [CFi, CFg, CMFi, CMiE, CMgE, CMel] = transCoeffs(betasol,theta,flightCondition,muW,GA,ndRotor);
%         CH(i,j)  = CFai(1)+CFa0(1);
%         CY(i,j)  = CFai(2)+CFa0(2);
%         CT(i,j)  = CFai(3);
%         CMax(i,j) = CMFai(1)+CMaEi(1)+CMFa0(1)+CMaE0(1);
%         CMay(i,j) = CMFai(2)+CMaEi(2)+CMFa0(2)+CMaE0(2);
%         CMaz(i,j) = CMFai(3)+CMaEi(3)+CMFa0(3)+CMaE0(3);
% %         CT1C(i,j)= CFai(4);
% %         CT1S(i,j)= CFai(5);   
%     end
% end

r2d = 180/pi;

figure (1)
xlabel('\mu_{xA} [-]'); ylabel('\lambda_0 [-]');
grid on
hold on
plot(muxA,lambda0(1,:),'-','LineWidth',2)
plot(muxA,lambda0(2,:),'--','LineWidth',2)
plot(muxA,lambda0(3,:),':','LineWidth',2)
legend('\omega_{AdyA} = 0','\omega_{AdyA} = 0.005','\omega_{AdyA} = 0.01')
savePlot(gcf,'lambda0',{'pdf'});

figure (11)
xlabel('\mu_{xA} [-]'); ylabel('\lambda_{1C} [-]');
grid on
hold on
plot(muxA,lambda1C(1,:),'-','LineWidth',2)
plot(muxA,lambda1C(2,:),'--','LineWidth',2)
plot(muxA,lambda1C(3,:),':','LineWidth',2)
legend('\omega_{AdyA} = 0','\omega_{AdyA} = 0.005','\omega_{AdyA} = 0.01')
savePlot(gcf,'lambda1C',{'pdf'});

figure (12)
xlabel('\mu_{xA} [-]'); ylabel('\lambda_{1S} [-]');
grid on
hold on
plot(muxA,lambda1S(1,:),'-','LineWidth',2)
plot(muxA,lambda1S(2,:),'--','LineWidth',2)
plot(muxA,lambda1S(3,:),':','LineWidth',2)
legend('\omega_{AdyA} = 0','\omega_{AdyA} = 0.005','\omega_{AdyA} = 0.01')
savePlot(gcf,'lambda1S',{'pdf'});

figure (2)
xlabel('\mu_{xA} [-]'); ylabel('\beta_0 [?]');
grid on
hold on
plot(muxA,r2d*beta0(1,:),'-','LineWidth',2)
plot(muxA,r2d*beta0(2,:),'--','LineWidth',2)
plot(muxA,r2d*beta0(3,:),':','LineWidth',2)
legend('\omega_{AdyA} = 0','\omega_{AdyA} = 0.005','\omega_{AdyA} = 0.01')
savePlot(gcf,'beta0',{'pdf'});

figure (3)
xlabel('\mu_{xA} [-]'); ylabel('\beta_{1C} [?]');
grid on
hold on
plot(muxA,r2d*beta1C(1,:),'-','LineWidth',2)
plot(muxA,r2d*beta1C(2,:),'--','LineWidth',2)
plot(muxA,r2d*beta1C(3,:),':','LineWidth',2)
legend('\omega_{AdyA} = 0','\omega_{AdyA} = 0.005','\omega_{AdyA} = 0.01')
savePlot(gcf,'beta1C',{'pdf'});

figure (4)
xlabel('\mu_{xA} [-]'); ylabel('\beta_{1S} [?]');
grid on
hold on
plot(muxA,r2d*beta1S(1,:),'-','LineWidth',2)
plot(muxA,r2d*beta1S(2,:),'--','LineWidth',2)
plot(muxA,r2d*beta1S(3,:),':','LineWidth',2)
legend('\omega_{AdyA} = 0','\omega_{AdyA} = 0.005','\omega_{AdyA} = 0.01')
savePlot(gcf,'beta1S',{'pdf'});

% figure (5)
% xlabel('\mu_{xA} [-]'); ylabel('C_H [-]');
% grid on
% hold on
% plot(muxA,CH(1,:),'-','LineWidth',2)
% plot(muxA,CH(2,:),'--','LineWidth',2)
% plot(muxA,CH(3,:),':','LineWidth',2)
% 
% plot(muxA,-beta1C(1,:).*CT(1,:),'r-','LineWidth',2)
% plot(muxA,-beta1C(2,:).*CT(2,:),'r--','LineWidth',2)
% plot(muxA,-beta1C(3,:).*CT(3,:),'r:','LineWidth',2)
% % savePlot(gcf,'CH',{'pdf'});
% 
% figure (6)
% xlabel('\mu_{xA} [-]'); ylabel('C_Y [-]');
% grid on
% hold on
% plot(muxA,CY(1,:),'-','LineWidth',2)
% plot(muxA,CY(2,:),'--','LineWidth',2)
% plot(muxA,CY(3,:),':','LineWidth',2)
% 
% plot(muxA,-beta1S(1,:).*CT(1,:),'r-','LineWidth',2)
% plot(muxA,-beta1S(2,:).*CT(2,:),'r--','LineWidth',2)
% plot(muxA,-beta1S(3,:).*CT(3,:),'r:','LineWidth',2)
% % savePlot(gcf,'CY',{'pdf'});
% 
% figure (7)
% xlabel('\mu_{xA} [-]'); ylabel('C_T [-]');
% grid on
% hold on
% plot(muxA,CT(1,:),'-','LineWidth',2)
% plot(muxA,CT(2,:),'--','LineWidth',2)
% plot(muxA,CT(3,:),':','LineWidth',2)
% % savePlot(gcf,'CT',{'pdf'});
% 
% figure (8)
% xlabel('\mu_{xA} [-]'); ylabel('C_{MaxA} [-]');
% grid on
% hold on
% plot(muxA,CMax(1,:),'-','LineWidth',2)
% plot(muxA,CMax(2,:),'--','LineWidth',2)
% plot(muxA,CMax(3,:),':','LineWidth',2)
% % savePlot(gcf,'CMaxA',{'pdf'});
% 
% figure (9)
% xlabel('\mu_{xA} [-]'); ylabel('C_{MayA} [-]');
% grid on
% hold on
% plot(muxA,CMay(1,:),'-','LineWidth',2)
% plot(muxA,CMay(2,:),'--','LineWidth',2)
% plot(muxA,CMay(3,:),':','LineWidth',2)
% % savePlot(gcf,'CMayA',{'pdf'});
% 
% figure (10)
% xlabel('\mu_{xA} [-]'); ylabel('C_{MazA} [-]');
% grid on
% hold on
% plot(muxA,CMaz(1,:),'-','LineWidth',2)
% plot(muxA,CMaz(2,:),'--','LineWidth',2)
% plot(muxA,CMaz(3,:),':','LineWidth',2)
% % savePlot(gcf,'CMazA',{'pdf'});

io = 1;
end