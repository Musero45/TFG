% Función de prueba de fuerza del rotor 01

clear all

%close all

format long

line = 'b-' 


theta00 = 1*pi/180;
theta1c0 = 0;
theta1s0 = 0;

% mu_xA = 0.22516421547832;
% mu_yA = -2.934154348262831e-004;
% mu_zA = -0.01138175546401;

mu_xA = 0;
mu_yA = 0;
mu_zA = 0;

omxA0 = 0;
omyA0 = 0;
omzA0 = 0;

mu_WxA = 0;
mu_WyA = 0;
mu_WzA = 0;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
%Añadimos todas las carpetas del programa para el cálculo
    %path_loader;
%Creación de la supervariable y de otras variables
    
    [HM] = Helimodel;
    
    
    R = HM.RP.R;
    HM.RP.e = 0.1*R;
    HM.RP.theta1 = 0;

%   bucle en beta
    
    vector_kbeta = [linspace(0,150000,20)];
    
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
    
    OAad_A = [0,0,0];
    
    MHAdim.Pala_RP.e_ad = 0;
    %MHAdim.Pala_RP.theta1 = 0;
    
    
%Solución del sistema del rotor principal
    
    lambda_i0 = -0.03;
   
    options = optimset('fsolve');
    options = optimset(options,'Display','off');

    % Control derivative d()/dtheta1c
    
    Dtheta1cvect = linspace(-pi/100,pi/100,20);
       
    for Dtheta1ci = 1:length(Dtheta1cvect);
        
        Dtheta1c = Dtheta1cvect(Dtheta1ci);
                     
        theta0 = theta00;
        theta1c = theta1c0+Dtheta1c; 
        theta1s = theta1s0;
        
        omxA = omxA0;
        omyA = omyA0;
        omzA = omzA0;
        
        omegaA = [omxA,omyA,omzA];
    
        muAvect = cross(OAad_A,omegaA)+[mu_xA,mu_yA,mu_zA];
    
        mu_xA = muAvect(1);
        mu_yA = muAvect(2);
        mu_zA = muAvect(3);
        
    x = fsolve(@(x) systemPalaOmega(x,MHAdim,theta0,theta1c,theta1s,mu_xA,mu_yA,mu_zA,mu_WxA,mu_WyA,mu_WzA,omxA,omyA,omzA,lambda_i0),...
        [0.01; 0.0; 0.0; -.3;1e-5],options);
    
        beta0_1c(Dtheta1ci) = x(1);
        beta1c_1c(Dtheta1ci) = x(2);
        beta1s_1c(Dtheta1ci) = x(3); 
        lambda_iP_1c(Dtheta1ci) = x(4);
        
    end

   % Control derivative d()/dtheta1s
    
    Dtheta1svect = linspace(-pi/100,pi/100,20);
       
    for Dtheta1si = 1:length(Dtheta1svect);
        
        Dtheta1s = Dtheta1svect(Dtheta1si);
                     
        theta0 = theta00;
        theta1c = theta1c0; 
        theta1s = theta1s0+Dtheta1s;
        
        omxA = omxA0;
        omyA = omyA0;
        omzA = omzA0;
        
        omegaA = [omxA,omyA,omzA];
    
        muAvect = cross(OAad_A,omegaA)+[mu_xA,mu_yA,mu_zA];
    
        mu_xA = muAvect(1);
        mu_yA = muAvect(2);
        mu_zA = muAvect(3);
        
        
    x = fsolve(@(x) systemPalaOmega(x,MHAdim,theta0,theta1c,theta1s,mu_xA,mu_yA,mu_zA,mu_WxA,mu_WyA,mu_WzA,omxA,omyA,omzA,lambda_i0),...
        [0.01; 0.0; 0.0; -.3;1e-5],options);
    
        beta0_1s(Dtheta1si) = x(1);
        beta1c_1s(Dtheta1si) = x(2);
        beta1s_1s(Dtheta1si) = x(3); 
        lambda_iP_1s(Dtheta1si) = x(4);
        
    end

    
    % Damping derivative d()/domxA
    
    DomxAvect = linspace(-0.001,0.001,20);
       
    for DomxAi = 1:length(DomxAvect);
        
        DomxA = DomxAvect(DomxAi);
                     
        theta0 = theta00;
        theta1c = theta1c0; 
        theta1s = theta1s0;
        
        omxA = omxA0+DomxA;
        omyA = omyA0;
        omzA = omzA0;
        
        omegaA = [omxA,omyA,omzA];
    
        muAvect = cross(OAad_A,omegaA)+[mu_xA,mu_yA,mu_zA];
    
        mu_xA = muAvect(1);
        mu_yA = muAvect(2);
        mu_zA = muAvect(3);
        
    x = fsolve(@(x) systemPalaOmega(x,MHAdim,theta0,theta1c,theta1s,mu_xA,mu_yA,mu_zA,mu_WxA,mu_WyA,mu_WzA,omxA,omyA,omzA,lambda_i0),...
        [0.01; 0.0; 0.0; -.3;1e-5],options);
    
        beta0_omxA(DomxAi) = x(1);
        beta1c_omxA(DomxAi) = x(2);
        beta1s_omxA(DomxAi) = x(3); 
        lambda_iP_omxA(DomxAi) = x(4);
        
    end
    
    
    
    % Damping derivative d()/domyA
    
    DomyAvect = linspace(-0.01,0.01,20);
       
    for DomyAi = 1:length(DomyAvect);
        
        DomyA = DomyAvect(DomyAi);
                     
        theta0 = theta00;
        theta1c = theta1c0; 
        theta1s = theta1s0;
        
        omxA = omxA0;
        omyA = omyA0+DomyA;
        omzA = omzA0;
        
        omegaA = [omxA,omyA,omzA];
    
        muAvect = cross(OAad_A,omegaA)+[mu_xA,mu_yA,mu_zA];
    
        mu_xA = muAvect(1);
        mu_yA = muAvect(2);
        mu_zA = muAvect(3);
        
    x = fsolve(@(x) systemPalaOmega(x,MHAdim,theta0,theta1c,theta1s,mu_xA,mu_yA,mu_zA,mu_WxA,mu_WyA,mu_WzA,omxA,omyA,omzA,lambda_i0),...
        [0.01; 0.0; 0.0; -.3;1e-5],options);
    
        beta0_omyA(DomyAi) = x(1);
        beta1c_omyA(DomyAi) = x(2);
        beta1s_omyA(DomyAi) = x(3); 
        lambda_iP_omyA(DomyAi) = x(4);
        
    end

    figure (50)
    
    hold on
    plot(Dtheta1cvect,beta1s_1c,'r-')
    plot(Dtheta1svect,beta1c_1s,'b-')
    

    figure (100)
    
    hold on
    plot(DomxAvect,beta1s_omyA,'r-')
    plot(DomxAvect,beta1c_omxA,'b-')
    
    beta0vect_1c = @(x) interp1(Dtheta1cvect,beta0_1c,x);
    beta1cvect_1c = @(x) interp1(Dtheta1cvect,beta1c_1c,x);
    beta1svect_1c = @(x) interp1(Dtheta1cvect,beta1s_1c,x);

    beta0vect_1s = @(x) interp1(Dtheta1svect,beta0_1s,x);
    beta1cvect_1s = @(x) interp1(Dtheta1svect,beta1c_1s,x);
    beta1svect_1s = @(x) interp1(Dtheta1svect,beta1s_1s,x);
    
    beta0vect_omxA = @(x) interp1(DomxAvect,beta0_omxA,x);
    beta1cvect_omxA = @(x) interp1(DomxAvect,beta1c_omxA,x);
    beta1svect_omxA = @(x) interp1(DomxAvect,beta1s_omxA,x);
    
    beta0vect_omyA = @(x) interp1(DomyAvect,beta0_omyA,x);
    beta1cvect_omyA = @(x) interp1(DomyAvect,beta1c_omyA,x);
    beta1svect_omyA = @(x) interp1(DomyAvect,beta1s_omyA,x);

    S_beta(kbetai) = MHAdim.Pala_RP.S_beta;
    
    dbeta0_1c(kbetai) = derivest(beta0vect_1c,0);
    dbeta1c_1c(kbetai) = derivest(beta1cvect_1c,0);
    dbeta1s_1c(kbetai) = derivest(beta1svect_1c,0); 
    
    dbeta0_1s(kbetai) = derivest(beta0vect_1s,0);
    dbeta1c_1s(kbetai) = derivest(beta1cvect_1s,0);
    dbeta1s_1s(kbetai) = derivest(beta1svect_1s,0);
    
    dbeta0_omxA(kbetai) = derivest(beta0vect_omxA,0);
    dbeta1c_omxA(kbetai) = derivest(beta1cvect_omxA,0);
    dbeta1s_omxA(kbetai) = derivest(beta1svect_omxA,0);
    
    dbeta0_omyA(kbetai) = derivest(beta0vect_omyA,0);
    dbeta1c_omyA(kbetai) = derivest(beta1cvect_omyA,0);
    dbeta1s_omyA(kbetai) = derivest(beta1svect_omyA,0); 

    
    end
    
    figure(1)
     
    hold on
    plot(S_beta,dbeta0_1c,line);
    xlabel('S\beta');
    ylabel('dbeta_0/dtheta1c');
    
    figure(2)
    
    hold on
    plot(S_beta,dbeta1c_1c,line);
    xlabel('S\beta');
    ylabel('dbeta_1c/dtheta1c');
    
    figure(3)
    
    hold on
    plot(S_beta,dbeta1s_1c,line);
    xlabel('S\beta');
    ylabel('dbeta_1s/dtheta1c');
    
    figure(4)
    hold on
    plot(S_beta,dbeta0_1s,line);
    xlabel('S\beta');
    ylabel('dbeta_0/dtheta1s');
    
    figure(5)
    hold on
    plot(S_beta,dbeta1c_1s,line);
    xlabel('S\beta');
    ylabel('dbeta_1c/dtheta1s');
    
    figure(6)
    hold on
    plot(S_beta,dbeta1s_1s,line);
    xlabel('S\beta');
    ylabel('dbeta_1s/dtheta1s');
    
   
    figure(7)
    hold on
    plot(S_beta,dbeta0_omxA,line);
    xlabel('S\beta');
    ylabel('dbeta_0/domxA');
    
    figure(8)
    hold on
    plot(S_beta,dbeta1c_omxA,line);
    xlabel('S\beta');
    ylabel('dbeta_1c/domxA');
    
    figure(9)
    hold on
    plot(S_beta,dbeta1s_omxA,line);
    xlabel('S\beta');
    ylabel('dbeta_1s/domxA');
    
          
    figure(10)
    hold on
    plot(S_beta,dbeta0_omyA,line);
    xlabel('S\beta');
    ylabel('dbeta_0/domyA');
    
    figure(11)
    hold on
    plot(S_beta,dbeta1c_omyA,line);
    xlabel('S\beta');
    ylabel('dbeta_1c/domyA');
    
    figure(12)
    hold on
    plot(S_beta,dbeta1s_omyA,line);
    xlabel('S\beta');
    ylabel('dbeta_1s/domyA');
    
    
    
    
    
    
    
    
    