% Función de prueba de fuerza del rotor 01

clear all

%close all

format long

% PUNTO FIJO  

% theta0 = 16*pi/180;
% theta1c = 0*pi/180;
% theta1s = 0*pi/180;
% muXe = 0.0;

% AVANCE REAL   

% theta0 = 14.38484759939697*pi/180;
% theta1c = -0.10979730264654*pi/180;
% theta1s = -3.41856786908905*pi/180;
% muXe = 0.15;

% AVANCE TUNEL   

theta0 = 16*pi/180;
theta1c = -0.2*pi/180;
theta1s = -4*pi/180;
muXe = 0.15;



mu_xA = muXe;
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
    
    DmuZvect = [linspace(-0.01,0.01,50)];
    
    for DmuZi = 1:length(DmuZvect);
        
        DmuZ = DmuZvect(DmuZi)
    
        mu_zA = DmuZ
        
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
       
    
    CFRPinA_ElasticoNLVec(DmuZi,:) = CFRPinA_ElasticoNL';
    CMRPinA_ElasticoNLVec(DmuZi,:) = CMRPinA_ElasticoNL';
    CMRalterElasticoNLVec(DmuZi,:) = CMRalterElasticoNL;
    beta_ElasticoNLVec(DmuZi,:) = beta_ElasticoNL*180/pi';
    lambda_iP_ElasticoNLVec(DmuZi,:) = lambda_iP_ElasticoNL';
    
    
    % Calculo de momentos indirectos
    
    had = MHAdim.Brazos.R.h_ad;
    
    OAad = [0;0;had];
    
    MindOinA = cross(OAad,CFRPinA_ElasticoNL);
    
    MindOinF = cambioFfA(0,0,MindOinA);
    
    MindOinFVec(DmuZi,:) = MindOinF';
        
    % Calculo de angulo de fuerza RP para hipotesis
    
    [CFu_RPinP] = cambioPfA(beta1c,beta1s,CFRPinA_ElasticoNL);

    CH_RPinP = CFu_RPinP(1);
    CY_RPinP = CFu_RPinP(2);
    CT_RPinP = CFu_RPinP(3);
    
    CH_RPinA = CFRPinA_ElasticoNL(1);
    CY_RPinA = CFRPinA_ElasticoNL(2);
    CT_RPinA = CFRPinA_ElasticoNL(3);
    
    CHY_RPinP = sqrt(CH_RPinP^2+CY_RPinP^2);
    CHY_RPinA = sqrt(CH_RPinA^2+CY_RPinA^2);
    
    RatioHY_PonA(DmuZi) = CHY_RPinP/CHY_RPinA;
    
    AnginA(DmuZi) = 180/pi*CHY_RPinA/CT_RPinA;
    AnginP(DmuZi) = 180/pi*CHY_RPinP/CT_RPinP;
    
    
    end
    
    
    figure(100)
    
    subplot(3,3,1)
    hold on
    grid on
    box on
    plot(DmuZvect,-CFRPinA_ElasticoNLVec(:,1),'k-');
    legend('ElasticoNL');
    xlabel('DmuZ');
    ylabel('CFx');
    
    subplot(3,3,2)
    hold on
    grid on
    box on
    plot(DmuZvect,CFRPinA_ElasticoNLVec(:,2),'k-');
    legend('ElasticoNL');
    xlabel('DmuZ');
    ylabel('CFy');
    
    subplot(3,3,3)
    hold on
    grid on
    box on
    plot(DmuZvect,-CFRPinA_ElasticoNLVec(:,3),'k-');
    legend('ElasticoNL');
    xlabel('DmuZ');
    ylabel('CFz');
    
    subplot(3,3,4)
    hold on
    grid on
    box on
    plot(DmuZvect,-CMRPinA_ElasticoNLVec(:,1),'k-');
    plot(DmuZvect,MindOinFVec(:,1),'r-');
    legend('Mrpx','OAxFrpx');
    xlabel('DmuZ');
    ylabel('CMx');
    
    subplot(3,3,5)
    hold on
    grid on
    box on
    plot(DmuZvect,CMRPinA_ElasticoNLVec(:,2),'k-');
    plot(DmuZvect,MindOinFVec(:,2),'r-');
    legend('Mrpy','OAxFrpy');
    xlabel('DmuZ');
    ylabel('CMy');
    
    subplot(3,3,6)
    hold on
    grid on
    box on
    plot(DmuZvect,-CMRPinA_ElasticoNLVec(:,3),'k-');
    %plot(DmuZvect,MindOinFVec(:,3),'r-');
    legend('Mrpz','OAxFrpz');
    xlabel('DmuZ');
    ylabel('CMz');
    
    subplot(3,3,7)
    hold on
    grid on
    box on
    plot(DmuZvect,beta_ElasticoNLVec(:,1),'k-');
    legend('ElasticoNL');
    xlabel('DmuZ');
    ylabel('beta_0 [º]');
    
    subplot(3,3,8)
    hold on
    grid on
    box on
    plot(DmuZvect,beta_ElasticoNLVec(:,2),'k-');
    legend('ElasticoNL');
    xlabel('DmuZ');
    ylabel('beta_1C [º]');
    
    subplot(3,3,9)
    hold on
    grid on
    box on
    plot(DmuZvect,beta_ElasticoNLVec(:,3),'k-');
    legend('ElasticoNL');
    xlabel('DmuZ');
    ylabel('beta_1S [º]');
   
    figure(150)
    
    hold on
    grid on
    box on
    plot(DmuZvect,lambda_iP_ElasticoNLVec,'k-');
    legend('ElasticoNL');
    xlabel('DmuZ');
    ylabel('lambda');
    
     figure(160)
    
    hold on
    grid on
    box on
    plot(DmuZvect,AnginA,'k-');
    plot(DmuZvect,AnginP,'r-');
    legend('AnginA [º]','AnginP[º]');
    xlabel('DmuZ');
    ylabel('Ang [º] ');
    
    DmuZvect1 = DmuZvect(1:length(DmuZvect)-1);
    
    figure(200)
    
    subplot(2,3,1)
    hold on
    grid on
    box on
    plot(DmuZvect1,diff(-CFRPinA_ElasticoNLVec(:,1))./diff(DmuZvect'),'k-');
    legend('ElasticoNL');
    xlabel('DmuZ');
    ylabel('dCFx/dmuZ');
    
    subplot(2,3,2)
    hold on
    grid on
    box on
    plot(DmuZvect1,diff(CFRPinA_ElasticoNLVec(:,2))./diff(DmuZvect'),'k-');
    legend('ElasticoNL');
    xlabel('DmuZ');
    ylabel('dCFy/dmuZ');
    
    subplot(2,3,3)
    hold on
    grid on
    box on
    plot(DmuZvect1,diff(-CFRPinA_ElasticoNLVec(:,3))./diff(DmuZvect'),'k-');
    legend('ElasticoNL');
    xlabel('DmuZ');
    ylabel('dCFz/dmuZ');
    
    subplot(2,3,4)
    hold on
    grid on
    box on
    plot(DmuZvect1,diff(-CMRPinA_ElasticoNLVec(:,1))./diff(DmuZvect'),'k-');
    legend('ElasticoNL');
    xlabel('DmuZ');
    ylabel('dCMx/dmuZ');
    
    subplot(2,3,5)
    hold on
    grid on
    box on
    plot(DmuZvect1,diff(CMRPinA_ElasticoNLVec(:,2))./diff(DmuZvect'),'k-');
    legend('ElasticoNL');
    xlabel('DmuZ');
    ylabel('dCMy/dmuZ');
    
    subplot(2,3,6)
    hold on
    grid on
    box on
    plot(DmuZvect1,diff(-CMRPinA_ElasticoNLVec(:,3))./diff(DmuZvect'),'k-');
    legend('ElasticoNL');
    xlabel('DmuZ');
    ylabel('dCMz/dmuZ');
    
   