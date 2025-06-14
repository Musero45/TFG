function ndFlightCondition = fc2ndFC(flightCondition,he,atmosphere)

if iscell(he)
    % Dimensions of the output ndHe
    n                 = numel(he);
    s                 = size(he);
    ndFlightCondition = cell(s);

    % Loop using linear indexing
    for i = 1:n
        ndFlightCondition{i}    = fci2ndFCi(flightCondition,he{i},atmosphere);
    end

else
    ndFlightCondition    = fci2ndFCi(flightCondition,he,atmosphere);
end


function ndFlightCondition  = fci2ndFCi(flightCondition,he,atmosphere)

% Flight condition properties
V      = flightCondition.V;
gammaT = flightCondition.gammaT;
Vh     = flightCondition.Vh;
Vv     = flightCondition.Vv;
H      = flightCondition.H;
GW     = flightCondition.GW;
Omega  = flightCondition.Omega;
Z      = flightCondition.Z;
P      = flightCondition.P;

% helicopter properties
R      = he.mainRotor.R;
OmegaN = he.mainRotor.Omega;
S      = pi*R^2;

% Atmosphere properties
rho0   = atmosphere.rho0;
p0     = atmosphere.p0;
T0     = atmosphere.T0;
fRho   = atmosphere.density;
fP     = atmosphere.pressure;
fT     = atmosphere.temperature;

% Evaluate density, pressure and temperature for flight condition altitude
density = fRho(H);
pressure = fP(H);
temperature = fT(H);

% S      = pi*he.mainRotor.R.^2; % FIXME
% FIXME power unit implies that atmosphere should be an input of the
% function
ORFC   = Omega.*R;
TuFC   = density.*S.*ORFC.^2;
PuFC   = density.*S.*ORFC.^3;
% % % % % % % TuFC   = TuHE.*(omega).^2;
% % % % % % % PuFC   = PuHE.*(omega).^3;



% Nodimensional outputs
VOR      = V./ORFC;
VhOR     = Vh./ORFC;
VvOR     = Vv./ORFC;
sigmaISA = density./rho0;
deltaISA = pressure./p0;
thetaISA = temperature./T0;
CW       = GW./TuFC;
omega    = Omega./OmegaN;
CP       = P./PuFC;
Z_nd     = Z./R;

ndFlightCondition = struct(...
                    'VOR',VOR,...
                    'gammaT',gammaT,...
                    'VhOR',VhOR,...
                    'VvOR',VvOR,...
                    'sigmaISA',sigmaISA,...
                    'deltaISA',deltaISA,...
                    'thetaISA',thetaISA,...
                    'CW',CW,...
                    'omega',omega,...
                    'CP',CP,...
                    'Z_nd',Z_nd ...
);
