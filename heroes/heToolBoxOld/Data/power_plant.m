function [Motor] = power_plant(altura)
    
    n_motores = 2;
    %ACTUACIONES DEL MOTOR DE ALBERTO
    
    %ACTUACIONES PARA ISA+0
        PMTO = 1609.6*exp(-9.45e-5*altura)*n_motores*1e3;
        PMC = 1411.5*exp(-9.45e-5*altura)*n_motores*1e3;
        
        SFC_pmto = 0.267;
        SFC_pmc = 0.282;
        
    %CREACIÓN DE LA ESTRUCTURA DE SALIDA
    
    Motor = struct('PMTO',PMTO,'PMC',PMC,'SFC_pmto',SFC_pmto,'SFC_pmc',SFC_pmc);


end