function gTmgT = qfdAutorrotation(ehe,MissionSegments,atm)
%QFDAUTORROTATION Select here your model to calculate Autorrotation


PL = MissionSegments.PayLoad;
MF = ehe.weights.MFW/atm.g;

ehe = addMissionWeightsEnergy(ehe,PL,MF,0,atm);

C       = 0.9;
Autorhe = ehe2Autorhe(ehe,C);


V           = 0;
Z           = 1000;
h           = 500;
gammaTdeg   = 0;
gammaT = deg2rad(gammaTdeg);
fC = get1flightCondition(V,gammaT,h,Z);


gTmgT = gammaTminGammaT(Autorhe,fC,atm);

end