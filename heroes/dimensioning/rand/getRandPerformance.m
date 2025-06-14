function y = getRandPerformance (input)
%
% Rand - Performance
% Page 313-316
%
% Input and output variables expressed in International System 
%
% Initial version: Emory et al
% International System Version 
%      24/01/2014 Jose Maria Garcia jose.garcia.garrido@alumnos.upm.es
%
% En las correlaciones utilizadas por Rand en su articulo, expresa las
% velocidades en km/h, potencias en KW y masas en kg. Las entradas en esta
% funcion vienen expresadas en el sistema internacional.


g=9.8; %gravedad


MTOW = input.rand.MTOW;
MTOW=MTOW/g; %obtiene la masa del peso
Vm = input.rand.Vm;
Vm=Vm*3.6; %convierte m/s a km/h
Range=input.rand.Range; %no es necesario el cambio de unidad ya que no interviene 
% en operaciones, la salida es transparente a la entrada

% NEVER EXCEED SPEED
Vne=0.8215*(Vm^1.0565); % equation 32

% LONG RANGE SPEED AT SEA LEVEL
Vlr=0.5475*(Vm^1.0899); % equation 33

% MAXIMUN CONTINUOUS TOTAL POWER
Pmc=0.00126*(MTOW^0.9876)*(Vm^0.976); % equation 36

% MAXIMUN CONTINUOUS TRANSMISSION RATING
Tmc=0.000141*(MTOW^0.9771)*(Vm^1.3393); % equation 37

% TAKE-OFF TOTAL POWER 
Pto=0.0764*(MTOW^1.1455); % equation 34

% TAKE-OFF TRANSMISSION RATING
Tto=0.0366*(MTOW^1.2107); % equation 35

Vm=Vm/3.6; %convierte las salidas al sistema internacional m/s
Vne=Vne/3.6;  
Vlr=Vlr/3.6;
Pmc=Pmc*1000; %convierte a W
Tmc=Tmc*1000;
Pto=Pto*1000;
Tto=Tto*1000;



y = struct(...
    'neverEsceedSpeed', Vne,...
    'longRangeSpeedSeaLevel', Vlr,...
    'maximumContinuousTotalPower',Pmc,...
    'maximumContinuousTransmissionRating', Tmc,...
    'TakeOffTotalPower', Pto,...
    'VmaxSeaLevel',Vm,...
    'Range',Range,...
    'TakeOffTransmissionRating', Tto ...
);




