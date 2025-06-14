function Vautorrot = gammaT2Vautorrotation(he,flightCondition,atm)

gammaT = flightCondition.gammaT;
Z      = flightCondition.Z;
H      = flightCondition.H;

ngammaT = size(gammaT,2);
Vautorrot = zeros(ngammaT,1);
for i=1:ngammaT

% Power goal
PCgoal = 0;

V0   = 0;
Vauto  = @(V) defineGoal(he,V,gammaT,H,Z,PCgoal,atm);
ops = optimset('Display','off');
Vautorrot  = fzero(Vauto,V0,ops);

end

end

function f = defineGoal(he,V,gammaT,h,Z,PCg,atm)

fC = getFlightCondition(he,'V',V,'gammaT',gammaT,'H',h,'Z',Z);

PCc = getP(he,fC,atm);
f  = PCg-PCc;

end