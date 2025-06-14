function CP = energyTermsCalculation (CW,VOR,gammaT,lambdaI,kappa,fS,sigma,Cd0,K,kG)
%  energyTermsCalculation gives the value for each term of the energy
%    equation for the main rotor

CP      = zeros(1,4);

CP(1)   = - kappa*lambdaI.*CW*kG;
CP(2)   =   fS/2*(VOR).^3;
CP(3)   =   sigma*Cd0/8*(1+K*(VOR*cos(gammaT)).^2);
CP(4)   =   VOR*sin(gammaT)*CW;
