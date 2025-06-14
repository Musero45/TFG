function cdz = CZF(alpha_F,beta_F,MHAdim)

%SACADA DE LA SIMPLIFICACION DEL PADFIELD
%ESTA NO LA ENCUENTRO

FusAcc = MHAdim.Fuselaje.ModeloAcciones;

if strcmp(FusAcc,'General') 

    alfa_f = [-180 -160 -120 -60 -20 0 20 60 120 160 180]*pi/180;
    C_zf = [.0 .15 1.3 1.3 .15 .0 -.15 -1.3 -1.3 -.15 -0];
 
    cdz = interp1 (alfa_f,C_zf,alpha_F);

elseif strcmp(FusAcc,'Bo105')    
    
    if (alpha_F < -20*pi/180  | alpha_F > 20*pi/180)

        alfa_f = [-180 -160 -120 -60 -20 0 20 60 120 160 180]*pi/180;
        C_zf = [.0 .15 1.3 1.3 .15 .0 -.15 -1.3 -1.3 -.15 -0];
 
        cdz = interp1 (alfa_f,C_zf,alpha_F);
    else

        cdz = -0.0160-0.3775*alpha_F+0.4760*alpha_F^2-0.1897*alpha_F^3;

    end
    
elseif strcmp(FusAcc,'Puma')    
    
    if (alpha_F < -20*pi/180  | alpha_F > 20*pi/180)

        alfa_f = [-180 -160 -120 -60 -20 0 20 60 120 160 180]*pi/180;
        C_zf = [.0 .15 1.3 1.3 .15 .0 -.15 -1.3 -1.3 -.15 -0];
 
        cdz = interp1 (alfa_f,C_zf,alpha_F);
   
    else    
    
    cdz = -0.0809-1.0059*alpha_F+0.3670*alpha_F^2-0.6994*alpha_F^3;

    end
    
end