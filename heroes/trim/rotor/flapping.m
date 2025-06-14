function beta = flapping(theta,lambda,flightCondition,GA,muW,ndRotor)

%
%FIXME To be documented
%

mu      = flightCondition (1:3);
omegaAd = flightCondition (4:6);

[ABeta,ATheta,AOmega,VInd] = flappingMatricesTaper(lambda,mu,GA,muW,ndRotor);

%Calculation
ABetaInv = inv(ABeta);
beta = -ABetaInv*(ATheta*theta+AOmega*omegaAd+VInd);

end

