function M = TFT(Psi,Theta,Phi)

% TFT Calculates the ground-fuselage transformation matrix of a helicopter.
%
%   M = TFT(Psi,Theta,Phi) computes the transformation matrix M from ground 
%   to fuselage frame of an helicopter, given the Euler (Psi,Theta,Phi) angles.
%

sinPsi   = sin(Psi);
cosPsi   = cos(Psi);
sinTheta = sin(Theta);
cosTheta = cos(Theta);
sinPhi   = sin(Phi);
cosPhi   = cos(Phi);

TPsi = [cosPsi sinPsi 0;...
        -sinPsi cosPsi 0;...
        0 0 1];
    
TTheta = [cosTheta 0 -sinTheta;...
          0 1 0;...
          sinTheta 0 cosTheta];
      
TPhi = [1 0 0;...
        0 cosPhi sinPhi;...
        0 -sinPhi cosPhi];
        

M = TPhi*TTheta*TPsi;
  
end