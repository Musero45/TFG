function h = pressureISA2h(atmosphereData,pressure)
%pressureISA2h computes the value of thealtitude as a function of air
%   pressure.
%
%   h = pressureISA2h(atmosphereData,h) returns the altitude at an air
%   pressure according to the data specified in the structure atmosphereData.
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

h = zeros(size(pressure));
n = numel(pressure);
for j = 1:n
    if pressure(j) >= p11
        %Pressure in the troposphere
        h(j) = T0/alpha_T*((pressure(j)/p0)^(1/(-g/(R_g*alpha_T)))-1); 
    else
        %Pressure in the stratosphere
        h(j) = R_g*T11/(-g)*log(pressure(j)/p11)+11000;
    end
end
