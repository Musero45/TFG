function F = systemAntipar(x,MHAdim,theta0RA,mu_xAra_ra,mu_yAra_ra,mu_zAra_ra,mu_WxAra_ra,mu_WyAra_ra,mu_WzAra_ra,lambda_0)

%COMO SE SUPONEN PALAS RIGIDAS DEL ANTIPAR, Y SOLO PASO COLECTIVO, EL
%SISTEMA ES MAS SIMPLE, EL SIGUIENTE PASO SERIA CONSIDERAR EL BATIMIENTO
%INTRODUCIDO POR LA VELOCIDAD INCIDENTE.

%PARA APROVECHAR ELEMENTOS, SE CAMBIARA LOS EJES ANTES 

%Asignación de las variables a resolver en el problema
lambda_iPRA = x(1);
CTinP = x(2);

%Expresión del sistema en la forma F(x,parametros)=0;

[CH_ra2inARA,CY_ra2inARA,CT_ra2inARA] = fza_antipar(MHAdim,theta0RA,lambda_iPRA,mu_xAra_ra,mu_yAra_ra,mu_zAra_ra,mu_WxAra_ra,mu_WyAra_ra,mu_WzAra_ra);
% [lambda_i_2inARA,lambda_iPRA2] = Velocind_antipar(MHAdim,0,0,mu_xAra_ra,mu_yAra_ra,mu_zAra_ra,...
%              mu_WxAra_ra,mu_WyAra_ra,mu_WzAra_ra,CH_rainF,CY_rainF,CT_rainF,lambda_0);


%Por el apaño en la velocind_antipar, hago lo siguiente:
%no disponemos de todas las componentes, esperemos converja esta llamada.

[CTinP2,lambda_iPRA2] = Velocind_antipar(MHAdim,0,0,mu_xAra_ra,mu_yAra_ra,mu_zAra_ra,...
             mu_WxAra_ra,mu_WyAra_ra,mu_WzAra_ra,CH_ra2inARA,CY_ra2inARA,CT_ra2inARA,lambda_0);


F(1) = lambda_iPRA - lambda_iPRA2;
F(2) = CTinP - CTinP2;


end