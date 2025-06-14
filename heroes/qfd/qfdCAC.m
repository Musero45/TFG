function CAC = qfdCAC(he,MissionSegments,atm)
%QFDCAC Select here your model to calculate adquisition cost


dreq = dimhe2dimdr(he);

CostAC = AircraftFlyawayCost(dreq,he.MainRotor,he.Weights,he.Engine);

CAC    = CostAC.C_AC;

end

