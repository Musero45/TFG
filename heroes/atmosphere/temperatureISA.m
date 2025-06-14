function temperature = temperatureISA(atmosphereData,h)
%temperatureISA computes the value of the air temperature as a function of
%   altitude.
%
%   temperature = temperatureISA(atmosphereData,h) returns the temperature 
%   at an altitude according to the data specified in the structure
%   atmosphereData.
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

temperature = zeros(size(h));
n           = numel(h);
for j = 1:n
    if h(j) <= 11000
        %Temperature in the troposphere
        temperature(j) = T0+alpha_T*h(j); 
    else
        %Temperature in the stratosphere
        temperature(j) = T11; 
    end
end
