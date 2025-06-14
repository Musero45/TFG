function apUr = getAvailableMaxUrgencyPower(r4fRigidHe,H,options)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

apUr = (min(r4fRigidHe.engine.fPmu(H),r4fRigidHe.transmission.Pmtu));

end

