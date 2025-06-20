% Funci�n de prueba de fuerza del rotor 01

clear all

%close all

format long

% PUNTO FIJO  

theta0 = 16*pi/180;
theta1c = 0*pi/180;
theta1s = 0*pi/180;
muXe = 0.0;

% AVANCE REAL   

% theta0 = 14.38484759939697*pi/180;
% theta1c = -0.10979730264654*pi/180;
% theta1s = -3.41856786908905*pi/180;
% muXe = 0.15;

% AVANCE TUNEL   

% theta0 = 16*pi/180;
% theta1c = -0.2*pi/180;
% theta1s = -4*pi/180;
% muXe = 0.15;


mu_xA = muXe;
mu_yA = 0;
mu_zA = 0;

mu_WxA = 0;
mu_WyA = 0;
mu_WzA = 0;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
%A�adimos todas las carpetas del programa para el c�lculo
    %path_loader;
%Creaci�n de la supervariable y de otras variables
    
    [HM] = Helimodel;


%   bucle en Pertubacion de vuelo en ejes cuerpo DmuX = DmuU
    
    DmuXvect = [linspace(-0.05,0.05,50)];
    
    for DmuXi = 1:length(DmuXvect);
        
        DmuX = DmuXvect(DmuXi)
    
        mu_xA = muXe+DmuX
        
    [Atm] = ISA(HM.altura);

%Para el caso de polar linealizada para todos los elementos

    rango = [-15 10]*pi/180;
    [HM] = polarlineal(HM,rango);

%Creacion de los parametros adimensionales para las ecuaciones
    
    [MHAdim] = Adimensionalizacion(HM,Atm);
     
    MHAdim.epsilon_y = 0;
    
    % Imposici�n de rotor articulado puro sin excentricidad y sin torsi�n
    
%     MHAdim.Pala_RP.e_ad = 0;
%     MHAdim.Pala_RP.lambda_beta = 1;
%     MHAdim.Pala_RP.m_b = 0;
%     
    
%Soluci�n del sistema del rotor principal
    
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
       
    
    CFRPinA_ElasticoNLVec(DmuXi,:) = CFRPinA_ElasticoNL';
    CMRPinA_ElasticoNLVec(DmuXi,:) = CMRPinA_ElasticoNL';
    CMRalterElasticoNLVec(DmuXi,:) = CMRalterElasticoNL;
    beta_ElasticoNLVec(DmuXi,:) = beta_ElasticoNL*180/pi';
    lambda_iP_ElasticoNLVec(DmuXi,:) = lambda_iP_ElasticoNL';
    
    
    % Calculo de momentos indirectos
    
    had = MHAdim.Brazos.R.h_ad;
    
    OAad = [0;0;had];
    
    MindOinA = cross(OAad,CFRPinA_ElasticoNL);
    
    MindOinF = cambioFfA(0,0,MindOinA);
    
    MindOinFVec(DmuXi,:) = MindOinF';
        
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
    
    RatioHY_PonA(DmuXi) = CHY_RPinP/CHY_RPinA;
    
    AnginA(DmuXi) = 180/pi*CHY_RPinA/CT_RPinA;
    AnginP(DmuXi) = 180/pi*CHY_RPinP/CT_RPinP;
    
    
    end
    
    
    figure(100)
    
    subplot(3,3,1)
    hold on
    grid on
    box on
    plot(DmuXvect,-CFRPinA_ElasticoNLVec(:,1),'k-');
    legend('ElasticoNL');
    xlabel('DmuX');
    ylabel('CFx');
    
    subplot(3,3,2)
    hold on
    grid on
    box on
    plot(DmuXvect,CFRPinA_ElasticoNLVec(:,2),'k-');
    legend('ElasticoNL');
    xlabel('DmuX');
    ylabel('CFy');
    
    subplot(3,3,3)
    hold on
    grid on
    box on
    plot(DmuXvect,-CFRPinA_ElasticoNLVec(:,3),'k-');
    legend('ElasticoNL');
    xlabel('DmuX');
    ylabel('CFz');
    
    subplot(3,3,4)
    hold on
    grid on
    box on
    plot(DmuXvect,-CMRPinA_ElasticoNLVec(:,1),'k-');
    plot(DmuXvect,MindOinFVec(:,1),'r-');
    legend('Mrpx','OAxFrpx');
    xlabel('DmuX');
    ylabel('CMx');
    
    subplot(3,3,5)
    hold on
    grid on
    box on
    plot(DmuXvect,CMRPinA_ElasticoNLVec(:,2),'k-');
    plot(DmuXvect,MindOinFVec(:,2),'r-');
    legend('Mrpy','OAxFrpy');
    xlabel('DmuX');
    ylabel('CMy');
    
    subplot(3,3,6)
    hold on
    grid on
    box on
    plot(DmuXvect,-CMRPinA_ElasticoNLVec(:,3),'k-');
    plot(DmuXvect,MindOinFVec(:,3),'r-');
    legend('Mrpz','OAxFrpz');
    xlabel('DmuX');
    ylabel('CMz');
    
    subplot(3,3,7)
    hold on
    grid on
    box on
    plot(DmuXvect,beta_ElasticoNLVec(:,1),'k-');
    legend('ElasticoNL');
    xlabel('DmuX');
    ylabel('beta_0 [�]');
    
    subplot(3,3,8)
    hold on
    grid on
    box on
    plot(DmuXvect,beta_ElasticoNLVec(:,2),'k-');
    legend('ElasticoNL');
    xlabel('DmuX');
    ylabel('beta_1C [�]');
    
    subplot(3,3,9)
    hold on
    grid on
    box on
    plot(DmuXvect,beta_ElasticoNLVec(:,3),'k-');
    legend('ElasticoNL');
    xlabel('DmuX');
    ylabel('beta_1S [�]');
   
    figure(150)
    
    hold on
    grid on
    box on
    plot(DmuXvect,lambda_iP_ElasticoNLVec,'k-');
    legend('ElasticoNL');
    xlabel('DmuX');
    ylabel('lambda');
    
    
    figure(160)
    
    hold on
    grid on
    box on
    plot(DmuXvect,AnginA,'k-');
    plot(DmuXvect,AnginP,'r-');
    legend('AnginA [�]','AnginP[�]');
    xlabel('DmuX');
    ylabel('Ang [�] ');
    
      
    DmuXvect1 = DmuXvect(1:length(DmuXvect)-1);
    
    figure(200)
    
    subplot(2,3,1)
    hold on
    grid on
    box on
    plot(DmuXvect1,diff(-CFRPinA_ElasticoNLVec(:,1))./diff(DmuXvect'),'k-');
    legend('ElasticoNL');
    xlabel('DmuX');
    ylabel('dCFx/dmux');
    
    subplot(2,3,2)
    hold on
    grid on
    box on
    plot(DmuXvect1,diff(CFRPinA_ElasticoNLVec(:,2))./diff(DmuXvect'),'k-');
    legend('ElasticoNL');
    xlabel('DmuX');
    ylabel('dCFy/dmux');
    
    subplot(2,3,3)
    hold on
    grid on
    box on
    plot(DmuXvect1,diff(-CFRPinA_ElasticoNLVec(:,3))./diff(DmuXvect'),'k-');
    legend('ElasticoNL');
    xlabel('DmuX');
    ylabel('dCFz/dmux');
    
    subplot(2,3,4)
    hold on
    grid on
    box on
    plot(DmuXvect1,diff(-CMRPinA_ElasticoNLVec(:,1))./diff(DmuXvect'),'k-');
    legend('ElasticoNL');
    xlabel('DmuX');
    ylabel('dCMx/dmux');
    
    subplot(2,3,5)
    hold on
    grid on
    box on
    plot(DmuXvect1,diff(CMRPinA_ElasticoNLVec(:,2))./diff(DmuXvect'),'k-');
    legend('ElasticoNL');
    xlabel('DmuX');
    ylabel('dCMy/dmux');
    
    subplot(2,3,6)
    hold on
    grid on
    box on
    plot(DmuXvect1,diff(-CMRPinA_ElasticoNLVec(:,3))./diff(DmuXvect'),'k-');
    legend('ElasticoNL');
    xlabel('DmuX');
    ylabel('dCMz/dmux');
    
   