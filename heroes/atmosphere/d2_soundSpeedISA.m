function d2_soundSpeed = d2_soundSpeedISA(atmosphereData,h)
%d2_soundSpeedISA computes the 2nd derivative of the air sound speed 
%  with respect to altitude as a function of altitude.
%
%   d2_soundSpeed = d2_soundSpeedISA(atmosphereData,h) returns the 2nd
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



% Due to the fact that ISA atmosphere implies a linear gradient of
% temperature the second derivative is zero
d2_soundSpeed = zeros(size(h));
