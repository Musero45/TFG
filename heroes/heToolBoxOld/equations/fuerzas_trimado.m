function [salida,TablaAcciones] = fuerzas_trimado (MHAdim,Veloc,theta0,theta1c,theta1s,theta0_RA,...
    angulo_guinada,angulo_cabeceo,angulo_balance)

    Omega_ra = MHAdim.Pala_RA.Omega;    Omega = MHAdim.Pala_RP.Omega;
    Rra = MHAdim.Pala_RA.R;             R = MHAdim.Pala_RP.R;
    rho = MHAdim.rho;

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
    options = optimset('fsolve');
    options = optimset(options,'Display','off');

    x = fsolve(@(x) systemPala(x,MHAdim,theta0,theta1c,theta1s,mu_xA,mu_yA,mu_zA,mu_WxA,mu_WyA,mu_WzA,lambda_0), [0.01; 0; 0; -.3;1e-4],options);
    beta0 = x(1);   beta1c = x(2);  beta1s = x(3); lambda_iP = x(4);

    [CHinA,CYinA,CTinA] = fza_rotor(MHAdim,theta0,theta1c,theta1s,beta0,beta1c,beta1s,lambda_iP,mu_xA,mu_yA,mu_zA,mu_WxA,mu_WyA,mu_WzA);
    [CMHinA,CMYinA,CMTinA,CMRalter] = momento_rotor(MHAdim,theta0,theta1c,theta1s,beta0,beta1c,beta1s,lambda_iP,mu_xA,mu_yA,mu_zA,mu_WxA,mu_WyA,mu_WzA);
    
    
%SOLUCIÓN DEL ANTIPAR.
    %Para calcularla pasamos a la adimensionalización del antipar

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
                        mu_WxAra_ra,mu_WyAra_ra,mu_WzAra_ra,lambda_0), [-.3;1e-4],options);
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
    [C_XEHIinEHI,C_YEHIinEHI,C_ZEHIinEHI,phi_EHI,alpha_EHI,CD_EHI,CL_EHI] = fza_eh_izquierdo(MHAdim,k_lambdaEHI,mu_xEHI,...
        mu_yEHI,mu_zEHI,mu_WxEHI,mu_WyEHI,mu_WzEHI,lambda_iP);
    
    [C_XEHDinEHD,C_YEHDinEHD,C_ZEHDinEHD,phi_EHD,alpha_EHD,CD_EHD,CL_EHD] = fza_eh_derecho(MHAdim,k_lambdaEHD,mu_xEHD,...
        mu_yEHD,mu_zEHD,mu_WxEHD,mu_WyEHD,mu_WzEHD,lambda_iP);
    
    [C_XEVinEV,C_YEVinEV,C_ZEVinEV,phi_EV,alpha_EV,CD_EV,CL_EV] = fza_e_vertical(MHAdim,k_lambdaEV,mu_xEV,...
        mu_yEV,mu_zEV,mu_WxEV,mu_WyEV,mu_WzEV,lambda_iPRA);

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
    TTfF = cambioTierrafF(angulo_guinada,angulo_cabeceo,angulo_balance,eye(3));

    CF_RPinF = TFfA*[CHinA;CYinA;CTinA];
    CM_RPinF = TFfA*[CMHinA;CMYinA;CMTinA];
    CF_RPinT = TTfF*CF_RPinF;
    CM_RPinT = TTfF*CM_RPinF;
            
            CHinF = CF_RPinF(1); 
            CYinF = CF_RPinF(2);
            CTinF = CF_RPinF(3);
            
            CM_RPXinF = CM_RPinF(1);
            CM_RPYinF = CM_RPinF(2);
            CM_RPZinF = CM_RPinF(3);
    
    CF_RAinF = TFfARA*[CH_ra2inARA;CY_ra2inARA;CT_ra2inARA];
    CM_RAinF = TFfARA*[CMH_ra2inARA;CMY_ra2inARA;CMT_ra2inARA];
    CF_RAinT = TTfF*CF_RAinF;
    CM_RAinT = TTfF*CM_RAinF;
            
            CF_RAXinF = CF_RAinF(1);
            CF_RAYinF = CF_RAinF(2);
            CF_RAZinF = CF_RAinF(3);
            
            CM_RAXinF = CM_RAinF(1);
            CM_RAYinF = CM_RAinF(2);
            CM_RAZinF = CM_RAinF(3);

    CF_EHIinF = TFfEHI*[C_XEHIinEHI;C_YEHIinEHI;C_ZEHIinEHI];
    CM_EHIinF = TFfEHI*[C_MXEHIinEHI;C_MYEHIinEHI;C_MZEHIinEHI];
    CF_EHIinT = TTfF*CF_EHIinF;
    CM_EHIinT = TTfF*CM_EHIinF;
            
            CF_EHIXinF = CF_EHIinF(1);
            CF_EHIYinF = CF_EHIinF(2);
            CF_EHIZinF = CF_EHIinF(3);
            
            CM_EHIXinF = CM_EHIinF(1);
            CM_EHIYinF = CM_EHIinF(2);
            CM_EHIZinF = CM_EHIinF(3);
            
    
    CF_EHDinF = TFfEHD*[C_XEHDinEHD;C_YEHDinEHD;C_ZEHDinEHD];
    CM_EHDinF = TFfEHD*[C_MXEHDinEHD;C_MYEHDinEHD;C_MZEHDinEHD];
    CF_EHDinT = TTfF*CF_EHDinF;
    CM_EHDinT = TTfF*CM_EHDinF;
            
            CF_EHDXinF = CF_EHDinF(1);
            CF_EHDYinF = CF_EHDinF(2);
            CF_EHDZinF = CF_EHDinF(3);
            
            CM_EHDXinF = CM_EHDinF(1);
            CM_EHDYinF = CM_EHDinF(2);
            CM_EHDZinF = CM_EHDinF(3);
    
    CF_EVinF = TFfEV*[C_XEVinEV;C_YEVinEV;C_ZEVinEV];
    CM_EVinF = TFfEV*[C_MXEVinEV;C_MYEVinEV;C_MZEVinEV];
    CF_EVinT = TTfF*CF_EVinF;
    CM_EVinT = TTfF*CM_EVinF;
    
            
            CF_EVXinF = CF_EVinF(1);
            CF_EVYinF = CF_EVinF(2);
            CF_EVZinF = CF_EVinF(3);
            
            CM_EVXinF = CM_EVinF(1);
            CM_EVYinF = CM_EVinF(2);
            CM_EVZinF = CM_EVinF(3);
    

%Creación de vectores para una salida mas simple
    CWinF = [CX_ginF; CY_ginF; CZ_ginF];
    CWinT =  TTfF*CWinF;
    

    CD_FinF = [CD_XFinF;CD_YFinF;CD_ZFinF];
    CM_FinF = [CM_FXinF;CM_FYinF;CM_FZinF];
    CF_FinT = TTfF*CD_FinF;
    CM_FinT = TTfF*CM_FinF;
    
    betas = [beta0, beta1c ,beta1s];
    thetas = [theta0,theta1c,theta1s];
    lambda_iP = lambda_iP;
    lambda_iPRA = lambda_iPRA;

    CF_RPinA = [CHinA; CYinA; CTinA];                       
    CM_RPinA = [CMHinA;CMYinA;CMTinA];
    
    CF_RAinARA = [CH_ra2inARA;CY_ra2inARA;CT_ra2inARA];     
    CM_RAinARA = [CMH_ra2inARA;CMY_ra2inARA;CMT_ra2inARA];
    
    CF_EHIinEHI = [C_XEHIinEHI;C_YEHIinEHI;C_ZEHIinEHI];    
    CM_EHIinEHI = [C_MXEHIinEHI;C_MYEHIinEHI;C_MZEHIinEHI];
    
    CF_EHDinEHD = [C_XEHDinEHD;C_YEHDinEHD;C_ZEHDinEHD];    
    CM_EHDinEHD = [C_MXEHDinEHD;C_MYEHDinEHD;C_MZEHDinEHD];
    
    CF_EVinEV = [C_XEVinEV;C_YEVinEV;C_ZEVinEV];            
    CM_EVinEV = [C_MXEVinEV;C_MYEVinEV;C_MZEVinEV];
    
 
%Cálculo de las potencias consumidas por los distintos elementos.
    
    potencia_RP = -CM_RPinA(3)*rho*pi*(R^5)*(Omega^3);
    potencia_RA = -CM_RAinARA(3)*rho*pi*(R^5)*(Omega^3);
    
    potencia_fuselaje = CD_FinF'*[mu_xF+mu_WxF+k_lambdaF(1)*lambda_iP; mu_yF+mu_WyF+k_lambdaF(2)*lambda_iP; mu_zF+mu_WzF+k_lambdaF(3)*lambda_iP];
    potencia_fuselaje = potencia_fuselaje*rho*pi*(R^5)*(Omega^3);
    
    potencia_EHI = CF_EHIinEHI'*[mu_xEHI+mu_WxEHI+k_lambdaEHI(1)*lambda_iP; mu_yEHI+mu_WyEHI+k_lambdaEHI(2)*lambda_iP; mu_zEHI+mu_WzEHI+k_lambdaEHI(3)*lambda_iP];
    potencia_EHD = CF_EHDinEHD'*[mu_xEHD+mu_WxEHD+k_lambdaEHD(1)*lambda_iP; mu_yEHD+mu_WyEHD+k_lambdaEHD(2)*lambda_iP; mu_zEHD+mu_WzEHD+k_lambdaEHD(3)*lambda_iP];
    potencia_EV = CF_EVinEV'*[mu_xEV+mu_WxEV+k_lambdaEV(1)*lambda_iPRA; mu_yEV+mu_WyEV+k_lambdaEV(2)*lambda_iPRA; mu_zEV+mu_WzEV+k_lambdaEV(3)*lambda_iPRA];
    potencia_stab = (potencia_EHI+potencia_EHD+potencia_EV)*rho*pi*(R^5)*(Omega^3);
    
%Creacion de la estructura de salida.
    Potencias = struct('RP',potencia_RP,'RA',potencia_RA,'F',potencia_fuselaje,'E',potencia_stab);
    Momentoslocales = struct('RP',CM_RPinA,'RA',CM_RAinARA,'F',CM_FinF,'EHI',CM_EHIinEHI,'EHD',CM_EHDinEHD,'EV',CM_EVinEV,'CMRPalter',CMRalter);
    Fuerzaslocales = struct('RP',CF_RPinA,'RA',CF_RAinARA,'F',CD_FinF,'EHI',CF_EHIinEHI,'EHD',CF_EHDinEHD,'EV',CF_EVinEV);
    FuerzasinF = struct('RP',CF_RPinF,'RA',CF_RAinF,'F',CD_FinF,'EHI',CF_EHIinF,'EHD',CF_EHDinF,'EV',CF_EVinF,'Grav',CWinF);
    MomentosinF = struct('RP',CM_RPinF,'RA',CM_RAinF,'F',CM_FinF,'EHI',CM_EHIinF,'EHD',CM_EHDinF,'EV',CM_EVinF);
    FuerzasinT = struct('RP',CF_RPinT,'RA',CF_RAinT,'F',CF_FinT,'EHI',CF_EHIinT,'EHD',CF_EHDinT,'EV',CF_EVinT,'Grav',CWinT);
    MomentosinT = struct('RP',CM_RPinT,'RA',CM_RAinT,'F',CM_FinT,'EHI',CM_EHIinT,'EHD',CM_EHDinT,'EV',CM_EVinT);
    
    AngulosElementos = struct('alpha_F',alpha_F,'beta_F',beta_F,'phi_EHD',phi_EHD,'alpha_EHD',alpha_EHD,...
        'phi_EHI',phi_EHI,'alpha_EHI',alpha_EHI,'phi_EV',phi_EV,'alpha_EV',alpha_EV);
    
    CoeficientesAerodinamicosEsta = struct('CD_EHD',CD_EHD,'CL_EHD',CL_EHD,'CD_EHI',CD_EHI,'CL_EHI',CL_EHI,...
        'CD_EV',CD_EV,'CL_EV',CL_EV);
    
    salida = struct('Potencia',Potencias,'CFinT',FuerzasinT,'CMinT',MomentosinT,'CFinF',FuerzasinF,'CMinF',MomentosinF,'CF_local',Fuerzaslocales,'CM_local',Momentoslocales,'betas',betas,...
        'thetas',thetas,'lambda_iP',lambda_iP,'lambda_iPRA',lambda_iPRA,...
        'AngulosElementos',AngulosElementos,'CoeficientesAerodinamicosEsta',CoeficientesAerodinamicosEsta);
    
    
 %Calculo de porcentajes de contribución de fuerzas y momentos en centro de masas
 
 % FUERZAS
  
 TotalFxinF = abs(CX_ginF)+abs(CHinF)+abs(CF_RAXinF)+abs(CD_XFinF)+abs(CF_EHIXinF)+abs(CF_EHDXinF)+abs(CF_EVXinF);
 TotalFyinF = abs(CY_ginF)+abs(CYinF)+abs(CF_RAYinF)+abs(CD_YFinF)+abs(CF_EHIYinF)+abs(CF_EHDYinF)+abs(CF_EVYinF);
 TotalFzinF = abs(CZ_ginF)+abs(CTinF)+abs(CF_RAZinF)+abs(CD_ZFinF)+abs(CF_EHIZinF)+abs(CF_EHDZinF)+abs(CF_EVZinF);
 
 TotalFinF = [TotalFxinF,TotalFyinF,TotalFzinF];
 
 ContFGrav = 100*[CX_ginF/TotalFxinF,CY_ginF/TotalFyinF,CZ_ginF/TotalFzinF];
 ContFRP = 100*[CHinF/TotalFxinF,CYinF/TotalFyinF,CTinF/TotalFzinF];
 ContFRA = 100*[CF_RAXinF/TotalFxinF,CF_RAYinF/TotalFyinF,CF_RAZinF/TotalFzinF];
 ContFF = 100*[CD_XFinF/TotalFxinF,CD_YFinF/TotalFyinF,CD_ZFinF/TotalFzinF];
 ContFEHI = 100*[CF_EHIXinF/TotalFxinF,CF_EHIYinF/TotalFyinF,CF_EHIZinF/TotalFzinF];
 ContFEHD = 100*[CF_EHDXinF/TotalFxinF,CF_EHDYinF/TotalFyinF,CF_EHDZinF/TotalFzinF];
 ContFEV = 100*[CF_EVXinF/TotalFxinF,CF_EVYinF/TotalFyinF,CF_EVZinF/TotalFzinF];
 
 PruebaFuerzas =  ContFGrav+ContFRP+ContFRA+ContFF+ContFEHI+ContFEHD+ContFEV;
 
 
 % MOMENTOS
 % Momentos directos
 
 TotalMDxinF = abs(CM_RPXinF)+abs(CM_RAXinF)+abs(CM_FXinF)+abs(CM_EHIXinF)+abs(CM_EHDXinF)+abs(CM_EVXinF);
 TotalMDyinF = abs(CM_RPYinF)+abs(CM_RAYinF)+abs(CM_FYinF)+abs(CM_EHIYinF)+abs(CM_EHDYinF)+abs(CM_EVYinF);
 TotalMDzinF = abs(CM_RPZinF)+abs(CM_RAZinF)+abs(CM_FZinF)+abs(CM_EHIZinF)+abs(CM_EHDZinF)+abs(CM_EVZinF);
 
 TotalMDinF = [TotalMDxinF,TotalMDyinF,TotalMDzinF];
  
 % Momentos indirectos;
 
    ContMIRPxinF = (-y_cg+dy_ad-sin(epsilon_x)*h_ad)*CTinF-(-z_cg-cos(epsilon_x)*cos(epsilon_y)*h_ad)*CYinF;
    ContMIRPyinF = (-z_cg-cos(epsilon_x)*cos(epsilon_y)*h_ad)*CHinF-(-x_cg+dx_ad-cos(epsilon_x)*sin(epsilon_y)*h_ad)*CTinF;
    ContMIRPzinF = (-x_cg+dx_ad-cos(epsilon_x)*sin(epsilon_y)*h_ad)*CYinF-(-y_cg+dy_ad-sin(epsilon_x)*h_ad)*CHinF;
 
    ContMIRAxinF = (-y_cg+dRA_ad)*CF_RAZinF-(-z_cg+lRAV_ad)*CF_RAYinF;    
    ContMIRAyinF = (-z_cg+lRAV_ad)*CF_RAXinF-(-x_cg+lRAH_ad)*CF_RAZinF;
    ContMIRAzinF = (-x_cg+lRAH_ad)*CF_RAYinF-(-y_cg+dRA_ad)*CF_RAXinF;
 
    ContMIFxinF = -y_cg*CD_ZFinF+z_cg*CD_YFinF;
    ContMIFyinF = -z_cg*CD_XFinF+x_cg*CD_ZFinF;
    ContMIFzinF = -x_cg*CD_YFinF+y_cg*CD_XFinF;
 
    ContMIEHIxinF = (-y_cg+dEHI_ad)*CF_EHIZinF-(-z_cg+lEVH_ad)*CF_EHIYinF;
    ContMIEHIyinF = (-z_cg+lEVH_ad)*CF_EHIXinF-(-x_cg+lEHH_ad)*CF_EHIZinF;
    ContMIEHIzinF = (-x_cg+lEHH_ad)*CF_EHIYinF-(-y_cg+dEHI_ad)*CF_EHIXinF;
 
    ContMIEHDxinF = (-y_cg+dEHD_ad)*CF_EHDZinF-(-z_cg+lEHV_ad)*CF_EHDYinF;
    ContMIEHDyinF = (-z_cg+lEHV_ad)*CF_EHDXinF-(-x_cg+lEHH_ad)*CF_EHDZinF;
    ContMIEHDzinF = (-x_cg+lEHH_ad)*CF_EHDYinF-(-y_cg+dEHD_ad)*CF_EHDXinF;
 
    ContMIEVxinF = -y_cg*CF_EVZinF-(-z_cg+lEVV_ad)*CF_EVYinF;
    ContMIEVyinF = (-z_cg+lEVV_ad)*CF_EVXinF-(-x_cg+lEVH_ad)*CF_EVZinF;
    ContMIEVzinF = (-x_cg+lEVH_ad)*CF_EVYinF+y_cg*CF_EVXinF;
 
    
 TotalMIxinF = abs(ContMIRPxinF)+abs(ContMIRAxinF)+abs(ContMIFxinF)+abs(ContMIEHIxinF)+abs(ContMIEHDxinF)+abs(ContMIEVxinF);
 TotalMIyinF = abs(ContMIRPyinF)+abs(ContMIRAyinF)+abs(ContMIFyinF)+abs(ContMIEHIyinF)+abs(ContMIEHDyinF)+abs(ContMIEVyinF);
 TotalMIzinF = abs(ContMIRPzinF)+abs(ContMIRAzinF)+abs(ContMIFzinF)+abs(ContMIEHIzinF)+abs(ContMIEHDzinF)+abs(ContMIEVzinF);
  
 TotalMIinF = [TotalMIxinF,TotalMIyinF,TotalMIzinF];
 
 TotalMxinF = TotalMDxinF+TotalMIxinF;
 TotalMyinF = TotalMDyinF+TotalMIyinF;
 TotalMzinF = TotalMDzinF+TotalMIzinF;
 
 
 ContMDRP = 100*[CM_RPXinF/TotalMxinF,CM_RPYinF/TotalMyinF,CM_RPZinF/TotalMzinF];
 ContMDRA = 100*[CM_RAXinF/TotalMxinF,CM_RAYinF/TotalMyinF,CM_RAZinF/TotalMzinF];
 ContMDF = 100*[CM_FXinF/TotalMxinF,CM_FYinF/TotalMyinF,CM_FZinF/TotalMzinF];
 ContMDEHI = 100*[CM_EHIXinF/TotalMxinF,CM_EHIYinF/TotalMyinF,CM_EHIZinF/TotalMzinF];
 ContMDEHD = 100*[CM_EHDXinF/TotalMxinF,CM_EHDYinF/TotalMyinF,CM_EHDZinF/TotalMzinF];
 ContMDEV = 100*[CM_EVXinF/TotalMxinF,CM_EVYinF/TotalMyinF,CM_EVZinF/TotalMzinF];
 
 ContMIRP = 100*[ContMIRPxinF/TotalMxinF,ContMIRPyinF/TotalMyinF,ContMIRPzinF/TotalMzinF];
 ContMIRA = 100*[ContMIRAxinF/TotalMxinF,ContMIRAyinF/TotalMyinF,ContMIRAzinF/TotalMzinF];
 ContMIF = 100*[ContMIFxinF/TotalMxinF,ContMIFyinF/TotalMyinF,ContMIFzinF/TotalMzinF];
 ContMIEHI = 100*[ContMIEHIxinF/TotalMxinF,ContMIEHIyinF/TotalMyinF,ContMIEHIzinF/TotalMzinF];
 ContMIEHD = 100*[ContMIEHDxinF/TotalMxinF,ContMIEHDyinF/TotalMyinF,ContMIEHDzinF/TotalMzinF];
 ContMIEV = 100*[ContMIEVxinF/TotalMxinF,ContMIEVyinF/TotalMyinF,ContMIEVzinF/TotalMzinF];
 
 
 TotalMinF = [TotalMxinF,TotalMyinF,TotalMzinF];
 
 PruebaMomentos =  ContMDRP+ContMIRP+ContMDRA+ContMIRA+ContMDF+ContMIF+ContMDEHI+ContMIEHI+ContMDEHD+ContMIEHD+...
ContMDEV+ContMIEV;
 
 
 TablaContFuerzas = struct('TotalFinF',TotalFinF,'ContGinF',ContFGrav,'ContFRPinF',ContFRP,'ContFRAinF',ContFRA,...
     'ContFFinF',ContFF,'ContFEHIinF',ContFEHI,'ContFEHDinF',ContFEHD,'ContFEVinF',ContFEV,'PruebaFuerzasPorcenerror',PruebaFuerzas);
 
 TablaContMom = struct('TotalMinF',TotalMinF,'TotalMDinF',TotalMDinF,'TotalMIinF',TotalMIinF,...
'ContMDRPinF',ContMDRP,'ContMIRPinF',ContMIRP,...
'ContMDRAinF',ContMDRA,'ContMIRAinF',ContMIRA,...
'ContMDFinF',ContMDF,'ContMIFinF',ContMIF,...
'ContMDEHIinF',ContMDEHI,'ContMIEHIinF',ContMIEHI,...
'ContMDEHDinF',ContMDEHD,'ContMIEHDinF',ContMIEHD,...
'ContMDEVinF',ContMDEV,'ContMIEVinF',ContMIEV,'PruebaMomentosPorcenerror',PruebaMomentos);
 
TablaAcciones = struct('CFinF',TablaContFuerzas,'CMinF',TablaContMom); 
 
 
    
   
end