function F = aeromechanicsLin(x,theta,flightCondition,GA,muW,ndRotor,varargin)
%aeromechanicsLin Defines the nondimensional set of rotor aeromechanic 
%                 equations
%   F = aeromechanicsLin(X,THETA,FC,GA,muW,ndROTOR) returns the value of
%   the vector function F of the rotor aeromechanic equations for a given
%   vectors of unknowns X, a control vector of size 3x1 of collective, 
%   longitudinal and lateral pitch angles, THETA, a flight condition 
%   vector of size 6x1 of rotor hub translational and angular velocities,
%   the gravity acceleration unitary vector, GA, the vector of 
%   nondimensional atmospheric wind, muW, and the nondimensional rotor,
%   ndROTOR. The set of rotor aeromechanics equations vector F consists of
%   the following subsets of equations:
%       * F(1:3) are the linearized flapping equations which provide the
%       flapping coefficient vector, that is:
%       F(1:3)= beta + inv(A_beta)*(A_theta*theta + A_omega*omega + v);
%       For more information see chapter 5 of reference [1].
%       * F(4:6) are the equations for the three harmonic induced velocity 
%       coefficients, lambda0, lambda1C and lambda1S according to 
%       momentum theory.
%       * F(7:9) are the expressions of the three harmonic thrust
%       coeffients, CT0, CT1C and CT1S according to the Blade Element
%       Theory.
%
%   The vector of unknowns X is a column vector of size 9x1. The unknowns
%   are the following ones:
%       * X(1:3) are the three flapping coefficients, blade conning angle,
%       BETA0, longitudinal flapping angle, BETA1C, and lateral flapping 
%       angle, BETA1S, according to the harmonic decomposition
%       LAMBDA = BETA0 + BETA1C*COS(PSI) + BETA1S*SIN(PSI)
%       * X(4:6) are the three harmonic components of the harmonic induced
%       velocity field, according to the expression:
%       LAMBDA = LAMBDA0 + LAMBDA1C*COS(PSI) + LAMBDA1S*SIN(PSI)
%       * X(7:9) are the corresponding harmonic components of the thrust
%       coefficient, that is
%       CT = CT0 + CT1C*COS(PSI) + CT1S*SIN(PSI)
%
%   F = aeromechanicsLin(X,THETA,FC,GA,muW,ndROTOR,OPTIONS) computes as 
%   above with default options replaced by values set in OPTIONS. OPTIONS 
%   should be input in the form of sets of property value pairs. Default 
%   OPTIONS is a structure with the following fields and values:
%               niSolver: @qtrapz
%               umSolver: @fminsearch
%               nlSolver: @fsolve
%              odeSolver: @ode45
%          newmarkParams: [0.166666666666667 0.500000000000000]
%                 TolFun: 1.000000000000000e-12
%                   TolX: 1.000000000000000e-12
%                Display: 'off'
%                MaxIter: 400
%           linearInflow: @wakeEqs
%     uniformInflowModel: @Cuerva
%     armonicInflowModel: @Coleman
%               mrForces: @thrustF
%               trForces: @thrustF
%              mrMoments: @elasticM
%              trMoments: @aerodynamicM
%                fInterf: @noneInterf
%               trInterf: @noneInterf
%               vfInterf: @noneInterf
%             lHTPInterf: @noneInterf
%             rHTPInterf: @noneInterf
%                     GT: 1
%             inertialFM: 1
%      aeromechanicModel: @aeromechanicsLin
%            engineState: @EngineOn
%             IniTrimCon: []
%
%  Examples of usage
%
%  The next example show how to obtain thhe blade conning variation with 
%  altitude. First we load the rigidBo105 and define the required 
%  collective pitch for a given weight coefficient. Then we setup a 
%  variation of altitude from the sea level to 1000 meters. 
% 
%     atm               = getISA;
%     heRef             = rigidBo105(atm);
%     ndHeRef           = rigidHe2ndHe(heRef,atm,0);
%     ndRotorRef        = ndHeRef.mainRotor;
%     sigma             = ndRotorRef.sigma0;
%     cla               = ndRotorRef.cldata(1);
%     theta1            = ndRotorRef.theta1;
%     f_theta0          = @(CT) 6*CT/sigma/cla - 3*theta1/4 + 3/2*sqrt(CT/2);
% 
%     fC0               = zeros(6,1);
%     GA                = [0; 0; -1];
%     muW               = [0; 0; 0];
% 
%     n_z               = 11;
%     z_i               = linspace(0,1000,n_z);
%     rho_z             = atm.density(z_i);
%     beta0_z           = zeros(n_z,1);
%     CT_z              = zeros(n_z,1);
%     theta0_z          = zeros(n_z,1);
%     for i = 1:n_z
%         he_z              = heRef;
%         ndHe_z            = rigidHe2ndHe(he_z,atm,z(i));
%         ndRotor_z         = ndHe_z.mainRotor;
%         CT_z(i)           = ndRotor_z.CW;
%         theta0_z(i)       = f_theta0(CT_z(i));
%         theta_z           = [theta0_z(i); 0; 0];
%         s2s_z             = @(x) aeromechanicsLin(x,theta_z,fC0,GA,muW,ndRotor_z);
%         x0z               = [2*pi/180;  0; 0; ...
%                              -sqrt(CT_z(i)/2); 0; 0; ...
%                              CT_z(i); 0; 0];
%         x                 = fsolve(s2s_z,x0z);
%         beta0_z(i)        = x(1);
%     end
% 
%     figure(1)
%     plot(z_i,beta0_z*180/pi,'b-o'); hold on;
%     xlabel('z [m]'); ylabel('\beta [^o]'); grid on;
% 
%     figure(2)
%     plot(theta0_z*180/pi,beta0_z*180/pi,'b-o'); hold on;
%     xlabel('\theta_0 [^o]'); ylabel('\beta [^o]'); grid on;
% 
%     figure(3)
%     plot(CT_z,beta0_z*180/pi,'b-o'); hold on;
%     xlabel('C_T [-]'); ylabel('\beta [^o]'); grid on;
% 
%     figure(4)
%     plot(theta0_z*180/pi,CT_z,'b-o'); hold on;
%     xlabel('\theta_0 [^o]'); ylabel('C_T [-]'); grid on;
%
% 
%  See also setHeroesRigidOptions
%
%  References
%
%  [1] Alvaro Cuerva Tejero, Jose Luis Espino Granado, Oscar Lopez Garcia,
%  Jose Meseguer Ruiz, and Angel Sanz Andres. Teoria de los Helicopteros.
%  Serie de Ingenieria y Tecnologia Aeroespacial. Universidad Politecnica
%  de Madrid, 2008.
%
%  TODO LIST
%  * Add some examples of usage
%
%
options = parseOptions(varargin,@setHeroesRigidOptions);

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

betaIt = flapping(theta,lambda,flightCondition,GA,muW,ndRotor);

F(1) = beta0 - betaIt(1);
F(2) = beta1C - betaIt(2);
F(3) = beta1S - betaIt(3);


% % % Old nested functionality. Now linearInflow provides 3 eqs instead of
% % % the lambda solution
% % % 
% % % lambdaIt = linearInflow(CT,flightCondition,muW,beta,varargin);
% % % 
% % % F(4) = lambda0 - lambdaIt(1);
% % % F(5) = lambda1C - lambdaIt(2);
% % % F(6) = lambda1S - lambdaIt(3);

F(4:6) = linearInflow(lambda,CT,flightCondition,muW,beta,options);

CTIt = CTvector(beta,theta,lambda,flightCondition,muW,ndRotor);

F(7) = CT0 - CTIt(1);
F(8) = CT1C - CTIt(2);
F(9) = CT1S - CTIt(3);
end