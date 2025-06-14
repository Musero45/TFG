function Vm = qfdVm(ehe,MissionSegments,atm)
%QFDendurance Select here your model to calculate the max speed

PL = MissionSegments.PayLoad;
MF = ehe.weights.MFW/atm.g;

ehe = addMissionWeightsEnergy(ehe,PL,MF,0,atm);

ehe.engine = addEnginePerformance(ehe.engine,atm);
availablePower = engine_transmission2availablePower(ehe.engine,ehe.transmission);
ehe.availablePower = availablePower;

V       = 'NaN';
gammaT  = deg2rad(0);
H       = 500;
Z       = 1000;

fC = get1flightCondition(V,gammaT,H,Z);


Vm = vGivenPower(ehe,fC,atm);

end