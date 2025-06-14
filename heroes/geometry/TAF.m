function M = TAF(epsx,epsy)

% TAF Calculates the fuselage-hub transformation matrix of a helicopter.
%
%   M = TAF(epsx,epsy) computes the transformation matrix M from fuselage to
%   main rotor hub frame of an helicopter, given the shaft (epsx and epsy) angles.
%

sinx = sin(epsx);
cosx = cos(epsx);
siny = sin(epsy);
cosy = cos(epsy);

M   = [-cosy 0 siny;...
      -sinx*siny cosx -sinx*cosy;...
      -cosx*siny -sinx -cosx*cosy];
  
end