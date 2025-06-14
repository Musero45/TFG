function y = FuelSystemWeight(desreq, engine, weights)
%
% NDARC, NASA Design and Analysis of Rotorcraft (2009)
% Wayne Johnson
%  
% 19-7.3 - Fuel System (pages 157-158)
%
% Input and output variables expressed in International System 
%
% Initial version: Emory et al
% International System Version 
%      21/01/2014 Alejandro Redondo Moral alex.redondo.moral@gmail.com
%


% Dimensionless parameters
Neng = engine.numEngines;
chitank  = desreq.technologyFactors.tank;
chiplumb = desreq.technologyFactors.plumb;
K0plumb = desreq.options.K0plumb; 
K1plumb = desreq.options.K1plumb; 
fbt     = desreq.options.fballistict;
Nint   = desreq.estimations.Nint;
Nplumb = desreq.estimations.Nplumb;


% Dimensional parameters, International System (SI) 
Cint_SI = weights.Vf; % Internal fuel tank capacity (m^3)
F_SI = weights.fuelFlow; % Fuel (mass) flow rate (kg/s)

% Dimensional parameters, English units (ENG)
Cint_ENG = Cint_SI*219.9692; % imperial gallons (1 m^3 = 219.9692 imperial gallons)
F_ENG = F_SI*3600*2.2046; % lb/hour (1 kg = 2.2046 lb)

%--------------------------------------------------------------------------------------------------
% TANKS AND SUPPORT STRUCTURE
% Includes fuel tanks, bladders, supporting structure, filler caps,
% tank covers and filler material for void and ullage
%
% Nint: number of internal fuel tanks
% fcwb: 1.3131 for ballistically survivable (UTTAS/AAH level), 1.0 otherwise
% fbt : ballistic tolerance factor, 1.0-2.5%  
%--------------------------------------------------------------------------------------------------
if desreq.options.fcwb == true
    fcwb=1;
else
    fcwb=1.3131;
end

wtank = 0.4341*(Cint_ENG^0.7717)*(Nint^0.5897)*fcwb*(fbt^1.9491);
Wtank_ENG = chitank*wtank;

% -------------------------------------------------------------------------------------------------
% FUEL PLUMBING
% Includes fuel-system weight not covered by tank weight
%
% K0plumb = 120, plumbing weight, constant
% K1plumb = 3,   plumbing weight, constant
% Nplumb:	 total number of fuel tanks (internal and auxiliary) for plumbing
% Neng  :	 number of main engines
% -------------------------------------------------------------------------------------------------
wplumb = K0plumb + K1plumb*(0.01*Nplumb+0.06*Neng)*(F_ENG/Neng)^0.866;
Wplumb_ENG = chiplumb*wplumb;

% Conversion to SI
g = 9.81;
Wtank_SI = Wtank_ENG*0.4536*g; % Newtons
Wplumb_SI = Wplumb_ENG*0.4536*g; % Newtons

y = struct (...
    'Wtank', Wtank_SI,...
    'Wplumb', Wplumb_SI ...
);







