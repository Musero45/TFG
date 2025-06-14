%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%   CONFIGURADOR DE AN�LISIS
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%   MODELO DE ACCIONES
%
% ASE: Fuerzas, Momento y Batimiento de Alberto Sergio y Elena
% Alvaro: Fuerzas, Momento y Batimiento de Alvaro
% Mixto: Momentos zA Alvaro, resto ASE
% Elastico: Modelo los momentos directos aerodin�micos con kbeta y e*xGB*Mp*Omega^2

    %ModeloAcciones = 'ASE';
    %ModeloAcciones = 'Alvaro';
    %ModeloAcciones = 'AlvaroNL';
    ModeloAcciones = 'ElasticoNL';
    %ModeloAcciones = 'Mixto';
    %ModeloAcciones = 'Elastico';

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%   MODELO DE VELOCIDAD INDUCIDA
%
% TCM: Teoria de Cantidad de Movimiento de Glauert.
% TCMM: Teoria de Cantidad de Movimiento Modificada.



    FormuVelind = 'TCMM';

%   Constante de correccion rotor principal

    kiRP = 1;

%   Constante de correccion rotor antipar

    kiRA= 1.5;

    ModeloVelInducida = struct('FomulacionVelocidadInducida',FormuVelind,'ConsCorrRP',kiRP,'ConsCorrRA',kiRA);

%   Precision en fsolve

    Precisionfsolve = 10^-9;
    
%   M�ximo n�mero de iteraciones permitidas

    MaxIter = 25;

%   Generai�n de estructura de analisis

%   Constantes de afectaci�n de la estela del principal a los subsistemas

    % Antipar

        kRA = 0;

    %   Estabilizador horizontal izquierdo

        kEHI = 0;

    %   Estabilizador horizontal derecho

        kEHD = 0;

    %   Estabilizador vertical

        kEV = 0;
    
    %   Configuraci�n de an�lisis relativa al fuselaje
    
        %   Parametro amplificador de fuerzas del fuselaje
    
        kf = 1;
     
        %   Modelo de acciones fuselaje
        
            %   FusAcc = 'General';
            %   FusAcc = 'Puma';
              FusAcc = 'Bo105';
         
  % Hipoteisis FRP_ortogonal Plano Puntas
  
        HFROPP = 'SI';
        
        
    Analisis = struct('ModeloAcciones',ModeloAcciones,'ModeloVelInducida',ModeloVelInducida,...
        'kRA',kRA,'kEHI',kEHI,'kEHD',kEHD,'kEV',kEV,'Precision',Precisionfsolve,'NumeroMaxIter',...
        MaxIter,'HipotesisFRPOPP',HFROPP);
    
