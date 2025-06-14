% Funci�n de prueba de momento del rotor 01

clear all

format long


theta0 = 0.30070464482031;
theta1c = 0.05181341861191;
theta1s = -0.04255047072930;
beta0 = 0.14927293607006;
beta1c = -0.05753670581640;
beta1s = 0.01081011868076;
lambda_i = -0.04022259791630;
mu_xA = 0*0.22516421547832;
mu_yA = 0*-2.934154348262831e-004;
mu_zA = 0*-0.01138175546401;
mu_WxA = 0;
mu_WyA = 0;
mu_WzA = 0;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
%A�adimos todas las carpetas del programa para el c�lculo
    %path_loader;
%Creaci�n de la supervariable y de otras variables
    [HM] = Helimodel;
    [Atm] = ISA(HM.altura);

    %Para el caso de polar linealizada para todos los elementos
    rango = [-15 10]*pi/180;
    [HM] = polarlineal(HM,rango);

%Creacion de los parametros adimensionales para las ecuaciones
    [MHAdim] = Adimensionalizacion(HM,Atm);

%CREACI�N DE UN BUCLE PARA CALCULAR LA EVOLUCI�N AL VARIAR ALG�N PAR�METRO.

    rho = MHAdim.rho;
    R = MHAdim.Pala_RP.R;
    Rra = MHAdim.Pala_RA.R;
    Omega = MHAdim.Pala_RP.Omega;
    Omega_ra = MHAdim.Pala_RA.Omega;


    %ModAcc = MHAdim.ModeloAcciones;

    a = MHAdim.Pala_RP.a;
    delta0 = MHAdim.Pala_RP.delta0; delta1 = MHAdim.Pala_RP.delta1; delta2 = MHAdim.Pala_RP.delta2;

    
    e_ad = MHAdim.Pala_RP.e_ad;
    sigma = MHAdim.Pala_RP.sigma;
    theta1 = MHAdim.Pala_RP.theta1;
    m_k = MHAdim.Pala_RP.m_k;
    m_e = MHAdim.Pala_RP.m_e;
    b = MHAdim.Pala_RP.b;

    
% Ojo he modificado el MHADIM

    lambda_beta = MHAdim.Pala_RP.lambda_beta;
    e_ad = MHAdim.Pala_RP.e_ad; gama = MHAdim.Pala_RP.gamma ;
    theta1 = MHAdim.Pala_RP.theta1;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%   Modelo ASE
%

    ec1beta0 = lambda_beta ^ 2;
    ec1beta1c = ((1/8)*mu_xA+(1/8)*mu_WxA)*gama*e_ad;
    ec1beta1s = ((1/8)*mu_yA+(1/8)*mu_WyA)*gama*e_ad;

    ec1theta0 = ((1/4)*mu_xA^2+(1/2)*mu_WyA*mu_yA+(1/4)*mu_yA^2+1/6+(1/2)*mu_WxA*mu_xA)*gama*e_ad+...
            (-(1/8)*mu_xA^2-(1/4)*mu_WxA*mu_xA-1/8-(1/8)*mu_yA^2-(1/4)*mu_WyA*mu_yA)*gama;
    ec1theta1c = -(1/12)*gama*(mu_WyA+mu_yA)*(3*e_ad-2);
    ec1theta1s = (1/12)*gama*(mu_WxA+mu_xA)*(3*e_ad-2);

    ec1indep = ((1/8+(1/8)*mu_yA^2+(1/8)*mu_xA^2)*theta1+(1/4)*mu_zA+(1/4)*mu_WzA+(1/4)*lambda_i)*gama*e_ad+...
           ((-1/10-(1/12)*mu_yA^2-(1/12)*mu_xA^2)*theta1-(1/6)*mu_zA-(1/6)*lambda_i-(1/6)*mu_WzA)*gama;

    ec2beta0 = -(1/12)*gama*(mu_WxA+mu_xA)*(3*e_ad-2);
    ec2beta1c = (1/8)*gama*(mu_WxA*mu_yA+mu_xA*mu_yA+mu_WyA*mu_xA)*(2*e_ad-1)-1+lambda_beta^2;
    ec2beta1s = (-(1/4)*mu_WxA*mu_xA-1/3+(1/4)*mu_WyA*mu_yA+(1/2)*mu_WzA*lambda_i+(1/8)*mu_yA^2-(1/8)*mu_xA^2)*gama*e_ad+...
            (-(1/16)*mu_yA^2+(1/16)*mu_xA^2-(1/8)*mu_WyA*mu_yA+1/8+(1/8)*mu_WxA*mu_xA-(1/4)*mu_WzA*lambda_i)*gama;


    ec2theta0 = -(1/6)*gama*(mu_WyA+mu_yA)*(3*e_ad-2);
    ec2theta1c = (1/6+(3/4)*mu_WyA*mu_yA+(3/8)*mu_yA^2+(1/8)*mu_xA^2+(1/4)*mu_WxA*mu_xA)*gama*e_ad+...
             (-(3/8)*mu_WyA*mu_yA-(1/16)*mu_xA^2-(3/16)*mu_yA^2-(1/8)*mu_WxA*mu_xA-1/8)*gama;
    ec2theta1s = -(1/8)*gama*(mu_WxA*mu_yA+mu_xA*mu_yA+mu_WyA*mu_xA)*(2*e_ad-1);

    ec2indep = (-(1/2)*mu_WyA*mu_zA-(1/2)*mu_yA*lambda_i-(1/2)*mu_yA*mu_zA-(1/2)*mu_WzA*mu_yA-(1/2)*mu_WyA*lambda_i-(1/3)*theta1*mu_yA)*gama*e_ad+...
           ((1/4)*mu_WyA*lambda_i+(1/4)*mu_WyA*mu_zA+(1/4)*mu_yA*mu_zA+(1/4)*mu_yA*lambda_i+(1/4)*theta1*mu_yA+(1/4)*mu_WzA*mu_yA)*gama;

    ec3beta0 = -(1/12)*gama*(mu_WyA+mu_yA)*(3*e_ad-2);
    ec3beta1c = ((1/8)*mu_yA^2-(1/2)*mu_WzA*lambda_i+1/3-(1/4)*mu_WxA*mu_xA+(1/4)*mu_WyA*mu_yA-(1/8)*mu_xA^2)*gama*e_ad+...
            (-(1/16)*mu_yA^2+(1/8)*mu_WxA*mu_xA+(1/16)*mu_xA^2-1/8-(1/8)*mu_WyA*mu_yA+(1/4)*mu_WzA*lambda_i)*gama;
    ec3beta1s = -(1/8)*gama*(mu_WxA*mu_yA+mu_xA*mu_yA+mu_WyA*mu_xA)*(2*e_ad-1)-1+lambda_beta^2;

    ec3theta0 = (1/6)*gama*(mu_WxA+mu_xA)*(3*e_ad-2);
    ec3theta1c = -(1/8)*gama*(mu_WxA*mu_yA+mu_xA*mu_yA+mu_WyA*mu_xA)*(2*e_ad-1);
    ec3theta1s = ((1/4)*mu_WyA*mu_yA+(1/8)*mu_yA^2+1/6+(3/8)*mu_xA^2+(3/4)*mu_WxA*mu_xA)*gama*e_ad+...
             (-1/8-(3/16)*mu_xA^2-(1/8)*mu_WyA*mu_yA-(3/8)*mu_WxA*mu_xA-(1/16)*mu_yA^2)*gama;

    ec3indep = ((1/3)*theta1*mu_xA+(1/2)*mu_xA*lambda_i+(1/2)*mu_xA*mu_zA+(1/2)*mu_WxA*mu_zA+(1/2)*mu_WxA*lambda_i+(1/2)*mu_WzA*mu_xA)*gama*e_ad+...
           (-(1/4)*mu_xA*lambda_i-(1/4)*theta1*mu_xA-(1/4)*mu_WzA*mu_xA-(1/4)*mu_WxA*mu_zA-(1/4)*mu_xA*mu_zA-(1/4)*mu_WxA*lambda_i)*gama;

   
       

M_beta_ASE = [ec1beta0,ec1beta1c,ec1beta1s; ec2beta0,ec2beta1c,ec2beta1s; ec3beta0,ec3beta1c,ec3beta1s]
M_theta_ASE = [ec1theta0,ec1theta1c,ec1theta1s; ec2theta0,ec2theta1c,ec2theta1s; ec3theta0,ec3theta1c,ec3theta1s]
M_beta_invertida_ASE = inv(M_beta_ASE);
thetas = [theta0;theta1c;theta1s];
terminoindep_ASE = [ec1indep;ec2indep;ec3indep];

betas_ASE = -M_beta_invertida_ASE*(M_theta_ASE*thetas+terminoindep_ASE);
beta0_ASE = betas_ASE(1); beta1c = betas_ASE(2); beta1s = betas_ASE(3);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%   Modelo Alvaro
%

% T�rminos inerciales

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

Vi_ind = [0;0;0];

%T�rminos aerodin�micos

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

Va_ind =[1/120*(30*e_ad*lambda_i+30*e_ad*(mu_zA+mu_WzA)+15*e_ad*theta1+30*e_ad*theta1*(mu_xA+mu_WxA)^2-20*...
    lambda_i-12*theta1-20*(mu_zA+mu_WzA)-20*theta1*(mu_xA+mu_WxA)^2)*gama;...
    -1/12*(mu_yA+mu_WyA)*(6*e_ad*lambda_i+6*e_ad*(mu_zA+mu_WzA)+4*e_ad*theta1-3*(mu_zA+mu_WzA)-3*theta1-3*lambda_i)*gama;...
    1/12*(mu_xA+mu_WxA)*(6*e_ad*lambda_i+6*e_ad*(mu_zA+mu_WzA)+4*e_ad*theta1-3*(mu_zA+mu_WzA)-3*theta1-3*lambda_i)*gama];


Mi_beta_Alvaro = [Mibeta_11,Mibeta_12,Mibeta_13; Mibeta_21,Mibeta_22,Mibeta_23; Mibeta_31,Mibeta_32,Mibeta_33];
Ma_beta_Alvaro = [Mabeta_11,Mabeta_12,Mabeta_13; Mabeta_21,Mabeta_22,Mabeta_23; Mabeta_31,Mabeta_32,Mabeta_33];
M_beta_Alvaro = Mi_beta_Alvaro+Ma_beta_Alvaro;


Mi_theta_Alvaro = [Mitheta_11,Mitheta_12,Mitheta_13; Mitheta_21,Mitheta_22,Mitheta_23; Mitheta_31,Mitheta_32,Mitheta_33];
Ma_theta_Alvaro = [Matheta_11,Matheta_12,Matheta_13; Matheta_21,Matheta_22,Matheta_23; Matheta_31,Matheta_32,Matheta_33];
M_theta_Alvaro = Mi_theta_Alvaro+Ma_theta_Alvaro;

V_ind_Alvaro = Vi_ind+Va_ind;

M_beta_invertida_Alvaro = inv(M_beta_Alvaro);

terminoindep_Alvaro = V_ind_Alvaro;

betas_Alvaro = -M_beta_invertida_Alvaro*(M_theta_Alvaro*thetas+terminoindep_Alvaro);
beta0_Alvaro = betas_Alvaro(1); beta1c = betas_Alvaro(2); beta1s = betas_Alvaro(3);


terminoindep_ASE = terminoindep_ASE
terminoindep_Alvaro = V_ind_Alvaro

M_theta_ASE = M_theta_ASE
M_theta_Alvaro = M_theta_Alvaro

M_beta_ASE = M_beta_ASE
M_beta_Alvaro = M_beta_Alvaro

betas_ASE = betas_ASE
betas_Alvaro = betas_Alvaro