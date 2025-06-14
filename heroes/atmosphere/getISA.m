function Atmosphere = getISA(varargin)
%ISAmodel establishes the International Standard Atmosphere.
%
%   Atmosphere = ISAmodel returns an structure containing
%   density, pressure, temperature, sound speed, their derivatives 
%   with respect to the altitude, their corresponding altitude inverse
%   functions and a null wind model. Atmosphere is by default an ISA+0
%   atmosphere.
%
%   Atmosphere = ISAmodel(value) understands that the model selected for 
%   the atmosphere is ISA+value.
%   
%   The folowing fields are available for a general ISA atmosphere:
%                  g: 9.8066
%               gama: 1.4000
%                R_g: 287.05287
%            alpha_T: -0.0065
%                 T0: 288.1500
%                 p0: 101325
%               rho0: 1.2252
%                 a0: 340.2626
%                T11: 216.6500
%              rho11: 0.3639
%                p11: 2.2626e+04
%                a11: 295.0695
%            density: @(h) densityISA(Atmosphere,h)
%           pressure: @(h) pressureISA(Atmosphere,h)
%        temperature: @(h) temperatureISA(Atmosphere,h)
%         soundSpeed: @(h) soundSpeedISA(Atmosphere,h)
%          d_density: @(h) d_densityISA(Atmosphere,h)
%         d_pressure: @(h) d_pressureISA(Atmosphere,h)
%      d_temperature: @(h) d_temperatureISA(Atmosphere,h)
%       d_soundSpeed: @(h) d_soundSpeedISA(Atmosphere,h)
%          density2h: @(density)     densityISA2h(Atmosphere,density)
%         pressure2h: @(pressure)    pressureISA2h(Atmosphere,pressure)
%      temperature2h: @(temperature) temperatureISA2h(Atmosphere,temperature)
%       soundSpeed2h: @(soundSpeed)  soundSpeedISA2h(Atmosphere,soundSpeed)
%         d2_density: @(h)d2_densityISA(Atmosphere,h)
%        d2_pressure: @(h)d2_pressureISA(Atmosphere,h)
%     d2_temperature: @(h)d2_temperatureISA(Atmosphere,h)
%      d2_soundSpeed: @(h)d2_soundSpeedISA(Atmosphere,h)
%               wind: @(h)0.0
%             d_wind: @(h)0.0 
%
%   The values used for the ISA model are:
%       Sea level values
%           temperature at sea level : 288.15+desvTemp   [K]
%           pressure at sea level    : 101325            [Pa]
% 
%       Air and atmosphere values
%           gama    : 1.4         C_p/C_v [-]
%           R_g     : 287.05287   [m^2/(s^2*K)]
%           alpha_T : -6.5e-3     dT/dh [K/m]
%
%       ISA uses an spherical Earth model with constant gravity. The value
%       for gravity is:
%           Gravity      : 9.80665          [m/s^2]
%
%   Examples of usage:
%   To load an ISA atmosphere and assign it to a variable, let us say at:
%   at=getISA;
%
%   To load an ISA+10 atmosphere and assign it to a variable, let us say at10:
%   at10=getISA(10);
%
%   Then both ISA atmospheres can be plotted together
%   atm={at,at10};
%   plotISA(atm,{'ISA+0','ISA+10'});
%
%




if isempty(varargin)
    desvTemp = 0;
else
    desvTemp = cell2mat(varargin);
end



%ISA model has his own values for the Earth model:
Atmosphere.g       = 9.80665;          %[m/s^2]

%Air and atmosphere values
Atmosphere.gama    = 1.4;               %C_p/C_v [-]
Atmosphere.R_g     = 287.05287;         %[m^2/(s^2K)]
Atmosphere.alpha_T = -6.5e-3;           %dT/dh [K/m]

%Sea level values
Atmosphere.T0      = 288.15+desvTemp;   %Temperature at sea level [K]
Atmosphere.p0      = 101325;            %Pressure at sea level [Pa]
Atmosphere.rho0    = Atmosphere.p0/(Atmosphere.R_g*Atmosphere.T0);
                                        %Density at sea level [kg/m^3]
Atmosphere.a0      = sqrt(Atmosphere.gama*Atmosphere.R_g*Atmosphere.T0);
                                        %Air sound speed at sea level [Pa]

% Dynamic viscosity at sea level
Atmosphere.mu0     = 1.7894e-5;

% Kinematic viscosity at sea level
Atmosphere.nu0     = Atmosphere.mu0/Atmosphere.rho0;

% Sutherland's constant for dynamic viscosity
Atmosphere.Ts      = 110;

%Atmosphere data structure
Atmosphere.T11     = Atmosphere.T0 + Atmosphere.alpha_T*11e3;
Atmosphere.rho11   = Atmosphere.rho0 *...
    (1+Atmosphere.alpha_T*11e3/Atmosphere.T0) ^...
    (-Atmosphere.g/(Atmosphere.R_g*Atmosphere.alpha_T)-1);
Atmosphere.p11     = Atmosphere.rho11*Atmosphere.R_g*Atmosphere.T11;
Atmosphere.a11     = sqrt(Atmosphere.gama*Atmosphere.R_g*Atmosphere.T11);
          
   
% ISA functions
Atmosphere.density            = @(h) densityISA(Atmosphere,h);
Atmosphere.pressure           = @(h) pressureISA(Atmosphere,h);
Atmosphere.temperature        = @(h) temperatureISA(Atmosphere,h);
Atmosphere.soundSpeed         = @(h) soundSpeedISA(Atmosphere,h);
Atmosphere.dynamicViscosity   = @(h) dynamicViscosityISA(Atmosphere,h);
Atmosphere.kinematicViscosity = @(h) kinematicViscosityISA(Atmosphere,h);

% Nondimensional ISA functions
Atmosphere.sigma              = @(h) sigmaISA(Atmosphere,h);
Atmosphere.delta              = @(h) deltaISA(Atmosphere,h);
Atmosphere.theta              = @(h) thetaISA(Atmosphere,h);

% First derivatives
Atmosphere.d_density          = @(h) d_densityISA(Atmosphere,h);
Atmosphere.d_pressure         = @(h) d_pressureISA(Atmosphere,h);
Atmosphere.d_temperature      = @(h) d_temperatureISA(Atmosphere,h);
Atmosphere.d_soundSpeed       = @(h) d_soundSpeedISA(Atmosphere,h);

% Inverse functions
Atmosphere.density2h     = @(density)     densityISA2h(Atmosphere,density);
Atmosphere.pressure2h    = @(pressure)    pressureISA2h(Atmosphere,pressure);
Atmosphere.temperature2h = @(temperature) temperatureISA2h(Atmosphere,temperature);
Atmosphere.soundSpeed2h  = @(soundSpeed)  soundSpeedISA2h(Atmosphere,soundSpeed);

% Second derivatives
Atmosphere.d2_density     = @(h) d2_densityISA(Atmosphere,h);
Atmosphere.d2_pressure    = @(h) d2_pressureISA(Atmosphere,h);
Atmosphere.d2_temperature = @(h) d2_temperatureISA(Atmosphere,h);
Atmosphere.d2_soundSpeed  = @(h) d2_soundSpeedISA(Atmosphere,h);

% By default ISA atmosphere is defined without wind model
Atmosphere.wind          = @(h)  zeros(size(h));
Atmosphere.d_wind        = @(h)  zeros(size(h));
