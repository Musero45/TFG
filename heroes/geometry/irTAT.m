function M = irTAT(ThetaA,PhiA)

% irTAT  Calculates the hub-ground transformation matrix of an isolated rotor.
%
%   M = irTAT(ThetaA,PhiA) computes the transformation matrix M from hub to
%   ground frame of an isolated rotor, given the trim Euler (ThetaA & PhiA) angles.
%

M   = [-cos(ThetaA) 0 sin(ThetaA);...
      -sin(ThetaA)*sin(PhiA) cos(PhiA) -cos(ThetaA)*sin(PhiA);...
      -sin(ThetaA)*cos(PhiA) -sin(PhiA) -cos(ThetaA)*cos(PhiA)];
  
end