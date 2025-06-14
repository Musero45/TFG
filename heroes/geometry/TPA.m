function M = TPA(beta)

% TPA Calculates the TPP-hub transformation matrix of a flapping rotor.
%
%   M = TPA(beta) computes the transformation matrix M from hub to
%   tip path plane frame of a rotor, given the flapping (beta) angles vector.
%

beta1C = beta(2);
beta1S = beta(3);

M   = [1 0 beta1C;...
      0 1 beta1S;...
      -beta1C -beta1S 1];
  
end