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

nodos = 6 ;
var = linspace(50,75,nodos)/(R*Omega);

nodos2 = 5;
var2 = linspace(0,3000,nodos2);


for j=1:nodos2
for i=1:nodos
    
    V = var(i)*(R*Omega);
    variable1 = 'V_X_T (m/s)';  %Nombre de la variable en las gráficas
    gamma_T=0*pi/180;

    HM.altura = var2(j);
    variable2 = 'altura (m)'; %Nombre de la variable en las gráficas
    
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

    
    %Creación de una estructura con las fuerzas, momentos y velocidades inducidas.
    
    [Veloc] = Velocidades(MHAdim,mu_xT,mu_yT,mu_zT,mu_WxT,mu_WyT,mu_WzT,angulo_guinada0, angulo_cabeceo, angulo_balance);
    [salida] = fuerzas_trimado (MHAdim,Veloc,theta0,theta1c,theta1s,theta0_RA,angulo_guinada0,angulo_cabeceo,angulo_balance);
    
   
    potencia_RP(i) = salida.Potencia.RP;
    potencia_RA(i) = salida.Potencia.RA;
    potencia_fuselaje(i) = salida.Potencia.F;
    potencia_stabs(i) = salida.Potencia.E;
    
    
    [Motor] = power_plant(HM.altura);
    
    PMTO(i) = Motor.PMTO;
    PMC(i) = Motor.PMC;
    
    

end

    perdidas = 1.1;
    potencia_total = perdidas*(potencia_RP+potencia_RA)+potencia_fuselaje+potencia_stabs*1e-3;

    
    
    x = fminsearch(@(x) interp1(var*R*Omega,potencia_total,x,'spline'),[.3]);
    V_autonomia(j) = x;
    P_autonomia(j) = interp1(var*R*Omega,potencia_total,x,'spline');
    
    x = fminsearch(@(x) interp1(var*R*Omega,potencia_total./(var*R*Omega),x,'spline'),[.3]);
    V_alcance(j) = x;
    P_alcance(j) = interp1(var*R*Omega,potencia_total,x,'spline');

    
% [P_autonomia(j),Indice] = min(potencia_total);
% V_autonomia(j) = var(Indice)*(R*Omega);
% [temp,Indice2] = min(potencia_total./(var*(R*Omega)));
% V_alcance(j) = var(Indice2)*(R*Omega);
% P_alcance(j) = potencia_total(Indice2);


var = linspace(0.7*V_autonomia(j),1.5*V_alcance(j),nodos)/(R*Omega);
end


figure(1)
hold on
    plot(var2,V_autonomia,'r')
    plot(var2,V_alcance,'b')
 hold off   
        xlabel(variable2)
        ylabel(variable1,'Rotation',90)
        legend('máxima autonomía',...
               'máximo alcance')

figure(2)
hold on
    plot(var2,P_autonomia,'r')
    plot(var2,P_alcance,'b')
hold off   
        xlabel(variable2)
        ylabel('P (kW)','Rotation',90)
        legend('P_m_i_n',...
               'P_m_á_x_ _a_l_c_a_n_c_e')


% figure(4)
%     perdidas = 1.1;
%     potencia_total = (perdidas*(potencia_RP+potencia_RA)+potencia_fuselaje+potencia_stabs)*1e-3;
%     hold on
%         plot(var,potencia_total,'r')
%         plot(var,(PMTO)*1e-3,'r--')
%         plot(var,(PMC)*1e-3,'r:')
%     hold off
%         xlabel(variable1)
%         ylabel('Potencia (kW)','Rotation',90)
%         legend(['P_N_E_C (',variable2,num2str(var2(j)),')'],...
%                ['P_M_T_O (',variable2,num2str(var2(j)),')'],...
%                ['P_M_C (',variable2,num2str(var2(j)),')'])
%         axis([min(var) max(var) 0 1.1*max((perdidas*(potencia_RP+potencia_RA)+potencia_fuselaje)*1e-3)])
%Desvinculamos las carpetas del programa
path_unloader;