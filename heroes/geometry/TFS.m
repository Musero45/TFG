function TFS = TFS(Gamma)

% TFS Calculates the fuselage-stabilizer transformation matrix of a helicopter.
%
%   M = TFS(Gamma) computes the transformation matrix M from stabilizer to
%   fuselage frame of an helicopter, given the stabilizer (Gamma) angle.
%

TFS = [1 0 0;...
       0 cos(Gamma) -sin(Gamma);
       0 sin(Gamma) cos(Gamma)];