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

omxA = 0.1;
omyA = 0;
omzA = 0;

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

%RECALCULO DE PARAMETROS DE VELOCIDAD DEBIDOS A VELOCIDAD ANGULAR

    epsilon_x = MHAdim.epsilon_x;
    epsilon_y = MHAdim.epsilon_y;

    OAad_F =  MHAdim.Brazos.R.OAad;
        
    OAad_A = cambioAfF(epsilon_x,epsilon_y,OAad_F');
    
    omegaA = [omxA,omyA,omzA];
    
    muAvect = cross(OAad_A,omegaA);
    
    mu_xA = muAvect(1);
    mu_yA = muAvect(2);
    mu_zA = muAvect(3);

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

    x = fsolve(@(x) systemPalaOmega(x,MHAdim,theta0,theta1c,theta1s,mu_xA,mu_yA,mu_zA,omxA,omyA,omzA,mu_WxA,mu_WyA,mu_WzA,lambda_i0),...
        [0.01; 0.0; 0.0; -.3;1e-5],options);
    
    beta0 = x(1);   beta1c = x(2);  beta1s = x(3); lambda_iP = x(4);

    [CHinA,CYinA,CTinA] = fza_rotorOmega(MHAdim,theta0,theta1c,theta1s,beta0,beta1c,beta1s,lambda_iP,mu_xA,mu_yA,...
        mu_zA,omxA,omyA,omzA,mu_WxA,mu_WyA,mu_WzA);
    
    [CMHinA,CMYinA,CMTinA,CMRalter] = momento_rotor(MHAdim,theta0,theta1c,theta1s,beta0,beta1c,beta1s,lambda_iP,...
        mu_xA,mu_yA,mu_zA,mu_WxA,mu_WyA,mu_WzA);
    
    CFRPinA = [CHinA;CYinA;CTinA];
    CMRPinA = [CMHinA;CMYinA;CMTinA];
    beta = [beta0;beta1c;beta1s];
    lambda_iP = lambda_iP;


    
    
   
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%   COMPARACIONES
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    CFRPinA = CFRPinA;
        
    CMRPinA = CMRPinA;
            
    beta = beta;
        
    lambda_iP = lambda_iP;
        
    CFRPinAVec(kbetai,:) = CFRPinA';
    CMRPinAVec(kbetai,:) = CMRPinA';
    betaVec(kbetai,:) = beta';
    lambda_iPVec(kbetai,:) = lambda_iP';
    
    end
    
    
    figure(1)
    
    subplot(3,3,1)
    hold on
    plot(vector_kbeta,CFRPinAVec(:,1),'k-');
    xlabel('k\it\beta');
    ylabel('CFxA');
    
    subplot(3,3,2)
    hold on
    plot(vector_kbeta,CFRPinAVec(:,2),'k-');
    xlabel('k\it\beta');
    ylabel('CFyA');
    
    subplot(3,3,3)
    hold on
    plot(vector_kbeta,CFRPinAVec(:,3),'k-');
    xlabel('k\it\beta');
    ylabel('CFzA');
    
    subplot(3,3,4)
    hold on
    plot(vector_kbeta,CMRPinAVec(:,1),'k-');
    xlabel('k\it\beta');
    ylabel('CMxA');
    
    subplot(3,3,5)
    hold on
    plot(vector_kbeta,CMRPinAVec(:,2),'k-');
    xlabel('k\it\beta');
    ylabel('CMyA');
    
    subplot(3,3,6)
    hold on
    plot(vector_kbeta,CMRPinAVec(:,3),'k-');
    xlabel('k\it\beta');
    ylabel('CMzA');
    
    subplot(3,3,7)
    hold on
    plot(vector_kbeta,betaVec(:,1),'k-');
    xlabel('k\it\beta');
    ylabel('beta_0');
    
    subplot(3,3,8)
    hold on
    plot(vector_kbeta,betaVec(:,2),'k-');
    xlabel('k\it\beta');
    ylabel('beta_1C');
    
    subplot(3,3,9)
    hold on
    plot(vector_kbeta,betaVec(:,3),'k-');
    xlabel('k\it\beta');
    ylabel('beta_1S');
   
    
  
    
    
    
    
    
    
    
    
    
    
    
    