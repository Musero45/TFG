function apMC = getAvailableMaxContPower(r4fRigidHe,H,options)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

apMC = (min(r4fRigidHe.engine.fPmc(H),r4fRigidHe.transmission.Pmt));

end

