function y = getRandMainRotor(input)
% Rand - Main rotor parameters
% Page 304-305
%
% Input and output variables expressed in International System 
%
% Initial version: Emory et al
% International System Version 
%      26/01/2014 Sergio Fernandez sergio.fernandezr@alumnos.upm.es
%
 
MTOW = input.rand.MTOW;
Vm = input.rand.Vm;
b = input.rand.b;
%The inputs go in SI and RAND's model uses Km/h and Kg
Vm=Vm*3600/1000;
MTOW=MTOW/9.81;

% MAIN ROTOR DIAMETER
D = 9.133*(MTOW^0.380)/(Vm^0.515); % equation 9 

% MAIN ROTOR RADIUS
R = D/2; 

% MAIN ROTOR CHORD
c = 0.0108*(MTOW^0.539)/(b^0.714); % equation 10

% MAIN ROTOR TIP SPEED
Vt = 140*(D^0.171); % equation 11

% MAIN ROTOR ANGULAR VELOCITY
OmegaRPM = 2673/(D^0.829); % equation 12, angular velocity in RPM
OmegaRAD = 280/(D^0.829); % equation 12, angular velocity in rad/s

% MAIN ROTOR SOLIDITY
sigma=(b*c)/(pi*(D/2));

y = struct(...
    'D',D,  ...
    'R',R, ...
    'c',c,  ...
    'Vt',Vt, ...
    'OmegaRPM',OmegaRPM, ...
    'OmegaRAD',OmegaRAD,...
    'b',b,...
    'sigma',sigma ...
);
