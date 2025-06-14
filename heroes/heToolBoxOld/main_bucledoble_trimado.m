clear

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



%CREACIÓN DE UN BUCLE PARA CALCULAR LA EVOLUCIÓN AL VARIAR ALGÚN PARÁMETRO.

rho = MHAdim.rho;
R = MHAdim.Pala_RP.R;
Rra = MHAdim.Pala_RA.R;
Omega = MHAdim.Pala_RP.Omega;
Omega_ra = MHAdim.Pala_RA.Omega;

nodos = 10 ;
var = linspace(0,120,nodos)/(R*Omega);

%OJO, SI SE VARIA NODOS2 HAY QUE RETOCAR LA LEYENDA A MANO; NO CONSEGUI AUTOMATIZARLO
nodos2 = 3;
var2 = linspace(0,3000,nodos2);


for i=1:nodos
for j=1:nodos2
    
    %MENOS OPTIMIZADO, PERO MAS SIMPLE PARA INTERCAMBIAR LAS VARIABLES
    
    V = var(i)*(R*Omega);
    variable1 = '\mu_X_T';  %Nombre de la variable en las gráficas
    gamma_T=0*pi/180;

    HM.altura = var2(j);
    variable2 = 'h = '; %Nombre de la variable en las gráficas
    variable2dim = 'm'; %unidades de la variable
    
    [Atm] = ISA(HM.altura);
    [MHAdim] = Adimensionalizacion(HM,Atm);
    
    mu_xT = -V*cos(gamma_T)/(R*Omega); 
    mu_yT = 0; 
    mu_zT = V*sin(gamma_T)/(R*Omega);
    mu_WxT = 0; mu_WyT = 0; mu_WzT = 0;
    
 %Selección de las condiciones iniciales de vuelo.
    
    theta00=10*pi/180;      theta1c0=0*pi/180;        theta1s0=0*pi/180;
    theta0_RA0 = 15*pi/180;
    angulo_guinada0 = 0*pi/180; angulo_cabeceo0 = -1*pi/180; angulo_balance0 = 0*pi/180;
   
    

    [theta0, theta1c, theta1s, theta0_RA,angulo_cabeceo,angulo_balance] = solucion_trimado (MHAdim, mu_xT, mu_yT, mu_zT, mu_WxT,mu_WyT,mu_WzT,...
        theta00, theta1c0, theta1s0, theta0_RA0, angulo_guinada0, angulo_cabeceo0, angulo_balance0);

    theta_0(j,i) = theta0;        theta_1c(j,i) = theta1c;              theta_1s(j,i) = theta1s;
    theta_0RA(j,i) = theta0_RA;   angulocabeceo(j,i) = angulo_cabeceo;  angulobalance(j,i) = angulo_balance;
    
    %Creación de una estructura con las fuerzas, momentos y velocidades inducidas.
    
    [Veloc] = Velocidades(MHAdim,mu_xT,mu_yT,mu_zT,mu_WxT,mu_WyT,mu_WzT,angulo_guinada0, angulo_cabeceo, angulo_balance);
    [salida] = fuerzas_trimado (MHAdim,Veloc,theta0,theta1c,theta1s,theta0_RA,angulo_guinada0,angulo_cabeceo,angulo_balance);
    
    betas = salida.betas;
    beta0(j,i) = betas(1);      beta1c(j,i) = betas(2);     beta1s(j,i) = betas(3);
    lambda_iP(j,i) = salida.lambda_iP;    lambda_iPRA(j,i) = salida.lambda_iPRA;
 
    
    CH_RPinA(j,i) = salida.CF_local.RP(1);
    CY_RPinA(j,i) = salida.CF_local.RP(2);
    CT_RPinA(j,i) = salida.CF_local.RP(3);
    CH_RAinARA(j,i) = salida.CF_local.RA(1);
    CY_RAinARA(j,i) = salida.CF_local.RA(2);
    CT_RAinARA(j,i) = salida.CF_local.RA(3);
    

    potencia_RP(j,i) = salida.Potencia.RP;
    potencia_RA(j,i) = salida.Potencia.RA;
    potencia_fuselaje(j,i) = salida.Potencia.F;
    potencia_stabs(j,i) = salida.Potencia.E;
    
    [Motor] = power_plant(HM.altura);
    
    PMTO(j,i) = Motor.PMTO;
    PMC(j,i) = Motor.PMC;
end
end


nota = 'RESULTADOS EN GRADOS'

theta_0 = theta_0*180/pi;       theta_1c = theta_1c*180/pi;             theta_1s = theta_1s*180/pi;
beta0 = beta0*180/pi;           beta1c = beta1c*180/pi;                 beta1s = beta1s*180/pi;
theta_0RA = theta_0RA*180/pi;   angulocabeceo = angulocabeceo*180/pi;   angulobalance = angulobalance*180/pi;


figure(1)
    subplot(3,3,1)
        plot(var,theta_0)
        xlabel(variable1)
        ylabel('\theta_0 (º)','Rotation',0)
        legend([variable2,num2str(var2(1)),variable2dim],...
               [variable2,num2str(var2(2)),variable2dim],...
               [variable2,num2str(var2(3)),variable2dim])
    subplot(3,3,2)
        plot(var,theta_1c)
        xlabel(variable1)
        ylabel('\theta_1_C (º)','Rotation',0)
        legend([variable2,num2str(var2(1)),variable2dim],...
               [variable2,num2str(var2(2)),variable2dim],...
               [variable2,num2str(var2(3)),variable2dim])
    subplot(3,3,3)
        plot(var,theta_1s)
        xlabel(variable1)
        ylabel('\theta_1_S (º)','Rotation',0)
        legend([variable2,num2str(var2(1)),variable2dim],...
               [variable2,num2str(var2(2)),variable2dim],...
               [variable2,num2str(var2(3)),variable2dim])
    subplot(3,3,4)
        plot(var,beta0)
        xlabel(variable1)
        ylabel('\beta_0 (º)','Rotation',0)
        legend([variable2,num2str(var2(1)),variable2dim],...
               [variable2,num2str(var2(2)),variable2dim],...
               [variable2,num2str(var2(3)),variable2dim])
    subplot(3,3,5)
        plot(var,beta1c)
        xlabel(variable1)
        ylabel('\beta_1_C (º)','Rotation',0)
        legend([variable2,num2str(var2(1)),variable2dim],...
               [variable2,num2str(var2(2)),variable2dim],...
               [variable2,num2str(var2(3)),variable2dim])
    subplot(3,3,6)
        plot(var,beta1s)
        xlabel(variable1)
        ylabel('\beta_1_S (º)','Rotation',0)
        legend([variable2,num2str(var2(1)),variable2dim],...
               [variable2,num2str(var2(2)),variable2dim],...
               [variable2,num2str(var2(3)),variable2dim])
    subplot(3,3,7)
        plot(var,theta_0RA)
        xlabel(variable1)
        ylabel('\theta_0_R_A (º)','Rotation',0)
        legend([variable2,num2str(var2(1)),variable2dim],...
               [variable2,num2str(var2(2)),variable2dim],...
               [variable2,num2str(var2(3)),variable2dim])
    subplot(3,3,8)
        plot(var,angulocabeceo)
        xlabel(variable1)
        ylabel('angulo cabeceo (º)','Rotation',90)
        legend([variable2,num2str(var2(1)),variable2dim],...
               [variable2,num2str(var2(2)),variable2dim],...
               [variable2,num2str(var2(3)),variable2dim])
    subplot(3,3,9)
        plot(var,angulobalance)
        xlabel(variable1)
        ylabel('angulo balance (º)','Rotation',90)
        legend([variable2,num2str(var2(1)),variable2dim],...
               [variable2,num2str(var2(2)),variable2dim],...
               [variable2,num2str(var2(3)),variable2dim])

figure(2)
    subplot(1,2,1)
        plot(var,lambda_iP)
        xlabel(variable1)
        ylabel('\lambda_i_P','Rotation',0)
        legend([variable2,num2str(var2(1)),variable2dim],...
               [variable2,num2str(var2(2)),variable2dim],...
               [variable2,num2str(var2(3)),variable2dim])
    subplot(1,2,2)
        plot(var/(R*Omega),lambda_iPRA)
        xlabel(variable1)
        ylabel('\lambda_i_P_R_A','Rotation',0)
        legend([variable2,num2str(var2(1)),variable2dim],...
               [variable2,num2str(var2(2)),variable2dim],...
               [variable2,num2str(var2(3)),variable2dim])

figure(3)
    subplot(2,3,1)
        plot(var,CH_RPinA)
        xlabel(variable1)
        ylabel('C_H_R_P (ejes A)','Rotation',90)
        legend([variable2,num2str(var2(1)),variable2dim],...
               [variable2,num2str(var2(2)),variable2dim],...
               [variable2,num2str(var2(3)),variable2dim])
    subplot(2,3,2)
        plot(var,CY_RPinA)
        xlabel(variable1)
        ylabel('C_Y_R_P (ejes A)','Rotation',90)
        legend([variable2,num2str(var2(1)),variable2dim],...
               [variable2,num2str(var2(2)),variable2dim],...
               [variable2,num2str(var2(3)),variable2dim])
    subplot(2,3,3)
        plot(var,CT_RPinA)
        xlabel(variable1)
        ylabel('C_T_R_P (ejes A)','Rotation',90)
        legend([variable2,num2str(var2(1)),variable2dim],...
               [variable2,num2str(var2(2)),variable2dim],...
               [variable2,num2str(var2(3)),variable2dim])
        
    subplot(2,3,4)
        plot(var,CH_RAinARA)
        xlabel(variable1)
        ylabel('C_H_R_A (ejes ARA)','Rotation',90)
        legend([variable2,num2str(var2(1)),variable2dim],...
               [variable2,num2str(var2(2)),variable2dim],...
               [variable2,num2str(var2(3)),variable2dim])
    subplot(2,3,5)
        plot(var,CY_RAinARA)
        xlabel(variable1)
        ylabel('C_Y_R_A (ejes ARA)','Rotation',90)
        legend([variable2,num2str(var2(1)),variable2dim],...
               [variable2,num2str(var2(2)),variable2dim],...
               [variable2,num2str(var2(3)),variable2dim])
    subplot(2,3,6)
        plot(var,CT_RAinARA)
        xlabel(variable1)
        ylabel('C_T_R_A (ejes ARA)','Rotation',90)
        legend([variable2,num2str(var2(1)),variable2dim],...
               [variable2,num2str(var2(2)),variable2dim],...
               [variable2,num2str(var2(3)),variable2dim])

           
figure(4)
    perdidas = 1.1;
    potencia_total = (perdidas*(potencia_RP+potencia_RA)+potencia_fuselaje+potencia_stabs)*1e-3;
    hold on
        plot(var,potencia_total(1,:),'r',var,potencia_total(2,:),'b',var,potencia_total(3,:),'g')
        plot(var,(PMTO(1,:))*1e-3,'r--',var,(PMTO(2,:))*1e-3,'b--',var,(PMTO(3,:))*1e-3,'g--')
        plot(var,(PMC(1,:))*1e-3,'r:',var,(PMC(2,:))*1e-3,'b:',var,(PMC(3,:))*1e-3,'g:')
    hold off
        xlabel(variable1)
        ylabel('Potencia (kW)','Rotation',90)
        legend(['P_N_E_C (',variable2,num2str(var2(1)),variable2dim,')'],...
               ['P_N_E_C (',variable2,num2str(var2(2)),variable2dim,')'],...
               ['P_N_E_C (',variable2,num2str(var2(3)),variable2dim,')'],...
               ['P_M_T_O (',variable2,num2str(var2(1)),variable2dim,')'],...
               ['P_M_T_O (',variable2,num2str(var2(2)),variable2dim,')'],...
               ['P_M_T_O (',variable2,num2str(var2(3)),variable2dim,')'],...
               ['P_M_C (',variable2,num2str(var2(1)),variable2dim,')'],...
               ['P_M_C (',variable2,num2str(var2(2)),variable2dim,')'],...
               ['P_M_C (',variable2,num2str(var2(3)),variable2dim,')'])
               
           
           %         axis([min(var/(R*Omega)) max(var/(R*Omega)) 0 1.1*max((perdidas*(potencia_RP+potencia_RA)+potencia_fuselaje)*1e-3)])
           
     
% figure(4)
%     perdidas = 1.1;
%     hold on
%         plot(var,potencia_RP*1e-3,'b--')
%         plot(var,potencia_RA*1e-3,'b:')
%         plot(var,potencia_fuselaje*1e-3,'k:')
%         plot(var,potencia_stabs*1e-3,'k--')
%         plot(var,(potencia_RP+potencia_RA+potencia_fuselaje+potencia_stabs)*1e-3,'r:')
%         plot(var,(perdidas*(potencia_RP+potencia_RA)+potencia_fuselaje+potencia_stabs)*1e-3,'r')
%         plot(var,(PMTO)*1e-3,'m')
%         plot(var,(PMC)*1e-3,'m--')
%         
%     hold off
%         xlabel(variable1)
%         ylabel('Potencia (kW)','Rotation',90)
%         legend('Potencia Rotor Principal',...
%                'Potencia Rotor Antipar',...
%                'Potencia parásita del fuselaje',...
%                'Potencia parásita de los estabilizadores',...
%                'Potencia total necesaria',...
%                'Potencia con perdidas en la transmision',...
%                'PMTO',...
%                'PMC',...
%                'Location','NorthEast')
%          axis([min(var/(R*Omega)) max(var/(R*Omega)) 0 1.1*max((perdidas*(potencia_RP+potencia_RA)+potencia_fuselaje)*1e-3)])
%Desvinculamos las carpetas del programa
path_unloader;