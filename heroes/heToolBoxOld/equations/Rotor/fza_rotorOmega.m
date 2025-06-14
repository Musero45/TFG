function [CHinA,CYinA,CTinA] = fza_rotorOmega(MHAdim,theta0,theta1c,theta1s,beta0,beta1c,beta1s,lambda_i,mu_xA,mu_yA,mu_zA,omxA,omyA,omzA,...
                                                mu_WxA,mu_WyA,mu_WzA)

%OJO, EL RESULTADO ESTA EN EJES CUERPO

ModAcc = MHAdim.Analisis.ModeloAcciones;

HFROPP = MHAdim.Analisis.HipotesisFRPOPP;

a = MHAdim.Pala_RP.a;
delta0 = MHAdim.Pala_RP.delta0; delta1 = MHAdim.Pala_RP.delta1; delta2 = MHAdim.Pala_RP.delta2;

e_ad = MHAdim.Pala_RP.e_ad;
sigma = MHAdim.Pala_RP.sigma;
theta1 = MHAdim.Pala_RP.theta1; 

    
   CFR = CF_RPNolinealOmega(MHAdim,theta0,theta1c,theta1s,beta0,beta1c,beta1s,...
    lambda_i,mu_xA,mu_yA,mu_zA,omxA,omyA,omzA,mu_WxA,mu_WyA,mu_WzA);
   

if strcmp(HFROPP,'SI') 

CFR = cambioAfP(beta1c,beta1s,[0;0;CFR(3)]);

else

CFR = CFR;    
    
end

CHinA = CFR(1); CYinA = CFR(2); CTinA = CFR(3);

