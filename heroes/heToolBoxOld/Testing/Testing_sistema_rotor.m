% Función de prueba de fuerza del rotor 01

clear all

%close all

format long

  

theta0 = 16*pi/180;
theta1c = 0;
theta1s = 0;


% mu_xA = 0.22516421547832;
% mu_yA = -2.934154348262831e-004;
% mu_zA = -0.01138175546401;

mu_xA = -0.1;
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


%   bucle en beta
    
    vector_kbeta = [linspace(1,150000,20)];
    
    for kbetai = 1:length(vector_kbeta);
        
        k_beta = vector_kbeta(kbetai)
    
        HM.RP.k_beta = k_beta;
    
    [Atm] = ISA(HM.altura);

%Para el caso de polar linealizada para todos los elementos

    rango = [-15 10]*pi/180;
    [HM] = polarlineal(HM,rango);

%Creacion de los parametros adimensionales para las ecuaciones
    
    [MHAdim] = Adimensionalizacion(HM,Atm);
     
%Solución del sistema del rotor principal
    
    lambda_i0 = -0.03;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%   Modelo ASE
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


MHAdim.Analisis.ModeloAcciones = 'ASE';
    
    options = optimset('fsolve');
    options = optimset(options,'Display','off');

    x = fsolve(@(x) systemPala(x,MHAdim,theta0,theta1c,theta1s,mu_xA,mu_yA,mu_zA,mu_WxA,mu_WyA,mu_WzA,lambda_i0),...
        [0.01; 0.0; 0.0; -.3;1e-5],options);
    
    beta0 = x(1);   beta1c = x(2);  beta1s = x(3); lambda_iP = x(4);

    [CHinA,CYinA,CTinA] = fza_rotor(MHAdim,theta0,theta1c,theta1s,beta0,beta1c,beta1s,lambda_iP,mu_xA,mu_yA,...
        mu_zA,mu_WxA,mu_WyA,mu_WzA);
    
    [CMHinA,CMYinA,CMTinA,CMRalter] = momento_rotor(MHAdim,theta0,theta1c,theta1s,beta0,beta1c,beta1s,lambda_iP,...
        mu_xA,mu_yA,mu_zA,mu_WxA,mu_WyA,mu_WzA);
    
    CFRPinA_ASE = [CHinA;CYinA;CTinA];
    CMRPinA_ASE = [CMHinA;CMYinA;CMTinA];
    beta_ASE = [beta0;beta1c;beta1s];
    lambda_iP_ASE = lambda_iP;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%   Modelo Mixto
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
MHAdim.Analisis.ModeloAcciones = 'Mixto';
    
    options = optimset('fsolve');
    options = optimset(options,'Display','off');

    x = fsolve(@(x) systemPala(x,MHAdim,theta0,theta1c,theta1s,mu_xA,mu_yA,mu_zA,mu_WxA,mu_WyA,mu_WzA,lambda_i0),...
        [0.01; 0.0; 0.0; -.3;1e-5],options);
    
    beta0 = x(1);   beta1c = x(2);  beta1s = x(3); lambda_iP = x(4);

    [CHinA,CYinA,CTinA] = fza_rotor(MHAdim,theta0,theta1c,theta1s,beta0,beta1c,beta1s,lambda_iP,mu_xA,mu_yA,...
        mu_zA,mu_WxA,mu_WyA,mu_WzA);
    
    [CMHinA,CMYinA,CMTinA,CMRalter] = momento_rotor(MHAdim,theta0,theta1c,theta1s,beta0,beta1c,beta1s,lambda_iP,...
        mu_xA,mu_yA,mu_zA,mu_WxA,mu_WyA,mu_WzA);
    
    CFRPinA_Mixto = [CHinA;CYinA;CTinA];
    CMRPinA_Mixto = [CMHinA;CMYinA;CMTinA];
    beta_Mixto = [beta0;beta1c;beta1s];
    lambda_iP_Mixto = lambda_iP;
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%   Modelo Alvaro
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
    
    
MHAdim.Analisis.ModeloAcciones = 'Alvaro';
    
    options = optimset('fsolve');
    options = optimset(options,'Display','off');

    x = fsolve(@(x) systemPala(x,MHAdim,theta0,theta1c,theta1s,mu_xA,mu_yA,mu_zA,mu_WxA,mu_WyA,mu_WzA,lambda_i0),...
        [0.01; 0.0; 0.0; -.3;1e-5],options);
    
    beta0 = x(1);   beta1c = x(2);  beta1s = x(3); lambda_iP = x(4);

    [CHinA,CYinA,CTinA] = fza_rotor(MHAdim,theta0,theta1c,theta1s,beta0,beta1c,beta1s,lambda_iP,mu_xA,mu_yA,...
        mu_zA,mu_WxA,mu_WyA,mu_WzA);
    
    [CMHinA,CMYinA,CMTinA,CMRalter] = momento_rotor(MHAdim,theta0,theta1c,theta1s,beta0,beta1c,beta1s,lambda_iP,...
        mu_xA,mu_yA,mu_zA,mu_WxA,mu_WyA,mu_WzA);
    
    CFRPinA_Alvaro = [CHinA;CYinA;CTinA];
    CMRPinA_Alvaro = [CMHinA;CMYinA;CMTinA];
    beta_Alvaro = [beta0;beta1c;beta1s];    
    lambda_iP_Alvaro = lambda_iP;
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%   Modelo Elástico
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
    
    
MHAdim.Analisis.ModeloAcciones = 'Elastico';
    
    options = optimset('fsolve');
    options = optimset(options,'Display','off');

    x = fsolve(@(x) systemPala(x,MHAdim,theta0,theta1c,theta1s,mu_xA,mu_yA,mu_zA,mu_WxA,mu_WyA,mu_WzA,lambda_i0),...
        [0.01; 0.0; 0.0; -.3;1e-5],options);
    
    beta0 = x(1);   beta1c = x(2);  beta1s = x(3); lambda_iP = x(4);

    [CHinA,CYinA,CTinA] = fza_rotor(MHAdim,theta0,theta1c,theta1s,beta0,beta1c,beta1s,lambda_iP,mu_xA,mu_yA,...
        mu_zA,mu_WxA,mu_WyA,mu_WzA);
    
    [CMHinA,CMYinA,CMTinA,CMRalter] = momento_rotor(MHAdim,theta0,theta1c,theta1s,beta0,beta1c,beta1s,lambda_iP,...
        mu_xA,mu_yA,mu_zA,mu_WxA,mu_WyA,mu_WzA);
    
    CFRPinA_Elastico = [CHinA;CYinA;CTinA];
    CMRPinA_Elastico = [CMHinA;CMYinA;CMTinA];
    beta_Elastico = [beta0;beta1c;beta1s];
    lambda_iP_Elastico = lambda_iP;
 
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%   Modelo AlvaroNL
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
    
    
MHAdim.Analisis.ModeloAcciones = 'AlvaroNL';
    
    options = optimset('fsolve');
    options = optimset(options,'Display','off');

    x = fsolve(@(x) systemPala(x,MHAdim,theta0,theta1c,theta1s,mu_xA,mu_yA,mu_zA,mu_WxA,mu_WyA,mu_WzA,lambda_i0),...
        [0.01; 0.0; 0.0; -.3;1e-5],options);
    
    beta0 = x(1);   beta1c = x(2);  beta1s = x(3); lambda_iP = x(4);

    [CHinA,CYinA,CTinA] = fza_rotor(MHAdim,theta0,theta1c,theta1s,beta0,beta1c,beta1s,lambda_iP,mu_xA,mu_yA,...
        mu_zA,mu_WxA,mu_WyA,mu_WzA);
    
    [CMHinA,CMYinA,CMTinA,CMRalter] = momento_rotor(MHAdim,theta0,theta1c,theta1s,beta0,beta1c,beta1s,lambda_iP,...
        mu_xA,mu_yA,mu_zA,mu_WxA,mu_WyA,mu_WzA);
    
%     [CMHinA,CMYinA,CMTinA,CMRalter] = momento_rotor(MHAdim,theta0,theta1c,theta1s,beta0,beta1c,beta1s,lambda_iP,...
%         mu_xA,mu_yA,mu_zA,mu_WxA,mu_WyA,mu_WzA);
    
    CFRPinA_AlvaroNL = [CHinA;CYinA;CTinA];
    CMRPinA_AlvaroNL = [CMHinA,CMYinA,CMTinA];

    
    
    beta_AlvaroNL = [beta0;beta1c;beta1s];
    lambda_iP_AlvaroNL = lambda_iP;
 
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%   Modelo ElasticoNL
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
    
    
MHAdim.Analisis.ModeloAcciones = 'ElasticoNL';
    
    options = optimset('fsolve');
    options = optimset(options,'Display','off');

    x = fsolve(@(x) systemPala(x,MHAdim,theta0,theta1c,theta1s,mu_xA,mu_yA,mu_zA,mu_WxA,mu_WyA,mu_WzA,lambda_i0),...
        [0.01; 0.0; 0.0; -.3;1e-5],options);
    
    beta0 = x(1);   beta1c = x(2);  beta1s = x(3); lambda_iP = x(4);

    [CHinA,CYinA,CTinA] = fza_rotor(MHAdim,theta0,theta1c,theta1s,beta0,beta1c,beta1s,lambda_iP,mu_xA,mu_yA,...
        mu_zA,mu_WxA,mu_WyA,mu_WzA);
    
    [CMHinA,CMYinA,CMTinA,CMRalter] = momento_rotor(MHAdim,theta0,theta1c,theta1s,beta0,beta1c,beta1s,lambda_iP,...
        mu_xA,mu_yA,mu_zA,mu_WxA,mu_WyA,mu_WzA);
    
    CFRPinA_ElasticoNL = [CHinA;CYinA;CTinA];
    CMRPinA_ElasticoNL = [CMHinA,CMYinA,CMTinA];
    CMRalterElasticoNL = CMRalter;
    beta_ElasticoNL = [beta0;beta1c;beta1s];
    lambda_iP_ElasticoNL = lambda_iP;
    
    
    
   
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%   COMPARACIONES
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    CFRPinA_ASE = CFRPinA_ASE;
    CFRPinA_Mixto = CFRPinA_Mixto;
    CFRPinA_Alvaro = CFRPinA_Alvaro;
    CFRPinA_Elastico = CFRPinA_Elastico;
    CFRPinA_AlvaroNL = CFRPinA_AlvaroNL;
    CFRPinA_ElasticoNL = CFRPinA_ElasticoNL;
    
    CMRPinA_ASE = CMRPinA_ASE;
    CMRPinA_Mixto = CMRPinA_Mixto;
    CMRPinA_Alvaro = CMRPinA_Alvaro;
    CMRPinA_Elastico = CMRPinA_Elastico;
    CMRPinA_ElasticoNL = CMRPinA_ElasticoNL;
        
    beta_ASE = beta_ASE;
    beta_Mixto = beta_Mixto;
    beta_Alvaro = beta_Alvaro;
    beta_Elastico = beta_Elastico;
    beta_AlvaroNL = beta_AlvaroNL;
    beta_ElasticoNL = beta_ElasticoNL;
    
    
    lambda_iP_ASE = lambda_iP_ASE;
    lambda_iP_Mixto = lambda_iP_Mixto;
    lambda_iP_Alvaro = lambda_iP_Alvaro;
    lambda_iP_Elastico = lambda_iP_Elastico;
    lambda_iP_AlvaroNL = lambda_iP_AlvaroNL;
    lambda_iP_ElasticoNL = lambda_iP_ElasticoNL;
    
    CFRPinA_ASEVec(kbetai,:) = CFRPinA_ASE';
    CFRPinA_MixtoVec(kbetai,:) = CFRPinA_Mixto';
    CFRPinA_AlvaroVec(kbetai,:) = CFRPinA_Alvaro';
    CFRPinA_ElasticoVec(kbetai,:) = CFRPinA_Elastico';
    CFRPinA_AlvaroNLVec(kbetai,:) = CFRPinA_AlvaroNL';
    CFRPinA_ElasticoNLVec(kbetai,:) = CFRPinA_ElasticoNL';
    
    
    
    CMRPinA_ASEVec(kbetai,:) = CMRPinA_ASE';
    CMRPinA_MixtoVec(kbetai,:) = CMRPinA_Mixto';
    CMRPinA_AlvaroVec(kbetai,:) = CMRPinA_Alvaro';
    CMRPinA_ElasticoVec(kbetai,:) = CMRPinA_Elastico';
    CMRPinA_AlvaroNLVec(kbetai,:) = CMRPinA_AlvaroNL';
    CMRPinA_ElasticoNLVec(kbetai,:) = CMRPinA_ElasticoNL';
    CMRalterElasticoNLVec(kbetai,:) = CMRalterElasticoNL;
    
    beta_ASEVec(kbetai,:) = beta_ASE';
    beta_MixtoVec(kbetai,:) = beta_Mixto';
    beta_AlvaroVec(kbetai,:) = beta_Alvaro';
    beta_ElasticoVec(kbetai,:) = beta_Elastico';
    beta_AlvaroNLVec(kbetai,:) = beta_AlvaroNL';
    beta_ElasticoNLVec(kbetai,:) = beta_ElasticoNL';
    
    lambda_iP_ASEVec(kbetai,:) = lambda_iP_ASE';
    lambda_iP_MixtoVec(kbetai,:) = lambda_iP_Mixto';
    lambda_iP_AlvaroVec(kbetai,:) = lambda_iP_Alvaro';
    lambda_iP_ElasticoVec(kbetai,:) = lambda_iP_Elastico';
    lambda_iP_AlvaroNLVec(kbetai,:) = lambda_iP_AlvaroNL';
    lambda_iP_ElasticoNLVec(kbetai,:) = lambda_iP_ElasticoNL';
    
    
    end
    
    
    figure(100)
    
    subplot(3,3,1)
    hold on
    plot(vector_kbeta,CFRPinA_ASEVec(:,1),'k-');
    plot(vector_kbeta,CFRPinA_MixtoVec(:,1),'bs');
    plot(vector_kbeta,CFRPinA_AlvaroVec(:,1),'r-');
    plot(vector_kbeta,CFRPinA_ElasticoVec(:,1),'go');
    plot(vector_kbeta,CFRPinA_AlvaroNLVec(:,1),'ks-');
    plot(vector_kbeta,CFRPinA_ElasticoNLVec(:,1),'ko-');
    legend('ASE','Mixto','Alvaro','Elastico','AlvaroNL','ElasticoNL');
    xlabel('k\it\beta');
    ylabel('CFxA');
    
    subplot(3,3,2)
    hold on
    plot(vector_kbeta,CFRPinA_ASEVec(:,2),'k-');
    plot(vector_kbeta,CFRPinA_MixtoVec(:,2),'bs');
    plot(vector_kbeta,CFRPinA_AlvaroVec(:,2),'r-');
    plot(vector_kbeta,CFRPinA_ElasticoVec(:,2),'go');
    plot(vector_kbeta,CFRPinA_AlvaroNLVec(:,2),'ks-');
    plot(vector_kbeta,CFRPinA_ElasticoNLVec(:,2),'ko-');
    legend('ASE','Mixto','Alvaro','Elastico','AlvaroNL','ElasticoNL');
    xlabel('k\it\beta');
    ylabel('CFyA');
    
    subplot(3,3,3)
    hold on
    plot(vector_kbeta,CFRPinA_ASEVec(:,3),'k-');
    plot(vector_kbeta,CFRPinA_MixtoVec(:,3),'bs');
    plot(vector_kbeta,CFRPinA_AlvaroVec(:,3),'r-');
    plot(vector_kbeta,CFRPinA_ElasticoVec(:,3),'go');
    plot(vector_kbeta,CFRPinA_AlvaroNLVec(:,3),'ks-');
    plot(vector_kbeta,CFRPinA_ElasticoNLVec(:,3),'ko-');
    legend('ASE','Mixto','Alvaro','Elastico','AlvaroNL','ElasticoNL');
    xlabel('k\it\beta');
    ylabel('CFzA');
    
    subplot(3,3,4)
    hold on
    plot(vector_kbeta,CMRPinA_ASEVec(:,1),'k-');
    plot(vector_kbeta,CMRPinA_MixtoVec(:,1),'bs');
    plot(vector_kbeta,CMRPinA_AlvaroVec(:,1),'r-');
    plot(vector_kbeta,CMRPinA_ElasticoVec(:,1),'go');
    plot(vector_kbeta,CMRPinA_AlvaroNLVec(:,1),'ks-');
    plot(vector_kbeta,CMRPinA_ElasticoNLVec(:,1),'ko-');
    legend('ASE','Mixto','Alvaro','Elastico','AlvaroNL','ElasticoNL');
    xlabel('k\it\beta');
    ylabel('CMxA');
    
    subplot(3,3,5)
    hold on
    plot(vector_kbeta,CMRPinA_ASEVec(:,2),'k-');
    plot(vector_kbeta,CMRPinA_MixtoVec(:,2),'bs');
    plot(vector_kbeta,CMRPinA_AlvaroVec(:,2),'r-');
    plot(vector_kbeta,CMRPinA_ElasticoVec(:,2),'go');
    plot(vector_kbeta,CMRPinA_AlvaroNLVec(:,2),'ks-');
    plot(vector_kbeta,CMRPinA_ElasticoNLVec(:,2),'ko-');
    legend('ASE','Mixto','Alvaro','Elastico','AlvaroNL','ElasticoNL');
    xlabel('k\it\beta');
    ylabel('CMyA');
    
    subplot(3,3,6)
    hold on
    plot(vector_kbeta,CMRPinA_ASEVec(:,3),'k-');
    plot(vector_kbeta,CMRPinA_MixtoVec(:,3),'bs');
    plot(vector_kbeta,CMRPinA_AlvaroVec(:,3),'r-');
    plot(vector_kbeta,CMRPinA_ElasticoVec(:,3),'go');
    plot(vector_kbeta,CMRPinA_AlvaroNLVec(:,3),'ks-');
    plot(vector_kbeta,CMRPinA_ElasticoNLVec(:,3),'ko-');
    legend('ASE','Mixto','Alvaro','Elastico','AlvaroNL','ElasticoNL');
    xlabel('k\it\beta');
    ylabel('CMzA');
    
    subplot(3,3,7)
    hold on
    plot(vector_kbeta,beta_ASEVec(:,1),'k-');
    plot(vector_kbeta,beta_MixtoVec(:,1),'bs');
    plot(vector_kbeta,beta_AlvaroVec(:,1),'r-');
    plot(vector_kbeta,beta_ElasticoVec(:,1),'go');
    plot(vector_kbeta,beta_AlvaroNLVec(:,1),'ks');
    plot(vector_kbeta,beta_ElasticoNLVec(:,1),'ko-');
    legend('ASE','Mixto','Alvaro','Elastico','AlvaroNL','ElasticoNL');
    xlabel('k\it\beta');
    ylabel('beta_0');
    
    subplot(3,3,8)
    hold on
    plot(vector_kbeta,beta_ASEVec(:,2),'k-');
    plot(vector_kbeta,beta_MixtoVec(:,2),'bs');
    plot(vector_kbeta,beta_AlvaroVec(:,2),'r-');
    plot(vector_kbeta,beta_ElasticoVec(:,2),'go');
    plot(vector_kbeta,beta_AlvaroNLVec(:,2),'ks-');
    plot(vector_kbeta,beta_ElasticoNLVec(:,2),'ko-');
    legend('ASE','Mixto','Alvaro','Elastico','AlvaroNL','ElasticoNL');
    xlabel('k\it\beta');
    ylabel('beta_1C');
    
    subplot(3,3,9)
    hold on
    plot(vector_kbeta,beta_ASEVec(:,3),'k-');
    plot(vector_kbeta,beta_MixtoVec(:,3),'bs');
    plot(vector_kbeta,beta_AlvaroVec(:,3),'r-');
    plot(vector_kbeta,beta_ElasticoVec(:,3),'go');
    plot(vector_kbeta,beta_AlvaroNLVec(:,3),'ks-');
    plot(vector_kbeta,beta_ElasticoNLVec(:,3),'ko-');
    legend('ASE','Mixto','Alvaro','Elastico','AlvaroNL','ElasticoNL');
    xlabel('k\it\beta');
    ylabel('beta_1S');
   
    
    figure (200)
    
   subplot(3,3,1)
    hold on
    plot(vector_kbeta,CFRPinA_AlvaroNLVec(:,1),'ks-');
    plot(vector_kbeta,CFRPinA_ElasticoNLVec(:,1),'r-');
    legend('AlvaroNL','ElasticoNL');
    xlabel('k\it\beta');
    ylabel('CFxA');
    
    subplot(3,3,2)
    hold on
    plot(vector_kbeta,CFRPinA_AlvaroNLVec(:,2),'ks-');
    plot(vector_kbeta,CFRPinA_ElasticoNLVec(:,2),'r-');
    legend('AlvaroNL','ElasticoNL');
    xlabel('k\it\beta');
    ylabel('CFyA');
    
    subplot(3,3,3)
    hold on
    plot(vector_kbeta,CFRPinA_AlvaroNLVec(:,3),'ks-');
    plot(vector_kbeta,CFRPinA_ElasticoNLVec(:,3),'r-');
    legend('AlvaroNL','ElasticoNL');
    xlabel('k\it\beta');
    ylabel('CFzA');
    
    subplot(3,3,4)
    hold on
    plot(vector_kbeta,CMRPinA_AlvaroNLVec(:,1),'ks-');
    plot(vector_kbeta,CMRPinA_ElasticoNLVec(:,1),'r-');
    plot(vector_kbeta,CMRalterElasticoNLVec(:,1),'bo-');
    legend('AlvaroNL','ElasticoNL','CMRalter');
    xlabel('k\it\beta');
    ylabel('CMxA');
    
    subplot(3,3,5)
    hold on
    plot(vector_kbeta,CMRPinA_AlvaroNLVec(:,2),'ks-');
    plot(vector_kbeta,CMRPinA_ElasticoNLVec(:,2),'r-');
    plot(vector_kbeta,CMRalterElasticoNLVec(:,2),'bo-');
    legend('AlvaroNL','ElasticoNL','CMRalter');
    xlabel('k\it\beta');
    ylabel('CMyA');
    
    subplot(3,3,6)
    hold on
    plot(vector_kbeta,CMRPinA_AlvaroNLVec(:,3),'ks-');
    plot(vector_kbeta,CMRPinA_ElasticoNLVec(:,3),'r-');
    plot(vector_kbeta,CMRalterElasticoNLVec(:,3),'bo-');
    legend('AlvaroNL','ElasticoNL','CMRalter');
    xlabel('k\it\beta');
    ylabel('CMzA');
    
    subplot(3,3,7)
    hold on
    plot(vector_kbeta,beta_AlvaroNLVec(:,1),'ks');
    plot(vector_kbeta,beta_ElasticoNLVec(:,1),'r-');
    legend('AlvaroNL','ElasticoNL');
    xlabel('k\it\beta');
    ylabel('beta_0');
    
    subplot(3,3,8)
    hold on
    plot(vector_kbeta,beta_AlvaroNLVec(:,2),'ks-');
    plot(vector_kbeta,beta_ElasticoNLVec(:,2),'r-');
    legend('AlvaroNL','ElasticoNL');
    xlabel('k\it\beta');
    ylabel('beta_1C');
    
    subplot(3,3,9)
    hold on
    plot(vector_kbeta,beta_AlvaroNLVec(:,3),'ks-');
    plot(vector_kbeta,beta_ElasticoNLVec(:,3),'r-');
    legend('AlvaroNL','ElasticoNL');
    xlabel('k\it\beta');
    ylabel('beta_1S');
   
    
    
    
    
    
    
    
    
    
    
    
    