function d_density = d_densityISA(atmosphereData,h)
%d_densityISA computes the derivative of the air density respect to 
%   altitude as a function of altitude.
%
%   d_density = d_densityISA(atmosphereData,h) returns the derivative of 
%   the air density respect to altitude at an altitude according to the 
%   data specified in the structure atmosphereData.
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
T0 = atmosphereData.T0;
rho0   = atmosphereData.rho0;

%Density and temperature values in the tropopause:
T11 = atmosphereData.T11;
rho11   = atmosphereData.rho11;

d_density = zeros(size(h));
n         = numel(h);
for j = 1:n
    if h(j) <= 11000
        %Derivative in the troposphere
        d_density(j) = rho0 * (-g/(R_g*alpha_T)-1) * alpha_T/T0 *...
            (1+alpha_T*h(j)/T0) ^ (-g/(R_g*alpha_T)-2); 
    else
        %Derivative in the stratosphere
        d_density(j) = rho11 * (-g/(R_g*T11)) *...
            exp(-g*(h(j)-11000)/(R_g*T11)); 
    end
end
