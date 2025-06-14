function FM = qfdHoverEfficiency(he,MissionSegments,atm)
% QFDHOVEREFFICIENCY select here the function to calculate hoverEfficiency

% Set Altitude
h  = 0;

% Variables to non Adimentional helicopter
W          = he.Weights.MTOW;
rho        = atm.density(h);
R          = he.MainRotor.R;
S          = pi*R^2;
OmegaRAD   = he.MainRotor.OmegaRAD;

% Weight coeficient
Cw = W / (rho*S*(OmegaRAD*R)^2);

% Hover hypothesis
Ct = Cw; 

% FM calculation
FM = getHoverFM(he,Ct);