
function VH = getMaximumFlightVelocity(r4fHe,vWT,FC4,atm,H,VH0,options)
% getMaximumFlightVelocity(r4fHe,vWT,FC4,atm,H,VH0,options)
% provides the maximum flight velocity in trim conditions for a
% ready for flight helicopter r4fHe, atmosphere atm, altitude H, wind
% velocity vector in ground reference system vWT and extra flight
% conditions FC4 (four extra flight conditions). Calcutation options are 
% specified in variable options and the initial iteration condition for
% the maximum flight velocity is VH0.  

ap = getAvailablePowerFuns(r4fHe,options);

for i = 1:length(H)
    
    Hi = H(i);

eq = @(VH)(getRequiredPower(r4fHe,vWT,FC4,VH,atm,Hi,options)-...
           ap.aPMC(Hi));
     
nlSolver = options.nlSolver;

VH(i) = nlSolver(eq,VH0,options);

VH0 = VH(i);

end

end





