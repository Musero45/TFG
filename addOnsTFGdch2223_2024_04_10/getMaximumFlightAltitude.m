function Hmax = getMaximumFlightAltitude(r4fHe,vWT,FC4,atm,V,Hmax0,options) 
% getMaximumFlightVelocity(r4fHe,vWT,FC4,atm,VH,Hmax0,options)
% provides the maximum flight altitude in trim conditions for a
% ready for flight helicopter r4fHe, atmosphere atm, flight velocity V, wind
% velocity vector in ground reference system vWT and extra flight
% conditions FC4 (four extra flight conditions). Calcutation options are 
% specified in variable options and the initial iteration condition for
% the maximum flight altitude is Hmax.
ap = getAvailablePowerFuns(r4fHe,options);


     
nlSolver = options.nlSolver;

for i = 1:length(V);
    
    Vi = V(i);
    
    eq = @(H)(getRequiredPower(r4fHe,vWT,FC4,Vi,atm,H,options)-...
           ap.aPMC(H));

Hmax(i) = nlSolver(eq,Hmax0,options);

    Hmax0 = Hmax(i);

end

end