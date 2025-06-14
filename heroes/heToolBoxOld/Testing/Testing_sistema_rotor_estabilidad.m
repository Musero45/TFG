% Función de prueba de fuerza del rotor 01

clear all

%close all

format long

  

theta0 = 16*pi/180;
theta1c = -0.5*pi/180;
theta1s = -3*pi/180;


% mu_xA = 0.22516421547832;
% mu_yA = -2.934154348262831e-004;
% mu_zA = -0.01138175546401;

muX = 0.25;

mu_xA = -muX;
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
    
    muXvect = [linspace(0,0.35,50)];
    
    for muXi = 1:length(muXvect);
        
        muX = muXvect(muXi)
    
        mu_xA = -muX
        
    [Atm] = ISA(HM.altura);

%Para el caso de polar linealizada para todos los elementos

    rango = [-15 10]*pi/180;
    [HM] = polarlineal(HM,rango);

%Creacion de los parametros adimensionales para las ecuaciones
    
    [MHAdim] = Adimensionalizacion(HM,Atm);
     
    MHAdim.epsilon_y = 0;
    
%Solución del sistema del rotor principal
    
    lambda_i0 = -0.03;
 
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
       
    
    CFRPinA_ElasticoNLVec(muXi,:) = CFRPinA_ElasticoNL';
    CMRPinA_ElasticoNLVec(muXi,:) = CMRPinA_ElasticoNL';
    CMRalterElasticoNLVec(muXi,:) = CMRalterElasticoNL;
    beta_ElasticoNLVec(muXi,:) = beta_ElasticoNL';
    lambda_iP_ElasticoNLVec(muXi,:) = lambda_iP_ElasticoNL';
    
    
    end
    
    
    figure(100)
    
    subplot(3,3,1)
    hold on
    plot(muXvect,-CFRPinA_ElasticoNLVec(:,1),'ko-');
    legend('ElasticoNL');
    xlabel('muXe');
    ylabel('CFx');
    
    subplot(3,3,2)
    hold on
    plot(muXvect,CFRPinA_ElasticoNLVec(:,2),'ko-');
    legend('ElasticoNL');
    xlabel('muXe');
    ylabel('CFy');
    
    subplot(3,3,3)
    hold on
    plot(muXvect,-CFRPinA_ElasticoNLVec(:,3),'ko-');
    legend('ElasticoNL');
    xlabel('muXe');
    ylabel('CFz');
    
    subplot(3,3,4)
    hold on
    plot(muXvect,-CMRPinA_ElasticoNLVec(:,1),'ko-');
    legend('ElasticoNL');
    xlabel('muXe');
    ylabel('CMx');
    
    subplot(3,3,5)
    hold on
    plot(muXvect,CMRPinA_ElasticoNLVec(:,2),'ko-');
    legend('ElasticoNL');
    xlabel('muXe');
    ylabel('CMy');
    
    subplot(3,3,6)
    hold on
    plot(muXvect,-CMRPinA_ElasticoNLVec(:,3),'ko-');
    legend('ElasticoNL');
    xlabel('muXe');
    ylabel('CMz');
    
    subplot(3,3,7)
    hold on
    plot(muXvect,beta_ElasticoNLVec(:,1),'ko-');
    legend('ElasticoNL');
    xlabel('muXe');
    ylabel('beta_0');
    
    subplot(3,3,8)
    hold on
    plot(muXvect,beta_ElasticoNLVec(:,2),'ko-');
    legend('ElasticoNL');
    xlabel('muXe');
    ylabel('beta_1C');
    
    subplot(3,3,9)
    hold on
    plot(muXvect,beta_ElasticoNLVec(:,3),'ko-');
    legend('ElasticoNL');
    xlabel('muXe');
    ylabel('beta_1S');
   
    
    muXvect1 = muXvect(1:length(muXvect)-1);
    
    figure(200)
    
    subplot(2,3,1)
    hold on
    plot(muXvect1,diff(-CFRPinA_ElasticoNLVec(:,1))./diff(muXvect'),'ko-');
    legend('ElasticoNL');
    xlabel('muXe');
    ylabel('dCFx/dmux');
    
    subplot(2,3,2)
    hold on
    plot(muXvect1,diff(CFRPinA_ElasticoNLVec(:,2))./diff(muXvect'),'ko-');
    legend('ElasticoNL');
    xlabel('muXe');
    ylabel('dCFy/dmux');
    
    subplot(2,3,3)
    hold on
    plot(muXvect1,diff(-CFRPinA_ElasticoNLVec(:,3))./diff(muXvect'),'ko-');
    legend('ElasticoNL');
    xlabel('muXe');
    ylabel('dCFz/dmux');
    
    subplot(2,3,4)
    hold on
    plot(muXvect1,diff(-CMRPinA_ElasticoNLVec(:,1))./diff(muXvect'),'ko-');
    legend('ElasticoNL');
    xlabel('muXe');
    ylabel('dCMx/dmux');
    
    subplot(2,3,5)
    hold on
    plot(muXvect1,diff(CMRPinA_ElasticoNLVec(:,2))./diff(muXvect'),'ko-');
    legend('ElasticoNL');
    xlabel('muXe');
    ylabel('dCMy/dmux');
    
    subplot(2,3,6)
    hold on
    plot(muXvect1,diff(-CMRPinA_ElasticoNLVec(:,3))./diff(muXvect'),'ko-');
    legend('ElasticoNL');
    xlabel('muXe');
    ylabel('dCMz/dmux');
    
   