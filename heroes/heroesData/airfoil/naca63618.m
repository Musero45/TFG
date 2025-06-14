function [Cl, Cd, Cm] = naca63618(alpha)

% NACA63618 Gets lift, drag and moment coefficients for the NACA 63618 
%           airfoil
%
%     [CL, CD, CM] = NACA63618(ALPHA) gets the lift (CL), drag (CD) and
%     moment (CM)coefficients of the 63618 NACA airfoil thickness, given
%     the angle of attack (ALPHA)
%

c = 'cl';
[alphaop,clop,cdop,kmax,alpha_d,Coeff] = NACA63618CORRdat(c);
Cl = interp1(alpha_d,Coeff,alpha);

c = 'cd';
[alphaop,clop,cdop,kmax,alpha_d,Coeff] = NACA63618CORRdat(c);
Cd = interp1(alpha_d,Coeff,alpha);

c = 'cm';
[alphaop,clop,cdop,kmax,alpha_d,Coeff] = NACA63618CORRdat(c);
Cm = interp1(alpha_d,Coeff,alpha);
end