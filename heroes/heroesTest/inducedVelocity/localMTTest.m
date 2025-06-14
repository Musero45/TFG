function io = localMTTest(mode)

%options     = setHeroesRigidOptions;


opt1       = {'uniformInflowModel',@Glauert,'armonicInflowModel',@none};
options1 = parseOptions(opt1,@setHeroesRigidOptions);

opt2       = {'uniformInflowModel',@Cuerva,'armonicInflowModel',@none};
options2 = parseOptions(opt1,@setHeroesRigidOptions);




atm     = getISA;
he      = rigidBo105(atm);
% % % % rho0    = atm.rho0;
% % % % g       = atm.g;
ndHe    = rigidHe2ndHe(he,atm,0);

options      = setHeroesRigidOptions; 
nlSolver     = options.nlSolver;

CT   = [ndHe.inertia.CW; 0; 0];
beta = [0; 0; 0];
muW  = [0; 0; 0];

alphaT = (-90:20:70)*pi/180;
betaT  = (-90:30:90)*pi/180;
mu     = 0:.05:.5;

n1 = length(alphaT);
n2 = length(betaT);
n3 = length(mu);
n = n1*n2*n3;

flightCondition = zeros(6,n3);

lambda1  = zeros(3,n);
lambda2 = zeros(3,n);
lambda3 = zeros(3,n);
lambda4 = zeros(3,n);

initialCondition = [-sqrt(CT(1)/2);0;0];

tic;
for i = 1:n1
    for j=1:n2
        flightCondition(3,:) = mu(:).*sin(alphaT(i));
        flightCondition(2,:) = mu(:).*cos(alphaT(i)).*sin(betaT(j));
        flightCondition(1,:) = mu(:).*cos(alphaT(i)).*cos(betaT(j));
        for k = 1:n3;
            index = k+n3*(j-1)+n3*n2*(i-1);

            f1 = @(lambda1) wakeEqs(lambda1,CT,flightCondition(:,k),muW,beta,options1);
            f2 = @(lambda2) LMTCuerva(lambda2,CT,flightCondition(:,k),muW,beta);
            f3 = @(lambda3) wakeEqs(lambda3,CT,flightCondition(:,k),muW,beta,options2);
            f4 = @(lambda4) LMTGlauert(lambda4,CT,flightCondition(:,k),muW,beta);
            lambda1(:,index) = nlSolver(f1,initialCondition,options);
            lambda2(:,index) = nlSolver(f2,initialCondition,options);
            lambda3(:,index) = nlSolver(f3,initialCondition,options);
            lambda4(:,index) = nlSolver(f4,initialCondition,options);
         end
    end
end
toc

rigidWakeC.lambda0  = lambda1(1,:);
rigidWakeC.lambda1C = lambda1(2,:);
rigidWakeC.lambda1S = lambda1(3,:);

localMTC.lambda0  = lambda2(1,:);
localMTC.lambda1C = lambda2(2,:);
localMTC.lambda1S = lambda2(3,:);

rigidWakeG.lambda0  = lambda3(1,:);
rigidWakeG.lambda1C = lambda3(2,:);
rigidWakeG.lambda1S = lambda3(3,:);

localMTG.lambda0  = lambda4(1,:);
localMTG.lambda1C = lambda4(2,:);
localMTG.lambda1S = lambda4(3,:);

% Computing error structures using checkError4s
err1 = checkError4s(rigidWakeG, localMTG,[],...
       'metric', 'mean', 'TOL', 1e-9,...
       'zvars',{'lambda0','lambda1C','lambda1S'});
err2 = checkError4s(rigidWakeC, localMTC,[], ...
       'metric', 'mean', 'TOL', 5e-3,...
       'zvars',{'lambda0','lambda1C','lambda1S'});

% 8/02/2016 contents of error structures:
% err1 = 
% 
%      lambda0: 1.6551e-12
%     lambda1C: 9.3948e-17
%     lambda1S: 9.3948e-17
% 
% err2 = 
% 
%      lambda0: 0.0038
%     lambda1C: 1.9472e-16
%     lambda1S: 1.9472e-16
%
io = 1;

end