function F = isolatedRotorTrim (x,flightCondition,muWT,ndRotor,options)

ThetaA  = x(1);
PhiA    = x(2);
theta   = [x(3); x(4); x(5)];
CQ      = x(6);
beta    = [x(7); x(8); x(9)];
lambda  = [x(10); x(11); x(12)];
CT0     = x(13);

TAT = irTAT(ThetaA,PhiA);

muA  = TAT*[flightCondition(1); flightCondition(2); flightCondition(3)];
muWA = TAT*[muWT(1);muWT(2);muWT(3)];
GA   = TAT*[0; 0; 1];
omegaAdA = [0; 0; 0];

flightConditionA = [muA; omegaAdA];

CW = ndRotor.CW;
mrF = options.mrForces;
mrM = options.mrMoments;

%initialCondition = [0; 0; 0; -sqrt(CW/2); 0; 0; CW];
%system2solve = @(y) aeromechanics(y,theta,flightConditionA,GA,muWA,ndMR,varargin);
%y = nlSolver(system2solve,initialCondition);

%beta   = [y(1) y(2) y(3)];
%lambda = [y(4) y(5) y(6)];
[CFai, CFa0, ~, ~]                       = mrF(beta,theta,lambda,flightCondition,muWA,GA,ndRotor);
[CMFai, CMFa0, CMaEi, CMaE0, ~, ~, ~, ~] = mrM(beta,theta,lambda,flightCondition,muWA,GA,ndRotor);

CHA = CFai(1) + CFa0(1);
CYA = CFai(2) + CFa0(2);
% CTA = CFai(3);
CMaxA = CMFai(1) + CMaEi(1) + CMFa0(1) + CMaE0(1);
CMayA = CMFai(2) + CMaEi(2) + CMFa0(2) + CMaE0(2);
CMazA = CMFai(3) + CMaEi(3) + CMFa0(3) + CMaE0(3);

F(1)    = CHA + CW*sin(ThetaA);
F(2)    = CYA + CW*sin(PhiA)*cos(ThetaA);
F(3)    = CT0 - CW*cos(PhiA)*cos(ThetaA);
F(4)    = CMaxA;
F(5)    = CMayA;
F(6)    = CMazA + CQ;
F(7:15) = aeromechanics(x(7:15),theta,flightConditionA,GA,muWA,ndRotor,options);

end
