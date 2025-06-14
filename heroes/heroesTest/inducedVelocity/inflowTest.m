function io = inflowTest(mode)

%options     = setHeroesRigidOptions;
plotOptions = setHeroesPlotOptions;
%lines = plotOptions.lines;
mark  = plotOptions.mark;

atm     = getISA;
he      = rigidBo105(atm);
% % % % % % rho0    = atm.rho0;
% % % % % % g       = atm.g;
ndHe    = rigidHe2ndHe(he,atm,0);

options      = setHeroesRigidOptions; 
nlSolver     = options.nlSolver;

CT   = [ndHe.inertia.CW; 0; 0];
beta = [0; 0; 0];
muW  = [0; 0; 0];

alpha = [-60,0,20,50,70]*pi/180;
mu    = 0:.003:.15;

flightCondition = zeros(length(mu),6);

% figure(6)
% axis([0 3 0 2])
% xlabel('V/v_{i0h} [-]'); ylabel('\lambda_0/\lambda_{0h}  \lambda_{1C}/\lambda_{0h} [-]');
% grid on

figure(7)
axis auto
xlabel('V/v_{i0h} [-]'); ylabel('(\lambda_{0MT} - \lambda_{0G})/\lambda_{0G} [%]');
grid on

% figure(8)
% axis([0 3 0 2.5])
% xlabel('V/v_{i0h} [-]'); ylabel('\lambda_0/\lambda_{0h}  \lambda_{1C}/\lambda_{0h} [-]');
% grid on

lambda  = zeros(length(mu),3);
lambda1 = zeros(length(mu),3);
% lambda2 = zeros(length(mu),3);
% lambda3 = zeros(length(mu),3);
% lambda4 = zeros(length(mu),3);
% lambda5 = zeros(length(mu),3);
% lambda6 = zeros(length(mu),3);
% lambda7 = zeros(length(mu),3);
% lambda8 = zeros(length(mu),3);

initialCondition = [-sqrt(CT(1)/2);0;0];

for i = 1:length(alpha)
    flightCondition(:,3) = mu(:).*sin(alpha(i)); 
    flightCondition(:,1) = mu(:).*cos(alpha(i));

    for j=1:length(flightCondition)
        f  = @(lambda) LMTGlauert(lambda,CT,flightCondition(j,:),muW,beta);
        f1 = @(lambda) wakeEqs(lambda,CT,flightCondition(j,:),muW,beta,'uniformInflowModel',@Glauert,'armonicInflowModel',@none);
%         f2 = @(lambda) wakeEqs(lambda,CT,flightCondition(j,:),muW,beta,'uniformInflowModel',@Glauert,'armonicInflowModel',@Coleman);
%         f3 = @(lambda) wakeEqs(lambda,CT,flightCondition(j,:),muW,beta,'uniformInflowModel',@Glauert,'armonicInflowModel',@Payne);
%         f4 = @(lambda) wakeEqs(lambda,CT,flightCondition(j,:),muW,beta,'uniformInflowModel',@Glauert,'armonicInflowModel',@White);
%         f5 = @(lambda) wakeEqs(lambda,CT,flightCondition(j,:),muW,beta,'uniformInflowModel',@Glauert,'armonicInflowModel',@Pitt);
%         f6 = @(lambda) wakeEqs(lambda,CT,flightCondition(j,:),muW,beta,'uniformInflowModel',@Glauert,'armonicInflowModel',@Howlett);
%         f7 = @(lambda) wakeEqs(lambda,CT,flightCondition(j,:),muW,beta,'uniformInflowModel',@Cuerva,'armonicInflowModel',@none);
%         f8 = @(lambda) wakeEqs(lambda,CT,flightCondition(j,:),muW,beta,'uniformInflowModel',@Rand,'armonicInflowModel',@none');
        
        lambda(j,:)  = nlSolver(f,initialCondition,options);
        lambda1(j,:) = nlSolver(f1,initialCondition,options);
%         lambda2(j,:) = nlSolver(f2,initialCondition,options);
%         lambda3(j,:) = nlSolver(f3,initialCondition,options);
%         lambda4(j,:) = nlSolver(f4,initialCondition,options);
%         lambda5(j,:) = nlSolver(f5,initialCondition,options);
%         lambda6(j,:) = nlSolver(f6,initialCondition,options);
%         lambda7(j,:) = nlSolver(f7,initialCondition,options);
%         lambda8(j,:) = nlSolver(f8,initialCondition,options);
    end
    lambdaHover = lambda1(1,1);
    
%     %Similar to Chen's report (NASA TM-102219) fig. 16 (Page 64-43)
%     figure(i)
%     axis([0 3 0 2.5])
%     axis 'auto y';
%     xlabel('V/v_{i0h} [-]'); ylabel('\lambda_0/\lambda_{0h}  \lambda_{1C}/\lambda_{0h} [-]');
%     grid on
%     hold on
%     plot(mu/abs(lambdaHover),lambda2(:,1)/lambdaHover,'k--','LineWidth',2)
%     plot(mu/abs(lambdaHover),lambda2(:,2)/lambdaHover,'k-v','LineWidth',2)
%     plot(mu/abs(lambdaHover),lambda3(:,2)/lambdaHover,'k-s','LineWidth',2)
%     plot(mu/abs(lambdaHover),lambda4(:,2)/lambdaHover,'k-+','LineWidth',2)
%     plot(mu/abs(lambdaHover),lambda5(:,2)/lambdaHover,'k-*','LineWidth',2)
%     plot(mu/abs(lambdaHover),lambda6(:,2)/lambdaHover,'k-d','LineWidth',2)
%     hold off
%     legend({'Glauert (\lambda_0)','Coleman','Payne','White','Pitt','Howlett'},'Location','B')
%     
% %     %Padfield's fig 3.15 (Page 121)
%     figure(6)
%     hold on
%     plot(mu/abs(lambdaHover),lambda2(:,1)/lambdaHover,mark{i},'LineWidth',2)
%     plot(mu/abs(lambdaHover),lambda2(:,2)/lambdaHover,mark{i+5},'LineWidth',2)
%     hold off
    
    %Differences between momentum theory and Glauert's model 
    err = 100*(lambda(:,1)-lambda1(:,1))./lambda1(:,1);
    figure(7)
    hold on
    plot(mu/abs(lambdaHover),err,mark{i},'LineWidth',2)
    hold off

%     %Red book figure 3.13 Page 112
%     figure(8)
%     hold on
%     plot(mu/abs(lambdaHover),lambda7(:,1)/lambdaHover,mark{i},'LineWidth',2)
%     plot(mu/abs(lambdaHover),lambda8(:,1)/lambdaHover,mark{i+5},'LineWidth',2)
%     hold off
end
% figure(6)
% legend({'\alpha_D=-60?','','\alpha_D=0?','','\alpha_D=20?','','\alpha_D=50?','','\alpha_D=70?',''})
% figure(7)
% legend({'\alpha_D=-60?','\alpha_D=0?','\alpha_D=20?','\alpha_D=50?','\alpha_D=70?'})
% figure(8)
% legend({'\alpha_D=-60? (Cuerva)','\alpha_D=-60? (Rand)','\alpha_D=0?','','\alpha_D=20?','','\alpha_D=50?','','\alpha_D=70?',''})

io = 1;

end