function [beta0,beta1c,beta1s] = batimiento_omega(theta0,theta1c,theta1s,mu_xA,mu_yA,mu_zA,mu_WxA,mu_WyA,mu_WzA,omxA,omyA,omzA,lambda_i,MHAdim)

% Ojo he modificado el MHADIM

lambda_beta = MHAdim.Pala_RP.lambda_beta;
e_ad = MHAdim.Pala_RP.e_ad; gama = MHAdim.Pala_RP.gamma ;

theta1 = MHAdim.Pala_RP.theta1;

ModAcc = MHAdim.Analisis.ModeloAcciones;

epsilon_R = MHAdim.Pala_RP.epsilon_R;
  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%   Modelo Alvaro
%

% Términos inerciales

Mibeta_11 = lambda_beta^2;
Mibeta_12 = 0;
Mibeta_13 = 0;
Mibeta_21 = 0;
Mibeta_22 = lambda_beta^2-1;
Mibeta_23 = 0;
Mibeta_31 = 0;
Mibeta_32 = 0;
Mibeta_33 = lambda_beta^2-1;

Mitheta_11 = 0;
Mitheta_12 = 0;
Mitheta_13 = 0;
Mitheta_21 = 0;
Mitheta_22 = 0;
Mitheta_23 = 0;
Mitheta_31 = 0;
Mitheta_32 = 0;
Mitheta_33 = 0;

Miomega_11 = -epsilon_R*mu_yA;
Miomega_12 = epsilon_R*mu_xA;
Miomega_13 = 0;
Miomega_21 = 2*(e_ad*epsilon_R+1);
Miomega_22 = 0;
Miomega_23 = 0;
Miomega_31 = 0;
Miomega_32 = 2*(e_ad*epsilon_R+1);
Miomega_33 = 0;

Vi_ind = [0;0;0];

%Términos aerodinámicos

Mabeta_11 = -(1/4)*(mu_yA+mu_WyA)*(mu_xA+mu_WxA)*(2*e_ad-1)*gama;
Mabeta_12 = -(1/6)*(mu_xA+mu_WxA)*(3*e_ad*theta1*lambda_i-3*e_ad-2*lambda_i*theta1+1)*gama;
Mabeta_13 = -(1/12)*(mu_yA+mu_WyA)*(3*e_ad-2)*gama;
Mabeta_21 = -(1/12)*(mu_xA+mu_WxA)*(3*e_ad-2)*gama;
Mabeta_22 = -(1/4)*(mu_yA+mu_WyA)*(mu_xA+mu_WxA)*(2*e_ad-1)*gama;
Mabeta_23 = (-(1/3)*e_ad+(1/2)*e_ad*lambda_i^2+(1/2)*e_ad*lambda_i*(mu_zA+mu_WzA)+(1/2)*e_ad*(mu_yA+mu_WyA)^2-...
    (1/2)*e_ad*(mu_xA+mu_WxA)^2+(1/3)*e_ad*theta1*lambda_i-(1/4)*(mu_yA+mu_WyA)^2+(1/4)*(mu_xA+mu_WxA)^2+1/8-(1/4)*...
    lambda_i*(mu_zA+mu_WzA)-(1/4)*lambda_i*theta1-(1/4)*lambda_i^2)*gama;

Mabeta_31 = -(1/12)*(mu_yA+mu_WyA)*(3*e_ad-2)*gama;
Mabeta_32 = -(-(1/3)*e_ad+(1/2)*e_ad*lambda_i*(mu_zA+mu_WzA)+(1/3)*e_ad*theta1*lambda_i+(1/2)*e_ad*lambda_i^2+1/8-(1/4)*...
    lambda_i*theta1-(1/4)*lambda_i^2-(1/4)*lambda_i*(mu_zA+mu_WzA))*gama;
Mabeta_33 = -(1/4)*(mu_yA+mu_WyA)*(mu_xA+mu_WxA)*(2*e_ad-1)*gama;

Matheta_11 = ((1/2)*e_ad*(mu_xA+mu_WxA)^2+(1/6)*e_ad-1/8-(1/4)*(mu_xA+mu_WxA)^2)*gama;
Matheta_12 = 0;
Matheta_13 = (1/6)*(mu_xA+mu_WxA)*(3*e_ad-2)*gama;
Matheta_21 = -(1/6)*(mu_yA+mu_WyA)*(3*e_ad-2)*gama;
Matheta_22 = ((1/2)*e_ad*(mu_xA+mu_WxA)^2+(1/6)*e_ad-1/8-(1/4)*(mu_xA+mu_WxA)^2)*gama;
Matheta_23 = -(1/2)*(mu_yA+mu_WyA)*(mu_xA+mu_WxA)*(2*e_ad-1)*gama;
Matheta_31 = (1/6)*(mu_xA+mu_WxA)*(3*e_ad-2)*gama;
Matheta_32 = 0;
Matheta_33 = ((1/2)*e_ad*(mu_xA+mu_WxA)^2+(1/6)*e_ad-1/8-(1/4)*(mu_xA+mu_WxA)^2)*gama;


Maomega_11 = -1/4*gama*e_ad*mu_xA-1/4*gama*e_ad*mu_WxA+1/6*gama*mu_xA+1/6*gama*mu_WxA;
Maomega_12 = 0;
Maomega_13 = 1/4*gama*e_ad*mu_zA+1/4*gama*e_ad*mu_WzA+1/4*gama*e_ad*theta1+1/4*gama*e_ad*lambda_i-1/6*gama*mu_WzA-1/6*gama*mu_zA...
    -1/6*gama*lambda_i-1/5*gama*theta1;
Maomega_21 = 0;
Maomega_22 = 1/6*gama*e_ad-1/8*gama;
Maomega_23 = -1/3*gama*e_ad*theta1*mu_WyA-1/3*gama*e_ad*theta1*mu_yA+1/4*gama*theta1*mu_WyA+1/4*gama*theta1*mu_yA;
Maomega_31 = -1/6*gama*e_ad+1/8*gama;
Maomega_32 = 0;
Maomega_33 = 1/3*gama*e_ad*theta1*mu_WxA+1/3*gama*e_ad*theta1*mu_xA-1/4*gama*theta1*mu_WxA-1/4*gama*theta1*mu_xA;



Va_ind =[1/120*(30*e_ad*lambda_i+30*e_ad*(mu_zA+mu_WzA)+15*e_ad*theta1+30*e_ad*theta1*(mu_xA+mu_WxA)^2-20*...
    lambda_i-12*theta1-20*(mu_zA+mu_WzA)-20*theta1*(mu_xA+mu_WxA)^2)*gama;...
    -1/12*(mu_yA+mu_WyA)*(6*e_ad*lambda_i+6*e_ad*(mu_zA+mu_WzA)+4*e_ad*theta1-3*(mu_zA+mu_WzA)-3*theta1-3*lambda_i)*gama;...
    1/12*(mu_xA+mu_WxA)*(6*e_ad*lambda_i+6*e_ad*(mu_zA+mu_WzA)+4*e_ad*theta1-3*(mu_zA+mu_WzA)-3*theta1-3*lambda_i)*gama];


Mi_beta = [Mibeta_11,Mibeta_12,Mibeta_13; Mibeta_21,Mibeta_22,Mibeta_23; Mibeta_31,Mibeta_32,Mibeta_33];
Ma_beta = [Mabeta_11,Mabeta_12,Mabeta_13; Mabeta_21,Mabeta_22,Mabeta_23; Mabeta_31,Mabeta_32,Mabeta_33];
M_beta = Mi_beta+Ma_beta;


Mi_theta = [Mitheta_11,Mitheta_12,Mitheta_13; Mitheta_21,Mitheta_22,Mitheta_23; Mitheta_31,Mitheta_32,Mitheta_33];
Ma_theta = [Matheta_11,Matheta_12,Matheta_13; Matheta_21,Matheta_22,Matheta_23; Matheta_31,Matheta_32,Matheta_33];
M_theta = Mi_theta+Ma_theta;

Mi_omega = [Miomega_11,Miomega_12,Miomega_13; Miomega_21,Miomega_22,Miomega_23; Miomega_31,Miomega_32,Miomega_33];
Ma_omega = [Maomega_11,Maomega_12,Maomega_13; Maomega_21,Maomega_22,Maomega_23; Maomega_31,Maomega_32,Maomega_33];
M_omega = Mi_omega+Ma_omega;

V_ind = Vi_ind+Va_ind;


M_beta_invertida = inv(M_beta);
thetas = [theta0;theta1c;theta1s];
omega = [omxA;omyA;omzA];
terminoindep = V_ind;

betas = -M_beta_invertida*(M_theta*thetas+M_omega*omega+terminoindep);
beta0 = betas(1); beta1c = betas(2); beta1s = betas(3);

end

