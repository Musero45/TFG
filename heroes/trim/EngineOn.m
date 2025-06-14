function F = EngineOn(CW,omega,CQmr,CQtr,ndRigidHe)
% EngineOn is the trim equation that imposes the
% steady normal operation of the power plant. This corresponds to
% the situation when the power plant keeps the angular velocity 
% of the main rotor (and therefore of the tail rotor) controlled
% and equal to the rated values.
% 
%FIXME (ALVARO) express everything in CPs   Detailed explanation goes here

F = omega-1;

end

