function d_temperature = d_temperatureISA(atmosphereData,h)
%d_temperatureISA computes the derivative of the air temperature respect to 
%   altitude as a function of altitude.
%
%   d_temperature = d_temperatureISA(atmosphereData,h) returns the 
%   derivative of the air temperature respect to altitude at an altitude 
%   according to the data specified in the structure atmosphereData.
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

d_temperature = zeros(size(h));
n             = numel(h);
for j = 1:n
    if h(j) <= 11000
        %Derivative in the troposphere
        d_temperature(j) = alpha_T; 
    else
        %Derivative in the stratosphere
        d_temperature(j) = 0; 
    end
end
