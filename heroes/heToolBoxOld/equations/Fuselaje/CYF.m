function cdy = CYF(alpha_F,beta_F,MHAdim)

%SACADA DE LA SIMPLIFICACION DEL PADFIELD
%ESTA NO LA ENCUENTRO

%SACADA DE LA SIMPLIFICACION DEL PADFIELD

if (beta_F < -20*pi/180) 

cdy = 0.52347589;

elseif (beta_F > 20*pi/180)

cdy = -0.52347589;    
    
else

cdy = (-6.9-2399.0*beta_F-1.7*beta_F^2+12.7*beta_F^3)/((1/2)*1.225*30.48^2*10);

end