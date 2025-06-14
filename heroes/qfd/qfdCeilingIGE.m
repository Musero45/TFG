function CeilingIGE = qfdCeilingIGE(he,MissionSegments,atm)
%QFDCeilingIGE Select here your model to calculate ceiling in IGE
Z = 2;

CeilingIGE  = ceilingHoverEnergy(he,atm,Z);

end