function [C_XEVinEV,C_YEVinEV,C_ZEVinEV,phi_EV,alpha_EV,CD_EV,CL_EV] = fza_e_vertical(MHAdim,k_lambdaEV,mu_xEV,mu_yEV,mu_zEV,mu_WxEV,...
    mu_WyEV,mu_WzEV,lambda_iRA)

kEV = MHAdim.Analisis.kEV;

k_lambdaxEV = kEV*k_lambdaEV(1);
k_lambdayEV = kEV*k_lambdaEV(2);
k_lambdazEV = kEV*k_lambdaEV(3);

% k_lambdaxEV = k_lambdaEV;   k_lambdayEV = k_lambdaEV;   k_lambdazEV = k_lambdaEV;

ModAcc = MHAdim.Analisis.ModeloAcciones;

%Carga de variables geometricas
Sev_ad = MHAdim.EVertical.Sev_ad;
theta_ev = MHAdim.EVertical.theta_ev;

%Carga de la polar
a = 0*MHAdim.EVertical.a;
delta0 = MHAdim.EVertical.delta0; delta1 = 0*MHAdim.EVertical.delta1; delta2 = 0*MHAdim.EVertical.delta2;


phi_EV = atan2((mu_zEV + mu_WzEV),(mu_yEV + mu_WyEV));

V_EV = sqrt((mu_xEV+mu_WxEV)^2 + ...
           (mu_yEV+mu_WyEV)^2 + ...
           (mu_zEV+mu_WzEV+0*lambda_iRA)^2);

alpha_EV = phi_EV+theta_ev;

if strcmp(ModAcc,'ASE')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%   MODELO DE FUERZAS SEGUN ASE
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

C_XEVinEV = 0;

C_YEVinEV = (1/2)*Sev_ad*mu_yEV*(delta2*theta_ev^2*mu_yEV+delta0*mu_yEV+delta1*theta_ev*mu_yEV+2*mu_WyEV*delta2*...
         theta_ev^2+2*mu_WyEV*delta0+2*mu_WyEV*delta1*theta_ev+delta1*mu_WzEV+a*theta_ev*mu_WzEV+2*delta2*...
         theta_ev*mu_WzEV+delta1*mu_zEV+a*theta_ev*mu_zEV+2*delta2*theta_ev*mu_zEV+2*delta1*theta_ev*lambda_iRA*...
         k_lambdayEV+2*delta2*theta_ev*lambda_iRA*k_lambdazEV+2*delta0*lambda_iRA*k_lambdayEV+delta1*...
         lambda_iRA*k_lambdazEV+a*theta_ev*lambda_iRA*k_lambdazEV+2*delta2*theta_ev^2*lambda_iRA*k_lambdayEV);
         

C_ZEVinEV = (1/2)*Sev_ad*mu_yEV*(a*theta_ev*mu_yEV+2*a*theta_ev*mu_WyEV+delta1*theta_ev*mu_WzEV+delta2*theta_ev^2*...
         mu_WzEV+delta0*mu_WzEV+a*mu_WzEV+delta1*theta_ev*mu_zEV+delta2*theta_ev^2*mu_zEV+delta0*mu_zEV+a*mu_zEV+...
         delta0*lambda_iRA*k_lambdazEV+a*lambda_iRA*k_lambdazEV+delta1*theta_ev*lambda_iRA*k_lambdazEV+...
         delta2*theta_ev^2*lambda_iRA*k_lambdazEV+2*a*theta_ev*lambda_iRA*k_lambdayEV);

CD_EV = delta0+delta1*alpha_EV+delta2*alpha_EV^2;
CL_EV = a*alpha_EV;

else

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%   RESTO DE MODELOS DE FUERZAS: ALVARO, MIXTO, ELASTICO
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  
        
        alphaClEVdat = MHAdim.EVertical.AirfdataEV.alphaClEVdat;
        ClEVdat = MHAdim.EVertical.AirfdataEV.ClEVdat;
    
        alphaCdEVdat = MHAdim.EVertical.AirfdataEV.alphaCdEVdat;
        CdEVdat = MHAdim.EVertical.AirfdataEV.CdEVdat;
    
        alphaCmEVdat = MHAdim.EVertical.AirfdataEV.alphaCmEVdat;
        CmEVdat = MHAdim.EVertical.AirfdataEV.CmEVdat;
          
        CD_EV = interp1(alphaCdEVdat,CdEVdat,alpha_EV);
        CL_EV = interp1(alphaClEVdat,ClEVdat,alpha_EV); 

    C_XEVinEV = 0;
    C_YEVinEV = (1/2)*Sev_ad*V_EV^2*(-CL_EV*sin(phi_EV)+CD_EV*cos(phi_EV));
    C_ZEVinEV = (1/2)*Sev_ad*V_EV^2*(CL_EV*cos(phi_EV)+CD_EV*sin(phi_EV));
    
end