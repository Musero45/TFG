function [HOWS] = HOWS
% QFD matrix engineering variables into account

%% HOW's in Dimentional variables
% Hows (label,unit,name, dimensioning,energy,trim,stability,generationOEC)

%%%%%%%%%%%%%%%%
% AERODYNAMICS %
%%%%%%%%%%%%%%%%
% #1 Main rotor chord
upVal = 1.2; downVal = 0.8;
aero(1) = getHOW('{\itc}','[m]','cMR',getContinuous('MainRotor.c'),getContinuous('mainRotor.c'),getContinuous('mainRotor.c0'),...
    getContiniousGeneration('mainRotor.c0',upVal,downVal));

% #2 Main rotor one blade more
aero(2) = getHOW('{\itb_{+1}}','[-]','bMore',getDiscrete('MainRotor.b',[4 5]),getDiscrete('mainRotor.b',[4 5]),getDiscrete('mainRotor.b',[4 5]),...
    getDiscreteGeneration('mainRotor.b',[3 4 5]));

% #3 Main rotor one blade less
aero(3) = getHOW('{\itb_{-1}}','[-]','bLess',getDiscrete('MainRotor.b',[3 4]),getDiscrete('mainRotor.b',[3 4]),getDiscrete('mainRotor.b',[3 4]),...
    getDiscreteGeneration('mainRotor.b',[3 4]));

% #4 Main rotor radius
upVal = 1.2; downVal = 0.8;
aero(4) = getHOW('{\itR}','[m]','RMR',getContinuous('MainRotor.R'),getContinuous('mainRotor.R'),getContinuous('mainRotor.R'),...
    getContiniousGeneration('mainRotor.R',upVal,downVal));

% #5 Main rotor angular velocity
upVal = 1.2; downVal = 0.8;
aero(5) = getHOW('{\it\Omega}','[rad/s]','omegaMR',getContinuous('MainRotor.OmegaRAD'),getContinuous('mainRotor.Omega'),getContinuous('mainRotor.Omega'),...
    getContiniousGeneration('mainRotor.Omega',upVal,downVal));

% #6 Main rotor parasite drag
upVal = 1.2; downVal = 0.8;
aero(6) = getHOW('{\itc_{d0}}','[-]','Cd0',getContinuous('DR.energyEstimations.cd0'),getContinuous('mainRotor.cd0'),getContinuous('mainRotor.cddata(1)'),...
    getContiniousGeneration('mainRotor.cddata(1)',upVal,downVal));

% #7 Tail rotor chord
upVal = 1.2; downVal = 0.8;
aero(7) = getHOW('{\itc_{TR}}','[m]','cTR',getContinuous('TailRotor.c'),getContinuous('tailRotor.c'),getContinuous('tailRotor.c0'),...
    getContiniousGeneration('tailRotor.c0',upVal,downVal));

% #8 Tail rotor radius
upVal = 1.2; downVal = 0.8;
aero(8) = getHOW('{\itR_{TR}}','[m]','RTR',getContinuous('TailRotor.R'),getContinuous('tailRotor.R'),getContinuous('tailRotor.R'),...
    getContiniousGeneration('tailRotor.R',upVal,downVal));

% #9 F coef
upVal = 1.2; downVal = 0.8;
aero(9) = getHOW('{\itf}','[m^2]','f',getContinuous('energyEstimations.f'),getContinuous('fuselage.f'),getContinuous('energyEstimations.f'),...
    getContiniousGeneration('energyEstimations.f',upVal,downVal));

% #10 Factor kappa
upVal = 1.2; downVal = 0.8;
aero(10) = getHOW('{\it\kappa}','[-]','kappa',getContinuous('energyEstimations.kappa'),getContinuous('mainRotor.kappa'),getContinuous('energyEstimations.kappa'),...
    getContiniousGeneration('energyEstimations.kappa',upVal,downVal));

% #11 Factor K
upVal = 1.2; downVal = 0.8;
aero(11) = getHOW('{\itK}','[-]','K',getContinuous('energyEstimations.K'),getContinuous('mainRotor.K'),getContinuous('energyEstimations.K'),...
    getContiniousGeneration('energyEstimations.K',upVal,downVal));

%%%%%%%%%%%%%
% STRUCTURE %
%%%%%%%%%%%%%
%#12 Gross weight
upVal = 1.2; downVal = 0.8;
struc(1) = getHOW('{\itGTOW}','[N]','grossWeight',getContinuous('Weights.MTOW'),getContinuous('W'),getContinuous('inertia.W'),...
    getContiniousGeneration('inertia.W',upVal,downVal));

% #13 Max take off weight
upVal = 1.2; downVal = 0.8;
struc(2) = getHOW('{\itMTOW}','[N]','MTOW',getContinuous('Weights.MTOW'),getContinuous('weights.MTOW'),getContinuous('inertia.MTOW'),...
    getContiniousGeneration('inertia.MTOW',upVal,downVal));

% #14 Operational empty weight
upVal = 1.2; downVal = 0.8;
struc(3) = getHOW('{\itOEW}','[N]','emptyWeight',getContinuous('Weights.emptyWeight'),getContinuous('weights.OEW'),getContinuous('inertia.OEW'),...
    getContiniousGeneration('inertia.OEW',upVal,downVal));

% #15 Max fuel weight
upVal = 1.2; downVal = 0.8;
struc(4) = getHOW('{\itMFW}','[N]','fuelWeight',getContinuous('Weights.fuelValue'),getContinuous('weights.MFW'),getContinuous('inertia.MFW'),...
    getContiniousGeneration('inertia.MFW',upVal,downVal));

%%%%%%%%%%%%%%
% PROPULTION %
%%%%%%%%%%%%%%
% #16 Take off power
upVal = 1.2; downVal = 0.8;
prop(1) = getHOW('{\itP_{to}}','[W]','PotTakeOff',getContinuous('Engine.PowerTakeOff'),getContinuous('engine.PowerTakeOff'),getContinuous('engine.PowerTakeOff'),...
    getContiniousGeneration('engine.PowerTakeOff',upVal,downVal));

% #17 Max continious power
upVal = 1.2; downVal = 0.8;
prop(2) = getHOW('{\itP_{mc}}','[W]','potMaxCont',getContinuous('Engine.PowerMaximumContinuous'),getContinuous('engine.PowerMaximumContinuous'),getContinuous('engine.PowerMaximumContinuous'),...
    getContiniousGeneration('engine.PowerMaximumContinuous',upVal,downVal));

% #18 Max transmission power
upVal = 1.2; downVal = 0.8;
prop(3) = getHOW('{\itP_{mt}}','[W]','potMaxTrans',getContinuous('Performances.TakeOffTransmissionRating'),getContinuous('transmission.Pmt'),getContinuous('dimensioningPerformances.TakeOffTransmissionRating'),...
    getContiniousGeneration('Performances.TakeOffTransmissionRating',upVal,downVal));

% #19 Fuel consuption
upVal = 1.2; downVal = 0.8;
prop(4) = getHOW('{\itPSFC}','[kg/Ws]','PSFC',getContinuous('Engine.PSFC'),getContinuous('engine.PSFC'),getContinuous('engine.PSFC'),...
    getContiniousGeneration('engine.PSFC',upVal,downVal));

% #20 Engine weight
upVal = 1.2; downVal = 0.8;
prop(5) = getHOW('{\itW_{e}}','[N]','engineWeight',getContinuous('Engine.weight'),getContinuous('engine.weight'),getContinuous('engine.weight'),...
    getContiniousGeneration('engine.weight',upVal,downVal));

% #21 Engine number
prop(6) = getHOW('{\itN_{e}}','[-]','engineNumber',getDiscrete('DR.costFactors.numEngines',[1.0 0.736]),getDiscrete('engine.numEngines',[1 2]),getDiscrete('engine.numEngines',[1 2]),...
    getDiscreteGeneration('engine.numEngines',[1 2]));
    


Cat{1} = getCat('Aerodynamics',aero);
Cat{2} = getCat('Structure',struc);
Cat{3} = getCat('Propulsion',prop);


Hows = getHOWS('Hows',Cat);
HOWS = addNumberItem(Hows);


end

