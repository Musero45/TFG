function d2_pressure = d2_pressureISA(atmosphereData,h)
%d_pressureISA computes the 2nd derivative of the air pressure 
%   with respect to altitude as a function of altitude.
%
%   d2_pressure = d2_pressureISA(atmosphereData,h) returns the 2nd derivative of 
%   the air pressure respect to altitude at an altitude according to the 
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
T0     = atmosphereData.T0;
p0     = atmosphereData.p0;

%Density and temperature values in the tropopause:
T11    = atmosphereData.T11;
p11    = atmosphereData.p11;

d2_pressure = zeros(size(h));
n           = numel(h);
for j = 1:n
    if h(j) <= 11000
        %Derivative in the troposphere
        d2_pressure(j) = p0*(-g/(R_g*alpha_T))*(-g/(R_g*alpha_T) -1) ...
                          *(alpha_T/T0)^2*(1+alpha_T*h(j)/T0)^ ...
                          (-g/(R_g*alpha_T)-2); 
    else
        %Derivative in the stratosphere
        d2_pressure(j) = p11*(-g/(R_g*T11))^2*...
                           exp(-g*(h(j)-11000)/(R_g*T11)); 
    end
end
