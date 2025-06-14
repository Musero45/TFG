function cmz = CMZF(alpha_F,beta_F,u)

%SACADA DE LA SIMPLIFICACION DEL PADFIELD
%según padfield para velocidad u>0 el momento es Cna
%para velocidad u<0 el momento es Cnb

if u>=0
    
    betaf = [-90 -70 -25 0 25 70 90]*pi/180;
    C_nfa = [-0.1 -0.1 0.005 0.0 -0.005 0.1 0.1];

    cmz = interp1 (betaf,C_nfa,beta_F);    
else
    betaf = [-90 -60 0 60 90]*pi/180;
    C_nfb = [-.1 -.1 .0 .1 .1];

    cmz = interp1 (betaf,C_nfb,beta_F);

end

    cmz = 0.1772*beta_F+0.7126*beta_F^3;


end