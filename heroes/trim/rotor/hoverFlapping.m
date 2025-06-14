function [beta,lambdai0] = hoverFlapping(theta,ndRotor)

sigma = ndRotor.sigma0;
a     = ndRotor.cldata(1);
ead   = ndRotor.ead;
gamma = ndRotor.gamma;
Sbeta = ndRotor.SBeta;

theta0  = theta(1);
theta1C = theta(2);
theta1S = theta(3);

lambdaBeta2 = 1+gamma*Sbeta/8;

% Original expansions to O(4) e/R
% alphaBeta = gamma/8*(1-4/3*ead+1/3*ead^4);
% deltaBeta = gamma/8*(-4/3+2*ead-2/3*ead^3);
% etaBeta   = gamma/8*(1-8/3*ead+2*ead^2-1/3*ead^4);

% Expansions to O(1) as considered in heroesFlapping
alphaBeta = gamma/8*(1-4/3*ead);
% deltaBeta = gamma/8*(-4/3+2*ead);
etaBeta   = gamma/8*(1-8/3*ead);

deltaBeta = gamma/8*(-4/3); % Independent flapping vector e/R term is O(0) e/R FIXME?


lambdai0  = 1/16*(sigma*a-sqrt((sigma*a)^2+64/3*sigma*a*theta0));

beta0  = 1/lambdaBeta2*(alphaBeta*theta0-deltaBeta*lambdai0);
beta1C = alphaBeta/((lambdaBeta2-1)^2+etaBeta^2)*((lambdaBeta2-1)*theta1C-etaBeta*theta1S);
beta1S = alphaBeta/((lambdaBeta2-1)^2+etaBeta^2)*(etaBeta*theta1C+(lambdaBeta2-1)*theta1S);

beta = [beta0; beta1C; beta1S];