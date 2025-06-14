function cdx = CXF(alpha_F,beta_F,MHAdim)

%ATENCIÓN MODIFICAR PARA QUE VALGA PARA TODO EL RANGO DE ÁNGULOS DE ATAQUE

%SACADA DE LA SIMPLIFICACION DEL PADFIELD

%ESTAN TOTALMENTE MINUSVALORADAS He añadido el 3 para que a 0 grados
%f=Sp*C_xf=2.4

FusAcc = MHAdim.Fuselaje.ModeloAcciones;

if strcmp(FusAcc,'General') 

    alfa_f = [-180 -160 -90 -30 0 20 90 160 180]*pi/180;
    C_xf = [.1 .08 .0 -.07 -1.25*.08 -.07 .0 .08 .1];

    cdx = interp1 (alfa_f,C_xf,alpha_F);
    
elseif strcmp(FusAcc,'Bo105')
    
    if (alpha_F < -20*pi/180  | alpha_F > 20*pi/180)
    
    alfa_f = [-180 -160 -90 -30 0 20 90 160 180]*pi/180;
    C_xf = [.1 .08 .0 -.07 -1.25*.08 -.07 .0 .08 .1];

    cdx = interp1 (alfa_f,C_xf,alpha_F); 

    else

    cdx = -0.1822-0.0891*alpha_F+0.0012*alpha_F^2+0.9124*alpha_F^3;
    
    end
        
elseif strcmp(FusAcc,'Puma')      

    if (alpha_F < -20*pi/180  | alpha_F > 20*pi/180)
    
    alfa_f = [-180 -160 -90 -30 0 20 90 160 180]*pi/180;
    C_xf = [.1 .08 .0 -.07 -1.25*.08 -.07 .0 .08 .1];

    cdx = interp1 (alfa_f,C_xf,alpha_F); 

    else
    
    cdx = -0.2326+0.0079*alpha_F+0.1611*alpha_F^2+0.2939*alpha_F^3;
    
    end

end