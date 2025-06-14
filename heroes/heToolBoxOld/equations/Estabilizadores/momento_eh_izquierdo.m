function [C_MXEHIinEHI,C_MYEHIinEHI,C_MZEHIinEHI] = momento_eh_izquierdo(MHAdim,k_lambdaEHI,mu_xEHI,mu_yEHI,mu_zEHI,mu_WxEHI,mu_WyEHI,mu_WzEHI,lambda_i)


k_lambdaxEHI = k_lambdaEHI(1);
k_lambdayEHI = k_lambdaEHI(2);
k_lambdazEHI = k_lambdaEHI(3);

% k_lambdaxEHI = k_lambdaEHI;     k_lambdayEHI = k_lambdaEHI;     k_lambdazEHI = k_lambdaEHI;

%Carga de variables geometricas
Sehi_ad = MHAdim.EHIzquierdo.Sehi_ad;
theta_ehi = MHAdim.EHIzquierdo.theta_ehi;
cehi_ad = MHAdim.EHIzquierdo.cehi_ad;

%Carga de la polar
a = MHAdim.EHIzquierdo.a; cmo = MHAdim.EHIzquierdo.Cmo;
delta0 = MHAdim.EHIzquierdo.delta0; delta1 = MHAdim.EHIzquierdo.delta1; delta2 = MHAdim.EHIzquierdo.delta2;


%Ecuaciones del sistema de fuerzas
CMX_ehi = 0*cmo; CMY_ehi = 0; CMZ_ehi = 0;

C_MXEHIinEHI = (1/2)*Sehi_ad*cehi_ad*mu_yEHI*CMX_ehi*(mu_yEHI+2*mu_WyEHI+2*lambda_i*k_lambdayEHI);

C_MYEHIinEHI = (1/2)*Sehi_ad*cehi_ad*mu_yEHI*CMY_ehi*(mu_yEHI+2*mu_WyEHI+2*lambda_i*k_lambdayEHI);
         
C_MZEHIinEHI = (1/2)*Sehi_ad*cehi_ad*mu_yEHI*CMZ_ehi*(mu_yEHI+2*mu_WyEHI+2*lambda_i*k_lambdayEHI);
     
end