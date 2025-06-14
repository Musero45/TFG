function [Result] = oecMissionFuel(ehe,MissionSegments,atm)
%OECMISSIONFUEL Select here your model to calculate the mission fuel


Result = zeros(1,2);

PL = MissionSegments.PayLoad;
MF = ehe.weights.MFW/atm.g;

ehe = addMissionWeightsEnergy(ehe,PL,MF,0,atm);

% Mission efectiveness by Fuel mass 
[ eheOpt, MissionOpt, io ] = missionWeightOptimization(ehe,MissionSegments,PL,atm);

% Output results
Result(1) = MissionOpt.TripFuelMass;
Result(2) = io;


end

