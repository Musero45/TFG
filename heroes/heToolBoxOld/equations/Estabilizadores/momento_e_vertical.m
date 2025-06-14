function [C_MXEVinEV,C_MYEVinEV,C_MZEVinEV] = momento_e_vertical(MHAdim,k_lambdaEV,mu_xEV,mu_yEV,mu_zEV,mu_WxEV,mu_WyEV,mu_WzEV,lambda_iRA)


k_lambdaxEV = k_lambdaEV(1);
k_lambdayEV = k_lambdaEV(2);
k_lambdazEV = k_lambdaEV(3);

% k_lambdaxEV = k_lambdaEV;   k_lambdayEV = k_lambdaEV;   k_lambdazEV = k_lambdaEV;

%Carga de variables geometricas
Sev_ad = MHAdim.EVertical.Sev_ad;
theta_ev = MHAdim.EVertical.theta_ev;
cev_ad = MHAdim.EVertical.cev_ad;

%Carga de la polar
a = MHAdim.EVertical.a; cmo = MHAdim.EVertical.Cmo;
delta0 = MHAdim.EVertical.delta0; delta1 = MHAdim.EVertical.delta1; delta2 = MHAdim.EVertical.delta2;


%Ecuaciones del sistema de fuerzas
CMX_ev = 0*cmo; CMY_ev = 0; CMZ_ev = 0;

C_MXEVinEV = (1/2)*CMX_ev*Sev_ad*cev_ad*mu_yEV*(mu_yEV+2*mu_WyEV+2*lambda_iRA*k_lambdayEV);

C_MYEVinEV = (1/2)*CMY_ev*Sev_ad*cev_ad*mu_yEV*(mu_yEV+2*mu_WyEV+2*lambda_iRA*k_lambdayEV);
         
C_MZEVinEV = (1/2)*CMZ_ev*Sev_ad*cev_ad*mu_yEV*(mu_yEV+2*mu_WyEV+2*lambda_iRA*k_lambdayEV);
     
end