function [C_XEHIinEHI,C_YEHIinEHI,C_ZEHIinEHI,phi_EHI,alpha_EHI,CD_EHI,CL_EHI] = fza_eh_izquierdo(MHAdim,k_lambdaEHI,mu_xEHI,mu_yEHI,...
    mu_zEHI,mu_WxEHI,mu_WyEHI,mu_WzEHI,lambda_i)

kEHI = MHAdim.Analisis.kEHI;

k_lambdaxEHI = kEHI*k_lambdaEHI(1);
k_lambdayEHI = kEHI*k_lambdaEHI(2);
k_lambdazEHI = kEHI*k_lambdaEHI(3);

% k_lambdaxEHI = k_lambdaEHI;     k_lambdayEHI = k_lambdaEHI;     k_lambdazEHI = k_lambdaEHI;

ModAcc = MHAdim.Analisis.ModeloAcciones;

%Carga de variables geometricas
Sehi_ad = MHAdim.EHIzquierdo.Sehi_ad;
theta_ehi = MHAdim.EHIzquierdo.theta_ehi;

%Carga de la polar
a = MHAdim.EHIzquierdo.a;
delta0 = MHAdim.EHIzquierdo.delta0; delta1 = MHAdim.EHIzquierdo.delta1; delta2 = MHAdim.EHIzquierdo.delta2;

phi_EHI = atan2((mu_zEHI + mu_WzEHI + lambda_i * k_lambdazEHI),(mu_yEHI + mu_WyEHI + lambda_i * k_lambdayEHI));

V_EHI = sqrt((mu_xEHI+mu_WxEHI+lambda_i*k_lambdaxEHI)^2 + ...
           (mu_yEHI+mu_WyEHI+lambda_i*k_lambdayEHI)^2 + ...
           (mu_zEHI+mu_WzEHI+lambda_i*k_lambdazEHI)^2);

alpha_EHI = phi_EHI+theta_ehi;


if strcmp(ModAcc,'ASE')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%   MODELO DE FUERZAS SEGUN ASE
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


    C_XEHIinEHI = 0;

    C_YEHIinEHI = -(1/2)*Sehi_ad*mu_yEHI*(-delta0*mu_yEHI-delta1*mu_yEHI*theta_ehi-delta2*theta_ehi^2*mu_yEHI-...
          2*delta0*mu_WyEHI-2*delta1*theta_ehi*mu_WyEHI-2*delta2*theta_ehi^2*mu_WyEHI-delta1*mu_WzEHI-...
          2*delta2*theta_ehi*mu_WzEHI+a*theta_ehi*mu_WzEHI-delta1*mu_zEHI-2*delta2*theta_ehi*mu_zEHI+...
          a*theta_ehi*mu_zEHI-2*delta2*theta_ehi^2*lambda_i*k_lambdayEHI-2*delta1*theta_ehi*lambda_i*...
          k_lambdayEHI-2*delta0*lambda_i*k_lambdayEHI-delta1*lambda_i*k_lambdazEHI+a*theta_ehi*...
          lambda_i*k_lambdazEHI-2*delta2*theta_ehi*lambda_i*k_lambdazEHI);
         

    C_ZEHIinEHI = (1/2)*Sehi_ad*mu_yEHI*(a*theta_ehi*mu_yEHI+2*a*theta_ehi*mu_WyEHI+delta0*mu_WzEHI+delta2*theta_ehi^2*...
          mu_WzEHI+delta1*theta_ehi*mu_WzEHI+a*mu_WzEHI+delta0*mu_zEHI+delta2*theta_ehi^2*mu_zEHI+delta1*...
          theta_ehi*mu_zEHI+a*mu_zEHI+a*lambda_i*k_lambdazEHI+delta2*theta_ehi^2*lambda_i*k_lambdazEHI+...
          delta0*lambda_i*k_lambdazEHI+delta1*theta_ehi*lambda_i*k_lambdazEHI+2*a*theta_ehi*lambda_i*...
          k_lambdayEHI);

    CD_EHI = delta0+delta1*alpha_EHI+delta2*alpha_EHI^2;
    CL_EHI = a*alpha_EHI;

else

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%   RESTO DE MODELOS DE FUERZAS: ALVARO, MIXTO, ELASTICO
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  
        
        alphaClEHdat = MHAdim.EHIzquierdo.AirfdataEHI.alphaClEHdat;
        ClEHdat = MHAdim.EHIzquierdo.AirfdataEHI.ClEHdat;
    
        alphaCdEHdat = MHAdim.EHIzquierdo.AirfdataEHI.alphaCdEHdat;
        CdEHdat = MHAdim.EHIzquierdo.AirfdataEHI.CdEHdat;
    
        alphaCmEHdat = MHAdim.EHIzquierdo.AirfdataEHI.alphaCmEHdat;
        CmEHdat = MHAdim.EHIzquierdo.AirfdataEHI.CmEHdat;
          
        CD_EHI = interp1(alphaCdEHdat,CdEHdat,alpha_EHI);
        CL_EHI = interp1(alphaClEHdat,ClEHdat,alpha_EHI); 

    C_XEHIinEHI = 0;
    C_YEHIinEHI = (1/2)*Sehi_ad*V_EHI^2*(-CL_EHI*sin(phi_EHI)+CD_EHI*cos(phi_EHI));
    C_ZEHIinEHI = (1/2)*Sehi_ad*V_EHI^2*(CL_EHI*cos(phi_EHI)+CD_EHI*sin(phi_EHI)); 
    
end