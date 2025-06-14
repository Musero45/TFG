
function PM = getRequiredPower(he,vWT,FC4,V,atm,H,options)
% PM = getRequiredPower(he,vWT,FC4,V,atm,H,options) provides 
% provides the required power for a trim condition in atmosphere atm,
% at height H, flight velocity V, wind velocity vector in ground reference
% system vWT and extra flight conditions FC4 (four extra flight conditions). 
% Calcutation options are specified in variable options.

ndHe  = rigidHe2ndHe(he,atm,H);

Omega = he.mainRotor.Omega;
R     = he.mainRotor.R;

VOR   = V/(Omega*R);
muWT  = vWT/(Omega*R);

FC0 = {'VOR',VOR(1),...
      FC4{1},FC4{2},...
      FC4{3},FC4{4},...
      FC4{5},FC4{6},...
      FC4{7},FC4{8}};

FC = {'VOR',VOR,...
      FC4{1},FC4{2},...
      FC4{3},FC4{4},...
      FC4{5},FC4{6},...
      FC4{7},FC4{8}};
  
options1 = options;
options1.aeromechanicModel = @aeromechanicsLin;
options1.mrForces          = @completeF;
options1.mrMoments         = @aerodynamicM;
options1.trForces          = @completeF;
options1.trMoments         = @aerodynamicM;
  
ndTs0 = getNdHeTrimState(ndHe,muWT,FC0,options1);
options.IniTrimCon = ndTs0.solution;

ndTs = getNdHeTrimState(ndHe,muWT,FC,options);

ts   = ndHeTrimState2HeTrimState(ndTs,he,atm,H,options);

PM   = ts.Pow.PM;

end
