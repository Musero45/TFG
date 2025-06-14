function io = stabilityTest(mode)

close all

options     = setHeroesRigidOptions;

options.GT  = 0;
% atmosphere variables needed
atm         = getISA;
H           = 0;

% helicopter model selection
he          = PadfieldBo105(atm);

% Reducded value of tail rotor blade mass
he.tailRotor.bm = 1;

ndHe    = rigidHe2ndHe(he,atm,H);

muWT    = [0; 0; 0];

FC = {'VOR',linspace(0.0001,0.4,5)...
      'betaf0',0,...
      'gammaT',0,...
      'cs',0,...
      'vTOR',0};

ndTs = getNdHeTrimState(ndHe,muWT,FC,options);

% Compute linear stability state

ndSs       = getndHeLinearStabilityState(ndTs,muWT,ndHe,options);

Ss         = ndHeSs2HeSs(ndSs,he,atm,H,options);


io =1;














