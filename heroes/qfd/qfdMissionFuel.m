function fuelMass = qfdMissionFuel(ehe,MissionSegments,atm)
%QFDMISSIONFUEL Select here your model to calculate the mission fuel


PL = MissionSegments.PayLoad;
MF = ehe.weights.MFW/atm.g;

ehe = addMissionWeightsEnergy(ehe,PL,MF,0,atm);

% Mission efectiveness by Fuel mass 
[ eheOpt, MissionOpt, io ] = missionWeightOptimization(ehe,MissionSegments,PL,atm);

if io == 0
    disp('...it doesnt matters when computating sensitivity')
end

fuelMass = MissionOpt.TripFuelMass;


end

