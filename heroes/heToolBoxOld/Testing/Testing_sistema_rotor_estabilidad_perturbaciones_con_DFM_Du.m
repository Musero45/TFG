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

LineWidth = 1;

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


%   bucle en Pertubacion de vuelo en ejes cuerpo DmuX = DmuU
    
    muXevect = [linspace(0,0.5,25)];
    
    for muXei = 1:length(muXevect);
        
        muXe = muXevect(muXei)
                                       
    [Atm] = ISA(HM.altura);

%Para el caso de polar linealizada para todos los elementos

    rango = [-15 10]*pi/180;
    [HM] = polarlineal(HM,rango);

%Creacion de los parametros adimensionales para las ecuaciones
    
    [MHAdim] = Adimensionalizacion(HM,Atm);
     
    MHAdim.epsilon_y = 0;
    
        
    lambda_beta = 1.05;
    e_ad = 0.0;
    MHAdim.Pala_RP.e_ad = e_ad;
    MHAdim.Pala_RP.lambda_beta = lambda_beta;
    Omega_rp = MHAdim.Pala_RP.Omega;
    Ip = HM.RP.Ip;
    rho = Atm.rho;
    R_rp = MHAdim.Pala_RP.R;
    b = MHAdim.Pala_RP.b;
    lock = MHAdim.Pala_RP.gamma;
    
    S_beta = (8/lock)*(lambda_beta^2-1);
    
    m_b = (b/2)*(lambda_beta^2-1)*Omega_rp^2*Ip/(rho*pi*R_rp^2*R_rp*(Omega_rp*R_rp)^2);
        
    MHAdim.Pala_RP.m_b = m_b;
    
        
    DmuXvect = linspace(-0.005,0.005,10);
    
       for DmuXi = 1:length(DmuXvect);
           
           DmuX = DmuXvect(DmuXi);
           
           mu_xA = muXe+DmuX;
    
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
       
    
    CFRPinA_ElasticoNLVec(DmuXi,:) = CFRPinA_ElasticoNL';
    CMRPinA_ElasticoNLVec(DmuXi,:) = CMRPinA_ElasticoNL';
    CMRalterElasticoNLVec(DmuXi,:) = CMRalterElasticoNL;
    beta_ElasticoNLVec(DmuXi,:) = beta_ElasticoNL*180/pi';
    lambda_iP_ElasticoNLVec(DmuXi) = lambda_iP_ElasticoNL';
    
    
    % Calculo de momentos indirectos
    
    had = MHAdim.Brazos.R.h_ad;
    
    OAad = [0;0;had];
    
    MindOinA = cross(OAad,CFRPinA_ElasticoNL);
    
    MindOinF = cambioFfA(0,0,MindOinA);
    
    MindOinFVec(DmuXi,:) = MindOinF';
       
    
       end
    
     CFRx = @(x) interp1(DmuXvect,-CFRPinA_ElasticoNLVec(:,1),x);
     CFRy = @(x) interp1(DmuXvect,CFRPinA_ElasticoNLVec(:,2),x);
     CFRz = @(x) interp1(DmuXvect,-CFRPinA_ElasticoNLVec(:,3),x);
     
     CMRx = @(x) interp1(DmuXvect,-CMRPinA_ElasticoNLVec(:,1),x);
     CMRy = @(x) interp1(DmuXvect,CMRPinA_ElasticoNLVec(:,2),x);
     CMRz = @(x) interp1(DmuXvect,-CMRPinA_ElasticoNLVec(:,3),x);
     
     MindOinFVecx = @(x) interp1(DmuXvect,MindOinFVec(:,1),x);
     MindOinFVecy = @(x) interp1(DmuXvect,MindOinFVec(:,2),x);
     MindOinFVecz = @(x) interp1(DmuXvect,MindOinFVec(:,3),x);
     
     beta0 = @(x) interp1(DmuXvect,beta_ElasticoNLVec(:,1),x);
     beta1c = @(x) interp1(DmuXvect,beta_ElasticoNLVec(:,2),x);
     beta1s = @(x) interp1(DmuXvect,beta_ElasticoNLVec(:,3),x);
     
     lambdai = @(x) interp1(DmuXvect,lambda_iP_ElasticoNLVec,x);
     
     dCFRx(muXei) = derivest(CFRx,0);  
     dCFRy(muXei) = derivest(CFRy,0);
     dCFRz(muXei) = derivest(CFRz,0);
          
     dCMRx(muXei) = derivest(CMRx,0);
     dCMRy(muXei) = derivest(CMRy,0);
     dCMRz(muXei) = derivest(CMRz,0);
     
     dMindOinFVecx(muXei) = derivest(MindOinFVecx,0);
     dMindOinFVecy(muXei) = derivest(MindOinFVecy,0);
     dMindOinFVecz(muXei) = derivest(MindOinFVecz,0);
     
     
     dbeta0(muXei) = derivest(beta0,0);
     dbeta1c(muXei) = derivest(beta1c,0);
     dbeta1s(muXei) = derivest(beta1s,0);
     
     dlambdai(muXei) = derivest(lambdai,0);
    
    end
         
    figure(100)
    
    subplot(3,3,1)
    hold on
    grid on
    box on
    plot(muXevect,dCFRx,'k-','LineWidth',LineWidth);
    legend('ElasticoNL');
    xlabel('muXe');
    ylabel('dCFx/dmux');
    
    subplot(3,3,2)
    hold on
    grid on
    box on
    plot(muXevect,dCFRy,'k-','LineWidth',LineWidth);
    legend('ElasticoNL');
    xlabel('muXe');
    ylabel('dCFy/dmux');
    
    subplot(3,3,3)
    hold on
    grid on
    box on
    plot(muXevect,dCFRz,'k-','LineWidth',LineWidth);
    legend('ElasticoNL');
    xlabel('muXe');
    ylabel('dCFz/dmux');
    
    subplot(3,3,4)
    hold on
    grid on
    box on
    plot(muXevect,dCMRx,'k-','LineWidth',LineWidth);
    plot(muXevect,dMindOinFVecx,'r-','LineWidth',LineWidth);
    plot(muXevect,dCMRx+dMindOinFVecx,'b-','LineWidth',2);
    legend('dMrpx/dmux','dOAxFrpx/dmux','dTotal/dmux');
    xlabel('muXe');
    ylabel('CMx');
    
    subplot(3,3,5)
    hold on
    grid on
    box on
    plot(muXevect,dCMRy,'k-','LineWidth',LineWidth);
    plot(muXevect,dMindOinFVecy,'r-','LineWidth',LineWidth);
    plot(muXevect,dCMRy+dMindOinFVecy,'b-','LineWidth',2);
    legend('dMrpy/dmux','dOAxFrpy/dmux','dTotal/dmux');
    xlabel('muXe');
    ylabel('CMy');
    
    subplot(3,3,6)
    hold on
    grid on
    box on
    plot(muXevect,dCMRz,'k-','LineWidth',LineWidth);
    plot(muXevect,dMindOinFVecz,'r-','LineWidth',LineWidth);
    plot(muXevect,dCMRz+dMindOinFVecz,'b-','LineWidth',2);
    legend('dMrpz/dmux','dOAxFrpz/dmux','dTotal/dmux');
    xlabel('muXe');
    ylabel('CMz');
    
    subplot(3,3,7)
    hold on
    grid on
    box on
    plot(muXevect,dbeta0,'k-','LineWidth',LineWidth);
    %legend('ElasticoNL');
    xlabel('muXe');
    ylabel('/dmuxbeta_0/dmux [º]');
    
    subplot(3,3,8)
    hold on
    grid on
    box on
    plot(muXevect,dbeta1c,'k-','LineWidth',LineWidth);
    %legend('ElasticoNL');
    xlabel('muXe');
    ylabel('dbeta_1C/dmux [º]');
    
    subplot(3,3,9)
    hold on
    grid on
    box on
    plot(muXevect,dbeta1s,'k-','LineWidth',LineWidth);
    %legend('ElasticoNL');
    xlabel('muXe');
    ylabel('dbeta_1S/dmux [º]');
   
    figure(150)
    
    hold on
    grid on
    box on
    plot(muXevect,dlambdai,'k-','LineWidth',LineWidth);
    %legend('ElasticoNL');
    xlabel('muXe');
    ylabel('d\{lambda}_i');
    
    
  
    
   