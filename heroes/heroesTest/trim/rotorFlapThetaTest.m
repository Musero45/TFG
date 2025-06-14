function io = rotorFlapThetaTest

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
thetaStep = (-5:.25:5)*pi/180;

n1 = length(muxA);
n2 = length(thetaStep);

beta0    = zeros(n1,n2,3);
beta1C   = zeros(n1,n2,3);
beta1S   = zeros(n1,n2,3);

nlSolver  = options.nlSolver;

tic;

trim0 = [-0.01; 0; 0.18; 0; 0.05; 1e-4; 0; 0; 0; lambda; CT0; 0; 0];
system2solve = @(x) isolatedRotorTrim(x,flightCondition,muW,ndMR);
trimState = nlSolver(system2solve,trim0,options);
thetaeq  = trimState(3:5);
beta   = trimState(7:9);
lambda = trimState(10:12);

for i = 1:n1;
    flightCondition(1) = muxA(i);
    for k = 1:3;
        theta = thetaeq;
        initialCondition = [beta; lambda; CT0;0;0];
        for j = 1:n2;
            theta(k) = thetaeq(k) + thetaStep(j);
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

str = ['0' 'C' 'S'];

r2d = 180/pi;

for k = 1:3
    figure (1+3*(k-1))
    xlabel(['\theta_' str(k) ' [?]']); ylabel('\beta_0 [?]');
    grid on
    hold on
    plot(r2d*(thetaeq(k)*unos(n2)+ thetaStep),r2d*beta0(1,:,k),'-','LineWidth',2)
    plot(r2d*(thetaeq(k)*unos(n2)+ thetaStep),r2d*beta0(2,:,k),'--','LineWidth',2)
    plot(r2d*(thetaeq(k)*unos(n2)+ thetaStep),r2d*beta0(3,:,k),':','LineWidth',2)
    legend('\mu_{xA} = 0','\mu_{xA} = 0.15','\mu_{xA} = 0.3')
%     savePlot(gcf,['beta0t' str(k)],{'pdf'});
    
    figure (2+3*(k-1))
    xlabel(['\theta_' str(k) ' [?]']); ylabel('\beta_{1C} [?]');
    grid on
    hold on
    plot(r2d*(thetaeq(k)*unos(n2)+ thetaStep),r2d*beta1C(1,:,k),'-','LineWidth',2)
    plot(r2d*(thetaeq(k)*unos(n2)+ thetaStep),r2d*beta1C(2,:,k),'--','LineWidth',2)
    plot(r2d*(thetaeq(k)*unos(n2)+ thetaStep),r2d*beta1C(3,:,k),':','LineWidth',2)
    legend('\mu_{xA} = 0','\mu_{xA} = 0.15','\mu_{xA} = 0.3')
%     savePlot(gcf,['beta1Ct' str(k)],{'pdf'});
    
    figure (3+3*(k-1))
    xlabel(['\theta_' str(k) ' [?]']); ylabel('\beta_{1S} [?]');
    grid on
    hold on
    plot(r2d*(thetaeq(k)*unos(n2)+ thetaStep),r2d*beta1S(1,:,k),'-','LineWidth',2)
    plot(r2d*(thetaeq(k)*unos(n2)+ thetaStep),r2d*beta1S(2,:,k),'--','LineWidth',2)
    plot(r2d*(thetaeq(k)*unos(n2)+ thetaStep),r2d*beta1S(3,:,k),':','LineWidth',2)
    legend('\mu_{xA} = 0','\mu_{xA} = 0.15','\mu_{xA} = 0.3')
%     savePlot(gcf,['beta1St' str(k)],{'pdf'});
end

io = 1;
end


% Oscar added this local function becaouse we deleted the unos function from
% energy
function y  = unos(x,y)

y   = ones(size(x));

end
