% Función de prueba de fuerza del rotor 01

clear all

format long


theta0 = 0.30070464482031;
theta1c = 0.05181341861191;
theta1s = -0.04255047072930;
beta0 = 0.14927293607006;
beta1c = -0.05753670581640;
beta1s = 0.01081011868076;
lambda_i = -0.04022259791630;

% mu_xA = 0.22516421547832;
% mu_yA = -2.934154348262831e-004;
% mu_zA = -0.01138175546401;

mu_xA = 0;
mu_yA = 0;
mu_zA = 0;

mu_WxA = 0;
mu_WyA = 0;
mu_WzA = 0;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
%Añadimos todas las carpetas del programa para el cálculo
    %path_loader;
%Creación de la supervariable y de otras variables
    [HM] = Helimodel;
    [Atm] = ISA(HM.altura);

    %Para el caso de polar linealizada para todos los elementos
    rango = [-15 10]*pi/180;
    [HM] = polarlineal(HM,rango);

%Creacion de los parametros adimensionales para las ecuaciones
    [MHAdim] = Adimensionalizacion(HM,Atm);

%CREACIÓN DE UN BUCLE PARA CALCULAR LA EVOLUCIÓN AL VARIAR ALGÚN PARÁMETRO.

    rho = MHAdim.rho;
    R = MHAdim.Pala_RP.R;
    Rra = MHAdim.Pala_RA.R;
    Omega = MHAdim.Pala_RP.Omega;
    Omega_ra = MHAdim.Pala_RA.Omega;


    %ModAcc = MHAdim.ModeloAcciones;

    a = MHAdim.Pala_RP.a;
    delta0 = MHAdim.Pala_RP.delta0; delta1 = MHAdim.Pala_RP.delta1; delta2 = MHAdim.Pala_RP.delta2;

%     delta1 = 0;
%     delta2 = 0;
    
    
    e_ad = MHAdim.Pala_RP.e_ad;
    sigma = MHAdim.Pala_RP.sigma;
    theta1 = MHAdim.Pala_RP.theta1;
    m_k = MHAdim.Pala_RP.m_k;
    m_e = MHAdim.Pala_RP.m_e;
    b = MHAdim.Pala_RP.b;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%   CREACION DE LAS MATRICES DEL SISTEMA
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%   MODELO DE FUERZAS SEGUN ASE
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%   VECTOR INDEPENDIENTE SEGÚN ASE


CFRind_1 = (1/12)*sigma*(3*mu_xA+3*mu_WxA)*delta0+(1/12)*sigma*(-3*e_ad*mu_xA*lambda_i+2*theta1*mu_xA-...
           3*e_ad*mu_xA*mu_zA+3*lambda_i*mu_xA+3*mu_WzA*mu_xA+3*mu_zA*mu_xA-3*e_ad*mu_xA*mu_WzA)*delta1;
CFRind_2 = (1/4)*sigma*delta0*(mu_yA+mu_WyA);
CFRind_3 = (1/8)*a*sigma*(2*lambda_i+2*mu_WzA+2*mu_zA+theta1+mu_xA^2*theta1);

%MATRIZ DE LOS TERMINOS PROPORCIONALES A LAS BETAS SEGUN ASE

CFRbeta_11 = -(1/8)*sigma*delta1*(mu_yA+mu_WyA);
CFRbeta_12 = -(1/48)*sigma*(3*theta1+6*mu_zA+6*lambda_i+6*mu_WzA)*a-(1/48)*sigma*(12*lambda_i+...
              12*e_ad-8)*delta0-(1/48)*sigma*(6*mu_xA*mu_WxA+12*mu_WzA*e_ad+12*lambda_i*e_ad-6*...
              e_ad*mu_xA*mu_WxA-6*mu_WzA+3*mu_xA^2-6*lambda_i+12*mu_zA*e_ad+8*e_ad*theta1-3*e_ad*...
              mu_xA^2-6*theta1-6*mu_zA)*delta1-(1/16)*sigma*mu_xA^2*theta1*delta2;
CFRbeta_13 = (1/8)*sigma*mu_xA*delta1*(e_ad*mu_yA+e_ad*mu_WyA-mu_WyA-mu_yA);
           
CFRbeta_21 = (1/24)*sigma*(-18*lambda_i*mu_xA+18*e_ad*mu_xA*lambda_i-18*mu_zA*mu_xA+18*e_ad*mu_xA*...
             mu_zA-6*theta1*mu_xA+18*e_ad*mu_xA*mu_WzA-18*mu_WzA*mu_xA)*a+(1/24)*sigma*(3*mu_xA+3*mu_WxA)*...
             delta1+(1/24)*sigma*(-12*e_ad*mu_xA*mu_zA+12*mu_zA*mu_xA+12*lambda_i*mu_xA-12*e_ad*mu_xA*...
             lambda_i+4*theta1*mu_xA-12*e_ad*mu_xA*mu_WzA+12*mu_WzA*mu_xA)*delta2;
CFRbeta_22 = (1/8)*sigma*mu_xA*delta1*(mu_yA+mu_WyA)*(e_ad-1);
CFRbeta_23 = -(1/48)*sigma*(6*mu_zA+6*mu_xA^2*theta1+6*lambda_i+3*theta1+6*mu_WzA)*a-(1/48)*sigma*...
             (12*lambda_i+12*e_ad-8)*delta0-(1/48)*sigma*(-6*mu_xA*mu_WxA-6*mu_WzA-6*theta1-6*mu_zA-3*...
             mu_xA^2+8*e_ad*theta1-6*lambda_i+6*e_ad*mu_xA*mu_WxA+12*mu_WzA*e_ad+12*mu_zA*e_ad+12*lambda_i*...
             e_ad+3*e_ad*mu_xA^2)*delta1+(1/16)*sigma*mu_xA^2*theta1*delta2;
             
CFRbeta_31 = 0;
CFRbeta_32 = -(1/24)*a*sigma*(3*mu_xA-4*theta1*mu_xA+3*mu_WxA+6*e_ad*mu_xA*theta1);
CFRbeta_33 = -(1/8)*a*sigma*(mu_yA+mu_WyA);

%MATRIZ DE LOS TERMINOS PROPORCIONALES A LAS THETAS SEGUN ASE

CFRtheta_11 = (1/12)*sigma*(3*e_ad*mu_xA*mu_WzA+3*e_ad*mu_xA*mu_zA-3*mu_zA*mu_xA+3*e_ad*mu_xA*...
              lambda_i-3*mu_WzA*mu_xA-3*lambda_i*mu_xA)*a+(1/12)*sigma*(3*mu_xA+3*mu_WxA)*delta1+...
              (1/12)*sigma*(4*theta1*mu_xA-6*e_ad*mu_xA*mu_zA+6*mu_WzA*mu_xA-6*e_ad*mu_xA*lambda_i-6*...
              e_ad*mu_xA*mu_WzA+6*mu_zA*mu_xA+6*lambda_i*mu_xA)*delta2;
CFRtheta_12 = (1/8)*sigma*mu_xA*delta1*(mu_yA+mu_WyA)*(e_ad-1);
CFRtheta_13 = -(1/48)*sigma*(6*lambda_i+6*mu_zA+6*mu_WzA)*a-(1/48)*sigma*(-18*mu_xA*mu_WxA-4+18*e_ad*...
               mu_xA*mu_WxA-9*mu_xA^2+9*e_ad*mu_xA^2)*delta1-(1/48)*sigma*(-12*mu_zA-9*mu_xA^2*theta1-...
               6*theta1-12*lambda_i-12*mu_WzA)*delta2;

CFRtheta_21 = (1/4)*sigma*delta1*(mu_yA+mu_WyA);
CFRtheta_22 = (1/48)*sigma*(6*lambda_i+6*mu_zA+6*mu_WzA)*a+(1/48)*sigma*(-6*mu_xA*mu_WxA-3*mu_xA^2+...
              3*e_ad*mu_xA^2-4+6*e_ad*mu_xA*mu_WxA)*delta1+(1/48)*sigma*(-3*mu_xA^2*theta1-12*mu_WzA-...
              6*theta1-12*mu_zA-12*lambda_i)*delta2;
CFRtheta_23 = -(1/8)*sigma*mu_xA*delta1*(mu_yA+mu_WyA)*(e_ad-1);

CFRtheta_31 = -(1/12)*a*sigma*(-2-6*mu_xA*mu_WxA-3*mu_xA^2+6*e_ad*mu_xA*mu_WxA+3*e_ad*mu_xA^2);
CFRtheta_32 = -(1/4)*a*sigma*(mu_yA+mu_WyA);
CFRtheta_33 = (1/4)*a*sigma*(mu_xA+mu_WxA);
              
%ORDENACION DE LAS MATRICES DEL SISTEMA

M_beta_ASE = [CFRbeta_11,CFRbeta_12,CFRbeta_13; CFRbeta_21,CFRbeta_22,CFRbeta_23; CFRbeta_31,CFRbeta_32,CFRbeta_33];
M_theta_ASE = [CFRtheta_11,CFRtheta_12,CFRtheta_13; CFRtheta_21,CFRtheta_22,CFRtheta_23; CFRtheta_31,CFRtheta_32,CFRtheta_33];
V_indep_ASE = [CFRind_1;CFRind_2;CFRind_3];

 betas = [beta0; beta1c ;beta1s];
 thetas = [theta0; theta1c; theta1s];
 
 CFR_ASE = M_beta_ASE*betas+M_theta_ASE*thetas+V_indep_ASE;
 CHinA_ASE = CFR_ASE(1); CYinA = CFR_ASE(2); CTinA = CFR_ASE(3);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%   CREACION DE LAS MATRICES DEL SISTEMA
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%   MODELO DE FUERZAS SEGUN ALVARO
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%   VECTOR INDEPENDIENTE SEGÚN ALVARO

CFRind_1 = ((1/4)*sigma*delta0*(mu_xA+mu_WxA)+(1/48)*sigma*(-12*e_ad*delta1+12*delta1)*(mu_zA+mu_WzA)*(mu_xA+mu_WxA)+...
    (1/48)*sigma*(-12*e_ad*delta1+12*delta1)*lambda_i*(mu_xA+mu_WxA)+(1/6)*sigma*delta1*theta1*(mu_xA+mu_WxA));

CFRind_2 = ((1/4)*sigma*delta0*(mu_yA+mu_WyA)-(1/48)*sigma*(12*e_ad*delta1-12*delta1)*(mu_zA+mu_WzA)*(mu_yA+mu_WyA)-...
    (1/48)*sigma*(12*e_ad*delta1-12*delta1)*lambda_i*(mu_yA+mu_WyA)+(1/6)*sigma*delta1*theta1*(mu_yA+mu_WyA));

CFRind_3 = ((1/4)*sigma*(mu_zA+mu_WzA)+(1/4)*sigma*lambda_i+(1/8)*sigma*theta1)*a;

%MATRIZ DE LOS TERMINOS PROPORCIONALES A LAS BETAS SEGUN ALVARO


CFRbeta_11 = ((1/48)*sigma*(-36*e_ad+36)*(mu_zA+mu_WzA)*(mu_yA+mu_WyA)+(1/48)*sigma*(-36*e_ad+36)*lambda_i*(mu_yA+mu_WyA)+(1/4)*...
    sigma*theta1*(mu_yA+mu_WyA))*a-(1/8)*sigma*delta1*(mu_yA+mu_WyA)+(1/48)*sigma*(24*e_ad*delta2-24*delta2)*...
    (mu_zA+mu_WzA)*(mu_yA+mu_WyA)+(1/48)*sigma*(24*e_ad*delta2-24*delta2)*lambda_i*(mu_yA+mu_WyA)-(1/6)*sigma*delta2*theta1*(mu_yA+mu_WyA);

CFRbeta_12 = ((1/48)*sigma*(-18+24*e_ad)*(mu_zA+mu_WzA)+(1/48)*sigma*(-18+24*e_ad)*lambda_i+(1/48)*sigma*(4*e_ad-6)*theta1)*...
    a+(1/48)*sigma*(4*delta1-6*e_ad*delta1)+(1/48)*sigma*(-24*e_ad*delta2+12*delta2)*(mu_zA+mu_WzA)-(1/6)*...
    sigma*delta1*theta1*lambda_i+(1/48)*sigma*(-12*delta0+12*delta2-24*e_ad*delta2)*lambda_i+(1/48)*...
    sigma*(-3*e_ad*delta1+3*delta1)*(mu_yA+mu_WyA)^2+(1/48)*sigma*(-8*e_ad*delta2+6*delta2)*theta1+(1/48)*sigma*...
    (3*e_ad*delta1-3*delta1)*(mu_xA+mu_WxA)^2+(1/48)*sigma*(12*e_ad*delta1-12*delta1)*lambda_i*(mu_zA+mu_WzA);

CFRbeta_13 = (1/48)*sigma*(6*e_ad*delta1-6*delta1)*(mu_yA+mu_WyA)*(mu_xA+mu_WxA);

CFRbeta_21 = (-(1/48)*sigma*(-36*e_ad+36)*(mu_zA+mu_WzA)*(mu_xA+mu_WxA)-(1/48)*sigma*(-36*e_ad+36)*lambda_i*(mu_xA+mu_WxA)-(1/4)*sigma*...
    theta1*(mu_xA+mu_WxA))*a+(1/8)*sigma*delta1*(mu_xA+mu_WxA)-(1/48)*sigma*(24*e_ad*delta2-24*delta2)*(mu_zA+mu_WzA)*(mu_xA+mu_WxA)-...
    (1/48)*sigma*(24*e_ad*delta2-24*delta2)*lambda_i*(mu_xA+mu_WxA)+(1/6)*sigma*delta2*theta1*(mu_xA+mu_WxA);

CFRbeta_22 = -(1/48)*sigma*(6*delta1-6*e_ad*delta1)*(mu_yA+mu_WyA)*(mu_xA+mu_WxA);

CFRbeta_23 = (-(1/48)*sigma*(18-24*e_ad)*(mu_zA+mu_WzA)-(1/48)*sigma*(18-24*e_ad)*lambda_i-...
    (1/48)*sigma*(-4*e_ad+6)*theta1)*a-(1/48)*sigma*(-4*delta1+6*e_ad*delta1)-(1/48)*sigma*...
    (24*e_ad*delta2-12*delta2)*(mu_zA+mu_WzA)-(1/6)*sigma*delta1*theta1*lambda_i-(1/48)*sigma*...
    (24*e_ad*delta2+12*delta0-12*delta2)*lambda_i-(1/48)*sigma*(-3*e_ad*delta1+3*delta1)*(mu_yA+mu_WyA)^2-(1/48)*...
    sigma*(-6*delta2+8*e_ad*delta2)*theta1-(1/48)*sigma*(3*e_ad*delta1-3*delta1)*(mu_xA+mu_WxA)^2-...
    (1/48)*sigma*(-12*e_ad*delta1+12*delta1)*lambda_i*(mu_zA+mu_WzA);

CFRbeta_31 = 0;

CFRbeta_32 = -(1/4)*sigma*a*(mu_xA+mu_WxA)*e_ad;

CFRbeta_33 = -(1/4)*sigma*a*e_ad*(mu_yA+mu_WyA);

%MATRIZ DE LOS TERMINOS PROPORCIONALES A LAS THETAS SEGUN ALVARO

CFRtheta_11 = ((1/48)*sigma*(12*e_ad-12)*(mu_zA+mu_WzA)*(mu_xA+mu_WxA)+(1/48)*sigma*(12*e_ad-12)*lambda_i*(mu_xA+mu_WxA))*a+(1/4)*sigma*delta1*...
    (mu_xA+mu_WxA)+(1/48)*sigma*(-24*e_ad*delta2+24*delta2)*(mu_zA+mu_WzA)*(mu_xA+mu_WxA)+(1/48)*sigma*(-24*e_ad*delta2+24*delta2)*...
    lambda_i*(mu_xA+mu_WxA)+(1/3)*sigma*delta2*theta1*(mu_xA+mu_WxA);

CFRtheta_12 = (1/48)*sigma*(6*e_ad*delta1-6*delta1)*(mu_yA+mu_WyA)*(mu_xA+mu_WxA);

CFRtheta_13 = (-(1/8)*sigma*lambda_i-(1/8)*sigma*(mu_zA+mu_WzA))*a+(1/12)*sigma*delta1+(1/4)*sigma*delta2*...
    (mu_zA+mu_WzA)+(1/48)*sigma*(9*delta1-9*e_ad*delta1)*(mu_xA+mu_WxA)^2+(1/4)*sigma*delta2*lambda_i+(1/8)*sigma*delta2*...
    theta1+(1/48)*sigma*(-3*e_ad*delta1+3*delta1)*(mu_yA+mu_WyA)^2;

CFRtheta_21 = (-(1/48)*sigma*(12-12*e_ad)*(mu_zA+mu_WzA)*(mu_yA+mu_WyA)-(1/48)*sigma*(12-12*e_ad)*lambda_i*(mu_yA+mu_WyA))*a+...
    (1/4)*sigma*delta1*(mu_yA+mu_WyA)-(1/48)*sigma*(24*e_ad*delta2-24*delta2)*(mu_zA+mu_WzA)*(mu_yA+mu_WyA)-...
    (1/48)*sigma*(24*e_ad*delta2-24*delta2)*lambda_i*(mu_yA+mu_WyA)+(1/3)*sigma*delta2*theta1*(mu_yA+mu_WyA);

CFRtheta_22 = ((1/8)*sigma*lambda_i+(1/8)*sigma*(mu_zA+mu_WzA))*a-(1/12)*sigma*delta1-(1/4)*sigma*delta2*(mu_zA+mu_WzA)-...
    (1/48)*sigma*(-3*e_ad*delta1+3*delta1)*(mu_xA+mu_WxA)^2-(1/4)*sigma*delta2*lambda_i-(1/8)*sigma*delta2*...
    theta1-(1/48)*sigma*(9*delta1-9*e_ad*delta1)*(mu_yA+mu_WyA)^2;

CFRtheta_23 = -(1/48)*sigma*(6*e_ad*delta1-6*delta1)*(mu_yA+mu_WyA)*(mu_xA+mu_WxA);

CFRtheta_31 = ((1/6)*sigma-(1/24)*sigma*(-6+6*e_ad)*(mu_yA+mu_WyA)^2-(1/24)*sigma*(-6+6*e_ad)*(mu_xA+mu_WxA)^2)*a;

CFRtheta_32 = -(1/4)*sigma*a*(mu_yA+mu_WyA);

CFRtheta_33 = (1/4)*sigma*a*(mu_xA+mu_WxA);


% ORDENACION DE LAS MATRICES DEL SISTEMA


M_beta_Alvaro = [CFRbeta_11,CFRbeta_12,CFRbeta_13; CFRbeta_21,CFRbeta_22,CFRbeta_23; CFRbeta_31,CFRbeta_32,CFRbeta_33];
M_theta_Alvaro = [CFRtheta_11,CFRtheta_12,CFRtheta_13; CFRtheta_21,CFRtheta_22,CFRtheta_23; CFRtheta_31,CFRtheta_32,CFRtheta_33];
V_indep_Alvaro = [CFRind_1;CFRind_2;CFRind_3];

CFR_Alvaro = M_beta_Alvaro*betas+M_theta_Alvaro*thetas+V_indep_Alvaro;


V_indep_ASE = V_indep_ASE
V_indep_Alvaro = V_indep_Alvaro

M_beta_ASE = M_beta_ASE
M_beta_Alvaro = M_beta_Alvaro

M_theta_ASE = M_theta_ASE
M_theta_Alvaro = M_theta_Alvaro

CFR_ASE = CFR_ASE 
CFR_Alvaro = CFR_Alvaro





