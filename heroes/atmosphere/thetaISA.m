function theta = thetaISA(atmosphereData,h)
%thetaISA computes the value of the air temperature ratio to sea level 
%         temperature as a function of altitude.
%
%   theta = thetaISA(atmosphereData,h) returns the temperature ratio to sea
%   level temperature at an altitude according to the data specified in 
%   the structure atmosphereData.
%
%   atmosphereData is an structure that must contain at least the following
%   fields:
%       g          : Gravity [m/s^2]
%       gama       : C_p/C_v [-]
%       R_g        : [m^2/(s^2K)]
%       alpha_T    : dT/dh [K/m]
%       T0         : Temperature at sea level [K]
%       p0         : Pressure at sea level [Pa]
%       rho0       : Density at sea level [kg/m^3]
%       T11        : Temperature at tropopause [K]
%       p11        : Pressure at tropopause [Pa]
%       rho11      : Density at tropopause [kg/m^3]



%Atmosphere and Earth data:
alpha_T = atmosphereData.alpha_T;

%Values at sea level
T0      = atmosphereData.T0;
T11     = atmosphereData.T11;

theta   = zeros(size(h));
n       = numel(h);
for j = 1:n
    if h(j) <= 11000
        %Temperature in the troposphere
        theta(j) = 1.0 + alpha_T*h(j)./T0; 
    else
        %Temperature in the stratosphere
        theta(j) = T11./T0; 
    end
end
