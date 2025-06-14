function heOut = addCharacteristic2he(heIn,atmosphere)

% First a copy of the helicopter data to safely changed it
heOut = heIn;

% density function handle
density  = atmosphere.density;

% Main rotor
mr       = heIn.mainRotor;
[area,OR,Tu,Pu] = getRotorCharacteristic(mr,density);


% Tail rotor
tr       = heIn.tailRotor;
[area_tr,OR_tr,Tu_tr,Pu_tr] = getRotorCharacteristic(tr,density);

% characteristic values
c        = struct(...
           'S',area,...
           'OR',OR,...
           'Tu',Tu, ...
           'Pu',Pu,...
           'S_tr',area_tr,...
           'OR_tr',OR_tr,...
           'Tu_tr',Tu_tr, ...
           'Pu_tr',Pu_tr,...
           'class','characteristic'...
);

heOut.characteristic = c;




function [area,OR,Tu,Pu] = getRotorCharacteristic(rotor,density)

% Dimensional variables
Omega    = rotor.Omega;
R        = rotor.R;
area     = pi*R^2;
OR       = Omega*R;
Tu       = @(h) density(h).*area.*OR.^2;
Pu       = @(h) density(h).*area.*OR.^3;
