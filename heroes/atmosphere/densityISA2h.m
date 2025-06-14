function h = densityISA2h(atmosphereData,density)
%densityISA2h computes the value of the altitude as a function of air
%    density.
%
%   h = densityISA2h(atmosphereData,temperature) returns the altitude 
%   at an air density according to the data specified in the structure
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
g       = atmosphereData.g;
R_g     = atmosphereData.R_g;
alpha_T = atmosphereData.alpha_T;

%Values at sea level
T0 = atmosphereData.T0;
rho0    = atmosphereData.rho0;

%Density and temperature values in the tropopause:
T11     = atmosphereData.T11;
rho11   = atmosphereData.rho11;

h = zeros(size(density));
n = numel(density);
for j = 1:n
    if density(j) >= rho11
        %Density in the troposphere
        h(j) = ((density(j)/rho0)^(1/(-g/(R_g*alpha_T)-1))-1)*T0/alpha_T; 
    else
        %Density in the stratosphere
        h(j) = R_g*T11/(-g)*log(density(j)/rho11)+11000;
    end
end
