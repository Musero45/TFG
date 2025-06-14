function apTO = getAvailableTakeOffPower(r4fRigidHe,H,options)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

apTO = (min(r4fRigidHe.engine.fPde(H),r4fRigidHe.transmission.Pmtto));

end

