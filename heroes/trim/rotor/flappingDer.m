function [controlDer,dumpDer] = flappingDer(lambda,mu,GA,muW,ndRotor,varargin)
%flappingDer Computes the flapping derivatives of a nondimensional rotor
%
%   [dBdT,dBdw] = flappingDer(LAMBDA,MU,GA,ndROTOR) returns the value of
%   the control derivative vector dBdT and the damping derivatives dBdw
%   as a function of the induced velocity vector, LAMBDA, the
%   nondimensional forward velocity vector, MU, the gravity acceleration 
%   unitary vector, GA, and the nondimensiona rotor, ndROTOR. The control
%   derivative vector dBdT is a 4x1 vector such as
%   dBdT(1) = d_beta1C/d_theta1C
%   dBdT(2) = d_beta1C/d_theta1S
%   dBdT(3) = d_beta1S/d_theta1C
%   dBdT(4) = d_beta1S/d_theta1S
%
%   and the damping derivative vector dBdw is a 6x1 vector such as
%   dBdw(1) = d_beta1C/d_omegax
%   dBdw(2) = d_beta1C/d_omegay
%   dBdw(3) = d_beta1C/d_omegaz
%   dBdw(4) = d_beta1S/d_omegax
%   dBdw(5) = d_beta1S/d_omegay
%   dBdw(6) = d_beta1S/d_omegaz
%
%   The induced velocity vector LAMBDA is [lambda_i0; lambda_1C; lambda_1S]
%   and the nondimensional forward velocity vector MU is
%   [mu_xA,mu_yA,mu_zA].
%
%   See also aeromechanicsLin
%
%   Examples of usage
%
%   References
%
%   [1] Alvaro Cuerva Tejero, Jose Luis Espino Granado, Oscar Lopez Garcia,
%   Jose Meseguer Ruiz, and Angel Sanz Andres. Teoria de los Helicopteros.
%   Serie de Ingenieria y Tecnologia Aeroespacial. Universidad Politecnica
%   de Madrid, 2008.
%
%   TODO LIST
%   * Add some examples of usage
%


[ABeta,ATheta,AOmega] = flappingMatricesTaper(lambda,mu,GA,muW,ndRotor);

%Calculation
ABetaInv = inv(ABeta);
betaTheta = -ABetaInv*ATheta;
betaOmega = -ABetaInv*AOmega;

db1ct1c = betaTheta(2,2);
db1ct1s = betaTheta(2,3);
db1st1c = betaTheta(3,2);
db1st1s = betaTheta(3,3);

db1cox = betaOmega(2,1);
db1coy = betaOmega(2,2);
db1coz = betaOmega(2,3);
db1sox = betaOmega(3,1);
db1soy = betaOmega(3,2);
db1soz = betaOmega(3,3);

controlDer = [db1ct1c; db1ct1s; db1st1c; db1st1s];
dumpDer = [db1cox; db1coy; db1coz; db1sox; db1soy; db1soz];
end