function h = soundSpeedISA2h(atmosphereData,soundSpeed)
%soundSpeedISA2h computes the value of the altitude a function of air
%   sound speed.
%
%   h = soundSpeedISA2h(atmosphereData,h) returns the altitude at an air
%   spund speed according to the data specified in the structure
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
gama    = atmosphereData.gama;
R_g     = atmosphereData.R_g;

temperature = soundSpeed.^2/gama/R_g;
h           = temperatureISA2h(atmosphereData,temperature);




