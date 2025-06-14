function F = systemPala(x,MHAdim,theta0,theta1c,theta1s,mu_xA,mu_yA,mu_zA,mu_WxA,mu_WyA,mu_WzA,lambda_0)

%Asignación de las variables a resolver en el problema
beta0 = x(1);
beta1c = x(2);
beta1s = x(3);
lambda_iP = x(4);
CTinP = x(5);

%Expresión del sistema en la forma F(x,parametros)=0;

[beta0_2,beta1c_2,beta1s_2] = batimiento(theta0,theta1c,theta1s,mu_xA,mu_yA,mu_zA,mu_WxA,mu_WyA,mu_WzA,lambda_iP,MHAdim);
[CH_2inA,CY_2inA,CT_2inA] = fza_rotor(MHAdim,theta0,theta1c,theta1s,beta0,beta1c,beta1s,lambda_iP,mu_xA,mu_yA,mu_zA,mu_WxA,mu_WyA,mu_WzA);
% [lambda_i_2inA,lambda_iP2] = Velocind(MHAdim,beta1c,beta1s,mu_xA,mu_yA,mu_zA,mu_WxA,mu_WyA,mu_WzA,CTinF,lambda_0);

% [CH_2,CY_2,CT_2] = fza_rotor(MHAdim,theta0,theta1c,theta1s,beta0_2,beta1c_2,beta1s_2,lambda_i,mu_xA,mu_yA,mu_zA,mu_WxA,mu_WyA,mu_WzA);
% lambda_i_2 = Velocind(beta1c_2,beta1s_2,mu_xA,mu_yA,mu_zA,mu_WxA,mu_WyA,mu_WzA,CT_2,lambda_0);
[CTinP2,lambda_iP2] = Velocind(MHAdim,beta1c,beta1s,mu_xA,mu_yA,mu_zA,mu_WxA,mu_WyA,mu_WzA,CH_2inA,CY_2inA,CT_2inA,lambda_0);



F(1) = beta0 - beta0_2;
F(2) = beta1c - beta1c_2;
F(3) = beta1s - beta1s_2;
F(4) = lambda_iP - lambda_iP2;
F(5) = CTinP - CTinP2;


end