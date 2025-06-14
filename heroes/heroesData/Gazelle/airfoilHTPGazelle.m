 function [Cl, Cd, Cm] = airfoilHTPGazelle(alpha,Re)
% Horizontal Tail Plane ecuations from pag. 387 of nasa-tm-88370.
% cd ecuation has been obtained from the polyfit done in the graphic of
% pag. 397.
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

Cd = (0.0961-0.0025*alphadeg+0.000445*alphadeg^2+0.00001567*alphadeg^3+0.0000004*alphadeg^4)/(100);
% Cd = Cd(alpha,Re);

Cm = (0.124-0.0594*alphadeg-0.00064*alphadeg^2+0.0000534*alphadeg^3+0.000000859*alphadeg^4)/(100);
% Cm = Cm(alpha,Re);

end
