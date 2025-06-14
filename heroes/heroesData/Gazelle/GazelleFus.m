function Ki = GazelleFus(alphaF, betaF, Re)
% K(i) gets the forces ando moments coefficient of the fuselage.
% Ecuations obtained from pag.387 of [1].
%
% Ki is referred in wind axes,this axes are shown in pag
% 397, figure 3 (c), so the Ki(i) have the following components according
% to pag 387 of [1]:
% Ki(1) = CD == -CX  
% Ki(2) = Clf == CY 
% Ki(3) = CL  == -CZ 
% Ki(4) = Crm  == -CMx
% Ki(5) = Cpm  == CMy
% Ki(6) = Cym  == -CMz
% The diferent sign of the components are because of Heroes definition of
% the xyz axis.
%
%% References
%    [1] Yamauchi, Gloria K., Heffernan, Ruth M. and Gaubert, Michel. 
%    Correlation of SA349/2 Helicopter Flight Test Data with a Comprehnsive
%    Rotorcraft Model, 1987. NASA-TM-88351.
% 
    Ki(1) = -(0.92+0.3783*sin(betaF)+9.549*sin(betaF).^2-4.472*sin(betaF).^3-0.4744*sin(alphaF)+4.158*sin(alphaF).^2)/100;
    Ki(3) = -(0.4993+0.9452*sin(2*alphaF)+0.1102*sin(2*alphaF).^3)/100;
    Ki(5) = (-0.0857+0.77*sin(2*alphaF)+0.1162*sin(2*alphaF).^2-0.2719*sin(2*alphaF).^3)/100;

    Ki(2) = (-2.86*sin(2*betaF)-0.5588*sin(2*alphaF).^3)/100;
    Ki(6) = -(0.01-0.8629*sin(2*betaF)+0.6039*sin(2*betaF).^3)/100;
    
    Ki(4) = -(0.01)/100;

    
%% It is not needed to transform de coefficients.
% % Ki(1) = CD   -[T]->  K(1) = CX
% % Ki(2) = Clf  -[T]->  K(2) = CY 
% % Ki(3) = CL   -[T]->  K(3) = CZ
% % Ki(4) = Crm  -[T]->  K(4) = CMx
% % Ki(5) = Cpm  -[T]->  K(5) = CMy
% % Ki(6) = Cym  -[T]->  K(6) = CMz    
% %
% % Tbeta = [cos(betaF),sin(betaF),0;...
% %          -sin(betaF),cos(betaF),0;...
% %          0,0,1];
% %       
% % Talpha = [cos(alphaF),0,-sin(alphaF);...
% %           0,1,0;...
% %           sin(alphaF),0,cos(alphaF)];
% % 
% % T = Talpha.*Tbeta;
% % 
% % K(1:3) = Ki(1:3)*T;
% % K(4:6) = Ki(4:6)*T;

