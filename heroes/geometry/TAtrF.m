function M = TAtrF(thetatr)

% TAtrF Calculates the fuselage-tail rotor hub transformation matrix of a tail rotor.
%
%   M = TAtrF(thetatr) computes the transformation matrix M from fuselage to
%   tail rotor hub of a tail rotor, given the cant (thetatr) angle.
%

sine = sin(thetatr);
cosine = cos(thetatr);

M   = [-1 0 0;...
      0  sine cosine;...
      0 cosine -sine];
  
end