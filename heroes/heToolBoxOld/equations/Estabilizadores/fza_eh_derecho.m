function [C_XEHDinEHD,C_YEHDinEHD,C_ZEHDinEHD,phi_EHD,alpha_EHD,CD_EHD,CL_EHD] = fza_eh_derecho(MHAdim,k_lambdaEHD,mu_xEHD,...
    mu_yEHD,mu_zEHD,mu_WxEHD,mu_WyEHD,mu_WzEHD,lambda_i)


kEHD = MHAdim.Analisis.kEHD;

k_lambdaxEHD = kEHD*k_lambdaEHD(1);
k_lambdayEHD = kEHD*k_lambdaEHD(2);
k_lambdazEHD = kEHD*k_lambdaEHD(3);

% k_lambdaxEHD = k_lambdaEHD;     k_lambdayEHD = k_lambdaEHD;     k_lambdazEHD = k_lambdaEHD;

ModAcc = MHAdim.Analisis.ModeloAcciones;

%Carga de variables geometricas
Sehd_ad = MHAdim.EHDerecho.Sehd_ad;
theta_ehd = MHAdim.EHDerecho.theta_ehd;

%Carga de la polar
a = MHAdim.EHDerecho.a;
delta0 = MHAdim.EHDerecho.delta0; delta1 = MHAdim.EHDerecho.delta1; delta2 = MHAdim.EHDerecho.delta2;


phi_EHD = atan2((mu_zEHD + mu_WzEHD + lambda_i * k_lambdazEHD),(mu_yEHD + mu_WyEHD + lambda_i * k_lambdayEHD));

V_EHD = sqrt((mu_xEHD+mu_WxEHD+lambda_i*k_lambdaxEHD)^2 + ...
           (mu_yEHD+mu_WyEHD+lambda_i*k_lambdayEHD)^2 + ...
           (mu_zEHD+mu_WzEHD+lambda_i*k_lambdazEHD)^2);

alpha_EHD = phi_EHD+theta_ehd;

if strcmp(ModAcc,'ASE')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%   MODELO DE FUERZAS SEGUN ASE
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Ecuaciones del sistema de fuerzas

C_XEHDinEHD = 0;

C_YEHDinEHD = -(1/2)*Sehd_ad*mu_yEHD*(-delta0*mu_yEHD-delta2*theta_ehd^2*mu_yEHD-delta1*mu_yEHD*theta_ehd-...
           2*delta0*mu_WyEHD-2*delta2*theta_ehd^2*mu_WyEHD-2*delta1*theta_ehd*mu_WyEHD+a*theta_ehd*mu_WzEHD-...
           2*delta2*theta_ehd*mu_WzEHD-delta1*mu_WzEHD+a*theta_ehd*mu_zEHD-2*delta2*theta_ehd*mu_zEHD-delta1*...
           mu_zEHD-2*delta2*theta_ehd^2*lambda_i*k_lambdayEHD-2*delta2*theta_ehd*lambda_i*k_lambdazEHD-...
           2*delta0*lambda_i*k_lambdayEHD-2*delta1*theta_ehd*lambda_i*k_lambdayEHD+a*theta_ehd*lambda_i*...
           k_lambdazEHD-delta1*lambda_i*k_lambdazEHD);
         

C_ZEHDinEHD = (1/2)*Sehd_ad*mu_yEHD*(a*theta_ehd*mu_yEHD+2*a*theta_ehd*mu_WyEHD+a*mu_WzEHD+delta1*theta_ehd*mu_WzEHD+...
         delta0*mu_WzEHD+delta2*theta_ehd^2*mu_WzEHD+a*mu_zEHD+delta1*theta_ehd*mu_zEHD+delta0*mu_zEHD+delta2*...
         theta_ehd^2*mu_zEHD+delta1*theta_ehd*lambda_i*k_lambdazEHD+delta2*theta_ehd^2*lambda_i*k_lambdazEHD+...
         delta0*lambda_i*k_lambdazEHD+a*lambda_i*k_lambdazEHD+2*a*theta_ehd*lambda_i*k_lambdayEHD);

CD_EHD = delta0+delta1*alpha_EHD+delta2*alpha_EHD^2;
CL_EHD = a*alpha_EHD;


else
 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%   RESTO DE MODELOS DE FUERZAS: ALVARO, MIXTO, ELASTICO
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        alphaClEHdat = MHAdim.EHDerecho.AirfdataEHD.alphaClEHdat;
        ClEHdat = MHAdim.EHDerecho.AirfdataEHD.ClEHdat;
    
        alphaCdEHdat = MHAdim.EHDerecho.AirfdataEHD.alphaCdEHdat;
        CdEHdat = MHAdim.EHDerecho.AirfdataEHD.CdEHdat;
    
        alphaCmEHdat = MHAdim.EHDerecho.AirfdataEHD.alphaCmEHdat;
        CmEHdat = MHAdim.EHDerecho.AirfdataEHD.CmEHdat;
          
        CD_EHD = interp1(alphaCdEHdat,CdEHdat,alpha_EHD);
        CL_EHD = interp1(alphaClEHdat,ClEHdat,alpha_EHD); 

    C_XEHDinEHD = 0;
    C_YEHDinEHD = (1/2)*Sehd_ad*V_EHD^2*(-CL_EHD*sin(phi_EHD)+CD_EHD*cos(phi_EHD));
    C_ZEHDinEHD = (1/2)*Sehd_ad*V_EHD^2*(CL_EHD*cos(phi_EHD)+CD_EHD*sin(phi_EHD)); 
    
end    
    
