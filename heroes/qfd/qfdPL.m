function PL = qfdPL(ehe,MissionSegments,atm)
%QFDPL Select here your model to calculate the PL


PL = MissionSegments.PayLoad;
MF = ehe.weights.MFW/atm.g;

ehe = addMissionWeightsEnergy(ehe,PL,MF,0,atm);

OEW  = ehe.weights.OEW;
MTOW = ehe.weights.MTOW;
MFW  = ehe.weights.MFW;

fC = get1flightCondition(0,0,500,10000);

PLB = MTOW-OEW-MFW;
FWB = MFW;
[ PLB, RB] = getPLRpoint(ehe,fC,PLB,FWB,atm);

PL = PLB;

end



