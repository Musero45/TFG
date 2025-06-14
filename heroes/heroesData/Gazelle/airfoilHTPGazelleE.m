 function [Cl, Cd, Cm] = airfoilHTPGazelleE(alpha,Re)
% Horizontal Tail Plane ecuations from pag. 387 of nasa-tm-88370.
%
%% References
%    [1] Heffernan, Ruth M. and Gaubert, Michel. Structural and aerodynamic
%    loads and performance measurements of an SA349/2 helicopter with an 
%    advanced geometry rotor, 1986. NASA-TM-88370.
% 

Re = 1e50;
alphadeg = alpha.*180/pi;  

Cl = (-0.0893+0.0657*alphadeg+0.000429*alphadeg^2-0.0000663*alphadeg^3-0.000000511*alphadeg^4)/(100);
% Cl = Cl(alpha,Re);

Cd = (-0.475-0.00243*alphadeg+0.000472*alphadeg^2+0.000014*alphadeg^3+0.00000029*alphadeg^4)/(100);
% Cd = Cd(alpha,Re);

Cm = (0.124-0.0594*alphadeg-0.00064*alphadeg^2+0.0000534*alphadeg^3+0.000000859*alphadeg^4)/(100);
% Cm = Cm(alpha,Re);

end