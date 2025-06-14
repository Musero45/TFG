function kinematicViscosity = kinematicViscosityISA(atmosphereData,h)
%kinematicViscosity computes the value of the air dynamic viscosity as a 
%   function of the altitude.
%
%   kinematicViscosity = kinematicViscosityISA(atmosphereData,h) returns the 
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


mu                  = dynamicViscosityISA(atmosphereData,h);
rho                 = densityISA(atmosphereData,h);
kinematicViscosity  = mu./rho;
