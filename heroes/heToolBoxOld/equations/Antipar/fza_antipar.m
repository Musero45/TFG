function [CH_rainARA,CY_rainARA,CT_rainARA] = fza_antipar(MHAdim,theta0RA,lambda_iRA,mu_xAra,mu_yAra,...
    mu_zAra,mu_WxAra,mu_WyAra,mu_WzAra)

ModAcc = MHAdim.Analisis.ModeloAcciones;

a = MHAdim.Pala_RA.a;
delta0 = MHAdim.Pala_RA.delta0; delta1 = MHAdim.Pala_RA.delta1; delta2 = MHAdim.Pala_RA.delta2;

%e_ad = MHAdim.Pala_RA.e_ad; %OJO, no hay excentricidad en el modelo
sigma_ra = MHAdim.Pala_RA.sigma;
theta1 = MHAdim.Pala_RA.theta1; 

epsilon_ra=MHAdim.epsilon_ra;

    Omega_ra = MHAdim.Pala_RA.Omega;    Omega = MHAdim.Pala_RP.Omega;
    Rra = MHAdim.Pala_RA.R;             R = MHAdim.Pala_RP.R;


    if strcmp(ModAcc,'ASE')
    
%CREACION DE L0S MATRICES DEL SISTEMA(solo se coge theta0RA como variable)
%VECTOR INDEPENDIENTE
CFRAind_1 = (1/4)*sigma_ra*(mu_xAra*delta0+lambda_iRA*mu_xAra*delta1+...
             delta0*mu_WxAra+mu_WzAra*mu_xAra*delta1+mu_zAra*mu_xAra*delta1);

CFRAind_2 = (1/4)*sigma_ra*(mu_WyAra+mu_yAra)*delta0;
            
CFRAind_3 = (1/4)*a*sigma_ra*(mu_WzAra+mu_zAra+lambda_iRA);

%VECTOR DE LOS TERMINOS PROPORCIONALES A THETA0

CFRAtheta_1 = -(1/4)*sigma_ra*(-mu_xAra*delta1-delta1*mu_WxAra-2*mu_WzAra*mu_xAra*delta2+...
                mu_WzAra*a*mu_xAra-2*mu_zAra*mu_xAra*delta2+mu_zAra*a*mu_xAra-2*lambda_iRA*...
                mu_xAra*delta2+lambda_iRA*a*mu_xAra);

CFRAtheta_2 = (1/4)*sigma_ra*(mu_WyAra+mu_yAra)*delta1;

CFRAtheta_3 = (1/12)*a*sigma_ra*(2+3*mu_xAra^2+6*mu_WxAra*mu_xAra);

    else
        
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%   MODELO DE FUERZAS SEGUN ALVARO
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%   VECTOR INDEPENDIENTE SEGÚN ALVARO

CFRAind_1 = ((1/4)*sigma_ra*delta0*(mu_xAra+mu_WxAra)+(1/48)*sigma_ra*(-12*0*delta1+12*delta1)*(mu_zAra+mu_WzAra)*(mu_xAra+mu_WxAra)+...
    (1/48)*sigma_ra*(-12*0*delta1+12*delta1)*lambda_iRA*(mu_xAra+mu_WxAra)+(1/6)*sigma_ra*delta1*theta1*(mu_xAra+mu_WxAra));

CFRAind_2 = ((1/4)*sigma_ra*delta0*(mu_yAra+mu_WyAra)-(1/48)*sigma_ra*(12*0*delta1-12*delta1)*(mu_zAra+mu_WzAra)*(mu_yAra+mu_WyAra)-...
    (1/48)*sigma_ra*(12*0*delta1-12*delta1)*lambda_iRA*(mu_yAra+mu_WyAra)+(1/6)*sigma_ra*delta1*theta1*(mu_yAra+mu_WyAra));

CFRAind_3 = ((1/4)*sigma_ra*(mu_zAra+mu_WzAra)+(1/4)*sigma_ra*lambda_iRA+(1/8)*sigma_ra*theta1)*a;


%MATRIZ DE LOS TERMINOS PROPORCIONALES A LAS THETAS SEGUN ALVARO

CFRAtheta_1 = ((1/48)*sigma_ra*(12*0-12)*(mu_zAra+mu_WzAra)*(mu_xAra+mu_WxAra)+(1/48)*sigma_ra*(12*0-12)*lambda_iRA*(mu_xAra+mu_WxAra))*a+(1/4)*sigma_ra*delta1*...
    (mu_xAra+mu_WxAra)+(1/48)*sigma_ra*(-24*0*delta2+24*delta2)*(mu_zAra+mu_WzAra)*(mu_xAra+mu_WxAra)+(1/48)*sigma_ra*(-24*0*delta2+24*delta2)*...
    lambda_iRA*(mu_xAra+mu_WxAra)+(1/3)*sigma_ra*delta2*theta1*(mu_xAra+mu_WxAra);


CFRAtheta_2 = (-(1/48)*sigma_ra*(12-12*0)*(mu_zAra+mu_WzAra)*(mu_yAra+mu_WyAra)-(1/48)*sigma_ra*(12-12*0)*lambda_iRA*(mu_yAra+mu_WyAra))*a+...
    (1/4)*sigma_ra*delta1*(mu_yAra+mu_WyAra)-(1/48)*sigma_ra*(24*0*delta2-24*delta2)*(mu_zAra+mu_WzAra)*(mu_yAra+mu_WyAra)-...
    (1/48)*sigma_ra*(24*0*delta2-24*delta2)*lambda_iRA*(mu_yAra+mu_WyAra)+(1/3)*sigma_ra*delta2*theta1*(mu_yAra+mu_WyAra);


CFRAtheta_3 = ((1/6)*sigma_ra-(1/24)*sigma_ra*(-6+6*0)*(mu_yAra+mu_WyAra)^2-(1/24)*sigma_ra*(-6+6*0)*(mu_xAra+mu_WxAra)^2)*a;


end




%ORDENACION DE LAS MATRICES DEL SISTEMA
V_theta = [CFRAtheta_1; CFRAtheta_2; CFRAtheta_3];
V_indep = [CFRAind_1;CFRAind_2;CFRAind_3];


CFRA = V_theta*theta0RA+V_indep;

%CFRA/(R^4*Omega^2)*(Rra^4*Omega_ra^2);

CH_rainARA = CFRA(1); CY_rainARA = CFRA(2); CT_rainARA = CFRA(3);

% CH_rainARA = 0; CY_rainARA = 0; CT_rainARA = CT_rainARA;
end