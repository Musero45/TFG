
function VVmax = getMaximumROC4givenVH(r4fHe,vWT,FC3,atm,H,VH,options)
% 
% getMaximumROC4givenVH(r4fHe,vWT,FC3,atm,H,VH0,options)
% provides the maximum vertical velocity VVmax in trim conditions for a
% given horizontal flight velocity component, atmosphere atm, altitude H, 
% wind velocity vector in ground reference system vWT and extra flight
% conditions FC4 (three extra flight conditions).
%
% Calcutation options are specified in variable options and the initial
% iteration condition for the maximum flight velocity is VH0.  

ap = getAvailablePowerFuns(r4fHe,options);

VVmax0 = 5;

for i = 1:length(VH)
    
    VHi = VH(i);


eq = @(VV)(getRequiredPowerVVVH(r4fHe,vWT,FC3,VV,VHi,atm,H,options)-...
           ap.aPMC(H));
     
nlSolver = options.nlSolver;

VVmax(i) = nlSolver(eq,VVmax0,options);

VVmax0 = VVmax(i);

end

end





