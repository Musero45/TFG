function d_soundSpeed = d_soundSpeedISA(atmosphereData,h)
%d_soundSpeedISA computes the derivative of the air sound speed respect to 
%   altitude as a function of altitude.
%
%   d_soundSpeed = d_soundSpeedISA(atmosphereData,h) returns the 
%   derivative of the air sound speed respect to altitude at an altitude 
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



%Atmosphere data:
gama    = atmosphereData.gama;
R_g     = atmosphereData.R_g;

temperature   = temperatureISA(atmosphereData,h);
d_temperature = d_temperatureISA(atmosphereData,h);
d_soundSpeed  = 0.5./sqrt(gama*R_g*temperature).*gama.*R_g.*d_temperature;
