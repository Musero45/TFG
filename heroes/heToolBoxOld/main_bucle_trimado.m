    clear all

    format long

    line = 'bo-';
    
%Añadimos todas las carpetas del programa para el cálculo
    path_loader;

%Creación de la supervariable y de otras variables
    [HM] = Helimodel;
    [Atm] = ISA(HM.altura);

    %Para el caso de polar linealizada para todos los elementos
    rango = [-15 10]*pi/180;
    [HM] = polarlineal(HM,rango);

%Creacion de los parametros adimensionales para las ecuaciones
    [MHAdim] = Adimensionalizacion(HM,Atm);
    
% %     B0105    
        MHAdim.Pala_RP.gamma = 5.087;
        MHAdim.Pala_RP.lambda_beta = sqrt(1.248);
%       %MHAdim.CW = 0.005889;
%       %MHAdim.Pala_RP.theta1 = -0.14;
%       %MHAdim.Brazos.CDG.x_cg = 0.0163;
%       MHAdim.Pala_RP.a = 6.113;
% %     MHAdim.Brazos.CDG.y_cg = 0;
        %MHAdim.Brazos.CDG.e_ad = 0; 

%    LYINX    
%    MHAdim.Pala_RP.gamma = 7.12;
%    MHAdim.Pala_RP.lambda_beta = sqrt(1.193);
%    MHAdim.CW = 0.005889;
%    MHAdim.Pala_RP.theta1 = -0.14;
%    MHAdim.Brazos.CDG.x_cg = -0.0198;
%    MHAdim.Brazos.CDG.y_cg = 0;    

    
%CREACIÓN DE UN BUCLE PARA CALCULAR LA EVOLUCIÓN AL VARIAR ALGÚN PARÁMETRO.

    rho = MHAdim.rho;
    R = MHAdim.Pala_RP.R;
    Rra = MHAdim.Pala_RA.R;
    Omega = MHAdim.Pala_RP.Omega;
    Omega_ra = MHAdim.Pala_RA.Omega;

%Definición del rango de calculo    
    
    nodos1 = 10;
    nodos2 = 10;
    nodos = nodos1+nodos2+1;

    maxSpeed = 140*1852/3600; %Velocidad en m/s desde nudos

    var = [0.001,0.005,200/3.6];
    
    var = [0.01,linspace(0.015,32,nodos1),linspace(35,maxSpeed,nodos2)];

    gamma_T = 0*pi/180;

%Selección de las condiciones iniciales de vuelo.
    
    theta00 = 15*pi/180;      theta1c0 = -0*pi/180;        theta1s0 = 0*pi/180;
    theta0_RA0 = 50*pi/180;
    angulo_guinada0 = 0*pi/180; angulo_cabeceo0 = 0*pi/180; angulo_balance0 = 0*pi/180;
   

for i=1:nodos
    
    V = var(i), Vkm = V*3.6, Vkts = V*3600/1852, mu = V/(R*Omega)
    
    mu_xT = -V*cos(gamma_T)/(R*Omega); 
    mu_yT = 0; 
    mu_zT = V*sin(gamma_T)/(R*Omega);
    mu_WxT = 0; mu_WyT = 0; mu_WzT = 0;
      

    [theta0, theta1c, theta1s, theta0_RA,angulo_cabeceo,angulo_balance,fval] = ...
                    solucion_trimado (MHAdim,mu_xT,mu_yT,mu_zT,mu_WxT,mu_WyT,mu_WzT,...
                    theta00,theta1c0,theta1s0,theta0_RA0,angulo_guinada0,angulo_cabeceo0,angulo_balance0);

    theta_0(i) = theta0;        theta_1c(i) = theta1c;              theta_1s(i) = theta1s;
    theta_0RA(i) = theta0_RA;   angulocabeceo(i) = angulo_cabeceo;  angulobalance(i) = angulo_balance;
   
    ErrorCFx(i) = fval(1);
    ErrorCFy(i) = fval(2);
    ErrorCFz(i) = fval(3);
    ErrorCMx(i) = fval(4);
    ErrorCMy(i) = fval(5);
    ErrorCMz(i) = fval(6);
    
    % Definición de nuevas condiciones iniciales
    
    theta00 = theta0;
    theta1c0 = theta1c;
    theta1s0 = theta1s;
    theta0_RA0 = theta0_RA;
    
    angulo_cabeceo0 = angulo_cabeceo;
    angulo_balance0 = angulo_balance;
    
    %Creación de una estructura con las fuerzas, momentos y velocidades inducidas.
    
    [Veloc] = Velocidades(MHAdim,mu_xT,mu_yT,mu_zT,mu_WxT,mu_WyT,mu_WzT,angulo_guinada0, angulo_cabeceo, angulo_balance);
    [salida,TablaAcciones] = fuerzas_trimado (MHAdim,Veloc,theta0,theta1c,theta1s,theta0_RA,angulo_guinada0,angulo_cabeceo,angulo_balance);
    
    betas(i,:) = salida.betas;
    lambda_iP(i) = salida.lambda_iP;    lambda_iPRA(i) = salida.lambda_iPRA;
 
    
    CFu_RPinA(i,:) = salida.CF_local.RP;     
    
    CM_RPinA(i,:) = salida.CM_local.RP;
    
    CFu_RAinARA(i,:) = salida.CF_local.RA;
    
    CM_RAinAra(i,:) = salida.CM_local.RA;
    
    CD_FinF(i,:) =  salida.CF_local.F;
    
    CM_FinF(i,:) = salida.CM_local.RA;
    
    CF_EHI(i,:) = salida.CFinF.EHI;
    
    CF_EHD(i,:) = salida.CFinF.EHD;
    
    CF_EV(i,:) = salida.CFinF.EV;
    
    
    
    alpha_F(i) = salida.AngulosElementos.alpha_F*180/pi;
    beta_F(i) = salida.AngulosElementos.beta_F*180/pi;
    
    phi_EHI(i) = salida.AngulosElementos.phi_EHI*180/pi;
    alpha_EHI(i) = salida.AngulosElementos.alpha_EHI*180/pi;
    
    phi_EHD(i) = salida.AngulosElementos.phi_EHD*180/pi;
    alpha_EHD(i) = salida.AngulosElementos.alpha_EHD*180/pi;
    
    phi_EV(i) = salida.AngulosElementos.phi_EV*180/pi;
    alpha_EV(i) = salida.AngulosElementos.alpha_EV*180/pi;
    
    CD_EHI(i) = salida.CoeficientesAerodinamicosEsta.CD_EHI;
    CL_EHI(i) = salida.CoeficientesAerodinamicosEsta.CL_EHI;
    
    CD_EHD(i) = salida.CoeficientesAerodinamicosEsta.CD_EHD;
    CL_EHD(i) = salida.CoeficientesAerodinamicosEsta.CL_EHD;
    
    CD_EV(i) = salida.CoeficientesAerodinamicosEsta.CD_EV;
    CL_EV(i) = salida.CoeficientesAerodinamicosEsta.CL_EV;
    
    potencia_RP(i) = salida.Potencia.RP;
    potencia_RA(i) = salida.Potencia.RA;
    potencia_fuselaje(i) = salida.Potencia.F;
    potencia_stabs(i) = salida.Potencia.E;
    
    [Motor] = power_plant(HM.altura);
    
    PMTO(i) = Motor.PMTO;
    PMC(i) = Motor.PMC;

    V_xF(i) = Veloc.F.mu_xF*R*Omega;
    
    %Componentes de fuerzas en plano de puntas
    
    beta1c = salida.betas(2);
    beta1s = salida.betas(3);
    CFu_RPinA0 = salida.CF_local.RP;
    
    
    [CFu_RPinP] = cambioPfA(beta1c,beta1s,CFu_RPinA0);

    CH_RPinP = CFu_RPinP(1);
    CY_RPinP = CFu_RPinP(2);
    CT_RPinP = CFu_RPinP(3);
    
    CH_RPinA = CFu_RPinA0(1);
    CY_RPinA = CFu_RPinA0(2);
    CT_RPinA = CFu_RPinA0(3);
    
    
    
    CHY_RPinP = sqrt(CH_RPinP^2+CY_RPinP^2);
    CHY_RPinA = sqrt(CH_RPinA^2+CY_RPinA^2);
    
    RatioHY_PonA(i) = CHY_RPinP/CHY_RPinA;
    
    AnginA(i) = CHY_RPinA/CT_RPinA;
    AnginP(i) = CHY_RPinP/CT_RPinP;
    
    beta1C_PC(i) = beta1c+theta1s;
    beta1S_PC(i) = beta1s-theta1c;
    
    
    
    % Contribucion rotor antipar en porcentaje
    
    ContCMz_RA(i) = TablaAcciones.CMinF.ContMIRAinF(3);
    ContCMz_EV(i) = TablaAcciones.CMinF.ContMIEVinF(3); 
    
    errorFx(i) = TablaAcciones.CFinF.PruebaFuerzasPorcenerror(1);
    errorFy(i) = TablaAcciones.CFinF.PruebaFuerzasPorcenerror(2);
    errorFz(i) = TablaAcciones.CFinF.PruebaFuerzasPorcenerror(3);
    
    errorMx(i) = TablaAcciones.CMinF.PruebaMomentosPorcenerror(1);
    errorMy(i) = TablaAcciones.CMinF.PruebaMomentosPorcenerror(2);
    errorMz(i) = TablaAcciones.CMinF.PruebaMomentosPorcenerror(3);
    
    
    
end

save 'entrada_estabilidad.mat' V_xF angulocabeceo angulobalance R Omega

nota = 'RESULTADOS EN GRADOS'

theta_0 = theta_0*180/pi;       theta_1c = theta_1c*180/pi;             theta_1s = theta_1s*180/pi;
betas = betas*180/pi;
theta_0RA = theta_0RA*180/pi;   angulocabeceo = angulocabeceo*180/pi;   angulobalance = angulobalance*180/pi;


figure(1)

    hold on
    subplot(3,3,1)
        plot(var/(R*Omega),theta_0,line)
        xlabel('\mu_X_T')
        ylabel('\theta_0 (º)','Rotation',0)
        
    hold on    
    subplot(3,3,2)
        plot(var/(R*Omega),theta_1c,line)
        xlabel('\mu_X_T')
        ylabel('\theta_1_C (º)','Rotation',0)
    hold on
    subplot(3,3,3)
        plot(var/(R*Omega),theta_1s,line)
        xlabel('\mu_X_T')
        ylabel('\theta_1_S (º)','Rotation',0)
    
    hold on
    subplot(3,3,4)
        plot(var/(R*Omega),betas(:,1),line)
        xlabel('\mu_X_T')
        ylabel('\beta_0 (º)','Rotation',0)
   hold on
   subplot(3,3,5)
        plot(var/(R*Omega),betas(:,2),line)
        xlabel('\mu_X_T')
        ylabel('\beta_1_C (º)','Rotation',0)

   hold on
   subplot(3,3,6)
        plot(var/(R*Omega),betas(:,3),line)
        xlabel('\mu_X_T')
        ylabel('\beta_1_S (º)','Rotation',0)
   hold on
   subplot(3,3,7)
        plot(var/(R*Omega),theta_0RA,line)
        xlabel('\mu_X_T')
        ylabel('\theta_0_R_A (º)','Rotation',0)
   hold on
   subplot(3,3,8)
        plot(var/(R*Omega),angulocabeceo,line)
        xlabel('\mu_X_T')
        ylabel('angulo cabeceo (º)','Rotation',90)

   hold on
   subplot(3,3,9)
        plot(var/(R*Omega),angulobalance,line)
        xlabel('\mu_X_T')
        ylabel('angulo balance (º)','Rotation',90)

figure(2)
    subplot(1,2,1)
        plot(var/(R*Omega),lambda_iP)
        xlabel('\mu_X_T')
        ylabel('\lambda_i_P','Rotation',0)
    subplot(1,2,2)
        plot(var/(R*Omega),lambda_iPRA)
        xlabel('\mu_X_T')
        ylabel('\lambda_i_P_R_A','Rotation',0)

figure(3)
    subplot(3,3,1)
        hold on
        plot(var/(R*Omega),CFu_RPinA(:,1),line)
        xlabel('\mu_X_T')
        ylabel('C_H_R_P (ejes A)','Rotation',90)
    subplot(3,3,2)
        hold on
        plot(var/(R*Omega),CFu_RPinA(:,2),line)
        xlabel('\mu_X_T')
        ylabel('C_Y_R_P (ejes A)','Rotation',90)
    subplot(3,3,3)
        hold on
        plot(var/(R*Omega),CFu_RPinA(:,3),line)
        xlabel('\mu_X_T')
        ylabel('C_T_R_P (ejes A)','Rotation',90)
        
    subplot(3,3,4)
        hold on
        plot(var/(R*Omega),CFu_RAinARA(:,1),line)
        xlabel('\mu_X_T')
        ylabel('C_H_R_A (ejes ARA)','Rotation',90)
    subplot(3,3,5)
        hold on
        plot(var/(R*Omega),CFu_RAinARA(:,2),line)
        xlabel('\mu_X_T')
        ylabel('C_Y_R_A (ejes ARA)','Rotation',90)
    subplot(3,3,6)
        hold on
        plot(var/(R*Omega),CFu_RAinARA(:,3),line)
        xlabel('\mu_X_T')
        ylabel('C_T_R_A (ejes ARA)','Rotation',90)

        subplot(3,3,7)
        hold on
        plot(var/(R*Omega),CD_FinF(:,1),line)
        xlabel('\mu_X_T')
        ylabel('C_Fx','Rotation',90)
    subplot(3,3,8)
        hold on
        plot(var/(R*Omega),CD_FinF (:,2),line)
        xlabel('\mu_X_T')
        ylabel('C_Fy','Rotation',90)
    subplot(3,3,9)
        hold on
        plot(var/(R*Omega),CD_FinF (:,3),line)
        xlabel('\mu_X_T')
        ylabel('C_Fz','Rotation',90)
 
    figure(31)
    
    subplot(2,3,1)
        hold on
        plot(var/(R*Omega),CM_RPinA(:,1),line)
        xlabel('\mu_X_T')
        ylabel('C_Mx_RP (ejes A)','Rotation',90)
    subplot(2,3,2)
        hold on
        plot(var/(R*Omega),CM_RPinA(:,2),line)
        xlabel('\mu_X_T')
        ylabel('C_My_RP (ejes A)','Rotation',90)
    subplot(2,3,3)
        hold on
        plot(var/(R*Omega),CM_RPinA(:,3),line)
        xlabel('\mu_X_T')
        ylabel('C_Mz_RP (ejes A)','Rotation',90)
        
    subplot(2,3,4)
        hold on
        plot(var/(R*Omega),CM_RAinAra(:,1),line)
        xlabel('\mu_X_T')
        ylabel('C_Mx_RA (ejes Ara)','Rotation',90)
    subplot(2,3,5)
        hold on
        plot(var/(R*Omega),CM_RAinAra(:,2),line)
        xlabel('\mu_X_T')
        ylabel('C_My_RA (ejes Ara)','Rotation',90)
    subplot(2,3,6)
        hold on
        plot(var/(R*Omega),CM_RAinAra(:,3),line)
        xlabel('\mu_X_T')
        ylabel('C_Mz_RA (ejes Ara)','Rotation',90)

              
        
        
 figure(32)
    subplot(3,3,1)
        hold on
        plot(var/(R*Omega),CF_EHI(:,1),line)
        xlabel('\mu_X_T')
        ylabel('CF_EHIx in F)','Rotation',90)
    subplot(3,3,2)
        hold on
        plot(var/(R*Omega),CF_EHI(:,2),line)
        xlabel('\mu_X_T')
        ylabel('CF_EHIy in F','Rotation',90)
    subplot(3,3,3)
        hold on
        plot(var/(R*Omega),CF_EHI(:,3),line)
        xlabel('\mu_X_T')
        ylabel('CF_EHIz in F','Rotation',90)
        
     subplot(3,3,4)
        hold on
        plot(var/(R*Omega),CF_EHD(:,1),line)
        xlabel('\mu_X_T')
        ylabel('CF_EHDx in F)','Rotation',90)
    subplot(3,3,5)
        hold on
        plot(var/(R*Omega),CF_EHD(:,2),line)
        xlabel('\mu_X_T')
        ylabel('CF_EHDy in F','Rotation',90)
    subplot(3,3,6)
        hold on
        plot(var/(R*Omega),CF_EHD(:,3),line)
        xlabel('\mu_X_T')
        ylabel('CF_EHDz in F','Rotation',90)
     subplot(3,3,7)
        hold on
        plot(var/(R*Omega),CF_EV(:,1),line)
        xlabel('\mu_X_T')
        ylabel('CF_EVx in F)','Rotation',90)
    subplot(3,3,8)
        hold on
        plot(var/(R*Omega),CF_EV(:,2),line)
        xlabel('\mu_X_T')
        ylabel('CF_EVy in F','Rotation',90)
    subplot(3,3,9)
        hold on
        plot(var/(R*Omega),CF_EV(:,3),line)
        xlabel('\mu_X_T')
        ylabel('CF_EVz in F','Rotation',90)
              
        
figure(4)


    perdidas = 1.2;
        subplot(1,2,1)
        hold on
        plot(var/(R*Omega),potencia_RP*1e-3,'b--')
        plot(var/(R*Omega),potencia_RA*1e-3,'b:')
        plot(var/(R*Omega),potencia_fuselaje*1e-3,'k:')
        plot(var/(R*Omega),potencia_stabs*1e-3,'k--')
        plot(var/(R*Omega),(potencia_RP+potencia_RA+potencia_fuselaje+potencia_stabs)*1e-3,'r:')
        %plot(var/(R*Omega),(perdidas*(potencia_RP+potencia_RA)+potencia_fuselaje+potencia_stabs)*1e-3,'r')
        plot(var/(R*Omega),perdidas*(potencia_RP+potencia_RA)*1e-3,'r','LineWidth',2)
        plot(var/(R*Omega),(PMTO)*1e-3,'m')
        plot(var/(R*Omega),(PMC)*1e-3,'m--')
   %hold off
        xlabel('\mu_X_T')
        ylabel('Potencia (kW)','Rotation',90)
        legend('Potencia Rotor Principal',...
               'Potencia Rotor Antipar',...
               'Potencia parásita del fuselaje',...
               'Potencia parásita de los estabilizadores',...
               'Potencia total necesaria',...
               'Potencia con perdidas en la transmision',...
               'PMTO',...
               'PMC',...
               'Location','NorthEast')
        axis([min(var/(R*Omega)) max(var/(R*Omega)) 0 1.1*max((perdidas*(potencia_RP+potencia_RA)+potencia_fuselaje)*1e-3)])

        subplot(1,2,2)
        hold on
        plot(var/(R*Omega),potencia_RP*1e-3/Omega,'ko-');
        xlabel('mu [knots]');
        ylabel('Q_{RP} [kNm]');
        
        
    figure(5)
 
    hold on
    plot(var/(R*Omega),RatioHY_PonA,'k-')
    plot(var/(R*Omega),AnginA*180/pi,'b--')
    plot(var/(R*Omega),AnginP*180/pi,'r--')
    legend('RatioHY_PonA','AnginA[º]','AnginP[º]');
     
    
    figure(6)
 
    hold on
    plot(var/(R*Omega),100*(potencia_RA./potencia_RP),'k-')
    legend('etaRA');
    
    figure(7)
 
    
    subplot(2,2,1)
    hold on
    plot(var/(R*Omega),alpha_F,'k-')
    plot(var/(R*Omega),beta_F,'r-')
    legend('alpha_F [º]','beta_F [º]');
    
    subplot(2,2,2)
    hold on
    plot(var/(R*Omega),phi_EHI,'k-')
    plot(var/(R*Omega),alpha_EHI,'r-')
    legend('phi_EHI [º]','alpha_EHI [º]');
    
    subplot(2,2,3)
    hold on
    plot(var/(R*Omega),phi_EHD,'k-')
    plot(var/(R*Omega),alpha_EHD,'r-')
    legend('phi_EHD [º]','alpha_EHD [º]');
    
    subplot(2,2,4)
    hold on
    plot(var/(R*Omega),phi_EV,'k-')
    plot(var/(R*Omega),alpha_EV,'r-')
    legend('phi_EV [º]','alpha_EV [º]');
    
     figure(71)
 
    
    subplot(2,2,1)
    hold on
    plot(var/(R*Omega),CD_EHI,'r-')
    plot(var/(R*Omega),CD_EHD,'k-')
    plot(var/(R*Omega),CD_EV,'b-')
    legend('CD_EHI','CD_EHD','CD_EV');
    xlabel('\mu');
    
    subplot(2,2,2)
    hold on
    plot(var/(R*Omega),CL_EHI,'r-')
    plot(var/(R*Omega),CL_EHD,'k-')
    plot(var/(R*Omega),CL_EV,'b-')
    legend('CL_EHI','CL_EHD','CL_EV');
    xlabel('\mu');
    
    subplot(2,2,3)
    hold on
    plot(alpha_EHI,CD_EHI,'r-')
    plot(alpha_EHD,CD_EHD,'k-')
    plot(alpha_EV,CD_EV,'b-')
    legend('CD_EHI','CD_EHD','CD_EV');
    xlabel('\alpha');
    
    subplot(2,2,4)
    hold on
    plot(alpha_EHI,CL_EHI,'r-')
    plot(alpha_EHD,CL_EHD,'k-')
    plot(alpha_EV,CL_EV,'b-')
    legend('CL_EHI','CL_EHD','CL_EV');
    xlabel('\alpha');
       
    
    figure(8)
    
    subplot(1,2,1)
    hold on
    plot(var/(R*Omega),errorFx,'ko-')
    plot(var/(R*Omega),errorFy,'ro-')
    plot(var/(R*Omega),errorFz,'bo-')
    hold on
    legend('%errorFx','%errorFy','%errorFz');
    
    subplot(1,2,2)
    hold on
    plot(var/(R*Omega),errorMx,'ko-')
    plot(var/(R*Omega),errorMy,'ro-')
    plot(var/(R*Omega),errorMz,'bo-')
    hold on
    legend('%errorMx','%errorMy','%errorMz');
    
    figure(9)
 
    
    subplot(1,2,1)
    hold on
    plot(var/(R*Omega),ErrorCFx,'k-')
    plot(var/(R*Omega),ErrorCFy,'r-')
    plot(var/(R*Omega),ErrorCFz,'b-')
    hold on
    legend('%ErrorCFx','%ErrorCFy','%ErrorCFz');
    
    subplot(1,2,2)
    hold on
    plot(var/(R*Omega),ErrorCMx,'k-')
    plot(var/(R*Omega),ErrorCMy,'r-')
    plot(var/(R*Omega),ErrorCMz,'b-')
    hold on
    legend('%ErrorCMx','%ErrorCMy','%ErrorCMz');
    
    figure(10)
   
    
    hold on
    plot(var/(R*Omega),-2*ContCMz_RA,'k-')
    plot(var/(R*Omega),-2*ContCMz_EV,'r-')
    plot(var/(R*Omega),(-2*ContCMz_RA-2*ContCMz_EV),'b-')
    hold on
    legend('%ContRA','%ContEV');
    
    figure(11)
   
    
    hold on
    plot(var/(R*Omega),beta1C_PC,'k-')
    plot(var/(R*Omega),beta1S_PC,'r-')
    hold on
    legend('beta1C_PC','beta1C_PC');
    
        
        
        %Desvinculamos las carpetas del programa
%path_unloader;