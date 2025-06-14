function io = rotorFlapOmegaTest

options = setHeroesRigidOptions;
aeromechanicModel = options.aeromechanicModel;

atm     = getISA;
he      = rigidBo105(atm);
rho0    = atm.rho0;
g       = atm.g;
ndHe    = rigidHe2ndHe(he,rho0,g);
ndMR    = ndHe.mainRotor;

CT0     = ndHe.inertia.CW;
lambda  = [-sqrt(CT0/2); 0; 0]; 
muW     = [0; 0; 0];
GA      = [0; 0; -1];

flightCondition = [0; 0; 0; 0; 0; 0];

muxA = 0:.15:.3;
omegaAdStep = -0.02:.001:.02;

n1 = length(muxA);
n2 = length(omegaAdStep);

beta0    = zeros(n1,n2,3);
beta1C   = zeros(n1,n2,3);
beta1S   = zeros(n1,n2,3);

r2d = 180/pi;

nlSolver  = options.nlSolver;

tic;
for i = 1:n1;
    trim0 = [-0.01; 0; 0.18; 0; 0.05; 1e-4; 0; 0; 0; lambda; CT0; 0; 0];
    flightCondition(1) = muxA(i);
    system2solve = @(x) isolatedRotorTrim(x,flightCondition,muW,ndMR);
    trimState = nlSolver(system2solve,trim0,options);
    theta  = trimState(3:5);
%     theta  = [trimState(3);0;0];
    beta   = trimState(7:9);
    lambda = trimState(10:12);
    for k = 1:3;
        initialCondition = [beta; lambda; CT0;0;0];
        flightCondition = [0; 0; 0; 0; 0; 0];
        for j = 1:n2;
            flightCondition(k+3) = omegaAdStep(j);
            system2solve = @(x) aeromechanicModel(x,theta,flightCondition,GA,muW,ndMR,'uniformInflowModel',@Cuerva,'armonicInflowModel',@none);
            x = nlSolver(system2solve,initialCondition,options);
            initialCondition = x;
            beta0 (i,j,k)    = x(1);
            beta1C (i,j,k)   = x(2);
            beta1S (i,j,k)   = x(3);      
        end
    end
end
toc

str = ['x' 'y' 'z'];

for k = 1:3
    figure (1+3*(k-1))
    xlabel(['\omega_' str(k) '/\Omega [-]']); ylabel('\beta_0 [?]');
    grid on
    hold on
    plot(omegaAdStep,r2d*beta0(1,:,k),'-','LineWidth',2)
    plot(omegaAdStep,r2d*beta0(2,:,k),'--','LineWidth',2)
    plot(omegaAdStep,r2d*beta0(3,:,k),':','LineWidth',2)
    legend('\mu_{xA} = 0','\mu_{xA} = 0.15','\mu_{xA} = 0.3')
%     savePlot(gcf,['beta0' str(k)],{'pdf'});
    
    figure (2+3*(k-1))
    xlabel(['\omega_' str(k) '/\Omega [-]']); ylabel('\beta_{1C} [?]');
    grid on
    hold on
    plot(omegaAdStep,r2d*beta1C(1,:,k),'-','LineWidth',2)
    plot(omegaAdStep,r2d*beta1C(2,:,k),'--','LineWidth',2)
    plot(omegaAdStep,r2d*beta1C(3,:,k),':','LineWidth',2)
    legend('\mu_{xA} = 0','\mu_{xA} = 0.15','\mu_{xA} = 0.3')
%     savePlot(gcf,['beta1C' str(k)],{'pdf'});
    
    figure (3+3*(k-1))
    xlabel(['\omega_' str(k) '/\Omega [-]']); ylabel('\beta_{1S} [?]');
    grid on
    hold on
    plot(omegaAdStep,r2d*beta1S(1,:,k),'-','LineWidth',2)
    plot(omegaAdStep,r2d*beta1S(2,:,k),'--','LineWidth',2)
    plot(omegaAdStep,r2d*beta1S(3,:,k),':','LineWidth',2)
    legend('\mu_{xA} = 0','\mu_{xA} = 0.15','\mu_{xA} = 0.3')
%     savePlot(gcf,['beta1S' str(k)],{'pdf'});
end

io = 1;
end