function [k_lambdaF,k_lambdaEHI,k_lambdaEHD,k_lambdaEV] = versores_lambdai (MHAdim,beta1c,beta1s)

%Carga de los parámetros geométricos necesarios
    epsilon_x = MHAdim.epsilon_x;
    epsilon_y = MHAdim.epsilon_y;

    epsilon_ra = MHAdim.epsilon_ra;

%Creación de las matrices de cambio
%     [TAF] = cambioAfF(epsilon_x,epsilon_y,eye(3));
    [TFfA] = cambioFfA(epsilon_x,epsilon_y,eye(3));
    
    [TAfP] = cambioAfP(beta1c,beta1s,eye(3));

     [TEHIfF] = cambioEHIfF(eye(3));
     [TEHDfF] = cambioEHDfF(eye(3));

     [TEVfF] = cambioEVfF(eye(3));

%     [TARAF] = cambioARAfF(epsilon_ra,eye(3));
     [TFfARA] = cambioFfARA(epsilon_ra,eye(3));
     [TARAfP] = cambioAfP(0,0,eye(3));
     
     
%Cálculo del cambio de componente
    k_lambdaF = TFfA*TAfP*[0; 0; 1];
    k_lambdaEHI = TEHIfF*TFfA*TAfP*[0; 0; 1];
    k_lambdaEHD = TEHDfF*TFfA*TAfP*[0; 0; 1];
    k_lambdaEV = TEVfF*TFfARA*TARAfP*[0; 0; 1];


















end