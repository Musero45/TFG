function F = EngineOffTransmissionOn(CW,omega,CQmr,CQtr,ndRigidHe)
% EngineOffTransmissionOn is the trim equation that imposes the
% steady autorrotation condition corresponding to the situation when 
% the power plant is not operating but the trasmission is operative.
% In this situation is assumed that the main rotor is extracting power
% from the flow, and this main rotor power is compensating the transmission
% losses and the tail rotor power.
%
% This model of the autorrotation conditions implicitily assumes that
% the rated relation between tail and main rotor angular velocities is
% valid since the transmision is active.
% 
%FIXME (ALVARO) express everything in CPs

rAngVel   = ndRigidHe.rAngVel;
transmission = ndRigidHe.transmission;
transmissionType = transmission.transmissionType;

CPtransmission = transmissionType(CQmr,CQtr,rAngVel,transmission);

F = CQmr+rAngVel*CQtr+CPtransmission;

end

