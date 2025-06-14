function [Cl, Cd, Cm] = naca0012(alpha)

% NACA0012  Gets lift, drag and moment coefficients for the NACA 12% 
%           symmetric airfoil
%
%     [CL, CD, CM] = NACA0012(ALPHA) gets the lift (CL), drag (CD) and
%     moment (CM)coefficients of the symmetric NACA airfoil of 12% relative
%     thickness, given the angle of attack (ALPHA)
%


Re = 1e50;
Cl = naca0012_cl;
Cl = Cl(alpha,Re);

Cd = naca0012_cd;
Cd = Cd(alpha,Re);

Cm = zeros(size(alpha));

end