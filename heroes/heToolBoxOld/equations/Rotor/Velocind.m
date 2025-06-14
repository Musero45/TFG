function [CTinP,lambda_iP] = Velocind(MHAdim,beta1c,beta1s,...
    mu_xA,mu_yA,mu_zA,mu_WxA,mu_WyA,mu_WzA,CHinA,CYinA,CTinA,lambdao)

[TAfP]=cambioAfP(beta1c,beta1s,eye(3));
[TPfA]=cambioPfA(beta1c,beta1s,eye(3));


CTtempinP = TPfA*[CHinA; CYinA; CTinA];

CTinP = CTtempinP(3);
%CTinP = (abs(CTtempinP(3)));

mu_inP = TPfA*[mu_xA; mu_yA; mu_zA];
mu_xP = mu_inP(1); mu_yP = mu_inP(2); mu_zP = mu_inP(3);

mu_WinP = TPfA*[mu_WxA; mu_WyA; mu_WzA];
mu_WxP = mu_WinP(1); mu_WyP = mu_WinP(2); mu_WzP = mu_WinP(3);


%   Modelo de velocidad inducida

FomulacionVelocidadInducida = MHAdim.Analisis.ModeloVelInducida.FomulacionVelocidadInducida;
kiRP = MHAdim.Analisis.ModeloVelInducida.ConsCorrRP;

% TCM de Glauert

    if strcmp(FomulacionVelocidadInducida,'TCM')

    lambda_iP = fzero(@(lambda_i0) kiRP*CTinP-2*(-lambda_i0)*(((mu_xP+mu_WxP)^2+(mu_yP+mu_WyP)^2)+(mu_zP+mu_WzP+lambda_i0)^2)^(1/2),lambdao);

    elseif strcmp(FomulacionVelocidadInducida,'TCMM')

% TCM modificada

    lambda_iP = fzero(@(lambda_i0) kiRP*CTinP-(2/3)*(-lambda_i0)*(6*((mu_xP+mu_WxP)^2+(mu_yP+mu_WyP)^2)+(mu_zP+mu_WzP)^2+5*...
    (mu_zP+mu_WzP+lambda_i0)^2)^(1/2),lambdao);

    end

% lambda_i_in_A = TAfP*[0; 0; lambda_iP];

% lambda_i_in_A = lambda_iinA(3);

%TIENE ESA COMPONENTE SI LAS BETAS SON CERO.
%SE SUPONDRÁN ÁNGULOS PEQUEÑOS CREO...

% lambda_i_in_F = TFfA*[0; 0; lambda_i_inA(3)];

end