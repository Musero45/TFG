function [CMH_rainARA,CMY_rainARA,CMT_rainARA] = momento_antipar(MHAdim,theta0RA,lambda_iRA,...
    mu_xAra,mu_yAra,mu_zAra,mu_WxAra,mu_WyAra,mu_WzAra)


a = MHAdim.Pala_RA.a;
delta0 = MHAdim.Pala_RA.delta0; delta1 = MHAdim.Pala_RA.delta1; delta2 = MHAdim.Pala_RA.delta2;

%e_ad = MHAdim.Pala_RA.e_ad; %OJO, no hay excentricidad en el modelo
sigma_ra = MHAdim.Pala_RA.sigma;
theta1 = MHAdim.Pala_RA.theta1; 

epsilon_ra=MHAdim.epsilon_ra;

%CREACION DE L0S MATRICES DEL SISTEMA(solo se coge theta0RA como variable)
%VECTOR INDEPENDIENTE
CMRAind_1 = (1/8)*a*sigma_ra*mu_xAra*(mu_zAra+theta1+mu_WzAra+lambda_iRA);
CMRAind_2 = 0;
CMRAind_3 = -(1/120)*sigma_ra*(15*delta0+20*mu_zAra*delta1+15*delta0*mu_xAra^2+12*theta1*delta1+...
              10*delta1*mu_xAra^2*theta1+20*lambda_iRA*delta1+20*mu_WzAra*delta1+30*delta0*mu_xAra*mu_WxAra);

%VECTOR INDEPENDIENTE (tercera componente Alvaro)

%  CMRAind_3 = (1/8*sigma_ra*theta1*lambda_iRA+1/8*sigma_ra*theta1*(mu_zAra+mu_WzAra)+1/4*sigma_ra*lambda_iRA^2+1/2*sigma_ra*(mu_zAra+mu_WzAra)*...
%     lambda_iRA+1/4*sigma_ra*(mu_zAra+mu_WzAra)^2)*a+1/240*sigma_ra*(-30*delta0-20*delta2*theta1^2-24*delta1*theta1)+1/240*sigma_ra*...
%     (-60*delta2*theta1-40*delta1)*(mu_zAra+mu_WzAra)+1/240*sigma_ra*(-30*delta0-15*delta2*theta1^2-20*delta1*theta1)*(mu_yAra+mu_WyAra)^2+...
%     1/240*sigma_ra*(-60*delta2*theta1-40*delta1)*lambda_iRA+1/240*sigma_ra*(-30*delta0-15*delta2*theta1^2-20*delta1*theta1)*(mu_xAra+mu_WxAra)^2-...
%     1/4*sigma_ra*delta2*lambda_iRA^2-1/2*sigma_ra*delta2*(mu_zAra+mu_WzAra)*lambda_iRA-1/4*sigma_ra*delta2*(mu_zAra+mu_WzAra)^2;        
          
          
%VECTOR DE LOS TERMINOS PROPORCIONALES A THETA0

CMRAtheta_1 = (1/6)*a*sigma_ra*(+mu_WxAra);

CMRAtheta_2 = (1/6)*a*sigma_ra*(mu_WyAra+mu_yAra);

CMRAtheta_3 = (1/120)*sigma_ra*(-15*mu_xAra^2*delta1-15*delta1-20*theta1*mu_xAra^2*delta2-...
               24*theta1*delta2-30*mu_WxAra*mu_xAra*delta1+20*mu_WzAra*a-40*mu_WzAra*delta2+...
               20*mu_zAra*a-40*mu_zAra*delta2+20*lambda_iRA*a-40*lambda_iRA*delta2);

%VECTOR proporcional a theta0 (tercera componente Alvaro)

% CMRAtheta_3 = (1/6*sigma_ra*lambda_iRA+1/6*sigma_ra*(mu_zAra+mu_WzAra))*a+1/240*sigma_ra*(-30*delta1-48*delta2*theta1)-...
%     1/3*sigma_ra*delta2*(mu_zAra+mu_WzAra)+1/240*sigma_ra*(-30*delta1-40*delta2*theta1)*(mu_yAra+mu_WyAra)^2-...
%     1/3*sigma_ra*delta2*lambda_iRA+1/240*sigma_ra*(-30*delta1-40*delta2*theta1)*(mu_xAra+mu_WxAra)^2;           
%            
           
%ORDENACION DE LAS MATRICES DEL SISTEMA
V_theta = [CMRAtheta_1; CMRAtheta_2; CMRAtheta_3];
V_indep = [CMRAind_1;CMRAind_2;CMRAind_3];


CMRA = V_theta*theta0RA+V_indep;


% MOMENTOS CORREGIDOS ALVARO NL

  CMRA = CM_RANolineal(MHAdim,theta0RA,lambda_iRA,...
     mu_xAra,mu_yAra,mu_zAra,mu_WxAra,mu_WyAra,mu_WzAra);

CMH_rainARA = CMRA(1); CMY_rainARA = CMRA(2); CMT_rainARA = CMRA(3);

% CMH_rainARA = 0; CMY_rainARA = 0;% CMT_rainARA = 0;

end