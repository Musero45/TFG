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

nodos = 11 ;
var = linspace(0,0.05,nodos);%/(R*Omega);

%OJO, SI SE VARIA NODOS2 HAY QUE RETOCAR LA LEYENDA A MANO; NO CONSEGUI AUTOMATIZARLO
nodos2 = 3;
var2 = linspace(0,4000,nodos2);


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
 
    
    mu_xA = Veloc.A.mu_xA;      mu_yA = Veloc.A.mu_yA;      mu_zA = Veloc.A.mu_zA;
    mu_WxA = Veloc.A.mu_WxA;    mu_WyA = Veloc.A.mu_WyA;    mu_WzA = Veloc.A.mu_WzA;
    lambda_i = salida.lambda_iP;
    
   delta_theta = 1e-3*pi/180; 
    
   [beta0_t1cp,beta1c_t1cp,beta1s_t1cp] = batimiento(theta0,theta1c+delta_theta,theta1s,mu_xA,mu_yA,mu_zA,mu_WxA,mu_WyA,mu_WzA,lambda_i,MHAdim);
   [beta0_t1cn,beta1c_t1cn,beta1s_t1cn] = batimiento(theta0,theta1c-delta_theta,theta1s,mu_xA,mu_yA,mu_zA,mu_WxA,mu_WyA,mu_WzA,lambda_i,MHAdim);
   
   [beta0_t1sp,beta1c_t1sp,beta1s_t1sp] = batimiento(theta0,theta1c,theta1s+delta_theta,mu_xA,mu_yA,mu_zA,mu_WxA,mu_WyA,mu_WzA,lambda_i,MHAdim);
   [beta0_t1sn,beta1c_t1sn,beta1s_t1sn] = batimiento(theta0,theta1c,theta1s-delta_theta,mu_xA,mu_yA,mu_zA,mu_WxA,mu_WyA,mu_WzA,lambda_i,MHAdim);
   
   beta1c_theta1c(j,i) = (beta1c_t1cp-beta1c_t1cn)/(2*delta_theta);
   beta1c_theta1s(j,i) = (beta1c_t1sp-beta1c_t1sn)/(2*delta_theta);
   beta1s_theta1c(j,i) = (beta1s_t1cp-beta1s_t1cn)/(2*delta_theta);
   beta1s_theta1s(j,i) = (beta1s_t1sp-beta1s_t1sn)/(2*delta_theta);
   
   beta0_theta1c(j,i) = (beta0_t1cp-beta0_t1cn)/(2*delta_theta);
   beta0_theta1s(j,i) = (beta0_t1sp-beta0_t1sn)/(2*delta_theta);

   
end
end


nota = 'RESULTADOS EN GRADOS'

theta_0 = theta_0*180/pi;       theta_1c = theta_1c*180/pi;             theta_1s = theta_1s*180/pi;
beta0 = beta0*180/pi;           beta1c = beta1c*180/pi;                 beta1s = beta1s*180/pi;
theta_0RA = theta_0RA*180/pi;   angulocabeceo = angulocabeceo*180/pi;   angulobalance = angulobalance*180/pi;


figure(1)
    subplot(2,2,1)
        plot(var,beta1c_theta1c)
        xlabel(variable1)
        ylabel('\partial \beta_1_C / \partial \theta_1_C','Rotation',90)
        legend([variable2,num2str(var2(1)),variable2dim],...
               [variable2,num2str(var2(2)),variable2dim],...
               [variable2,num2str(var2(3)),variable2dim])
    subplot(2,2,2)
        plot(var,beta1c_theta1s)
        xlabel(variable1)
        ylabel('\partial \beta_1_C / \partial \theta_1_S','Rotation',90)
        legend([variable2,num2str(var2(1)),variable2dim],...
               [variable2,num2str(var2(2)),variable2dim],...
               [variable2,num2str(var2(3)),variable2dim])
    subplot(2,2,3)
        plot(var,beta1s_theta1c)
        xlabel(variable1)
        ylabel('\partial \beta_1_S / \partial \theta_1_C','Rotation',90)
        legend([variable2,num2str(var2(1)),variable2dim],...
               [variable2,num2str(var2(2)),variable2dim],...
               [variable2,num2str(var2(3)),variable2dim])
    subplot(2,2,4)
        plot(var,beta1s_theta1s)
        xlabel(variable1)
        ylabel('\partial \beta_1_S / \partial \theta_1_S','Rotation',90)
        legend([variable2,num2str(var2(1)),variable2dim],...
               [variable2,num2str(var2(2)),variable2dim],...
               [variable2,num2str(var2(3)),variable2dim])

figure(2)
    subplot(2,2,1)
        plot(var,beta0_theta1c)
        xlabel(variable1)
        ylabel('\partial \beta_0 / \partial \theta_1_C','Rotation',90)
        legend([variable2,num2str(var2(1)),variable2dim],...
               [variable2,num2str(var2(2)),variable2dim],...
               [variable2,num2str(var2(3)),variable2dim])
           
    subplot(2,2,2)
        plot(var,beta0_theta1s)
        xlabel(variable1)
        ylabel('\partial \beta_0 / \partial \theta_1_S','Rotation',90)
        legend([variable2,num2str(var2(1)),variable2dim],...
               [variable2,num2str(var2(2)),variable2dim],...
               [variable2,num2str(var2(3)),variable2dim])
           
%Desvinculamos las carpetas del programa
path_unloader;