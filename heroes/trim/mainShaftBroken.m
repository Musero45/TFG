function F = mainShaftBroken(CW,omega,CQmr,CQtr,ndRigidHe)
% mainShaftBroken is the trim equation that imposes the
% steady autorrotation condition corresponding to the situation when 
% the main shaft is broken, so it corresponds to the pure autorrotation
% of the main rotor. 
% In this situation is assumed that the torque at the main rotor shaft
% is 0. 
%
% In this situation it is assumed that the transmision of the main rotor
% is not lossing energy but the tail rotor transmission is. On the 
% other hand, it is assumed that the controller is keeping the tail rotor
% angular velocity equal to the rated value.
% 
%FIXME (ALVARO) express everything in CPs   Detailed explanation goes here

rAngVel   = ndRigidHe.rAngVel;
transmission = ndRigidHe.transmission;
transmissionType = transmission.transmissionType;

CPtransmission = transmissionType(CQmr,CQtr,rAngVel,transmission);

F = CQmr;

end

