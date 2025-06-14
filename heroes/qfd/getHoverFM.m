function FM = getHoverFM(stathehe,Ct)
% FM calculation using a stathelicopter

kappa = stathehe.energyEstimations.kappa;
sigma = stathehe.MainRotor.sigma;
cd0 = stathehe.energyEstimations.cd0;

Piid = Ct*sqrt(Ct/2);
Pi   = Piid*kappa;
P0   = sigma*cd0/8;

FM = Piid/(Pi+P0);

end