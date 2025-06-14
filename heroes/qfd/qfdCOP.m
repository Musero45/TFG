function COP = qfdCOP(he,MissionSegments,atm)
%QFDCAC Select here your model to calculate operation cost

dreq = dimhe2dimdr(he);

CostAC = AircraftFlyawayCost(dreq,he.MainRotor,he.Weights,he.Engine);
CostOP = DirectOperatingCost(dreq,he.Weights,he.Engine,CostAC);

COP    = CostOP.C_OP;

end

