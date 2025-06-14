function [C_DXF,C_DYF,C_DZF,alpha_F,beta_F] = fza_fuselaje(MHAdim,k_lambdaF,mu_xF,mu_yF,mu_zF,mu_WxF,mu_WyF,mu_WzF,lambda_i)

kf = MHAdim.Fuselaje.FactorAmplifi;
    

 k_lambdaxF = 1*k_lambdaF(1);
 k_lambdayF = 1*k_lambdaF(2);
 k_lambdazF = 1*k_lambdaF(3);

% k_lambdaxF = k_lambdaF;     k_lambdayF = k_lambdaF;     k_lambdazF = k_lambdaF;

alpha_F = atan2(-(mu_zF + mu_WzF + lambda_i * k_lambdazF),-(mu_xF + mu_WxF + lambda_i * k_lambdaxF));

V_F = sqrt((mu_xF+mu_WxF+lambda_i*k_lambdaxF)^2 + ...
           (mu_yF+mu_WyF+lambda_i*k_lambdayF)^2 + ...
           (mu_zF+mu_WzF+lambda_i*k_lambdazF)^2);
     
beta_F = -asin((mu_yF+mu_WyF+lambda_i*k_lambdayF)/(V_F));

%Carga de variables geometricas
sp_ad = MHAdim.Fuselaje.sp_ad;
ss_ad = MHAdim.Fuselaje.ss_ad;

rho = MHAdim.rho;
R = MHAdim.Pala_RP.R;
Omega = MHAdim.Pala_RP.Omega;


%Ecuaciones del sistema de fuerzas segun SEA

% C_DXF = (1/2*mu_xF+mu_WxF+lambda_i*k_lambdaxF)*sp_ad*mu_xF*CXF(alpha_F,beta_F)
% 
% C_DYF = (1/2*mu_xF+mu_WxF+lambda_i*k_lambdaxF)*ss_ad*mu_xF*CYF(alpha_F,beta_F)
% 
% C_DYF = (1/2*mu_xF+mu_WxF+lambda_i*k_lambdaxF)*ss_ad*mu_xF*(-11672.0)*beta_F/(rho*pi*R^4*Omega^2)
% 
% C_DZF = (1/2*mu_xF+mu_WxF+lambda_i*k_lambdaxF)*sp_ad*mu_xF*CZF(alpha_F,beta_F)

%Ecuaciones del sistema de fuerzas segun ALVARO

C_DXF = kf*(1/2*V_F^2)*sp_ad*CXF(alpha_F,beta_F,MHAdim);

C_DYF = (1/2*V_F^2)*ss_ad*CYF(alpha_F,beta_F,MHAdim);

C_DZF = (1/2*V_F^2)*sp_ad*CZF(alpha_F,beta_F,MHAdim);

end