function y=getRandTailRotor(input)
% Rand - Tail rotor parameters
% Page 306-308
%
% Input and output variables expressed in International System 
%
% Initial version: Emory et al
% International System Version 
%      11/03/2014 Ivan Marquez i.marquez@alumnos.upm.es
%

MTOW=input.rand.MTOW; %[N]
btr=input.rand.btr;
kgf2N=9.81;
 
% MTOW [N]->[Kg]
MTOW=MTOW/kgf2N;
 
% TAIL ROTOR DIAMETER
Dtr=0.0886*(MTOW^0.393); % equation 15

% TAIL ROTOR RADIUS
Rtr=Dtr/2; 

% TAIL ROTOR CHORD
ctr=0.0058*(MTOW^0.506)/(btr^0.720); % equation 21

% TAIL ROTOR TIP SPEED
Vttr= 182*(Dtr^0.172); % equation 19

% TAIL ROTOR ANGULAR VELOCITY
OmegatrRPM=3475/(Dtr^0.828); % equation 20, angular velocity in RPM
OmegatrRAD=364/(Dtr^0.828); % equation 20, angular velocity in rad/s

% TAIL ROTOR SOLIDITY
sigmatr=(btr*ctr)/(pi*(Dtr/2));


y=struct(...
     'D',Dtr,...
     'R',Rtr,...
     'c',ctr,...
     'Vt',Vttr,...
     'OmegaRPM',OmegatrRPM,...
     'OmegaRAD',OmegatrRAD,...
     'b',btr,...
     'sigma',sigmatr ...
);
