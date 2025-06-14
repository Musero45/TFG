function Range = qfdRange(ehe,MissionSegments,atm)
%QFDendurance Select here your model to calculate Range

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


[vB]   = vMaxRange(ehe,fCini,atm);

fCRange = get1flightCondition(vB,gammaT,h,Z);

Range = getRange(ehe,fCRange,atm);


end