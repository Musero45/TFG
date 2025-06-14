function dynamicViscosity = dynamicViscosityISA(atmosphereData,h)
%dynamicViscosity computes the value of the air dynamic viscosity as a 
%   function of the altitude.
%
%   dynamicViscosity = dynamicViscosityISA(atmosphereData,h) returns the 
%   dynamic viscosity at an altitude according to the data specified 
%   in the structure atmosphereData.
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
%       mu0        : Dynamic viscosity at sea level [kg/(m s)]
%       T11        : Temperature at tropopause [K]
%       p11        : Pressure at tropopause [Pa]
%       rho11      : Density at tropopause [kg/m^3]
%       Ts         : Sutherland's constant for dynamic viscosity [K]
% 
%   The dynamic viscosity dependence with altitude comes from the reference
%   Advanced Aircraft Design: Conceptual Design, Analysis and 
%   Optimization of Subsonic Civil Airplanes, First Edition. 
%   Egbert Torenbeek. Published 2013 by John Wiley & Sons, Ltd

%Atmosphere and Earth data:
alpha_T = atmosphereData.alpha_T;

% Sutherland constant
Ts      = atmosphereData.Ts;

%Values at sea level
T0      = atmosphereData.T0;
T11     = atmosphereData.T11;
mu0     = atmosphereData.mu0;

dynamicViscosity = zeros(size(h));
n           = numel(h);
for j = 1:n
    if h(j) <= 11000
        %Temperature in the troposphere
        T = T0+alpha_T*h(j);
    else
        %Temperature in the stratosphere
        T = T11; 
    end
    dynamicViscosity(j) = mu0.*((T./T0).^(3/2)).*(T0 + Ts)./(T + Ts);
end
