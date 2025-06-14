function [C_MXF,C_MYF,C_MZF] = momento_fuselaje(MHAdim,k_lambdaF,mu_xF,mu_yF,mu_zF,mu_WxF,mu_WyF,mu_WzF,lambda_i)

k_lambdaxF = k_lambdaF(1);
k_lambdayF = k_lambdaF(2);
k_lambdazF = k_lambdaF(3);

% k_lambdaxF = k_lambdaF;     k_lambdayF = k_lambdaF;     k_lambdazF = k_lambdaF;

alpha_F = atan2(-(mu_zF + mu_WzF + lambda_i * k_lambdazF),-(mu_xF + mu_WxF + lambda_i * k_lambdaxF));

V_F = sqrt((mu_xF+mu_WxF+lambda_i*k_lambdaxF)^2 + ...
           (mu_yF+mu_WyF+lambda_i*k_lambdayF)^2 + ...
           (mu_zF+mu_WzF+lambda_i*k_lambdazF)^2);
     
beta_F = -asin((mu_yF+mu_WyF+lambda_i*k_lambdayF)/(V_F));

%Carga de variables geometricas
sp_ad = MHAdim.Fuselaje.sp_ad;
ss_ad = MHAdim.Fuselaje.ss_ad;

lRAH_ad = MHAdim.Fuselaje.lRAH_ad;


%Ecuaciones del sistema de fuerzas (segun SEA)

% C_MXF = ((1/2)*mu_xF^2+mu_xF*mu_WxF+mu_xF*lambda_i*k_lambdaxF)*ss_ad*levh_ad*CMXF(alpha_F,beta_F);
% 
% C_MYF = ((1/2)*mu_xF^2+mu_xF*mu_WxF+mu_xF*lambda_i*k_lambdaxF)*sp_ad*levh_ad*CMYF(alpha_F,beta_F);
% 
% C_MZF = ((1/2)*mu_xF^2+mu_xF*mu_WxF+mu_xF*lambda_i*k_lambdaxF)*ss_ad*levh_ad*CMZF(alpha_F,beta_F, mu_xF+mu_WxF);

%Ecuaciones del sistema de fuerzas (segun ALVARO)

C_MXF = (1/2*V_F^2)*ss_ad*lRAH_ad*CMXF(alpha_F,beta_F);

C_MYF = (1/2*V_F^2)*sp_ad*lRAH_ad*CMYF(alpha_F,beta_F);

u = -(mu_xF+mu_WxF);

C_MZF = (1/2*V_F^2)*ss_ad*lRAH_ad*CMZF(alpha_F,beta_F, u);


end