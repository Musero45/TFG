function K = GazelleTP(alphaF, betaF, Re)
% K(i) gets the forces ando moments coefficient of the Tail Plane.
% Ecuations obtained from pag.387 of [1].
%
% Ki is referred in wind axes,this axes are shown in pag
% 397, figure 3 (c), so the Ki(i) have the following components according
% to pag 387 of [1]:
% K(1) = CD == -CX  
% K(2) = Clf == CY 
% K(3) = CL  == -CZ 
% K(4) = Crm  == -CMx
% K(5) = Cpm  == CMy
% K(6) = Cym  == - CMz 
% The diferent sign of the components are because of Heroes definition of
% the xyz axis.
%
%% References
%    [1] Yamauchi, Gloria K., Heffernan, Ruth M. and Gaubert, Michel. 
%    Correlation of SA349/2 Helicopter Flight Test Data with a Comprehnsive
%    Rotorcraft Model, 1987. NASA-TM-88351.
% 

% HTP
 [Cl, Cd, Cm] = airfoilHTPGazelle(alphaF,Re);
    
    K(1)= Cd;
    K(3)= Cl;
    K(5)= Cm;
    
    
   % VTP
ndStab.ndS = 1;
ndStab.ndc = 1;
muxs = 1;
muzs = 1;
% ndVs = sqrt(muxs^2+muys^2+muzs^2); ->
% muys = -sin(betaF).*ndVs;          ->
% --> muys^2=-sin(betaF)^2*(1+muyx^2+1)-> sacando factor com?n :
if betaF<=0;
muys = sqrt((2.*(sin(betaF).^2))./(1-(sin(betaF).^2)));
else
muys = -sqrt((2.*(sin(betaF).^2))./(1-(sin(betaF).^2)));
end    
flightConditionStab(1) = muxs;
flightConditionStab(2) = muys;
flightConditionStab(3) = muzs;

 [CF, CM] = get2D_VTP_body(flightConditionStab,ndStab);
 
ndVs = sqrt(muxs^2+muys^2+muzs^2);
 
    K(2) = CF(2).*100./(0.5*ndVs^2);
    K(4) = CM(1).*100./(0.5*ndVs^2);
    K(6) = CM(3).*100./(0.5*ndVs^2);
         
end