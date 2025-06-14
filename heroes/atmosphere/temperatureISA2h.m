function h = temperatureISA2h(atmosphereData,temperature)
%temperatureISA2h computes the value of the altitude as a function of
%    temperature.
%
%   h = temperatureISA(atmosphereData,temperature) returns the altitude 
%   at an air temperature according to the data specified in the structure
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

h = zeros(size(temperature));
n = numel(temperature);
for j = 1:n
    if temperature(j) >= T11
        %Temperature in the troposphere
        h(j) = (temperature(j)-T0)/alpha_T; 
    else
        %Temperature in the stratosphere
        warning(['The aircraft is in the stratosphere. Altitude can not be'...
                 'determined. Try to calculate altitude using other variables,'...
                 'like density or pressure.'])
        h(j) = 11e3; 
    end
end
