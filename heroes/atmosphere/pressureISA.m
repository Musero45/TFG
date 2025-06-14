function pressure = pressureISA(atmosphereData,h)
%pressureISA computes the value of the air pressure as a function of altitude.
%
%   pressure = pressureISA(atmosphereData,h) returns the pressure at an
%   altitude according to the data specified in the structure atmosphereData.
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
g       = atmosphereData.g;
R_g     = atmosphereData.R_g;
alpha_T = atmosphereData.alpha_T;

%Values at sea level
T0      = atmosphereData.T0;
p0      = atmosphereData.p0;

%Density and temperature values in the tropopause:
T11     = atmosphereData.T11;
p11     = atmosphereData.p11;

pressure = zeros(size(h));
n        = numel(h);
for j = 1:n
    if h(j) <= 11000
        %Pressure in the troposphere
        pressure(j) = p0 * (1+alpha_T*h(j)/T0) ^ (-g/(R_g*alpha_T)); 
    else
        %Pressure in the stratosphere
        pressure(j) = p11 * exp(-g*(h(j)-11000)/(R_g*T11)); 
    end
end
