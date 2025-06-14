function F = aeromechanicsNL(x,theta,fc,GA,muW,ndRotor,varargin)

options = parseOptions(varargin,@setHeroesRigidOptions);

b = ndRotor.b;

linearInflow = options.linearInflow;

beta0    = x(1);
beta1C   = x(2);
beta1S   = x(3);
% lambda0  = x(4);
% lambda1C = x(5);
% lambda1S = x(6);
CT0      = x(7);
CT1C     = x(8);
CT1S     = x(9);

beta   = x(1:3);
lambda = x(4:6);
CT     = x(7:9);


%=========================================================================
% Old linear/analytic
%-------------------------------------------------------------------------

%betaIt = flapping(theta,lambda,flightCondition,GA,muW,ndRotor);

%F(1) = beta0 - betaIt(1);
%F(2) = beta1C - betaIt(2);
%F(3) = beta1S - betaIt(3);

%=========================================================================


%=========================================================================
% New non linear/non analytic
%-------------------------------------------------------------------------

zeta = [0;0;0];

Out = basicAeroStateNL(beta,theta,zeta,lambda,fc,muW,ndRotor);

vaerad    = Out.vaerad;
dFab      = Out.dFab;
harmFunct = Out.harmFunct;

[CMaEb0yA1,CMaEb1CyA1,CMaEb1SyA1] = getFourierCMaEbyA1(vaerad,dFab,harmFunct,ndRotor);

[irgxA1, irgyA1, irgzA1] = basicIrgStateNL(beta,theta,zeta,fc,GA,ndRotor);

[irg0yA1,irg1CyA1,irg1SyA1] = getFourierIrgyA1(irgyA1,ndRotor);

F(1) = CMaEb0yA1  + irg0yA1;
F(2) = CMaEb1CyA1 + irg1CyA1;
F(3) = CMaEb1SyA1 + irg1SyA1;

%=========================================================================

% % % Old nested functionality. Now linearInflow provides 3 eqs instead of
% % % the lambda solution
% % % 
% % % lambdaIt = linearInflow(CT,flightCondition,muW,beta,varargin);
% % % 
% % % F(4) = lambda0 - lambdaIt(1);
% % % F(5) = lambda1C - lambdaIt(2);
% % % F(6) = lambda1S - lambdaIt(3);

F(4:6) = linearInflow(lambda,CT,fc,muW,beta,options);

%=========================================================================
%Old linear/analytic
%-------------------------------------------------------------------------

%CTIt = CTvector(beta,theta,lambda,flightCondition,muW,ndRotor);

%F(7) = CT0 - CTIt(1);
%F(8) = CT1C - CTIt(2);
%F(9) = CT1S - CTIt(3); old LINEAR

%=========================================================================

%=========================================================================
% New non linear/non analytic
%-------------------------------------------------------------------------

[CTb0,CTb1C,CTb1S] = getFourierCTb(vaerad,dFab,harmFunct,ndRotor);

CT0obj  = b*CTb0; % b multiplica directamente, pero posición de c/pala?
CT1Cobj = b*CTb1C;
CT1Sobj = b*CTb1S;

F(7) = CT0 - CT0obj;
F(8) = CT1C - CT1Cobj;
F(9) = CT1S - CT1Sobj;

%=========================================================================


end