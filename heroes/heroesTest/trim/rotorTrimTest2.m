function io = rotorTrimTest2

clear all
close all

options = setHeroesRigidOptions;

%atmosphere variables needed
atm     = getISA;
rho0    = atm.rho0;
g       = atm.g;

%helicopter model selection
he      = rigidBo105(atm);

% helicopter 2 non-dimensional helicopter
ndHe = rigidHe2ndHe(he,rho0,g);
ndMR = ndHe.mainRotor;

ndMR.SBeta = 0;
ndMR.ead   = 0;

CW   = ndMR.CW;

flightCondition = [0; 0; 0; 0; 0; 0];
muW             = [0; 0; 0];

muxT = 0:-.025:-.35;

inflow  = {@wakeEqs @wakeEqs @wakeEqs};
uniform = {@Glauert @Glauert @Glauert};
armonic = {@none @Drees @Coleman};

n = length(inflow);
m = length(muxT);

trimState  = zeros(n,m,21);

nlSolver  = options.nlSolver;

tic;
for i = 1:n;
    initialCondition = [-0.01; 0; 0.18; 0; 0.05; 1e-4; 0; 0; 0; -sqrt(CW/2); 0; 0; CW; 0; 0];
    inf = inflow{i};
    uni = uniform{i};
    arm = armonic{i};
    for j = 1:m;
        flightCondition(1) = muxT(j);
        system2solve = @(x) isolatedRotorTrim(x,flightCondition,muW,ndMR,'linearInflow',inf,'uniformInflowModel',uni,'armonicInflowModel',arm);
        x = nlSolver(system2solve,initialCondition,options);
        initialCondition = x;
        trimState(i,j,1:15) = x;
        TAT = irTAT(x(1),x(2));
        muA  = TAT*[flightCondition(1); flightCondition(2); flightCondition(3)];
        muWA = TAT*[muW(1);muW(2);muW(3)];
        omegaAdA = [0; 0; 0];
        flightConditionA = [muA; omegaAdA];
        [CFai, CFa0, CMFai, CMFa0, CMaEi, CMaE0] = aerodCoeffs(x(7:9),x(3:5),x(10:12),flightConditionA,muWA,ndMR);
        trimState(i,j,16:18) = CFai(1:3) + CFa0(1:3);
        trimState(i,j,19:21) = CMFai + CMFa0 + CMaEi + CMaE0;
    end
end
toc

r2d = 180/pi;

trimState(:,:,1:5) = r2d*trimState(:,:,1:5);
trimState(:,:,7:9) = r2d*trimState(:,:,7:9);

vars = {'\Theta_A [?]' '\Phi_A [?]' '\theta_0 [?]' '\theta_{1C} [?]' ...
        '\theta_{1S} [?]' 'C_Q [-]' '\beta_0 [?]' '\beta_{1C} [?]' ...
        '\beta_{1S} [?]' '\lambda_0 [-]' '\lambda_{1C} [-]' '\lambda_{1S} [-]' ...
        'C_{T0} [-]' 'C_{T1C} [-]' 'C_{T1S} [-]' 'C_{H} [-]' 'C_{Y} [-]' 'C_{T} [-]' ...
        'C_{xA}^{Ma} [-]' 'C_{yA}^{Ma} [-]' 'C_{zA}^{Ma}'};
    
names = {'ThetaA' 'PhiA' 'theta0' 'theta1C' ...
        'theta1S' 'CQ' 'beta0' 'beta1C' ...
        'beta1S' 'lambda0' 'lambda1C' 'lambda1S' ...
        'CT0' 'CT1C' 'CT1S' 'CH' 'CY' 'CT' ...
        'CMaxA' 'CMayA' 'CMazA'};
    
mark = {'-' '--' ':' '.-'};

for k = 1:21
    figure (k)
    xlabel('V/\Omega R [-]'); ylabel(vars{k});
    grid on
    hold on
    for i = 1:n
        plot(-muxT,trimState(i,:,k),mark{i},'LineWidth',2)
    end 
%     if k==3
%         annotation('textbox',...
%     [0.670642857142856 0.464285714285714 0.179357142857144 0.226190476190483],...
%     'String',{'Trim','k_{\beta} = 1e50','e/R = 0','\mu_{yT} = \mu_{zT} = 0','\omega/\Omega = 0'},...
%     'FitBoxToText','off',...
%     'BackgroundColor',[1 1 1]);
%     end
    legend('Glauert-none','Glauert-Drees','Glauert-Coleman')
    savePlot(gcf,names{k},{'pdf'});
end

io = 1;
