function io = hoverFlappingTest(mode)

options  = setHeroesRigidOptions;
opt1     = {'linearInflow',@wakeEqs,'uniformInflowModel',@Glauert,'armonicInflowModel',@none};
options1 = parseOptions(opt1,@setHeroesRigidOptions);
aeromechanicModel = options.aeromechanicModel;

atm     = getISA;
he      = rigidBo105(atm);
%he.mainRotor.kBeta = 0;
% % % % % % % % % % rho0    = atm.rho0;
% % % % % % % % % % g       = atm.g;

ndHe    = rigidHe2ndHe(he,atm,0);
ndRotor = ndHe.mainRotor;

ndRotor.theta1 = 0;
ndRotor.aG     = 0; %Gravitational forces neglected
%ndRotor.ead    = 0;

muW     = [0; 0; 0];
GA      = [0; 0; -1];
flightCondition = [0; 0; 0; 0; 0; 0]; % [mu; omegaAd]

theta0  = (5:1:25)*pi/180;
theta1C = (-10:1:10)*pi/180;
theta1S = (-10:1:10)*pi/180;

n1 = length(theta0);
n2 = length(theta1C);
n3 = length(theta1S);

n = n1*n2*n3;

beta0     = zeros(n,1);
beta1C    = zeros(n,1);
beta1S    = zeros(n,1);
lambdai   = zeros(n,1);
beta02    = zeros(n,1);
beta1C2   = zeros(n,1);
beta1S2   = zeros(n,1);
lambdai2  = zeros(n,1);

nlSolver  = options.nlSolver;

tic;
for i = 1:n1;
    for j =1:n2;
        for k = 1:n3
            theta = [theta0(i); theta1C(j); theta1S(k)];
            [beta2,lambdai0] = hoverFlapping(theta,ndRotor); %Red book model
            initialCondition = [beta2; lambdai0; 0; 0; 2*lambdai0^2; 0; 0]; %Initial condition near solution (for speed)
            system2solve = @(x) aeromechanicModel(x,theta,flightCondition,GA,muW,ndRotor,options1);
            x = nlSolver(system2solve,initialCondition);
            index = k+n3*(j-1)+n3*n2*(i-1); %complete grid to (n,1) vector
            beta0 (index)    = x(1);
            beta1C (index)   = x(2);
            beta1S (index)   = x(3);
            lambdai (index)  = x(4);
            beta02 (index)   = beta2(1);
            beta1C2 (index)  = beta2(2);
            beta1S2 (index)  = beta2(3);
            lambdai2 (index) = lambdai0;
        end
    end
end
toc

%result structures in order to run checkError4s
redBook.beta0   = beta02;
redBook.beta1C  = beta1C2;
redBook.beta1S  = beta1S2;
redBook.lambdai = lambdai2;
heroes.beta0    = beta0 ;
heroes.beta1C   = beta1C;
heroes.beta1S   = beta1S;
heroes.lambdai  = lambdai;

% Computing error structures using checkError4s
err = checkError4s(heroes, redBook,[],...
      'metric', 'mean', 'TOL', 1e-10,...
      'zvars',{'beta0','beta1C','beta1S','lambdai'});

% 8/02/2016 contents of error structures:
% 
% err = 
% 
%       beta0: 1.2033e-17
%      beta1C: 8.9957e-18
%      beta1S: 6.3720e-18
%     lambdai: 3.9561e-18
% 

io = 1;
end