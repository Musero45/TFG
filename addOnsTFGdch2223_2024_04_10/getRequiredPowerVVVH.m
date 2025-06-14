
function PM = getRequiredPowerVVVH(he,vWT,FC3,VV,VH,atm,H,options)
% PM = getRequiredPowerVVVH(he,vWT,FC4,V,atm,H,options) provides 
% provides the required power for a trim condition with hotizontal flight
% velocity component VH and vertical flight velocity component VV 
% in atmosphere atm, at height H, wind velocity vector in ground reference
% system vWT and extra flight conditions FC4 (four extra flight conditions). 
%
% Calculation options are specified in variable options.

ndHe  = rigidHe2ndHe(he,atm,H);

Omega = he.mainRotor.Omega;
R     = he.mainRotor.R;

uTOR  = VH/(Omega*R);
wTOR  = -VV/(Omega*R);
muWT  = vWT/(Omega*R);

FC0 = {'uTOR',uTOR(1),...
       'wTOR',wTOR(1),...
        FC3{1},FC3{2},...
        FC3{3},FC3{4},...
        FC3{5},FC3{6}};

FC  = {'uTOR',uTOR,...
       'wTOR',wTOR,...
        FC3{1},FC3{2},...
        FC3{3},FC3{4},...
        FC3{5},FC3{6}};
  
options1                   = options;
options1.aeromechanicModel = @aeromechanicsLin;
options1.mrForces          = @completeF;
options1.mrMoments         = @aerodynamicM;
options1.trForces          = @completeF;
options1.trMoments         = @aerodynamicM;
  
             ndTs0 = getNdHeTrimState(ndHe,muWT,FC0,options1);
options.IniTrimCon = ndTs0.solution;

              ndTs = getNdHeTrimState(ndHe,muWT,FC,options);
                ts = ndHeTrimState2HeTrimState(ndTs,he,atm,H,options);
                PM = ts.Pow.PM;
                
end
