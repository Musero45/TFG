function y = getRandWeight (input)
%
% Rand - Weights and disc loading
% Page 303 & 312-313
%
% Input and output variables expressed in International System 
%
% Initial version: Emory et al
% International System Version 
%      20/01/2014 Lucia Sanchez: luchisan@gmail.com
%




MTOW = input.rand.MTOW;
Rg   = input.rand.Range;
Rgkm = Rg*1e-3;
Crew = input.rand.Crew;

g    = 9.81;
MTOW = MTOW/g;  %MTOW Kg

Wcrew=Crew*75;


% EMPTY WEIGHT
We=0.4854*(MTOW^1.015); % equation 29

% USEFUL LOAD
Wu=0.4709*(MTOW^0.99); % equation 30

% FUEL VALUE
Vf=0.0038*(MTOW^0.976)*(Rgkm^0.65); % equation 31 (In liters)

Wf=Vf*0.8;

Wpl=Wu-Wcrew-Wf;

% DISC LOADING
Dl=2.12*((MTOW^(1/3))-0.57); % equation 6

We=We*g;     %Weights in N
Wu=Wu*g;
Wf=Wf*g;
MTOW=MTOW*g;
Wcrew=Wcrew*g;
Wpl=Wpl*g;
Dl=Dl*g;
Vfm3 = Vf*1e-3;  %Volume in m^3

y = struct (...
    'emptyWeight', We,...
    'usefulLoad', Wu, ...
    'fuelValue', Wf,...
    'MTOW',MTOW,...
    'Wcrew',Wcrew,...
    'Wpl',Wpl,...
    'Vf',Vfm3,...
    'discLoading', Dl ...
);
