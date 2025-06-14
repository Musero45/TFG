% Función de prueba de momento del rotor 01

clear all

format long


theta0 = 0.30070464482031;
theta1c = 0*0.05181341861191;
theta1s = 0*-0.04255047072930;
beta0 = 0.14927293607006;
beta1c = 0*-0.05753670581640;
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

    
    e_ad = MHAdim.Pala_RP.e_ad;
    sigma = MHAdim.Pala_RP.sigma;
    theta1 = MHAdim.Pala_RP.theta1;
    m_k = MHAdim.Pala_RP.m_k;
    m_e = MHAdim.Pala_RP.m_e;
    b = MHAdim.Pala_RP.b;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%   CREACION DE LAS MATRICES DEL SISTEMA VECTOR INDEPENDIENTE
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%   MODELO DE MOMENTOS SEGÚN ASE
%
%
%       Vector independiente (ASE)

  CMRind_1 = (1/8)*sigma*a*mu_xA*(lambda_i+theta1+mu_zA+mu_WzA);
  CMRind_2 = 0;
  CMRind_3 = -(1/120)*sigma*(15+30*mu_xA*mu_WxA+15*mu_xA^2)*delta0-(1/120)*sigma*(12*theta1+...
            20*mu_zA+20*mu_WzA+10*mu_xA^2*theta1+20*lambda_i)*delta1;
 

%       Matriz de términos proporcionales a beta (ASE)


CMRbeta_11 = -(1/12)*sigma*(mu_yA+mu_WyA)*(-3*e_ad+2)*delta0-(1/12)*a*sigma*(mu_yA+mu_WyA);
CMRbeta_12 = -(1/480)*sigma*(-48*theta1+15*mu_xA^2-40*mu_zA-40*mu_WzA+30*mu_xA*mu_WxA-40*lambda_i+...
              60*mu_zA*e_ad+60*mu_WzA*e_ad+60*e_ad*theta1+60*lambda_i*e_ad)*a-(1/480)*sigma*(-30*mu_xA*...
              mu_WxA+30*e_ad*mu_xA^2-30-15*mu_xA^2+60*e_ad*mu_xA*mu_WxA+40*e_ad)*delta0-(1/480)*sigma*...
              (60*mu_WzA*e_ad+60*lambda_i*e_ad+60*mu_zA*e_ad+15*e_ad*theta1*mu_xA^2-10*mu_xA^2*theta1-...
              24*theta1+30*e_ad*theta1-40*lambda_i-40*mu_WzA-40*mu_zA)*delta1;
CMRbeta_13 = -(1/16)*sigma*mu_xA*(mu_yA+mu_WyA)*(a+delta0-2*delta0*e_ad);
           
CMRbeta_21 = (1/24)*sigma*(2*mu_WxA+2*mu_xA)*a+(1/24)*sigma*(4*mu_WxA-6*e_ad*mu_WxA-6*e_ad*mu_xA+4*mu_xA)*...
             delta0+(1/24)*sigma*(-6*e_ad*mu_xA*mu_zA-4*e_ad*mu_xA*theta1-6*e_ad*mu_xA*lambda_i-6*e_ad*mu_xA*...
             mu_WzA+3*lambda_i*mu_xA+3*mu_WzA*mu_xA+3*mu_zA*mu_xA+3*theta1*mu_xA)*delta1;
CMRbeta_22 = -(1/16)*sigma*mu_xA*(mu_yA+mu_WyA)*(a+delta0-2*delta0*e_ad);
CMRbeta_23 = -(1/480)*sigma*(-48*theta1-15*mu_xA^2-40*mu_zA-40*mu_WzA-30*mu_xA*mu_WxA-40*lambda_i+60*mu_zA*e_ad+...
             60*mu_WzA*e_ad+60*e_ad*theta1+60*lambda_i*e_ad)*a-(1/480)*sigma*(-90*mu_xA*mu_WxA+90*e_ad*mu_xA^2-30-...
             45*mu_xA^2+180*e_ad*mu_xA*mu_WxA+40*e_ad)*delta0-(1/480)*sigma*(60*mu_WzA*e_ad+60*lambda_i*e_ad+60*mu_zA*...
             e_ad+45*e_ad*theta1*mu_xA^2-30*mu_xA^2*theta1-24*theta1+30*e_ad*theta1-40*lambda_i-40*mu_WzA-40*mu_zA)*delta1;

CMRbeta_31 = 0;
CMRbeta_32 = -(1/48)*sigma*(12*mu_zA*mu_xA+3*theta1*mu_xA+12*lambda_i*mu_xA+12*mu_WzA*mu_xA)*a-(1/48)*sigma*(8*mu_WxA-12*...
             lambda_i*mu_xA+8*mu_xA-12*e_ad*mu_xA-12*e_ad*mu_WxA)*delta0-(1/48)*sigma*(-4*mu_WxA+6*theta1*mu_xA-4*mu_xA-8*...
             e_ad*mu_xA*theta1)*delta1-(1/48)*sigma*(-12*mu_zA*mu_xA-6*theta1*mu_xA-12*mu_WzA*mu_xA-12*lambda_i*mu_xA)*delta2;
CMRbeta_33 = (1/12)*sigma*(mu_yA+mu_WyA)*(-2*delta0+delta1+3*delta0*e_ad);

   

%       Matriz de términos proporcionales a theta (ASE)


CMRtheta_11 = (1/6)*a*sigma*(mu_xA+mu_WxA);
CMRtheta_12 = -(1/16)*sigma*mu_xA*(mu_yA+mu_WyA)*a;
CMRtheta_13 = (1/32)*sigma*a*(2+6*mu_xA*mu_WxA+3*mu_xA^2);

CMRtheta_21 = (1/6)*a*sigma*(mu_yA+mu_WyA);
CMRtheta_22 = -(1/32)*sigma*a*(2*mu_xA*mu_WxA+mu_xA^2+2);
CMRtheta_23 = (1/16)*sigma*mu_xA*(mu_yA+mu_WyA)*a;

CMRtheta_31 = (1/120)*sigma*(20*mu_zA+20*lambda_i+20*mu_WzA)*a+(1/120)*sigma*(-15-30*mu_xA*mu_WxA-15*...
              mu_xA^2)*delta1+(1/120)*sigma*(-20*mu_xA^2*theta1-40*mu_zA-24*theta1-40*mu_WzA-40*lambda_i)*delta2;
CMRtheta_32 = (1/6)*sigma*delta1*(mu_yA+mu_WyA);
CMRtheta_33 = (1/24)*sigma*(3*mu_zA*mu_xA+3*lambda_i*mu_xA+3*mu_WzA*mu_xA)*a+(1/24)*sigma*(-4*mu_xA-4*mu_WxA)*...
              delta1+(1/24)*sigma*(-6*mu_WzA*mu_xA-6*theta1*mu_xA-6*mu_zA*mu_xA-6*lambda_i*mu_xA)*delta2;

    
    M_beta_ASE = [CMRbeta_11,CMRbeta_12,CMRbeta_13; CMRbeta_21,CMRbeta_22,CMRbeta_23; CMRbeta_31,CMRbeta_32,CMRbeta_33];
    M_theta_ASE = [CMRtheta_11,CMRtheta_12,CMRtheta_13; CMRtheta_21,CMRtheta_22,CMRtheta_23; CMRtheta_31,CMRtheta_32,CMRtheta_33];
    V_indep_ASE = [CMRind_1;CMRind_2;CMRind_3];

    betas = [beta0; beta1c ;beta1s];
    thetas = [theta0; theta1c; theta1s];

    CMRbeta_ASE = M_beta_ASE*betas;
    CMRtheta_ASE = M_theta_ASE*thetas;
    V_indep_ASE;

    %CMR = M_beta*betas+M_theta*thetas+V_indep;
    
    %CMR = M_beta*betas+M_theta*thetas+V_indep;
    
    CMRalter = b*[m_k*beta1s+m_e*beta1s;-m_k*beta1c-m_e*beta1c;0];
    
    CMR_ASE = M_beta_ASE*betas+M_theta_ASE*thetas+V_indep_ASE;

    
        
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%
%   MODELO DE MOMENTOS MIXTO
%
%
%       Vector independiente (MIXTO)
        
  
 CMRind_1 = (1/960*sigma*(120*theta1-160*e_ad*theta1)*(mu_xA+mu_WxA)+1/960*sigma*(-240*e_ad+120)*(mu_zA+mu_WzA)*(mu_xA+mu_WxA)+1/960*sigma*...
     (-240*e_ad+120)*lambda_i*(mu_xA+mu_WxA))*a+((1/6)*sigma*e_ad*theta1*(mu_xA+mu_WxA)+(1/4)*sigma*e_ad*(mu_zA+mu_WzA)*...
     (mu_xA+mu_WxA)+(1/4)*sigma*e_ad*lambda_i*(mu_xA+mu_WxA))*a;
 
 CMRind_2 = (-1/960*sigma*(160*e_ad*theta1-120*theta1)*(mu_yA+mu_WyA)-1/960*sigma*(-120+240*e_ad)*(mu_zA+mu_WzA)*(mu_yA+mu_WyA)-1/960*sigma*...
     (-120+240*e_ad)*lambda_i*(mu_yA+mu_WyA))*a+((1/6)*sigma*e_ad*theta1*(mu_yA+mu_WyA)+(1/4)*...
     sigma*e_ad*(mu_zA+mu_WzA)*(mu_yA+mu_WyA)+(1/4)*sigma*e_ad*lambda_i*(mu_yA+mu_WyA))*a;
 
 CMRind_3 = (1/240*sigma*(-40*e_ad*theta1+30*theta1)*lambda_i+1/240*sigma*(-40*e_ad*theta1+30*theta1)*...
     (mu_zA+mu_WzA)+1/240*sigma*(-120*e_ad+60)*lambda_i^2+1/240*sigma*(-240*e_ad+120)*(mu_zA+mu_WzA)*lambda_i+...
     1/240*sigma*(-120*e_ad+60)*(mu_zA+mu_WzA)^2)*a+1/240*sigma*(-30*delta0-20*delta2*theta1^2-24*delta1*...
     theta1+24*e_ad*delta2*theta1^2+40*e_ad*delta0+30*e_ad*delta1*theta1)+1/240*sigma*...
     (-60*delta2*theta1-40*delta1+60*e_ad*delta1+80*e_ad*delta2*theta1)*(mu_zA+mu_WzA)+1/240*sigma*...
     (-30*delta0-15*delta2*theta1^2-20*delta1*theta1+60*e_ad*delta0+30*e_ad*delta1*theta1+20*e_ad*delta2*theta1^2)*(mu_yA+mu_WyA)^2+...
     1/240*sigma*(-60*delta2*theta1-40*delta1+60*e_ad*delta1+80*e_ad*delta2*theta1)*lambda_i+...
     1/240*sigma*(-30*delta0-15*delta2*theta1^2-20*delta1*theta1+60*e_ad*delta0+30*e_ad*delta1*theta1+...
     20*e_ad*delta2*theta1^2)*(mu_xA+mu_WxA)^2+1/240*sigma*(-60*delta2+120*e_ad*delta2)*lambda_i^2+...
     1/240*sigma*(240*e_ad*delta2-120*delta2)*(mu_zA+mu_WzA)*lambda_i+1/240*sigma*(-60*delta2+120*e_ad*delta2)*(mu_zA+mu_WzA)^2+...
     (((1/6)*sigma*theta1*lambda_i*e_ad+(1/6)*sigma*e_ad*theta1*(mu_zA+mu_WzA)+(1/2)*sigma*e_ad*lambda_i^2+...
    sigma*lambda_i*e_ad*(mu_zA+mu_WzA)+(1/2)*sigma*e_ad*(mu_zA+mu_WzA)^2)*a-(1/120)*sigma*(20*delta0+12*delta2*theta1^2+...
    15*delta1*theta1)*e_ad-(1/120)*sigma*(30*delta1+40*delta2*theta1)*e_ad*(mu_zA+mu_WzA)-...
    (1/120)*sigma*(30*delta0+10*delta2*theta1^2+15*delta1*theta1)*e_ad*(mu_yA+mu_WyA)^2-...
    (1/120)*sigma*(30*delta1+40*delta2*theta1)*e_ad*lambda_i-(1/120)*sigma*(30*delta0+10*delta2*theta1^2+...
    15*delta1*theta1)*e_ad*(mu_xA+mu_WxA)^2-(1/2)*sigma*delta2*e_ad*lambda_i^2-...
    sigma*delta2*e_ad*(mu_zA+mu_WzA)*lambda_i-(1/2)*sigma*delta2*e_ad*(mu_zA+mu_WzA)^2);
 
      

%       Matriz de términos proporcionales a beta (MIXTO)


CMRbeta_11 = -(1/12)*sigma*(mu_yA+mu_WyA)*(-3*e_ad+2)*delta0-(1/12)*a*sigma*(mu_yA+mu_WyA);
CMRbeta_12 = -(1/480)*sigma*(-48*theta1+15*mu_xA^2-40*mu_zA-40*mu_WzA+30*mu_xA*mu_WxA-40*lambda_i+...
              60*mu_zA*e_ad+60*mu_WzA*e_ad+60*e_ad*theta1+60*lambda_i*e_ad)*a-(1/480)*sigma*(-30*mu_xA*...
              mu_WxA+30*e_ad*mu_xA^2-30-15*mu_xA^2+60*e_ad*mu_xA*mu_WxA+40*e_ad)*delta0-(1/480)*sigma*...
              (60*mu_WzA*e_ad+60*lambda_i*e_ad+60*mu_zA*e_ad+15*e_ad*theta1*mu_xA^2-10*mu_xA^2*theta1-...
              24*theta1+30*e_ad*theta1-40*lambda_i-40*mu_WzA-40*mu_zA)*delta1;
CMRbeta_13 = -(1/16)*sigma*mu_xA*(mu_yA+mu_WyA)*(a+delta0-2*delta0*e_ad);
           
CMRbeta_21 = (1/24)*sigma*(2*mu_WxA+2*mu_xA)*a+(1/24)*sigma*(4*mu_WxA-6*e_ad*mu_WxA-6*e_ad*mu_xA+4*mu_xA)*...
             delta0+(1/24)*sigma*(-6*e_ad*mu_xA*mu_zA-4*e_ad*mu_xA*theta1-6*e_ad*mu_xA*lambda_i-6*e_ad*mu_xA*...
             mu_WzA+3*lambda_i*mu_xA+3*mu_WzA*mu_xA+3*mu_zA*mu_xA+3*theta1*mu_xA)*delta1;
CMRbeta_22 = -(1/16)*sigma*mu_xA*(mu_yA+mu_WyA)*(a+delta0-2*delta0*e_ad);
CMRbeta_23 = -(1/480)*sigma*(-48*theta1-15*mu_xA^2-40*mu_zA-40*mu_WzA-30*mu_xA*mu_WxA-40*lambda_i+60*mu_zA*e_ad+...
             60*mu_WzA*e_ad+60*e_ad*theta1+60*lambda_i*e_ad)*a-(1/480)*sigma*(-90*mu_xA*mu_WxA+90*e_ad*mu_xA^2-30-...
             45*mu_xA^2+180*e_ad*mu_xA*mu_WxA+40*e_ad)*delta0-(1/480)*sigma*(60*mu_WzA*e_ad+60*lambda_i*e_ad+60*mu_zA*...
             e_ad+45*e_ad*theta1*mu_xA^2-30*mu_xA^2*theta1-24*theta1+30*e_ad*theta1-40*lambda_i-40*mu_WzA-40*mu_zA)*delta1;

CMRbeta_31 = 0+0; 
    
CMRbeta_32 =(-(1/12)*sigma*e_ad*theta1*(mu_xA+mu_WxA)+(1/240)*sigma*(-60+120*e_ad)*(mu_zA+mu_WzA)*(mu_xA+mu_WxA)+...
        (1/240)*sigma*(-60+120*e_ad)*lambda_i*(mu_xA+mu_WxA))*a+(1/240)*sigma*(30*e_ad*delta1+40*e_ad*delta2*theta1)*(mu_xA+mu_WxA)+(1/240)*...
        sigma*(-120*e_ad*delta2+60*delta2)*(mu_zA+mu_WzA)*(mu_xA+mu_WxA)+(1/240)*sigma*(60*delta2+40*delta1*theta1+60*delta0-120*e_ad*delta0-...
        40*e_ad*delta2*theta1^2-60*e_ad*delta1*theta1-120*e_ad*delta2+30*delta2*theta1^2)*lambda_i*(mu_xA+mu_WxA)+...
        (-(1/2)*sigma*e_ad*(mu_zA+mu_WzA)*(mu_xA+mu_WxA)-(1/2)*sigma*e_ad*lambda_i*(mu_xA+mu_WxA))*a+(1/2)*sigma*delta2*e_ad*(mu_zA+mu_WzA)*...
        (mu_xA+mu_WxA)-(1/120)*sigma*(-60*delta2-30*delta1*theta1-60*delta0-20*delta2*theta1^2)*e_ad*lambda_i*(mu_xA+mu_WxA);
    
CMRbeta_33 =(-(1/12)*sigma*e_ad*theta1*(mu_yA+mu_WyA)+(1/240)*sigma*(-60+120*e_ad)*(mu_zA+mu_WzA)*(mu_yA+mu_WyA)+(1/240)*sigma*(-60+120*e_ad)*lambda_i*(mu_yA+mu_WyA))*a+...
        (1/240)*sigma*(30*e_ad*delta1+40*e_ad*delta2*theta1)*(mu_yA+mu_WyA)+(1/240)*sigma*(-120*e_ad*delta2+60*delta2)*(mu_zA+mu_WzA)*(mu_yA+mu_WyA)+...
        (1/240)*sigma*(60*delta2+40*delta1*theta1+60*delta0-120*e_ad*delta0-40*e_ad*delta2*theta1^2-...
        60*e_ad*delta1*theta1-120*e_ad*delta2+30*delta2*theta1^2)*lambda_i*(mu_yA+mu_WyA)+(-(1/2)*sigma*e_ad*(mu_zA+mu_WzA)*...
        (mu_yA+mu_WyA)-(1/2)*sigma*e_ad*lambda_i*(mu_yA+mu_WyA))*a+(1/2)*sigma*delta2*e_ad*(mu_zA+mu_WzA)*(mu_yA+mu_WyA)-...
        (1/120)*sigma*(-60*delta2-30*delta1*theta1-60*delta0-20*delta2*theta1^2)*e_ad*lambda_i*(mu_yA+mu_WyA);
    
    

%       Matriz de términos proporcionales a theta (MIXTO)


CMRtheta_11 = (1/6)*a*sigma*(mu_xA+mu_WxA);
CMRtheta_12 = -(1/16)*sigma*mu_xA*(mu_yA+mu_WyA)*a;
CMRtheta_13 = (1/32)*sigma*a*(2+6*mu_xA*mu_WxA+3*mu_xA^2);

CMRtheta_21 = (1/6)*a*sigma*(mu_yA+mu_WyA);
CMRtheta_22 = -(1/32)*sigma*a*(2*mu_xA*mu_WxA+mu_xA^2+2);
CMRtheta_23 = (1/16)*sigma*mu_xA*(mu_yA+mu_WyA)*a;
CMRtheta_31 = ((1/240)*sigma*(40-60*e_ad)*lambda_i+(1/240)*sigma*(40-60*e_ad)*(mu_zA+mu_WzA))*a+(1/240)*sigma*...
                (60*e_ad*delta2*theta1-30*delta1+40*e_ad*delta1-48*delta2*theta1)+(1/240)*sigma*...
                (-80*delta2+120*e_ad*delta2)*(mu_zA+mu_WzA)+(1/240)*sigma*(-30*delta1+60*e_ad*delta2*theta1-40*delta2*...
                theta1+60*e_ad*delta1)*(mu_yA+mu_WyA)^2+(1/240)*sigma*(-80*delta2+120*e_ad*delta2)*lambda_i+(1/240)*sigma*...
                (-30*delta1+60*e_ad*delta2*theta1-40*delta2*theta1+60*e_ad*delta1)*(mu_xA+mu_WxA)^2+((1/4)*sigma*e_ad*lambda_i+...
                (1/4)*sigma*e_ad*(mu_zA+mu_WzA))*a-(1/120)*sigma*(20*delta1+30*delta2*theta1)*e_ad-(1/2)*sigma*delta2*e_ad*...
                (mu_zA+mu_WzA)-(1/120)*sigma*(30*delta1+30*delta2*theta1)*e_ad*(mu_yA+mu_WyA)^2-...
                (1/2)*sigma*delta2*e_ad*lambda_i-(1/120)*sigma*(30*delta1+30*delta2*theta1)*e_ad*(mu_xA+mu_WxA)^2;
 
 CMRtheta_32 = ((1/240)*sigma*(-30+60*e_ad)*(mu_zA+mu_WzA)*(mu_yA+mu_WyA)+(1/240)*sigma*(-30+60*e_ad)*lambda_i*(mu_yA+mu_WyA))*a+...
                (1/240)*sigma*(60*delta2*theta1-80*e_ad*delta2*theta1+40*delta1-60*e_ad*delta1)*(mu_yA+mu_WyA)+(1/240)*sigma*...
                (-120*e_ad*delta2+60*delta2)*(mu_zA+mu_WzA)*(mu_yA+mu_WyA)+(1/240)*sigma*(-120*e_ad*delta2+60*delta2)...
                *lambda_i*(mu_yA+mu_WyA)+(-(1/4)*sigma*e_ad*(mu_zA+mu_WzA)*(mu_yA+mu_WyA)-(1/4)*sigma*e_ad*lambda_i*(mu_yA+mu_WyA))*...
                a-(1/120)*sigma*(-30*delta1-40*delta2*theta1)*e_ad*(mu_yA+mu_WyA)+(1/2)*sigma*delta2*e_ad*(mu_zA+mu_WzA)*...
                (mu_yA+mu_WyA)+(1/2)*sigma*delta2*e_ad*lambda_i*(mu_yA+mu_WyA);
 
 CMRtheta_33 = ((1/240)*sigma*(-60*e_ad+30)*(mu_zA+mu_WzA)*(mu_xA+mu_WxA)+(1/240)*sigma*(-60*e_ad+30)*lambda_i*(mu_xA+mu_WxA))*a+(1/240)*sigma*...
                (-60*delta2*theta1-40*delta1+60*e_ad*delta1+80*e_ad*delta2*theta1)*(mu_xA+mu_WxA)+(1/240)*sigma*...
                (-60*delta2+120*e_ad*delta2)*(mu_zA+mu_WzA)*(mu_xA+mu_WxA)+(1/240)*sigma*(-60*delta2+120*e_ad*delta2)*...
                lambda_i*(mu_xA+mu_WxA)+((1/4)*sigma*e_ad*(mu_zA+mu_WzA)*(mu_xA+mu_WxA)+(1/4)*sigma*e_ad*lambda_i*(mu_xA+mu_WxA))...
                *a-(1/120)*sigma*(30*delta1+40*delta2*theta1)*e_ad*(mu_xA+mu_WxA)-(1/2)*sigma*delta2*e_ad*(mu_zA+mu_WzA)*(mu_xA+mu_WxA)-...
                (1/2)*sigma*delta2*e_ad*lambda_i*(mu_xA+mu_WxA); 

    
    M_beta_Mixto = [CMRbeta_11,CMRbeta_12,CMRbeta_13; CMRbeta_21,CMRbeta_22,CMRbeta_23; CMRbeta_31,CMRbeta_32,CMRbeta_33];
    M_theta_Mixto = [CMRtheta_11,CMRtheta_12,CMRtheta_13; CMRtheta_21,CMRtheta_22,CMRtheta_23; CMRtheta_31,CMRtheta_32,CMRtheta_33];
    V_indep_Mixto = [CMRind_1;CMRind_2;CMRind_3];

    betas = [beta0; beta1c ;beta1s];
    thetas = [theta0; theta1c; theta1s];

    CMRbeta_Mixto = M_beta_Mixto*betas;
    CMRtheta_Mixto = M_theta_Mixto*thetas;
    V_indep_Mixto;
    
    
    CMRalter = b*[m_k*beta1s+m_e*beta1s;-m_k*beta1c-m_e*beta1c;0];
    
    CMR_Mixto = M_beta_Mixto*betas+M_theta_Mixto*thetas+V_indep_Mixto;
    
 

       
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%
%   MODELO DE MOMENTOS ALVARO
%
%
%       Vector independiente (Alvaro)


%   Momento en E

CMdRind_1 = ((1/960)*sigma*(120*theta1-160*e_ad*theta1)*(mu_xA+mu_WxA)+(1/960)*sigma*(-240*e_ad+120)*(mu_zA+mu_WzA)*(mu_xA+mu_WxA)+(1/960)*sigma*...
    (-240*e_ad+120)*lambda_i*(mu_xA+mu_WxA))*a;

CMdRind_2 = (-(1/960)*sigma*(160*e_ad*theta1-120*theta1)*(mu_yA+mu_WyA)-(1/960)*sigma*(-120+240*e_ad)*(mu_zA+mu_WzA)*(mu_yA+mu_WyA)-(1/960)*sigma*...
    (-120+240*e_ad)*lambda_i*(mu_yA+mu_WyA))*a;

CMdRind_3 = (((1/240)*sigma*(-40*e_ad*theta1+30*theta1)*lambda_i+(1/240)*sigma*(-40*e_ad*theta1+30*theta1)*(mu_zA+mu_WzA)+....
    (1/240)*sigma*(-120*e_ad+60)*lambda_i^2+(1/240)*sigma*(-240*e_ad+120)*(mu_zA+mu_WzA)*lambda_i+(1/240)*sigma*...
    (-120*e_ad+60)*(mu_zA+mu_WzA)^2)*a+(1/240)*sigma*(-30*delta0-20*delta2*theta1^2-24*delta1*theta1+24*e_ad*delta2*theta1^2+...
    40*e_ad*delta0+30*e_ad*delta1*theta1)+(1/240)*sigma*(-60*delta2*theta1-40*delta1+60*e_ad*delta1+80*e_ad*delta2*theta1)*...
    (mu_zA+mu_WzA)+(1/240)*sigma*(-30*delta0-15*delta2*theta1^2-20*delta1*theta1+60*e_ad*delta0+30*e_ad*delta1*...
    theta1+20*e_ad*delta2*theta1^2)*(mu_yA+mu_WyA)^2+(1/240)*sigma*(-60*delta2*theta1-40*delta1+60*...
    e_ad*delta1+80*e_ad*delta2*theta1)*lambda_i+(1/240)*sigma*(-30*delta0-15*delta2*theta1^2-20*delta1*...
    theta1+60*e_ad*delta0+30*e_ad*delta1*theta1+20*e_ad*delta2*theta1^2)*(mu_xA+mu_WxA)^2+(1/240)*sigma*...
    (-60*delta2+120*e_ad*delta2)*lambda_i^2+(1/240)*sigma*(240*e_ad*delta2-120*delta2)*(mu_zA+mu_WzA)*lambda_i+(1/240)*sigma*...
    (-60*delta2+120*e_ad*delta2)*(mu_zA+mu_WzA)^2);

%   Momento en A de las fuerzas en E

CMiRind_1 = ((1/6)*sigma*e_ad*theta1*(mu_xA+mu_WxA)+(1/4)*sigma*e_ad*(mu_zA+mu_WzA)*(mu_xA+mu_WxA)+(1/4)*sigma*e_ad*lambda_i*(mu_xA+mu_WxA))*a;

CMiRind_2 = ((1/6)*sigma*e_ad*theta1*(mu_yA+mu_WyA)+(1/4)*sigma*e_ad*(mu_zA+mu_WzA)*(mu_yA+mu_WyA)+(1/4)*sigma*e_ad*lambda_i*(mu_yA+mu_WyA))*a;

CMiRind_3 = (((1/6)*sigma*theta1*lambda_i*e_ad+(1/6)*sigma*e_ad*theta1*(mu_zA+mu_WzA)+(1/2)*sigma*e_ad*lambda_i^2+...
    sigma*lambda_i*e_ad*(mu_zA+mu_WzA)+(1/2)*sigma*e_ad*(mu_zA+mu_WzA)^2)*a-(1/120)*sigma*(20*delta0+12*delta2*theta1^2+15*delta1*theta1)*...
    e_ad-(1/120)*sigma*(30*delta1+40*delta2*theta1)*e_ad*(mu_zA+mu_WzA)-(1/120)*sigma*(30*delta0+10*delta2*theta1^2+15*delta1*theta1)*...
    e_ad*(mu_yA+mu_WyA)^2-(1/120)*sigma*(30*delta1+40*delta2*theta1)*e_ad*lambda_i-(1/120)*sigma*(30*delta0+10*delta2*...
    theta1^2+15*delta1*theta1)*e_ad*(mu_xA+mu_WxA)^2-(1/2)*sigma*delta2*e_ad*lambda_i^2-sigma*delta2*e_ad*(mu_zA+mu_WzA)*lambda_i-...
    (1/2)*sigma*delta2*e_ad*(mu_zA+mu_WzA)^2);

% Termino independiente de momento en A total

  CMRind_1 = CMdRind_1+CMiRind_1;
  CMRind_2 = CMdRind_2+CMiRind_2;
  CMRind_3 = CMdRind_3+CMiRind_3;


%   MATRICES DE TERMINOS EN THETA


%   Matriz de momentos en E proporcionales a theta

CMRdtheta_11 = (1/960)*sigma*(-240*e_ad+160)*(mu_xA+mu_WxA)*a;

CMRdtheta_12 = (1/960)*sigma*(-60+120*e_ad)*(mu_yA+mu_WyA)*(mu_xA+mu_WxA)*a;

CMRdtheta_13 = ((1/960)*sigma*(60-80*e_ad)+(1/960)*sigma*(90-180*e_ad)*(mu_xA+mu_WxA)^2+(1/960)*sigma*(-60*e_ad+30)*(mu_yA+mu_WyA)^2)*a;

CMRdtheta_21 = -(1/960)*sigma*(-160+240*e_ad)*(mu_yA+mu_WyA)*a;

CMRdtheta_22 = (-(1/960)*sigma*(60-80*e_ad)-(1/960)*sigma*(-60*e_ad+30)*(mu_xA+mu_WxA)^2-(1/960)*sigma*(90-180*e_ad)*(mu_yA+mu_WyA)^2)*a;

CMRdtheta_23 = -(1/960)*sigma*(-60+120*e_ad)*(mu_yA+mu_WyA)*(mu_xA+mu_WxA)*a;

CMRdtheta_31 = ((1/240)*sigma*(40-60*e_ad)*lambda_i+(1/240)*sigma*(40-60*e_ad)*(mu_zA+mu_WzA))*a+(1/240)*sigma*...
                (60*e_ad*delta2*theta1-30*delta1+40*e_ad*delta1-48*delta2*theta1)+(1/240)*sigma*(-80*delta2+120*e_ad*delta2)*...
                (mu_zA+mu_WzA)+(1/240)*sigma*(60*e_ad*delta2*theta1-30*delta1-40*delta2*theta1+60*e_ad*delta1)*(mu_yA+mu_WyA)^2+(1/240)*sigma*...
                (-80*delta2+120*e_ad*delta2)*lambda_i+(1/240)*sigma*(60*e_ad*delta2*theta1-30*delta1-40*delta2*...
                theta1+60*e_ad*delta1)*(mu_xA+mu_WxA)^2;
                        
            
CMRdtheta_32 = ((1/240)*sigma*(-30+60*e_ad)*(mu_zA+mu_WzA)*(mu_yA+mu_WyA)+(1/240)*sigma*(-30+60*e_ad)*lambda_i*(mu_yA+mu_WyA))*a+(1/240)*sigma*...
                (60*delta2*theta1-80*e_ad*delta2*theta1+40*delta1-60*e_ad*delta1)*(mu_yA+mu_WyA)+(1/240)*sigma*(-120*e_ad*delta2+60*delta2)*...
                (mu_zA+mu_WzA)*(mu_yA+mu_WyA)+(1/240)*sigma*(-120*e_ad*delta2+60*delta2)*lambda_i*(mu_yA+mu_WyA);

CMRdtheta_33 = ((1/240)*sigma*(-60*e_ad+30)*(mu_zA+mu_WzA)*(mu_xA+mu_WxA)+(1/240)*sigma*(-60*e_ad+30)*lambda_i*(mu_xA+mu_WxA))*a+(1/240)*sigma*(-60*delta2*theta1-40*...
                delta1+60*e_ad*delta1+80*e_ad*delta2*theta1)*(mu_xA+mu_WxA)+(1/240)*sigma*(-60*delta2+120*e_ad*delta2)*(mu_zA+mu_WzA)*(mu_xA+mu_WxA)+(1/240)*sigma*...
                (-60*delta2+120*e_ad*delta2)*lambda_i*(mu_xA+mu_WxA);


%   Matriz de momentos en A debidos a las fuerzas en E proporcionales a theta


CMRitheta_11 = (1/4)*sigma*a*(mu_xA+mu_WxA)*e_ad;
CMRitheta_12 = -(1/8)*sigma*a*e_ad*(mu_yA+mu_WyA)*(mu_xA+mu_WxA);
CMRitheta_13 = ((1/12)*sigma*e_ad+(3/16)*sigma*e_ad*(mu_xA+mu_WxA)^2+(1/16)*sigma*e_ad*(mu_yA+mu_WyA)^2)*a;
CMRitheta_21 = (1/4)*sigma*a*e_ad*(mu_yA+mu_WyA);
CMRitheta_22 = (-(1/12)*sigma*e_ad-(1/16)*sigma*e_ad*(mu_xA+mu_WxA)^2-(3/16)*sigma*e_ad*(mu_yA+mu_WyA)^2)*a;
CMRitheta_23 = (1/8)*sigma*a*e_ad*(mu_yA+mu_WyA)*(mu_xA+mu_WxA);
CMRitheta_31 = ((1/4)*sigma*e_ad*lambda_i+(1/4)*sigma*e_ad*(mu_zA+mu_WzA))*a-(1/120)*sigma*(20*delta1+30*delta2*theta1)*e_ad...
                -(1/2)*sigma*delta2*e_ad*(mu_zA+mu_WzA)-(1/120)*sigma*(30*delta1+30*delta2*theta1)*e_ad*(mu_yA+mu_WyA)^2-(1/2)*sigma*delta2*e_ad*...
                lambda_i-(1/120)*sigma*(30*delta1+30*delta2*theta1)*e_ad*(mu_xA+mu_WxA)^2;
CMRitheta_32 = (-(1/4)*sigma*e_ad*(mu_zA+mu_WzA)*(mu_yA+mu_WyA)-(1/4)*sigma*e_ad*lambda_i*(mu_yA+mu_WyA))*a-(1/120)*sigma*(-30*delta1-40*delta2*theta1)*...
                e_ad*(mu_yA+mu_WyA)+(1/2)*sigma*delta2*e_ad*(mu_zA+mu_WzA)*(mu_yA+mu_WyA)+(1/2)*sigma*delta2*e_ad*lambda_i*(mu_yA+mu_WyA);
CMRitheta_33 = ((1/4)*sigma*e_ad*(mu_zA+mu_WzA)*(mu_xA+mu_WxA)+(1/4)*sigma*e_ad*lambda_i*(mu_xA+mu_WxA))*a-(1/120)*sigma*(30*delta1+40*delta2*theta1)*e_ad*(mu_xA+mu_WxA)...
                -(1/2)*sigma*delta2*e_ad*(mu_zA+mu_WzA)*(mu_xA+mu_WxA)-(1/2)*sigma*delta2*e_ad*lambda_i*(mu_xA+mu_WxA);


 %Matriz de momentos en A totales proporcionales a theta

CMRtheta_11 = CMRdtheta_11+CMRitheta_11;
CMRtheta_12 = CMRdtheta_12+CMRitheta_12;
CMRtheta_13 = CMRdtheta_13+CMRitheta_13;
CMRtheta_21 = CMRdtheta_21+CMRitheta_21;
CMRtheta_22 = CMRdtheta_22+CMRitheta_22;
CMRtheta_23 = CMRdtheta_23+CMRitheta_23;
CMRtheta_31 = CMRdtheta_31+CMRitheta_31;
CMRtheta_32 = CMRdtheta_32+CMRitheta_32;
CMRtheta_33 = CMRdtheta_33+CMRitheta_33;


%   MATRICES DE TERMINOS EN BETA


%   Matriz de momentos en E proporcionales a beta

CMRdbeta_11 = ((1/960)*sigma*(-80+120*e_ad)*(mu_yA+mu_WyA)+(1/960)*sigma*(80*theta1-120*e_ad*theta1)*(mu_zA+mu_WzA)*(mu_yA+mu_WyA)+(1/960)*sigma*...
    (80*theta1-120*e_ad*theta1)*lambda_i*(mu_yA+mu_WyA))*a+(1/960)*sigma*(-96*delta2*theta1^2+160*e_ad*delta1*theta1-120*delta1*...
    theta1+240*e_ad*delta0+120*e_ad*delta2*theta1^2-160*delta0)*(mu_yA+mu_WyA)+(1/960)*sigma*(-120*delta1+240*e_ad*delta2*theta1-160*...
    delta2*theta1+240*e_ad*delta1)*(mu_zA+mu_WzA)*(mu_yA+mu_WyA)+(1/960)*sigma*(-120*delta1+240*e_ad*delta2*theta1-160*delta2*...
    theta1+240*e_ad*delta1)*lambda_i*(mu_yA+mu_WyA);

CMRdbeta_12 = ((1/960)*sigma*(-60*theta1+80*e_ad*theta1)*(mu_zA+mu_WzA)+(1/960)*sigma*(-180*theta1+240*e_ad*theta1)*lambda_i+...
    (1/960)*sigma*(-30+60*e_ad)*(mu_xA+mu_WxA)^2+(1/960)*sigma*(-60*e_ad+30)*(mu_yA+mu_WyA)^2+(1/960)*sigma*(-120+240*e_ad)*(mu_zA+mu_WzA)^2+(1/960)*sigma*...
    (-240+480*e_ad)*lambda_i^2+(1/960)*sigma*(60-160*e_ad)+(1/960)*sigma*(720*e_ad-360)*(mu_zA+mu_WzA)*lambda_i)*a+(1/960)*sigma*...
    (60*delta0+48*delta1*theta1-60*e_ad*delta1*theta1-48*e_ad*delta2*theta1^2-80*e_ad*delta0+40*delta2*theta1^2)+...
    (1/960)*sigma*(240*delta2-480*e_ad*delta2)*(mu_zA+mu_WzA)*lambda_i+(1/960)*sigma*(80*delta1-160*e_ad*delta2*theta1-120*e_ad*...
    delta1+120*delta2*theta1)*(mu_zA+mu_WzA)+(1/960)*sigma*(80*delta1-160*e_ad*delta2*theta1-120*e_ad*delta1+120*delta2*theta1)*...
    lambda_i+(1/960)*sigma*(30*delta0-20*e_ad*delta2*theta1^2-60*e_ad*delta0+20*delta1*theta1+15*delta2*theta1^2-30*e_ad*...
    delta1*theta1)*(mu_xA+mu_WxA)^2+(1/960)*sigma*(-60*e_ad*delta2*theta1^2+90*delta0-180*e_ad*delta0+45*delta2*theta1^2-90*e_ad*delta1*...
    theta1+60*delta1*theta1)*(mu_yA+mu_WyA)^2+(1/960)*sigma*(120*delta2-240*e_ad*delta2)*(mu_zA+mu_WzA)^2+(1/960)*sigma*(120*delta2-...
    240*e_ad*delta2)*lambda_i^2;

CMRdbeta_13 = (1/960)*sigma*(-60+120*e_ad)*(mu_yA+mu_WyA)*(mu_xA+mu_WxA)*a+(1/960)*sigma*(-40*delta1*theta1-60*delta0-30*delta2*theta1^2+...
60*e_ad*delta1*theta1+120*e_ad*delta0+40*e_ad*delta2*theta1^2)*(mu_yA+mu_WyA)*(mu_xA+mu_WxA);

CMRdbeta_21 = (-(1/960)*sigma*(-80+120*e_ad)*(mu_xA+mu_WxA)-(1/960)*sigma*(80*theta1-120*e_ad*theta1)*(mu_zA+mu_WzA)*(mu_xA+mu_WxA)-(1/960)*sigma*...
    (80*theta1-120*e_ad*theta1)*lambda_i*(mu_xA+mu_WxA))*a-(1/960)*sigma*(-96*delta2*theta1^2+160*e_ad*delta1*theta1-120*delta1*...
    theta1+240*e_ad*delta0+120*e_ad*delta2*theta1^2-160*delta0)*(mu_xA+mu_WxA)-(1/960)*sigma*(-120*delta1+240*e_ad*delta2*...
    theta1-160*delta2*theta1+240*e_ad*delta1)*(mu_zA+mu_WzA)*(mu_xA+mu_WxA)-(1/960)*sigma*(-120*delta1+240*e_ad*delta2*theta1-160*delta2*...
    theta1+240*e_ad*delta1)*lambda_i*(mu_xA+mu_WxA);

CMRdbeta_22 = -(1/960)*sigma*(-120*e_ad+60)*(mu_yA+mu_WyA)*(mu_xA+mu_WxA)*a-(1/960)*sigma*(60*delta0+30*delta2*theta1^2-40*e_ad*delta2*theta1^2+...
    40*delta1*theta1-60*e_ad*delta1*theta1-120*e_ad*delta0)*(mu_yA+mu_WyA)*(mu_xA+mu_WxA);

CMRdbeta_23 = (-(1/960)*sigma*(60*theta1-80*e_ad*theta1)*(mu_zA+mu_WzA)-(1/960)*sigma*(180*theta1-240*e_ad*theta1)*lambda_i-...
    (1/960)*sigma*(-30+60*e_ad)*(mu_xA+mu_WxA)^2-(1/960)*sigma*(-60*e_ad+30)*(mu_yA+mu_WyA)^2-(1/960)*sigma*(-240*e_ad+120)*(mu_zA+mu_WzA)^2-...
    (1/960)*sigma*(-480*e_ad+240)*lambda_i^2-(1/960)*sigma*(160*e_ad-60)-(1/960)*sigma*(360-720*e_ad)*(mu_zA+mu_WzA)*lambda_i)*a-...
    (1/960)*sigma*(60*e_ad*delta1*theta1-48*delta1*theta1+48*e_ad*delta2*theta1^2-40*delta2*theta1^2+80*e_ad*delta0-...
    60*delta0)-(1/960)*sigma*(480*e_ad*delta2-240*delta2)*(mu_zA+mu_WzA)*lambda_i-(1/960)*sigma*(-120*delta2*...
    theta1+160*e_ad*delta2*theta1-80*delta1+120*e_ad*delta1)*(mu_zA+mu_WzA)-(1/960)*sigma*(-120*delta2*theta1+...
    160*e_ad*delta2*theta1-80*delta1+120*e_ad*delta1)*lambda_i-(1/960)*sigma*(-60*delta1*theta1+90*e_ad*delta1*...
    theta1-45*delta2*theta1^2-90*delta0+60*e_ad*delta2*theta1^2+180*e_ad*delta0)*(mu_xA+mu_WxA)^2-(1/960)*sigma*...
    (-30*delta0-15*delta2*theta1^2-20*delta1*theta1+60*e_ad*delta0+30*e_ad*delta1*theta1+20*e_ad*delta2*theta1^2)*...
    (mu_yA+mu_WyA)^2-(1/960)*sigma*(240*e_ad*delta2-120*delta2)*(mu_zA+mu_WzA)^2-(1/960)*sigma*(240*e_ad*delta2-120*delta2)*lambda_i^2;

CMRdbeta_31 = 0;

CMRdbeta_32 = (-(1/12)*sigma*e_ad*theta1*(mu_xA+mu_WxA)+(1/240)*sigma*(-60+120*e_ad)*(mu_zA+mu_WzA)*(mu_xA+mu_WxA)+(1/240)*sigma*(-60+120*e_ad)*...
    lambda_i*(mu_xA+mu_WxA))*a+(1/240)*sigma*(30*e_ad*delta1+40*e_ad*delta2*theta1)*(mu_xA+mu_WxA)+(1/240)*sigma*(-120*e_ad*delta2+...
    60*delta2)*(mu_zA+mu_WzA)*(mu_xA+mu_WxA)+(1/240)*sigma*(60*delta2+40*delta1*theta1+60*delta0-120*e_ad*delta0-40*e_ad*delta2*...
    theta1^2-60*e_ad*delta1*theta1-120*e_ad*delta2+30*delta2*theta1^2)*lambda_i*(mu_xA+mu_WxA);

CMRdbeta_33 = (-(1/12)*sigma*e_ad*theta1*(mu_yA+mu_WyA)+(1/240)*sigma*(-60+120*e_ad)*(mu_zA+mu_WzA)*(mu_yA+mu_WyA)+(1/240)*sigma*(-60+120*e_ad)*...
    lambda_i*(mu_yA+mu_WyA))*a+(1/240)*sigma*(30*e_ad*delta1+40*e_ad*delta2*theta1)*(mu_yA+mu_WyA)+(1/240)*sigma*(-120*e_ad*delta2...
    +60*delta2)*(mu_zA+mu_WzA)*(mu_yA+mu_WyA)+(1/240)*sigma*(60*delta2+40*delta1*theta1+60*delta0-120*e_ad*delta0-40*e_ad*delta2*...
    theta1^2-60*e_ad*delta1*theta1-120*e_ad*delta2+30*delta2*theta1^2)*lambda_i*(mu_yA+mu_WyA);

%   Matriz de momentos en A debidos a las fuerzas en E proporcionales a  beta

CMRibeta_11 = -(1/8)*sigma*a*e_ad*(mu_yA+mu_WyA);
CMRibeta_12 = ((1/12)*sigma*e_ad-(1/6)*sigma*theta1*lambda_i*e_ad-(1/16)*sigma*e_ad*(mu_xA+mu_WxA)^2+(1/16)*sigma*e_ad*(mu_yA+mu_WyA)^2-...
    (1/4)*sigma*lambda_i*e_ad*(mu_zA+mu_WzA))*a;
CMRibeta_13 = -(1/8)*sigma*a*e_ad*(mu_yA+mu_WyA)*(mu_xA+mu_WxA);
CMRibeta_21 = (1/8)*sigma*a*(mu_xA+mu_WxA)*e_ad;
CMRibeta_22 = -(1/8)*sigma*a*e_ad*(mu_yA+mu_WyA)*(mu_xA+mu_WxA);
CMRibeta_23 = ((1/12)*sigma*e_ad-(1/6)*sigma*theta1*lambda_i*e_ad+(1/16)*sigma*e_ad*(mu_xA+mu_WxA)^2-(1/16)*...
    sigma*e_ad*(mu_yA+mu_WyA)^2-(1/4)*sigma*lambda_i*e_ad*(mu_zA+mu_WzA))*a;
CMRibeta_31 = 0;
CMRibeta_32 = (-(1/2)*sigma*e_ad*(mu_zA+mu_WzA)*(mu_xA+mu_WxA)-(1/2)*sigma*e_ad*lambda_i*(mu_xA+mu_WxA))*a+(1/2)*sigma*delta2*e_ad*(mu_zA+mu_WzA)*(mu_xA+mu_WxA)...
    -(1/120)*sigma*(-60*delta2-30*delta1*theta1-60*delta0-20*delta2*theta1^2)*e_ad*lambda_i*(mu_xA+mu_WxA);
CMRibeta_33 = (-(1/2)*sigma*e_ad*(mu_zA+mu_WzA)*(mu_yA+mu_WyA)-(1/2)*sigma*e_ad*lambda_i*(mu_yA+mu_WyA))*a+(1/2)*sigma*delta2*e_ad*(mu_zA+mu_WzA)*(mu_yA+mu_WyA)-...
    (1/120)*sigma*(-60*delta2-30*delta1*theta1-60*delta0-20*delta2*theta1^2)*e_ad*lambda_i*(mu_yA+mu_WyA);


%Matriz de momentos en A totales proporcionales a beta

CMRbeta_11 = CMRdbeta_11+CMRibeta_11;
CMRbeta_12 = CMRdbeta_12+CMRibeta_12;
CMRbeta_13 = CMRdbeta_13+CMRibeta_13;
CMRbeta_21 = CMRdbeta_21+CMRibeta_21;
CMRbeta_22 = CMRdbeta_22+CMRibeta_22;
CMRbeta_23 = CMRdbeta_23+CMRibeta_23;
CMRbeta_31 = CMRdbeta_31+CMRibeta_31;
CMRbeta_32 = CMRdbeta_32+CMRibeta_32;
CMRbeta_33 = CMRdbeta_33+CMRibeta_33;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
         
           
          
%ORDENACION DE LAS MATRICES DEL SISTEMA A PARTIR DE LA PARTE PURAMENTE
%AERODINÁMICA



    M_beta_Alvaro = [CMRbeta_11,CMRbeta_12,CMRbeta_13; CMRbeta_21,CMRbeta_22,CMRbeta_23; CMRbeta_31,CMRbeta_32,CMRbeta_33];
    M_theta_Alvaro = [CMRtheta_11,CMRtheta_12,CMRtheta_13; CMRtheta_21,CMRtheta_22,CMRtheta_23; CMRtheta_31,CMRtheta_32,CMRtheta_33];
    V_indep_Alvaro = [CMRind_1;CMRind_2;CMRind_3];
    
    Md_beta_Alvaro = [CMRdbeta_11,CMRdbeta_12,CMRdbeta_13; CMRdbeta_21,CMRdbeta_22,CMRdbeta_23; CMRdbeta_31,CMRdbeta_32,CMRdbeta_33];
    Md_theta_Alvaro = [CMRdtheta_11,CMRdtheta_12,CMRdtheta_13; CMRdtheta_21,CMRdtheta_22,CMRdtheta_23; CMRdtheta_31,CMRdtheta_32,CMRdtheta_33];
    Vd_indep_Alvaro = [CMdRind_1;CMdRind_2;CMdRind_3];
    
    Mi_beta_Alvaro = [CMRibeta_11,CMRibeta_12,CMRibeta_13; CMRibeta_21,CMRibeta_22,CMRibeta_23; CMRibeta_31,CMRibeta_32,CMRibeta_33];
    Mi_theta_Alvaro = [CMRitheta_11,CMRitheta_12,CMRitheta_13; CMRitheta_21,CMRitheta_22,CMRitheta_23; CMRitheta_31,CMRitheta_32,CMRitheta_33];
    Vi_indep_Alvaro = [CMiRind_1;CMiRind_2;CMiRind_3];

    betas = [beta0; beta1c ;beta1s];
    thetas = [theta0; theta1c; theta1s];

    CMRbeta_Alvaro = M_beta_Alvaro*betas;
    CMRtheta_Alvaro = M_theta_Alvaro*thetas;
    V_indep_Alvaro;

    %CMR = M_beta*betas+M_theta*thetas+V_indep;
    
    %CMR = M_beta*betas+M_theta*thetas+V_indep;
    
    CMRalter = b*[m_k*beta1s+m_e*beta1s;-m_k*beta1c-m_e*beta1c;0];
    
    CMR_Alvaro = M_beta_Alvaro*betas+M_theta_Alvaro*thetas+V_indep_Alvaro;

    
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%
%   MODELO DE MOMENTOS SIMPLIFICANDO POR ACOPLAMIENTO ELASTICO
%
%   MxA = [(k_beta/2)+(e*xGB*Mp*Omega^2)/2]*beta1s
%
%   MyA = -[(k_beta/2)+(e*xGB*Mp*Omega^2)/2]*beta1c
%
%
%       Vector independiente (Alvaro)
%
%
%   Momento en E

CMdRind_1 = 0;
CMdRind_2 = 0;
CMdRind_3 = (1/240*sigma*(-40*e_ad*theta1+30*theta1)*lambda_i+1/240*sigma*(-40*e_ad*theta1+30*theta1)*(mu_zA+mu_WzA)+1/240*sigma*...
    (60-120*e_ad)*lambda_i^2+1/240*sigma*(-240*e_ad+120)*(mu_zA+mu_WzA)*lambda_i+1/240*sigma*(60-120*e_ad)*(mu_zA+mu_WzA)^2)*a+1/240*sigma*...
    (-20*delta2*theta1^2-24*delta1*theta1-30*delta0+40*e_ad*delta0+24*e_ad*delta2*theta1^2+30*e_ad*delta1*theta1)+...
    1/240*sigma*(80*e_ad*delta2*theta1-40*delta1-60*delta2*theta1+60*e_ad*delta1)*(mu_zA+mu_WzA)+1/240*sigma*(-20*delta1*...
    theta1-30*delta0+20*e_ad*delta2*theta1^2+30*e_ad*delta1*theta1-15*delta2*theta1^2+60*e_ad*delta0)*(mu_yA+mu_WyA)^2+1/240*...
    sigma*(80*e_ad*delta2*theta1-40*delta1-60*delta2*theta1+60*e_ad*delta1)*lambda_i+1/240*sigma*(-20*delta1*theta1-...
    30*delta0+20*e_ad*delta2*theta1^2+30*e_ad*delta1*theta1-15*delta2*theta1^2+60*e_ad*delta0)*(mu_xA+mu_WxA)^2+1/240*sigma*...
    (-60*delta2+120*e_ad*delta2)*lambda_i^2+1/240*sigma*(240*e_ad*delta2-120*delta2)*(mu_zA+mu_WzA)*lambda_i+1/240*sigma*...
    (-60*delta2+120*e_ad*delta2)*(mu_zA+mu_WzA)^2;

    
 %   Momento en A de las fuerzas en E

CMiRind_1 = ((1/6)*sigma*e_ad*theta1*(mu_xA+mu_WxA)+(1/4)*sigma*e_ad*(mu_zA+mu_WzA)*(mu_xA+mu_WxA)+(1/4)*sigma*e_ad*lambda_i*(mu_xA+mu_WxA))*a;

CMiRind_2 = ((1/6)*sigma*e_ad*theta1*(mu_yA+mu_WyA)+(1/4)*sigma*e_ad*(mu_zA+mu_WzA)*(mu_yA+mu_WyA)+(1/4)*sigma*e_ad*lambda_i*(mu_yA+mu_WyA))*a;

CMiRind_3 = (((1/6)*sigma*theta1*lambda_i*e_ad+(1/6)*sigma*e_ad*theta1*(mu_zA+mu_WzA)+(1/2)*sigma*e_ad*lambda_i^2+...
    sigma*lambda_i*e_ad*(mu_zA+mu_WzA)+(1/2)*sigma*e_ad*(mu_zA+mu_WzA)^2)*a-(1/120)*sigma*(20*delta0+12*delta2*theta1^2+15*delta1*theta1)*...
    e_ad-(1/120)*sigma*(30*delta1+40*delta2*theta1)*e_ad*(mu_zA+mu_WzA)-(1/120)*sigma*(30*delta0+10*delta2*theta1^2+15*delta1*theta1)*...
    e_ad*(mu_yA+mu_WyA)^2-(1/120)*sigma*(30*delta1+40*delta2*theta1)*e_ad*lambda_i-(1/120)*sigma*(30*delta0+10*delta2*...
    theta1^2+15*delta1*theta1)*e_ad*(mu_xA+mu_WxA)^2-(1/2)*sigma*delta2*e_ad*lambda_i^2-sigma*delta2*e_ad*(mu_zA+mu_WzA)*lambda_i-...
    (1/2)*sigma*delta2*e_ad*(mu_zA+mu_WzA)^2);

% Termino independiente de momento en A total

  CMRind_1 = CMdRind_1+CMiRind_1;
  CMRind_2 = CMdRind_2+CMiRind_2;
  CMRind_3 = CMdRind_3+CMiRind_3;


%   MATRICES DE TERMINOS EN THETA
%
%   Matriz de momentos en E proporcionales a theta
%
%

CMRdtheta_11 = 0;
CMRdtheta_12 = 0;
CMRdtheta_13 = 0;
CMRdtheta_21 = 0;
CMRdtheta_22 = 0;
CMRdtheta_23 = 0;
CMRdtheta_31 = ((1/240)*sigma*(40-60*e_ad)*lambda_i+(1/240)*sigma*(40-60*e_ad)*(mu_zA+mu_WzA))*a+(1/240)*sigma*...
    (60*e_ad*delta2*theta1-30*delta1-48*delta2*theta1+40*e_ad*delta1)+(1/240)*sigma*(120*e_ad*delta2-80*delta2)*...
    (mu_zA+mu_WzA)+(1/240)*sigma*(-40*delta2*theta1+60*e_ad*delta2*theta1-30*delta1+60*e_ad*delta1)*(mu_yA+mu_WyA)^2+(1/240)*sigma*...
    (120*e_ad*delta2-80*delta2)*lambda_i+(1/240)*sigma*(-40*delta2*theta1+60*e_ad*delta2*theta1-30*delta1+60*e_ad*...
    delta1)*(mu_xA+mu_WxA)^2;
CMRdtheta_32 = ((1/240)*sigma*(-30+60*e_ad)*(mu_zA+mu_WzA)*(mu_yA+mu_WyA)+(1/240)*sigma*(-30+60*e_ad)*lambda_i*(mu_yA+mu_WyA))*a+(1/240)*...
    sigma*(-80*e_ad*delta2*theta1-60*e_ad*delta1+40*delta1+60*delta2*theta1)*(mu_yA+mu_WyA)+(1/240)*sigma*(-120*e_ad*delta2+60*delta2)*...
    (mu_zA+mu_WzA)*(mu_yA+mu_WyA)+(1/240)*sigma*(-120*e_ad*delta2+60*delta2)*lambda_i*(mu_yA+mu_WyA);
CMRdtheta_33 = ((1/240)*sigma*(30-60*e_ad)*(mu_zA+mu_WzA)*(mu_xA+mu_WxA)+(1/240)*sigma*(30-60*e_ad)*lambda_i*(mu_xA+mu_WxA))*a+...
    (1/240)*sigma*(80*e_ad*delta2*theta1-40*delta1-60*delta2*theta1+60*e_ad*delta1)*(mu_xA+mu_WxA)+(1/240)*sigma*...
    (-60*delta2+120*e_ad*delta2)*(mu_zA+mu_WzA)*(mu_xA+mu_WxA)+(1/240)*sigma*(-60*delta2+120*e_ad*delta2)*lambda_i*(mu_xA+mu_WxA);

%   Matriz de momentos en A debidos a las fuerzas en E proporcionales a theta


CMRitheta_11 = (1/4)*sigma*a*(mu_xA+mu_WxA)*e_ad;
CMRitheta_12 = -(1/8)*sigma*a*e_ad*(mu_yA+mu_WyA)*(mu_xA+mu_WxA);
CMRitheta_13 = ((1/12)*sigma*e_ad+(3/16)*sigma*e_ad*(mu_xA+mu_WxA)^2+(1/16)*sigma*e_ad*(mu_yA+mu_WyA)^2)*a;
CMRitheta_21 = (1/4)*sigma*a*e_ad*(mu_yA+mu_WyA);
CMRitheta_22 = (-(1/12)*sigma*e_ad-(1/16)*sigma*e_ad*(mu_xA+mu_WxA)^2-(3/16)*sigma*e_ad*(mu_yA+mu_WyA)^2)*a;
CMRitheta_23 = (1/8)*sigma*a*e_ad*(mu_yA+mu_WyA)*(mu_xA+mu_WxA);
CMRitheta_31 = ((1/4)*sigma*e_ad*lambda_i+(1/4)*sigma*e_ad*(mu_zA+mu_WzA))*a-(1/120)*sigma*(20*delta1+30*delta2*theta1)*e_ad...
                -(1/2)*sigma*delta2*e_ad*(mu_zA+mu_WzA)-(1/120)*sigma*(30*delta1+30*delta2*theta1)*e_ad*(mu_yA+mu_WyA)^2-(1/2)*sigma*delta2*e_ad*...
                lambda_i-(1/120)*sigma*(30*delta1+30*delta2*theta1)*e_ad*(mu_xA+mu_WxA)^2;
CMRitheta_32 = (-(1/4)*sigma*e_ad*(mu_zA+mu_WzA)*(mu_yA+mu_WyA)-(1/4)*sigma*e_ad*lambda_i*(mu_yA+mu_WyA))*a-(1/120)*sigma*(-30*delta1-40*delta2*theta1)*...
                e_ad*(mu_yA+mu_WyA)+(1/2)*sigma*delta2*e_ad*(mu_zA+mu_WzA)*(mu_yA+mu_WyA)+(1/2)*sigma*delta2*e_ad*lambda_i*(mu_yA+mu_WyA);
CMRitheta_33 = ((1/4)*sigma*e_ad*(mu_zA+mu_WzA)*(mu_xA+mu_WxA)+(1/4)*sigma*e_ad*lambda_i*(mu_xA+mu_WxA))*a-(1/120)*sigma*(30*delta1+40*delta2*theta1)*e_ad*(mu_xA+mu_WxA)...
                -(1/2)*sigma*delta2*e_ad*(mu_zA+mu_WzA)*(mu_xA+mu_WxA)-(1/2)*sigma*delta2*e_ad*lambda_i*(mu_xA+mu_WxA);


 %Matriz de momentos en A totales proporcionales a theta

CMRtheta_11 = CMRdtheta_11+CMRitheta_11;
CMRtheta_12 = CMRdtheta_12+CMRitheta_12;
CMRtheta_13 = CMRdtheta_13+CMRitheta_13;
CMRtheta_21 = CMRdtheta_21+CMRitheta_21;
CMRtheta_22 = CMRdtheta_22+CMRitheta_22;
CMRtheta_23 = CMRdtheta_23+CMRitheta_23;
CMRtheta_31 = CMRdtheta_31+CMRitheta_31;
CMRtheta_32 = CMRdtheta_32+CMRitheta_32;
CMRtheta_33 = CMRdtheta_33+CMRitheta_33;


%   MATRICES DE TERMINOS EN BETA


%   Matriz de momentos en E proporcionales a beta

CMRdbeta_11 = (-(1/960)*sigma*(120*e_ad*theta1-80*theta1)*(mu_zA+mu_WzA)*(mu_yA+mu_WyA)-(1/960)*sigma*(120*e_ad*theta1-80*theta1)*...
    lambda_i*(mu_yA+mu_WyA))*a-(1/960)*sigma*(-160*e_ad*delta1*theta1+96*delta2*theta1^2+160*delta0-240*e_ad*delta0...
    +120*delta1*theta1-120*e_ad*delta2*theta1^2)*(mu_yA+mu_WyA)-(1/960)*sigma*(-240*e_ad*delta1-240*e_ad*delta2*theta1+160*...
    delta2*theta1+120*delta1)*(mu_zA+mu_WzA)*(mu_yA+mu_WyA)-(1/960)*sigma*(-240*e_ad*delta1-240*e_ad*delta2*theta1+160*delta2*theta1+120*delta1)...
    *lambda_i*(mu_yA+mu_WyA);
CMRdbeta_12 = (-(1/960)*sigma*(-80*e_ad*theta1+60*theta1)*lambda_i-(1/960)*sigma*(-80*e_ad*theta1+60*theta1)*(mu_zA+mu_WzA)-...
    (1/960)*sigma*(-480*e_ad+240)*(mu_zA+mu_WzA)*lambda_i-(1/960)*sigma*(-240*e_ad+120)*lambda_i^2-(1/960)*sigma*(-240*e_ad+120)*...
    (mu_zA+mu_WzA)^2)*a-(1/960)*sigma*(-40*delta2*theta1^2+80*e_ad*delta0+60*e_ad*delta1*theta1+48*e_ad*delta2*theta1^2-60*delta0...
    -48*delta1*theta1)-(1/960)*sigma*(-80*delta1+160*e_ad*delta2*theta1+120*e_ad*delta1-120*delta2*theta1)*(mu_zA+mu_WzA)-(1/960)*...
    sigma*(60*e_ad*delta2*theta1^2+180*e_ad*delta0+90*e_ad*delta1*theta1-60*delta1*theta1-90*delta0-45*...
    delta2*theta1^2)*(mu_yA+mu_WyA)^2-(1/960)*sigma*(-80*delta1+160*e_ad*delta2*theta1+120*e_ad*delta1-120*delta2*...
    theta1)*lambda_i-(1/960)*sigma*(-20*delta1*theta1-30*delta0+20*e_ad*delta2*theta1^2+30*e_ad*delta1*theta1-15*delta2...
    *theta1^2+60*e_ad*delta0)*(mu_xA+mu_WxA)^2-(1/960)*sigma*(480*e_ad*delta2-240*delta2)*(mu_zA+mu_WzA)*lambda_i-(1/960)*sigma*...
    (240*e_ad*delta2-120*delta2)*lambda_i^2-(1/960)*sigma*(240*e_ad*delta2-120*delta2)*(mu_zA+mu_WzA)^2;

CMRdbeta_13 = -(1/960)*sigma*(-120*e_ad*delta0+30*delta2*theta1^2-40*e_ad*delta2*theta1^2+60*delta0+40*delta1*...
    theta1-60*e_ad*delta1*theta1)*(mu_yA+mu_WyA)*(mu_xA+mu_WxA);

CMRdbeta_21 = ((1/960)*sigma*(120*e_ad*theta1-80*theta1)*(mu_zA+mu_WzA)*(mu_xA+mu_WxA)+(1/960)*sigma*(120*e_ad*theta1-80*theta1)*...
    lambda_i*(mu_xA+mu_WxA))*a+(1/960)*sigma*(-160*e_ad*delta1*theta1+96*delta2*theta1^2+160*delta0-240*e_ad*delta0+...
    120*delta1*theta1-120*e_ad*delta2*theta1^2)*(mu_xA+mu_WxA)+(1/960)*sigma*(-240*e_ad*delta1-240*e_ad*delta2*...
    theta1+160*delta2*theta1+120*delta1)*(mu_zA+mu_WzA)*(mu_xA+mu_WxA)+(1/960)*sigma*(-240*e_ad*delta1-240*e_ad*delta2*theta1+...
    160*delta2*theta1+120*delta1)*lambda_i*(mu_xA+mu_WxA);

CMRdbeta_22 = (1/960)*sigma*(-40*delta1*theta1+40*e_ad*delta2*theta1^2-60*delta0-30*delta2*theta1^2+120*...
    e_ad*delta0+60*e_ad*delta1*theta1)*(mu_yA+mu_WyA)*(mu_xA+mu_WxA),

CMRdbeta_23 = ((1/960)*sigma*(80*e_ad*theta1-60*theta1)*lambda_i+(1/960)*...
    sigma*(80*e_ad*theta1-60*theta1)*(mu_zA+mu_WzA)+(1/960)*sigma*(240*e_ad-120)*lambda_i^2+(1/960)*sigma*(240*e_ad-120)*(mu_zA+mu_WzA)^2+...
    (1/960)*sigma*(-240+480*e_ad)*(mu_zA+mu_WzA)*lambda_i)*a+(1/960)*sigma*(-48*e_ad*delta2*theta1^2-60*e_ad*delta1*theta1+40*delta2*...
    theta1^2-80*e_ad*delta0+48*delta1*theta1+60*delta0)+(1/960)*sigma*(120*delta2*theta1+80*delta1-...
    160*e_ad*delta2*theta1-120*e_ad*delta1)*(mu_zA+mu_WzA)+(1/960)*sigma*(-60*e_ad*delta0+20*delta1*theta1+30*delta0-...
    30*e_ad*delta1*theta1-20*e_ad*delta2*theta1^2+15*delta2*theta1^2)*(mu_yA+mu_WyA)^2+(1/960)*sigma*(120*delta2*theta1+80*...
    delta1-160*e_ad*delta2*theta1-120*e_ad*delta1)*lambda_i+(1/960)*sigma*(45*delta2*theta1^2-90*e_ad*delta1*...
    theta1+60*delta1*theta1+90*delta0-60*e_ad*delta2*theta1^2-180*e_ad*delta0)*(mu_xA+mu_WxA)^2+(1/960)*sigma*(-240*e_ad*delta2+...
    120*delta2)*lambda_i^2+(1/960)*sigma*(-240*e_ad*delta2+120*delta2)*(mu_zA+mu_WzA)^2+(1/960)*sigma*(240*delta2-...
    480*e_ad*delta2)*(mu_zA+mu_WzA)*lambda_i;

CMRdbeta_31 = 0;

CMRdbeta_32 = (-(1/12)*sigma*e_ad*theta1*(mu_xA+mu_WxA)+(1/240)*sigma*(120*e_ad-60)*(mu_zA+mu_WzA)*(mu_xA+mu_WxA)+(1/240)*sigma*(120*e_ad-60)*...
    lambda_i*(mu_xA+mu_WxA))*a+(1/240)*sigma*(40*e_ad*delta2*theta1+30*e_ad*delta1)*(mu_xA+mu_WxA)+(1/240)*sigma*...
    (-120*e_ad*delta2+60*delta2)*(mu_zA+mu_WzA)*(mu_xA+mu_WxA)+(1/240)*sigma*(40*delta1*theta1-120*e_ad*delta2+30*delta2*...
    theta1^2-40*e_ad*delta2*theta1^2-60*e_ad*delta1*theta1-120*e_ad*delta0+60*delta0+60*delta2)*lambda_i*(mu_xA+mu_WxA);

CMRdbeta_33 = (-(1/12)*sigma*e_ad*theta1*(mu_yA+mu_WyA)+(1/240)*sigma*(120*e_ad-60)*(mu_zA+mu_WzA)*(mu_yA+mu_WyA)+(1/240)*sigma*(120*e_ad-60)*...
    lambda_i*(mu_yA+mu_WyA))*a+(1/240)*sigma*(40*e_ad*delta2*theta1+30*e_ad*delta1)*(mu_yA+mu_WyA)+(1/240)*sigma*...
    (-120*e_ad*delta2+60*delta2)*(mu_zA+mu_WzA)*(mu_yA+mu_WyA)+(1/240)*sigma*...
    (40*delta1*theta1-120*e_ad*delta2+30*delta2*theta1^2-40*e_ad*delta2*theta1^2-60*e_ad*delta1*theta1-120*e_ad*delta0+60*delta0+60*delta2)*...
    lambda_i*(mu_yA+mu_WyA);

%   Matriz de momentos en A debidos a las fuerzas en E proporcionales a  beta

CMRibeta_11 = -(1/8)*sigma*a*e_ad*(mu_yA+mu_WyA);
CMRibeta_12 = ((1/12)*sigma*e_ad-(1/6)*sigma*theta1*lambda_i*e_ad-(1/16)*sigma*e_ad*(mu_xA+mu_WxA)^2+(1/16)*sigma*e_ad*(mu_yA+mu_WyA)^2-...
    (1/4)*sigma*lambda_i*e_ad*(mu_zA+mu_WzA))*a;
CMRibeta_13 = -(1/8)*sigma*a*e_ad*(mu_yA+mu_WyA)*(mu_xA+mu_WxA);
CMRibeta_21 = (1/8)*sigma*a*(mu_xA+mu_WxA)*e_ad;
CMRibeta_22 = -(1/8)*sigma*a*e_ad*(mu_yA+mu_WyA)*(mu_xA+mu_WxA);
CMRibeta_23 = ((1/12)*sigma*e_ad-(1/6)*sigma*theta1*lambda_i*e_ad+(1/16)*sigma*e_ad*(mu_xA+mu_WxA)^2-(1/16)*...
    sigma*e_ad*(mu_yA+mu_WyA)^2-(1/4)*sigma*lambda_i*e_ad*(mu_zA+mu_WzA))*a;
CMRibeta_31 = 0;
CMRibeta_32 = (-(1/2)*sigma*e_ad*(mu_zA+mu_WzA)*(mu_xA+mu_WxA)-(1/2)*sigma*e_ad*lambda_i*(mu_xA+mu_WxA))*a+(1/2)*sigma*delta2*e_ad*(mu_zA+mu_WzA)*(mu_xA+mu_WxA)...
    -(1/120)*sigma*(-60*delta2-30*delta1*theta1-60*delta0-20*delta2*theta1^2)*e_ad*lambda_i*(mu_xA+mu_WxA);
CMRibeta_33 = (-(1/2)*sigma*e_ad*(mu_zA+mu_WzA)*(mu_yA+mu_WyA)-(1/2)*sigma*e_ad*lambda_i*(mu_yA+mu_WyA))*a+(1/2)*sigma*delta2*e_ad*(mu_zA+mu_WzA)*(mu_yA+mu_WyA)-...
    (1/120)*sigma*(-60*delta2-30*delta1*theta1-60*delta0-20*delta2*theta1^2)*e_ad*lambda_i*(mu_yA+mu_WyA);


%Matriz de momentos en A totales proporcionales a beta

CMRbeta_11 = CMRdbeta_11+CMRibeta_11;
CMRbeta_12 = CMRdbeta_12+CMRibeta_12;
CMRbeta_13 = CMRdbeta_13+CMRibeta_13;
CMRbeta_21 = CMRdbeta_21+CMRibeta_21;
CMRbeta_22 = CMRdbeta_22+CMRibeta_22;
CMRbeta_23 = CMRdbeta_23+CMRibeta_23;
CMRbeta_31 = CMRdbeta_31+CMRibeta_31;
CMRbeta_32 = CMRdbeta_32+CMRibeta_32;
CMRbeta_33 = CMRdbeta_33+CMRibeta_33;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
         
           
          
%ORDENACION DE LAS MATRICES DEL SISTEMA A PARTIR DE LA PARTE PURAMENTE
%AERODINÁMICA



    M_beta_Elastico = [CMRbeta_11,CMRbeta_12,CMRbeta_13; CMRbeta_21,CMRbeta_22,CMRbeta_23; CMRbeta_31,CMRbeta_32,CMRbeta_33];
    M_theta_Elastico = [CMRtheta_11,CMRtheta_12,CMRtheta_13; CMRtheta_21,CMRtheta_22,CMRtheta_23; CMRtheta_31,CMRtheta_32,CMRtheta_33];
    V_indep_Elastico = [CMRind_1;CMRind_2;CMRind_3];
    
    Md_beta_Elastico = [CMRdbeta_11,CMRdbeta_12,CMRdbeta_13; CMRdbeta_21,CMRdbeta_22,CMRdbeta_23; CMRdbeta_31,CMRdbeta_32,CMRdbeta_33];
    Md_theta_Elastico = [CMRdtheta_11,CMRdtheta_12,CMRdtheta_13; CMRdtheta_21,CMRdtheta_22,CMRdtheta_23; CMRdtheta_31,CMRdtheta_32,CMRdtheta_33];
    Vd_indep_Elastico = [CMdRind_1;CMdRind_2;CMdRind_3];
    
    Mi_beta_Elastico = [CMRibeta_11,CMRibeta_12,CMRibeta_13; CMRibeta_21,CMRibeta_22,CMRibeta_23; CMRibeta_31,CMRibeta_32,CMRibeta_33];
    Mi_theta_Elastico = [CMRitheta_11,CMRitheta_12,CMRitheta_13; CMRitheta_21,CMRitheta_22,CMRitheta_23; CMRitheta_31,CMRitheta_32,CMRitheta_33];
    Vi_indep_Elastico = [CMiRind_1;CMiRind_2;CMiRind_3];

    betas = [beta0; beta1c ;beta1s];
    thetas = [theta0; theta1c; theta1s];

    CMRbeta_Elastico = M_beta_Elastico*betas;
    CMRtheta_Elastico = M_theta_Elastico*thetas;
    V_indep_Elastico;

    %CMR = M_beta*betas+M_theta*thetas+V_indep;
    
    %CMR = M_beta*betas+M_theta*thetas+V_indep;
    
    CMRalter = b*[m_k*beta1s+m_e*beta1s;-m_k*beta1c-m_e*beta1c;0];
    
    CMR_Elastico = M_beta_Elastico*betas+M_theta_Elastico*thetas+V_indep_Elastico;

    
    
    
%   COMPARACIÓN DE MATRICES
    
    
    V_indep_ASE = V_indep_ASE
    V_indep_Mixto = V_indep_Mixto  
    V_indep_Alvaro = V_indep_Alvaro
    Vd_indep_Alvaro = Vd_indep_Alvaro
    Vi_iindep_Alvaro = Vi_indep_Alvaro
    V_indep_Elastico = V_indep_Elastico
    Vd_indep_Elastico = Vd_indep_Elastico
    Vi_iindep_Elastico = Vi_indep_Elastico
    
    
    M_beta_ASE = M_beta_ASE
    M_beta_Mixto = M_beta_Mixto
    M_beta_Alvaro = M_beta_Alvaro
    Md_beta_Alvaro = Md_beta_Alvaro
    Mi_beta_Alvaro = Mi_beta_Alvaro
    M_beta_Elastico = M_beta_Elastico
    Md_beta_Elastico = Md_beta_Elastico
    Mi_beta_Elastico = Mi_beta_Elastico
    
    M_theta_ASE = M_theta_ASE
    M_theta_Mixto = M_theta_Mixto
    M_theta_Alvaro = M_theta_Alvaro
    Md_theta_Alvaro = Md_theta_Alvaro
    Mi_theta_Alvaro = Mi_theta_Alvaro
    M_theta_Elastico = M_theta_Elastico
    Md_theta_Elastico = Md_theta_Elastico
    Mi_theta_Elastico = Mi_theta_Elastico
    
    
    CMR_ASE = CMR_ASE
    CMR_Mixto = CMR_Mixto
    CMR_Alvaro = CMR_Alvaro
    CMR_Elastico = CMR_Elastico
    
    CMRalter = CMRalter
