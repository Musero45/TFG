
%MUCHOS VALORES HAY QUE COMPROBARLOS, COGI LOS DE UN SEMEJANTE PARA PROBAR
%EL PROGRAMA.

% TIPO DE ANALISIS

% ASE: Fuerzas, Momento y Batimiento de Alberto Sergio y Elena
% Alvaro: Fuerzas, Momento y Batimiento de Alvaro
% Mixto: Momentos zA Alvaro, resto ASE
% Elastico: Modelo los momentos directos aerodin�micos con kbeta y
% e*xGB*Mp*Omega^2

% TCM: Teoria de Cantidad de Movimiento de Glauert.
% TCMCorr: Teoria de Cantidad de Movimiento de Glauert incrementada.
% TC2M: Teoria de Cantidad de Movimiento Modificada.
% TC2MCorr: Teoria de Cantidad de Movimiento Modificada incrementada.


%PARAMETROS GENERALES Y "M�SICOS" (EN Kg)
    MTOW = 9500;       EW = 5056;    %Kg
    PL = 4507;          FW = 2463;    %Kg

    PESO_referencia = MTOW*1; %Al que evaluaremos las actuaciones.
    altura = 000; %altitud sobre el nivel del mar
    
    %Posici�n del centro de gravedad, respecto los ejes fuselaje.
        XCG = 0;       YCG = 0;        ZCG = .0;

%DATOS DEL ROTOR PRINCIPAL

    AirfoilRP = @NACA63618CORRdat;
    
    OmegaRotor = 251*2*pi/60;
    b_rp = 4;                     %n� de palas;
    R_rp = 8.6;               %Radio del principal
    c_rp = 0.54;%0.59;                  %cuerda

    Ip = 1500;          %Momento principal de la pala
    e_rp = 0*0.035*R_rp;     %Excentricidad de la pala
    k_beta = 0*111000;
    Mp = 130;
    xGB = 3.2;

    theta1 = (-7*pi/180); %Torsion
    
    %posicionamiento respecto de los ejes fuselaje
        h_rp = 4.42/2.3;        %altura del arbol
        x = 0;                    %posici�n del origen
        y = 0;
        epsilon_x = 0*pi/180;   %desviaci�n angular
        epsilon_y = 0*pi/180;

%DATOS DEL ROTOR ANTIPAR

    AirfoilRA = @NACA63618CORRdat;

    OmegaAntipar = 1271*2*pi/60;
    b_ra = 4;             %n� de palas;
    R_ra = 3.371/2;       %Radio del antipar
    c_ra = 0.23;          %cuerda antipar

    theta1_ra = 0*pi/180; %Torsion(al final no se incluyo, pero esta preparado)
    e_ra = 0;            %no contemplado en el modelo de momento.
    
    %posicionamiento respecto de los ejes fuselaje
        lRAH = -10.26;                 %distancia seg�n eje X
        dRA = -0.3;                 %distancia seg�n eje Y (CAMBIADO ALVARO)
        lRAV = 2.00;%1.587;                 %distancia seg�n eje Z
        
        epsilon_ra = 0*pi/180;  %desviaci�n angular
    
%DATOS DEL FUSELAJE
    SP = 10;     %Superficie en planta
    SS = 22;     %Superficie lateral (m^2)

%DATOS DE LOS ESTABILIZADORES
    %Estabilizadores horizontales
    
    AirfoilEH = @NACA0012dat;
    
        Sestabhorizontal= 1.5;                 %Superficie de referencia.
        SDerecho = Sestabhorizontal*(2/4);       %Porcentaje de la total
        SIzquierdo = Sestabhorizontal*(2/4);  %(CAMBIADO ALVARO)
        c_eh = 0.7;       %Cuerda de los estabilizadores
        
        theta_ehi = -7*pi/180;     %�ngulos de calado
        theta_ehd = -1*pi/180;

        %posicionamiento respecto de los ejes fuselaje
            lEHH = -8.55;      %distancia seg�n eje X
            lEHV = 1.2;       %distancia seg�n eje Z

            dEHI = -0.3;        %distancia del origen, sgun eje Y
            dEHD = 0.3;

            %Distancias corregidas, para recoger el punto de aplicaci�n de la fuerza
            dEHI = dEHI - SIzquierdo/c_eh/2;
            dEHD = dEHD + SDerecho/c_eh/2;

    %Estabilizador vertical
    
    AirfoilEV = @NACA0012dat;
    
        SVertical = 1.4;          %Superficie del estabilizador
        c_ev = 1.0;             %cuerda
        theta_ev = 0*pi/180;    %�ngulo de calado

        %posicionamiento respecto de los ejes fuselaje
            
            lEVH = -4.19;          %distancia seg�n eje X
            lEVV = 0.5;           %distancia seg�n eje Z
            
            %Distancia corregida, para recoger el punto de aplicaci�n de la fuerza
            lEVV = lEVV + SVertical/c_ev/2;

%DATOS DEL MOTOR
    %Como depender� de la altura, y esta puede ir variando, decidi crear
    %una subrutina nueva,...comprobar que son los par�metros propios
    OmegaMotor = 21000;
    PMTO=[];
    PMC=[];


