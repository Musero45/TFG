function cmy = CMYF(alpha_F,beta_F)

%SACADA DE LA SIMPLIFICACION DEL PADFIELD


 if (alpha_F < 1000*pi/180  | alpha_F > -1000*pi/180)

alfa_f = [-205 -160 -130 -60 -25 25 60 130 155 200]*pi/180;
C_mf = [.02 -.03 .1 .1 -.04 .02 -.1 -.1 .02 -.03];

cmy = interp1 (alfa_f,C_mf,alpha_F);

 else
% 
 cmy = -0.0171+0.1404*alpha_F+0.2003*alpha_F^2-0.1611*alpha_F^3;
% % 
% % %cmy=cmy*alpha_F;
% % 
 end
 
 