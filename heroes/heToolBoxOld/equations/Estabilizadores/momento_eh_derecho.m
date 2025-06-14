function [C_MXEHDinEHD,C_MYEHDinEHD,C_MZEHDinEHD] = momento_eh_derecho(MHAdim,k_lambdaEHD,mu_xEHD,mu_yEHD,mu_zEHD,mu_WxEHD,mu_WyEHD,mu_WzEHD,lambda_i)


k_lambdaxEHD = k_lambdaEHD(1);
k_lambdayEHD = k_lambdaEHD(2);
k_lambdazEHD = k_lambdaEHD(3);

% k_lambdaxEHD = k_lambdaEHD;     k_lambdayEHD = k_lambdaEHD;     k_lambdazEHD = k_lambdaEHD;


%Carga de variables geometricas
Sehd_ad = MHAdim.EHDerecho.Sehd_ad;
theta_ehd = MHAdim.EHDerecho.theta_ehd;
cehd_ad = MHAdim.EHDerecho.cehd_ad;

%Carga de la polar
a = MHAdim.EHDerecho.a; cmo = MHAdim.EHDerecho.Cmo;
delta0 = MHAdim.EHDerecho.delta0; delta1 = MHAdim.EHDerecho.delta1; delta2 = MHAdim.EHDerecho.delta2;


%Ecuaciones del sistema de fuerzas
CMX_ehd = 0*cmo; CMY_ehd = 0; CMZ_ehd = 0;

C_MXEHDinEHD = (1/2)*Sehd_ad*cehd_ad*mu_yEHD*CMX_ehd*(mu_yEHD+2*mu_WyEHD+2*lambda_i*k_lambdayEHD);

C_MYEHDinEHD = (1/2)*Sehd_ad*cehd_ad*mu_yEHD*CMY_ehd*(mu_yEHD+2*mu_WyEHD+2*lambda_i*k_lambdayEHD);
         
C_MZEHDinEHD = (1/2)*Sehd_ad*cehd_ad*mu_yEHD*CMZ_ehd*(mu_yEHD+2*mu_WyEHD+2*lambda_i*k_lambdayEHD);
     
end