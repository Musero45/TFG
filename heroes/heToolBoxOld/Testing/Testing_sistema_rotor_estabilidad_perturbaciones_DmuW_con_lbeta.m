% Función de prueba de fuerza del rotor 01

clear all

%close all

format long

% PUNTO FIJO  

% theta0 = 16*pi/180;
% theta1c = 0*pi/180;
% theta1s = 0*pi/180;
% muXe = 0.0;
% muYe = 0.0;

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
muYe = 0;
muZe = 0;

LineWidth = 1;

mu_xA = muXe;
mu_yA = muYe;
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
    
    lbvect = [linspace(1,1.3,20)];
    
    for lbi = 1:length(lbvect);
        
        lambdab = lbvect(lbi)
                                       
    [Atm] = ISA(HM.altura);

%Para el caso de polar linealizada para todos los elementos

    rango = [-15 10]*pi/180;
    [HM] = polarlineal(HM,rango);

%Creacion de los parametros adimensionales para las ecuaciones
    
    [MHAdim] = Adimensionalizacion(HM,Atm);
     
    MHAdim.epsilon_y = 0;
    
    MHAdim.Pala_RP.lambda_beta = lbvect(lbi);
    
    lambda_beta = lbvect(lbi);
    Omega_rp = MHAdim.Pala_RP.Omega;
    Ip = HM.RP.Ip;
    rho = Atm.rho;
    R_rp = MHAdim.Pala_RP.R;
    b = MHAdim.Pala_RP.b;
    
    m_b = (b/2)*(lambda_beta^2-1)*Omega_rp^2*Ip/(rho*pi*R_rp^2*R_rp*(Omega_rp*R_rp)^2);
        
    MHAdim.Pala_RP.m_b = m_b;
    
    
    DmuZvect = linspace(-0.005,0.005,10);
    
       for DmuZi = 1:length(DmuZvect);
           
           DmuZ = DmuZvect(DmuZi);
           
           mu_zA = muZe+DmuZ;
    
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
    lambda_iP_ElasticoNLVec(DmuZi) = lambda_iP_ElasticoNL';
    
    
    % Calculo de momentos indirectos
    
    had = MHAdim.Brazos.R.h_ad;
    
    OAad = [0;0;had];
    
    MindOinA = cross(OAad,CFRPinA_ElasticoNL);
    
    MindOinF = cambioFfA(0,0,MindOinA);
    
    MindOinFVec(DmuZi,:) = MindOinF';
       
    
       end
    
     CFRx = @(x) interp1(DmuZvect,-CFRPinA_ElasticoNLVec(:,1),x);
     CFRy = @(x) interp1(DmuZvect,CFRPinA_ElasticoNLVec(:,2),x);
     CFRz = @(x) interp1(DmuZvect,-CFRPinA_ElasticoNLVec(:,3),x);
     
     CMRx = @(x) interp1(DmuZvect,-CMRPinA_ElasticoNLVec(:,1),x);
     CMRy = @(x) interp1(DmuZvect,CMRPinA_ElasticoNLVec(:,2),x);
     CMRz = @(x) interp1(DmuZvect,-CMRPinA_ElasticoNLVec(:,3),x);
     
     MindOinFVecx = @(x) interp1(DmuZvect,MindOinFVec(:,1),x);
     MindOinFVecy = @(x) interp1(DmuZvect,MindOinFVec(:,2),x);
     MindOinFVecz = @(x) interp1(DmuZvect,MindOinFVec(:,3),x);
     
     beta0 = @(x) interp1(DmuZvect,beta_ElasticoNLVec(:,1),x);
     beta1c = @(x) interp1(DmuZvect,beta_ElasticoNLVec(:,2),x);
     beta1s = @(x) interp1(DmuZvect,beta_ElasticoNLVec(:,3),x);
     
     lambdai = @(x) interp1(DmuZvect,lambda_iP_ElasticoNLVec,x);
     
     dCFRx(lbi) = derivest(CFRx,0);  
     dCFRy(lbi) = derivest(CFRy,0);
     dCFRz(lbi) = derivest(CFRz,0);
          
     dCMRx(lbi) = derivest(CMRx,0);
     dCMRy(lbi) = derivest(CMRy,0);
     dCMRz(lbi) = derivest(CMRz,0);
     
     dMindOinFVecx(lbi) = derivest(MindOinFVecx,0);
     dMindOinFVecy(lbi) = derivest(MindOinFVecy,0);
     dMindOinFVecz(lbi) = derivest(MindOinFVecz,0);
     
     
     dbeta0(lbi) = derivest(beta0,0);
     dbeta1c(lbi) = derivest(beta1c,0);
     dbeta1s(lbi) = derivest(beta1s,0);
     
     dlambdai(lbi) = derivest(lambdai,0);
    
    end
         
    figure(100)
    
    subplot(3,3,1)
    hold on
    grid on
    box on
    plot(lbvect,dCFRx,'k-','LineWidth',LineWidth);
    legend('ElasticoNL');
    xlabel('\lambda_{\beta}');
    ylabel('CFx');
    
    subplot(3,3,2)
    hold on
    grid on
    box on
    plot(lbvect,dCFRy,'k-','LineWidth',LineWidth);
    legend('ElasticoNL');
    xlabel('\lambda_{\beta}');
    ylabel('CFy');
    
    subplot(3,3,3)
    hold on
    grid on
    box on
    plot(lbvect,dCFRz,'k-','LineWidth',LineWidth);
    legend('ElasticoNL');
    xlabel('\lambda_{\beta}');
    ylabel('CFz');
    
    subplot(3,3,4)
    hold on
    grid on
    box on
    plot(lbvect,dCMRx,'k-','LineWidth',LineWidth);
    plot(lbvect,dMindOinFVecx,'r-','LineWidth',LineWidth);
    legend('dMrpx','dOAxFrpx');
    xlabel('\lambda_{\beta}');
    ylabel('CMx');
    
    subplot(3,3,5)
    hold on
    grid on
    box on
    plot(lbvect,dCMRy,'k-','LineWidth',LineWidth);
    plot(lbvect,dMindOinFVecy,'r-','LineWidth',LineWidth);
    legend('dMrpy','dOAxFrpy');
    xlabel('\lambda_{\beta}');
    ylabel('CMy');
    
    subplot(3,3,6)
    hold on
    grid on
    box on
    plot(lbvect,dCMRz,'k-','LineWidth',LineWidth);
    plot(lbvect,dMindOinFVecz,'r-','LineWidth',LineWidth);
    legend('dMrpz','dOAxFrpz');
    xlabel('\lambda_{\beta}');
    ylabel('CMz');
    
    subplot(3,3,7)
    hold on
    grid on
    box on
    plot(lbvect,dbeta0,'k-','LineWidth',LineWidth);
    legend('ElasticoNL');
    xlabel('\lambda_{\beta}');
    ylabel('beta_0 [º]');
    
    subplot(3,3,8)
    hold on
    grid on
    box on
    plot(lbvect,dbeta1c,'k-','LineWidth',LineWidth);
    legend('ElasticoNL');
    xlabel('\lambda_{\beta}');
    ylabel('beta_1C [º]');
    
    subplot(3,3,9)
    hold on
    grid on
    box on
    plot(lbvect,dbeta1s,'k-','LineWidth',LineWidth);
    legend('ElasticoNL');
    xlabel('\lambda_{\beta}');
    ylabel('beta_1S [º]');
   
    figure(150)
    
    hold on
    grid on
    box on
    plot(lbvect,dlambdai,'k-','LineWidth',LineWidth);
    legend('ElasticoNL');
    xlabel('\it{\lambda}_{\beta}');
    ylabel('d\{lambda}_i');
    
    
  
    
   