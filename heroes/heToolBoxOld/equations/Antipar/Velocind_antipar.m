function [CTinP,lambda_iPRA] = Velocind_antipar(MHAdim,beta1c,beta1s,...
    mu_xAra,mu_yAra,mu_zAra,mu_WxAra,mu_WyAra,mu_WzAra,CH_rainARA,CY_rainARA,CT_rainARA,lambdao)



epsilon_RA = MHAdim.epsilon_ra;


%OJO, APAÑO EXTRAÑO PARA NO TENER QUE SEGUIR PENSADO


%CTinP = (abs(CT_rainARA));
CTinP = CT_rainARA;


FomulacionVelocidadInducida = MHAdim.Analisis.ModeloVelInducida.FomulacionVelocidadInducida;
kiRA = MHAdim.Analisis.ModeloVelInducida.ConsCorrRA;


% TCM de Glauert

    if strcmp(FomulacionVelocidadInducida,'TCM')
        
    lambda_iPRA = fzero(@(lambda_i0) kiRA*CTinP-2*(-lambda_i0)*(((mu_xAra+mu_WxAra)^2+(mu_yAra+mu_WyAra)^2)+...
        (mu_zAra+mu_WzAra+lambda_i0)^2)^(1/2),lambdao);

    elseif strcmp(FomulacionVelocidadInducida,'TCMM')

% TCM modificada

    lambda_iPRA = fzero(@(lambda_i0) kiRA*CTinP-(2/3)*(-lambda_i0)*(6*((mu_xAra+mu_WxAra)^2+(mu_yAra+mu_WyAra)^2)+...
    (mu_zAra+mu_WzAra)^2+5*(mu_zAra+mu_WzAra+lambda_i0)^2)^(1/2),lambdao);

    end



% lambda_ira_inARA = TARAfP*[0; 0; lambda_iPRA];
% lambda_ira_inARA = lambda_i_inARA(3);

%TIENE ESA COMPONENTE SI LAS BETAS SON CERO.
%SE SUPONDRÁN ÁNGULOS PEQUEÑOS CREO...

%lambda_ira_inF = TFfARA*[0; 0; lambda_i_inARA(3)];

end