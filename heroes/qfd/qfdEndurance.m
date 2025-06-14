function Endurance = qfdEndurance(ehe,MissionSegments,atm)
%QFDendurance Select here your model to calculate Endurance

PL = MissionSegments.PayLoad;
MF = ehe.weights.MFW/atm.g;

ehe = addMissionWeightsEnergy(ehe,PL,MF,0,atm);

% Initial fC
V           = 0;
Z           = 1000;
h           = 0;
gammaTdeg   = 0;
gammaT = deg2rad(gammaTdeg);
fCini = get1flightCondition(V,gammaT,h,Z);


[vC]    = vMaxEndurance(ehe,fCini,atm); 

fCEndurance = get1flightCondition(vC,gammaT,h,Z);
Endurance = getEndurance(ehe,fCEndurance,atm);


end