function ap = getAvailablePowerFuns(r4fRigidHe,options)
% getAvailablePowerFuns(r4fRigidHe,options)
%
%    functions handles @(H) where H is the altitude of the
%    power available for maximum continous regime, take off regime and urgency
%    regime. The available power is calculated considering the limitations 
%    due to transmission rating for each regime

% ap.aPMC is a funtion handle @(H) for the maximum continous power regime
% ap.aPTO is a funtion handle @(H) for the maximum take off power regime
% ap.aPTO is a funtion handle @(H) for the maximum urgency power regime


ap.aPMC = @(H)getAvailableMaxContPower(r4fRigidHe,H,options);
ap.aPTO = @(H)getAvailableTakeOffPower(r4fRigidHe,H,options);
ap.aPUR = @(H)getAvailableMaxUrgencyPower(r4fRigidHe,H,options);

end

