function F = trimado (incog, MHAdim,mu_xT, mu_yT, mu_zT, mu_WxT,mu_WyT,mu_WzT, angulo_guinada)

%Asignación de las incógnitas de solución.
theta0 = incog(1);   theta1c = incog(2); theta1s = incog(3);
theta0_RA = incog(4); angulo_cabeceo = npi2pi(incog(5),'rad'); angulo_balance = npi2pi(incog(6),'rad');

[Veloc] = Velocidades(MHAdim, mu_xT,mu_yT,mu_zT,mu_WxT,mu_WyT,mu_WzT,angulo_guinada, angulo_cabeceo, angulo_balance);

%Asignación de las velocidades.
mu_xA = Veloc.A.mu_xA;      mu_yA = Veloc.A.mu_yA;      mu_zA = Veloc.A.mu_zA;
mu_WxA = Veloc.A.mu_WxA;    mu_WyA = Veloc.A.mu_WyA;    mu_WzA = Veloc.A.mu_WzA;

mu_xAra = Veloc.ARA.mu_xARA;    mu_yAra = Veloc.ARA.mu_yARA;    mu_zAra = Veloc.ARA.mu_zARA;
mu_WxAra = Veloc.ARA.mu_WxARA;  mu_WyAra = Veloc.ARA.mu_WyARA;  mu_WzAra = Veloc.ARA.mu_WzARA;

mu_xF = Veloc.F.mu_xF;      mu_yF = Veloc.F.mu_yF;      mu_zF = Veloc.F.mu_zF;
mu_WxF = Veloc.F.mu_WxF;    mu_WyF = Veloc.F.mu_WyF;    mu_WzF = Veloc.F.mu_WzF;

mu_xEHI = Veloc.EHI.mu_xEHI;    mu_yEHI = Veloc.EHI.mu_yEHI;    mu_zEHI = Veloc.EHI.mu_zEHI;
mu_WxEHI = Veloc.EHI.mu_WxEHI;  mu_WyEHI = Veloc.EHI.mu_WyEHI;  mu_WzEHI = Veloc.EHI.mu_WzEHI;

mu_xEHD = Veloc.EHD.mu_xEHD;    mu_yEHD = Veloc.EHD.mu_yEHD;    mu_zEHD = Veloc.EHD.mu_zEHD;
mu_WxEHD = Veloc.EHD.mu_WxEHD;  mu_WyEHD = Veloc.EHD.mu_WyEHD;  mu_WzEHD = Veloc.EHD.mu_WzEHD;

mu_xEV = Veloc.EV.mu_xEV;    mu_yEV = Veloc.EV.mu_yEV;    mu_zEV = Veloc.EV.mu_zEV;
mu_WxEV = Veloc.EV.mu_WxEV;  mu_WyEV = Veloc.EV.mu_WyEV;  mu_WzEV = Veloc.EV.mu_WzEV;

lambda_0=-.001;

%Brazos adimensionales para los momentos
    x_cg = MHAdim.Brazos.CDG.x_cg;      y_cg = MHAdim.Brazos.CDG.y_cg;      z_cg = MHAdim.Brazos.CDG.z_cg;
    dx_ad = MHAdim.Brazos.R.dx_ad;      dy_ad = MHAdim.Brazos.R.dy_ad;      h_ad = MHAdim.Brazos.R.h_ad;
    lRAH_ad = MHAdim.Brazos.RA.lRAH_ad; lRAV_ad = MHAdim.Brazos.RA.lRAV_ad; dRA_ad = MHAdim.Brazos.RA.dRA_ad;
    lEHH_ad = MHAdim.Brazos.EH.lEHH_ad; lEHV_ad = MHAdim.Brazos.EH.lEHV_ad;
    dEHD_ad = MHAdim.Brazos.EH.dEHD_ad; dEHI_ad = MHAdim.Brazos.EH.dEHI_ad;
    lEVH_ad = MHAdim.Brazos.EV.lEVH_ad; lEVV_ad = MHAdim.Brazos.EV.lEVV_ad;
    
    
%Fuerza de gravedad
    [CX_ginF, CY_ginF, CZ_ginF] = fza_gravedad (MHAdim, angulo_guinada, angulo_cabeceo, angulo_balance);

%Solución del sistema del rotor principal
    
    options = optimset('Display','off','TolFun',10^-6);

    x = fsolve(@(x) systemPala(x,MHAdim,theta0,theta1c,theta1s,mu_xA,mu_yA,mu_zA,mu_WxA,mu_WyA,mu_WzA,lambda_0),...
        [0.3; 0.1; -0.1; -.03;1e-5],options);
    
    beta0 = x(1);   beta1c = x(2);  beta1s = x(3); lambda_iP = x(4);

    [CHinA,CYinA,CTinA] = fza_rotor(MHAdim,theta0,theta1c,theta1s,beta0,beta1c,beta1s,lambda_iP,...
        mu_xA,mu_yA,mu_zA,mu_WxA,mu_WyA,mu_WzA);
    
    [CMHinA,CMYinA,CMTinA,CMRalter] = momento_rotor(MHAdim,theta0,theta1c,theta1s,beta0,beta1c,beta1s,...
        lambda_iP,mu_xA,mu_yA,mu_zA,mu_WxA,mu_WyA,mu_WzA);

%SOLUCIÓN DEL ANTIPAR.
    %Para calcularla pasamos a la adimensionalización del antipar
        Omega_ra = MHAdim.Pala_RA.Omega;    Omega = MHAdim.Pala_RP.Omega;
        Rra = MHAdim.Pala_RA.R;             R = MHAdim.Pala_RP.R;

        mu_xAra_ra = mu_xAra*(Omega*R)/(Omega_ra*Rra);
        mu_yAra_ra = mu_yAra*(Omega*R)/(Omega_ra*Rra);
        mu_zAra_ra = mu_zAra*(Omega*R)/(Omega_ra*Rra);
        mu_WxAra_ra = mu_WxAra*(Omega*R)/(Omega_ra*Rra);
        mu_WyAra_ra = mu_WyAra*(Omega*R)/(Omega_ra*Rra);
        mu_WzAra_ra = mu_WzAra*(Omega*R)/(Omega_ra*Rra);

        %     mu_xAra_ra = mu_xAra;    mu_yAra_ra = mu_yAra;
        %     mu_zAra_ra = mu_zAra;    mu_WxAra_ra = mu_WxAra;
        %     mu_WyAra_ra = mu_WyAra;  mu_WzAra_ra = mu_WzAra;

    %Planteamiento del sistema de ecuaciones en los ejes y variables del antipar
    
    y = fsolve(@(y) systemAntipar(y,MHAdim,theta0_RA,mu_xAra_ra,mu_yAra_ra,mu_zAra_ra,...
                        mu_WxAra_ra,mu_WyAra_ra,mu_WzAra_ra,lambda_0), [-.3;1e-5],options);
    lambda_iPRA = y(1);

    [CH_rainARA,CY_rainARA,CT_rainARA] = fza_antipar(MHAdim,theta0_RA,lambda_iPRA,mu_xAra_ra,mu_yAra_ra,mu_zAra_ra,...
                        mu_WxAra_ra,mu_WyAra_ra,mu_WzAra_ra);
    [CMH_rainARA,CMY_rainARA,CMT_rainARA] = momento_antipar(MHAdim,theta0_RA,lambda_iPRA,mu_xAra_ra,mu_yAra_ra,mu_zAra_ra,...
                        mu_WxAra_ra,mu_WyAra_ra,mu_WzAra_ra);

    %Ojo, estaba adimensionalizado con el propio antipar.
    %DEVOLVEMOS A LAS VARIABLES DEL ROTOR PRINCIPAL PARA REALIZAR EL TRIMADO

        CH_ra2inARA = CH_rainARA/(R^4*Omega^2)*(Rra^4*Omega_ra^2);
        CY_ra2inARA = CY_rainARA/(R^4*Omega^2)*(Rra^4*Omega_ra^2);
        CT_ra2inARA = CT_rainARA/(R^4*Omega^2)*(Rra^4*Omega_ra^2);
        CMH_ra2inARA = CMH_rainARA/(R^5*Omega^2)*(Rra^5*Omega_ra^2);
        CMY_ra2inARA = CMY_rainARA/(R^5*Omega^2)*(Rra^5*Omega_ra^2);
        CMT_ra2inARA = CMT_rainARA/(R^5*Omega^2)*(Rra^5*Omega_ra^2);
        lambda_iPRA = lambda_iPRA/(R*Omega)*(Rra*Omega_ra);

        %     CH_ra2 = CH_ra;     CY_ra2 = CY_ra;     CT_ra2 = CT_ra;
        %     CMH_ra2 = CMH_ra;   CMY_ra2 = CMY_ra;   CMT_ra2 = CMT_ra;

%CÁLCULO DEL CAMBIO DE EJES DE LA VELOCIDAD INDUCIDA EN CADA ELEMENTO    
	[k_lambdaF,k_lambdaEHI,k_lambdaEHD,k_lambdaEV] = versores_lambdai (MHAdim,beta1c,beta1s);
    
    
%Solución de fuselaje
    [CD_XFinF,CD_YFinF,CD_ZFinF,alpha_F,beta_F] = fza_fuselaje(MHAdim,k_lambdaF,mu_xF,mu_yF,mu_zF,mu_WxF,mu_WyF,mu_WzF,lambda_iP);
    [CM_FXinF,CM_FYinF,CM_FZinF] = momento_fuselaje(MHAdim,k_lambdaF,mu_xF,mu_yF,mu_zF,mu_WxF,mu_WyF,mu_WzF,lambda_iP);

%Soluciones de los estabilizadores
    [C_XEHIinEHI,C_YEHIinEHI,C_ZEHIinEHI,phi_EHI,alpha_EHI,CD_EHI,CL_EHI] = fza_eh_izquierdo(MHAdim,k_lambdaEHI,mu_xEHI,mu_yEHI,mu_zEHI,mu_WxEHI,mu_WyEHI,mu_WzEHI,lambda_iP);
    [C_XEHDinEHD,C_YEHDinEHD,C_ZEHDinEHD,phi_EHD,alpha_EHD,CD_EHD,CL_EHD] = fza_eh_derecho(MHAdim,k_lambdaEHD,mu_xEHD,mu_yEHD,mu_zEHD,mu_WxEHD,mu_WyEHD,mu_WzEHD,lambda_iP);
    [C_XEVinEV,C_YEVinEV,C_ZEVinEV,phi_EV,alpha_EV,CD_EV,CL_EV] = fza_e_vertical(MHAdim,k_lambdaEV,mu_xEV,mu_yEV,mu_zEV,mu_WxEV,mu_WyEV,mu_WzEV,lambda_iPRA);

    [C_MXEHIinEHI,C_MYEHIinEHI,C_MZEHIinEHI] = momento_eh_izquierdo(MHAdim,k_lambdaEHI,mu_xEHI,mu_yEHI,mu_zEHI,mu_WxEHI,mu_WyEHI,mu_WzEHI,lambda_iP);
    [C_MXEHDinEHD,C_MYEHDinEHD,C_MZEHDinEHD] = momento_eh_derecho(MHAdim,k_lambdaEHD,mu_xEHD,mu_yEHD,mu_zEHD,mu_WxEHD,mu_WyEHD,mu_WzEHD,lambda_iP);
    [C_MXEVinEV,C_MYEVinEV,C_MZEVinEV] = momento_e_vertical(MHAdim,k_lambdaEV,mu_xEV,mu_yEV,mu_zEV,mu_WxEV,mu_WyEV,mu_WzEV,lambda_iPRA);

    
    
%CAMBIO DE BASE DE LAS COMPONENTES DE LAS FUERZAS Y MOMENTOS
    epsilon_x = MHAdim.epsilon_x;
    epsilon_y = MHAdim.epsilon_y;
    epsilon_RA = MHAdim.epsilon_ra;

    [TFfA] = cambioFfA(epsilon_x,epsilon_y,eye(3));
    [TFfARA] = cambioFfARA(epsilon_RA,eye(3));
    [TFfEHI] = cambioFfEHI(eye(3));
    [TFfEHD] = cambioFfEHD(eye(3));
    [TFfEV] = cambioFfEV(eye(3));

    CF_RPinF = TFfA*[CHinA;CYinA;CTinA];
    CHinF = CF_RPinF(1);    CYinF = CF_RPinF(2);    CTinF = CF_RPinF(3);
            CM_RPinF = TFfA*[CMHinA;CMYinA;CMTinA];
            CM_RPXinF = CM_RPinF(1);   CM_RPYinF = CM_RPinF(2);   CM_RPZinF = CM_RPinF(3);
    
    CF_RAinF = TFfARA*[CH_ra2inARA;CY_ra2inARA;CT_ra2inARA];
    CF_RAXinF = CF_RAinF(1); CF_RAYinF = CF_RAinF(2); CF_RAZinF = CF_RAinF(3);
            CM_RAinF = TFfARA*[CMH_ra2inARA;CMY_ra2inARA;CMT_ra2inARA];
            CM_RAXinF = CM_RAinF(1); CM_RAYinF = CM_RAinF(2); CM_RAZinF = CM_RAinF(3);

    CF_EHIinF = TFfEHI*[C_XEHIinEHI;C_YEHIinEHI;C_ZEHIinEHI];
    CF_XEHIinF = CF_EHIinF(1); CF_YEHIinF = CF_EHIinF(2); CF_ZEHIinF = CF_EHIinF(3);
            CM_EHIinF = TFfEHI*[C_MXEHIinEHI;C_MYEHIinEHI;C_MZEHIinEHI];
            CM_EHIXinF = CM_EHIinF(1); CM_EHIYinF = CM_EHIinF(2); CM_EHIZinF = CM_EHIinF(3);
    
    CF_EHDinF = TFfEHD*[C_XEHDinEHD;C_YEHDinEHD;C_ZEHDinEHD];
    CF_XEHDinF = CF_EHDinF(1); CF_YEHDinF = CF_EHDinF(2); CF_ZEHDinF = CF_EHDinF(3);
            CM_EHDinF = TFfEHD*[C_MXEHDinEHD;C_MYEHDinEHD;C_MZEHDinEHD];
            CM_EHDXinF = CM_EHDinF(1); CM_EHDYinF = CM_EHDinF(2); CM_EHDZinF = CM_EHDinF(3);
    
    CF_EVinF = TFfEV*[C_XEVinEV;C_YEVinEV;C_ZEVinEV];
    CF_XEVinF = CF_EVinF(1); CF_YEVinF = CF_EVinF(2); CF_ZEVinF = CF_EVinF(3);
            CM_EVinF = TFfEV*[C_MXEVinEV;C_MYEVinEV;C_MZEVinEV];
            CM_EVXinF = CM_EVinF(1); CM_EVYinF = CM_EVinF(2); CM_EVZinF = CM_EVinF(3);
    
%Suma de fuerzas
    F(1) = CX_ginF+CHinF+CF_RAXinF+CD_XFinF+CF_XEHIinF+CF_XEHDinF+CF_XEVinF;%;
    F(2) = CY_ginF+CYinF+CF_RAYinF+CD_YFinF+CF_YEHIinF+CF_YEHDinF+CF_YEVinF;%;
    F(3) = CZ_ginF+CTinF+CF_RAZinF+CD_ZFinF+CF_ZEHIinF+CF_ZEHDinF+CF_ZEVinF;%;

    
    
%Ecuaciones de momentos

%SIMPLFICACIÓN
%     F(4) =  CM_RPXinF + ...
%             CM_RAXinF;% + ...
%     F(5) = CM_RPYinF + ...
%            CM_RAYinF;% - ...
%     F(6) = CM_RPZinF + ...
%            (-x_cg-lRAH_ad)*CF_RAYinF;%

%SISTEMA COMPLETO ASE
     
%     F(4) =  (-y_cg-h_ad*sin(epsilon_x)+dy_ad)*CTinF + (z_cg+h_ad*cos(epsilon_y)*cos(epsilon_x))*CYinF + CM_RPXinF + ...
%             (z_cg+lRAV_ad)*CF_RAYinF + (-y_cg+dRA_ad)*CF_RAZinF + CM_RAXinF + ...
%             z_cg*CD_YFinF - y_cg*CD_ZFinF + CM_FXinF +...
%             (z_cg+lEHV_ad)*CF_YEHIinF + (-y_cg+dEHI_ad)*CF_ZEHIinF + CM_EHIXinF + ...
%             (z_cg+lEHV_ad)*CF_YEHDinF + (-y_cg-dEHD_ad)*CF_ZEHDinF + CM_EHDXinF + ...
%             (z_cg+lEVV_ad)*CF_YEVinF - y_cg*CF_ZEVinF + CM_EVXinF;%;
% 
%     F(5) = (-z_cg-h_ad*cos(epsilon_y)*cos(epsilon_x))*CHinF + (x_cg-dx_ad+h_ad*sin(epsilon_y)*cos(epsilon_x))*CTinF + CM_RPYinF + ...
%            (-z_cg-lRAV_ad)*CF_RAXinF + (x_cg+lRAH_ad)*CF_RAZinF + CM_RAYinF - ...
%             z_cg*CD_XFinF + x_cg*CD_ZFinF + CM_FYinF + ...
%            (-z_cg-lEHV_ad)*CF_XEHIinF + (x_cg+lEHH_ad)*CF_ZEHIinF + CM_EHIYinF + ...
%            (-z_cg-lEHV_ad)*CF_XEHDinF + (x_cg+lEHH_ad)*CF_ZEHDinF + CM_EHDYinF + ...
%            (-z_cg-lEVV_ad)*CF_XEVinF + (x_cg+lEVH_ad)*CF_ZEVinF + CM_EVYinF;%;
% 
%     F(6) = (y_cg-dy_ad+h_ad*sin(epsilon_x))*CHinF + (-x_cg+dx_ad-h_ad*sin(epsilon_y)*cos(epsilon_x))*CYinF + CM_RPZinF + ...
%            (-dRA_ad+y_cg)*CF_RAXinF + (-x_cg-lRAH_ad)*CF_RAYinF + CM_RAZinF + ...
%             y_cg*CD_XFinF - x_cg*CD_YFinF + CM_FZinF + ...
%            (-dEHI_ad+y_cg)*CF_XEHIinF + (-x_cg-lEHH_ad)*CF_YEHIinF + CM_EHIZinF + ...
%            (y_cg+dEHD_ad)*CF_XEHDinF + (-x_cg-lEHH_ad)*CF_YEHDinF + CM_EHDZinF + ...
%             y_cg*CF_XEVinF + (-x_cg-lEVH_ad)*CF_YEVinF + CM_EVZinF;%;
%  
 
        %SISTEMA COMPLETO ALVARO
        
        
 F(4) =  (-y_cg+dy_ad-sin(epsilon_x)*h_ad)*CTinF-(-z_cg-cos(epsilon_x)*cos(epsilon_y)*h_ad)*CYinF+CM_RPXinF+...
(-y_cg+dRA_ad)*CF_RAZinF-(-z_cg+lRAV_ad)*CF_RAYinF+CM_RAXinF + ...
-y_cg*CD_ZFinF+z_cg*CD_YFinF+CM_FXinF+...
(-y_cg+dEHI_ad)*CF_ZEHIinF-(-z_cg+lEVH_ad)*CF_YEHIinF+CM_EHIXinF+...
(-y_cg+dEHD_ad)*CF_ZEHDinF-(-z_cg+lEHV_ad)*CF_YEHDinF+CM_EHDXinF+...
-y_cg*CF_ZEVinF-(-z_cg+lEVV_ad)*CF_YEVinF+CM_EVXinF;



F(5) =  (-z_cg-cos(epsilon_x)*cos(epsilon_y)*h_ad)*CHinF-(-x_cg+dx_ad-cos(epsilon_x)*sin(epsilon_y)*h_ad)*CTinF+CM_RPYinF+...
(-z_cg+lRAV_ad)*CF_RAXinF-(-x_cg+lRAH_ad)*CF_RAZinF+CM_RAYinF+...
-z_cg*CD_XFinF+x_cg*CD_ZFinF+CM_FYinF+...
(-z_cg+lEVH_ad)*CF_XEHIinF-(-x_cg+lEHH_ad)*CF_ZEHIinF+CM_EHIYinF+...
(-z_cg+lEHV_ad)*CF_XEHDinF-(-x_cg+lEHH_ad)*CF_ZEHDinF+CM_EHDYinF+...
(-z_cg+lEVV_ad)*CF_XEVinF-(-x_cg+lEVH_ad)*CF_ZEVinF+CM_EVYinF;



F(6) =  (-x_cg+dx_ad-cos(epsilon_x)*sin(epsilon_y)*h_ad)*CYinF-(-y_cg+dy_ad-sin(epsilon_x)*h_ad)*CHinF+CM_RPZinF+...
(-x_cg+lRAH_ad)*CF_RAYinF-(-y_cg+dRA_ad)*CF_RAXinF+CM_RAZinF+...
-x_cg*CD_YFinF+y_cg*CD_XFinF+CM_FZinF+...
(-x_cg+lEHH_ad)*CF_YEHIinF-(-y_cg+dEHI_ad)*CF_XEHIinF+CM_EHIZinF+...
(-x_cg+lEHH_ad)*CF_YEHDinF-(-y_cg+dEHD_ad)*CF_XEHDinF+CM_EHDZinF+...
(-x_cg+lEVH_ad)*CF_YEVinF+y_cg*CF_XEVinF+CM_EVZinF;

  
        
        
    ResF = [F(1);F(2);F(3)];
    ResM = [F(4);F(5);F(6)];
    
    

%MOMENTOS SIN TENER EN CUENTA EPSILON X E Y

% F(4) = (-y_cg+dy_ad)*CTinF+(z_cg+h_ad)*CYinF+z_cg*CD_YFinF-y_cg*CD_ZFinF+(z_cg+lRAV_ad)*CF_RAYinF+(-y_cg+dRA_ad)*CF_RAZinF+(z_cg+lEHV_ad)*CF_YEHDinF+(z_cg+lEHV_ad)*CF_YEHIinF+(z_cg+lEVV_ad)*CF_YEVinF+(-y_cg-dEHD_ad)*CF_ZEHDinF+(-y_cg+dEHI_ad)*CF_ZEHIinF+CM_RPXinF-y_cg*CF_ZEVinF+CM_EHDXinF+CM_EVXinF+CM_RAXinF+CM_EHIXinF+CM_FXinF;
% F(5) = (-z_cg-h_ad)*CHinF+(x_cg-dx_ad)*CTinF-z_cg*CD_XFinF+x_cg*CD_ZFinF+(-z_cg-lRAV_ad)*CF_RAXinF+(x_cg+lRAH_ad)*CF_RAZinF+(-z_cg-lEHV_ad)*CF_XEHDinF+(-z_cg-lEHV_ad)*CF_XEHIinF+(-z_cg-lEVV_ad)*CF_XEVinF+(x_cg+lEHH_ad)*CF_ZEHDinF+(x_cg+lEHH_ad)*CF_ZEHIinF+(x_cg+lEVH_ad)*CF_ZEVinF+CM_RPYinF+CM_EHIYinF+CM_FYinF+CM_EHDYinF+CM_EVYinF+CM_RAYinF;
% F(6) = (y_cg-dy_ad)*CHinF+(-x_cg+dx_ad)*CYinF+y_cg*CD_XFinF-x_cg*CD_YFinF+(-dRA_ad+y_cg)*CF_RAXinF+(-x_cg-lRAH_ad)*CF_RAYinF+(y_cg+dEHD_ad)*CF_XEHDinF+(-dEHI_ad+y_cg)*CF_XEHIinF+y_cg*CF_XEVinF+(-x_cg-lEHH_ad)*CF_YEHDinF+(-x_cg-lEHH_ad)*CF_YEHIinF+(-x_cg-lEVH_ad)*CF_YEVinF+CM_RPZinF+CM_EHIZinF+CM_RAZinF+CM_EHDZinF+CM_FZinF+CM_EVZinF;




end