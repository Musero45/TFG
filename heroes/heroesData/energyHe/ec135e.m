function energyHe = ec135e(atmosphere)
% Eurocopter EC 135T2 from The Official Helicopter Blue Book pages 183-184
%'A significant amount of internet research revealed that the EC-135 
%was derived from the BO-105 helicopter. A rich collection of available 
%engineering information for the BO-105 allowed the values found to be used 
%instead of reverse engineered calculation values using the equations of motion 
%for a first-pass iteration of the EC-135 moments of inertia at OEW.'

% Helicopter definition

label = 'EC_135';


% main rotor definition

mainRotor = struct(...
            'class','rotor',...
            'id',label,...
            'eta',0.2,... %!!!
            'R',5.1,...%BlueBook 
            'b',4,...%BlueBook
            'cldata',[6.11 0],... %Padfield(Bo105)
            'cddata',[0.0074 0.0 38.66],... %Padfield(Bo105)
            'profile',@cl1cd2,... %!!!
            'Omega',41.3725,... %Bluebook 
            'c',0.3, ... %BlueBook 
            'kappa',1.15,... %!!! 
            'K',5,...%!!!
            'cd0',0.013...%!!!
);

% engine definition
numEng  = 2;
engine = Arrius_2B2(atmosphere,numEng);

n              = engine.powerExponent;
Pmu            = numEng*1400e3;%!!!
engine.Pmu     = Pmu;
engine.fPmu    = @(h) engPower(h,Pmu,n,atmosphere.density);

 
% tail rotor definition
tailRotor = struct(...
            'class','rotor',...
            'id',label,...
            'eta',0.2,... %!!!
            'R',0.5,... %BlueBook
            'b',10,... %(number of blades)Bluebook
            'cldata',[5.7 0],...%Padfield(Bo105)
            'cddata',[0.008 0.0 9.5],...%Padfield(Bo105)
            'Omega',376,... %Bluebook
            'c',0.05, ...%Kampa1999
            'kappa',1.1,...%!!!
            'K',3,... %!!!
            'cd0', 0.01... %!!!
);


% fuselage definition
fuselage   = struct(...
            'class','fuselage',...
            'id',label,...
             'f',0.805 ...%Padfield(Bo105)
);

% transmission definition
transmission = struct(...
            'class','transmission',...
            'id',label,...
            'etaTra',0.07,... %!!!
            'etaTrp',0.12...  %!!!
);


Pmt     = 2410*1e3;%!!!
fPmt    = @(h) Pmt*ones(size(h));

% FIXME discuss about this point
[etaMrp,etaMra,etaM] = getEtaM(transmission,tailRotor.eta);
transmission.etaMrp  = etaMrp;
transmission.etaMra  = etaMra;
transmission.etaM    = etaM;
transmission.fPmt    = fPmt;
transmission.Pmt     = Pmt;

% Weights(ActualizadoTechnicalData)

g   = 9.81;

weights.MTOW = 2835*g;
weights.OEW  = 1490*g;
weights.MPL  = 1375*g;
weights.MFW  = 544*g;

% Get available power taken into account transmission power limitation
availablePower = engine_transmission2availablePower(engine,transmission);

% helicopter definition

energyHe  = struct(...
      'class','ehe', ...
      'id',label,...
      'mainRotor',mainRotor,...
      'tailRotor',tailRotor,...
      'engine',engine,... 
      'fuselage',fuselage, ...
      'transmission',transmission,...
      'weights',weights,...
      'availablePower',availablePower,...
      'W',2200*g,...%Padfield(Bo105)
      'Mf',544,...  %TechnicalData
      'Wf',544*g,...
      'x_tr',4.33 ... %TecnicalData(Ltp)
);


% atmosphere seems not very clear that it is convenient to be input FIXME
energyHe      = addCharacteristic2he(energyHe,atmosphere);
