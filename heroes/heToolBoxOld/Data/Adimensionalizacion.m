function [MHAdim] = Adimensionalizacion(HM,Atm)


%CARACTERIZACION DEL ANALISIS

 Analisis = HM.Analisis;

%HARA FALTA ALGUN PARAMETRO CON DIMENSIONES, COMO LA OMEGA Y LA TORSION

rho = Atm.rho;

peso_kg = HM.peso;
b = HM.RP.b;

epsilon_ra = HM.F.Pos.RA.epsilon_ra;
epsilon_x = HM.F.Pos.R.epsilon_x;
epsilon_y = HM.F.Pos.R.epsilon_y;

%Rotor principal
    %Carga de las variables(con eval('parametros') seria inecesario)
    
    AirfdataRP = HM.RP.Perfil.AirfdataRP;
    
    a = HM.RP.Perfil.cla; cmo = HM.RP.Perfil.cmo;
    delta0 = HM.RP.Perfil.delta0; delta1 = HM.RP.Perfil.delta1; delta2 = HM.RP.Perfil.delta2;
    
    Omega_rp = HM.RP.Omega;
    e_rp = HM.RP.e; R_rp = HM.RP.R; b_rp = HM.RP.b; c_rp = HM.RP.c;
    Ip = HM.RP.Ip; k_beta = HM.RP.k_beta; Mp = HM.RP.Mp; xGB= HM.RP.xGB;
    
    theta1_rp = HM.RP.theta1;
    
    %Creación de las variables adimensionales
    e_ad = e_rp/R_rp;
    sigma_rp = b_rp*c_rp/pi/R_rp;     %No da exactamente el de los semejantes
    gama = rho*c_rp*a*R_rp^4/Ip;      %nº de lock
    lambda_beta = sqrt((k_beta/Ip/Omega_rp^2+1+e_ad*R_rp*Mp*xGB/Ip));
    
    S_beta = (8/gama)*(lambda_beta^2-1);
    
    m_k = b*k_beta/(2*rho*pi*R_rp^2*R_rp*(Omega_rp*R_rp)^2);
    m_e = b*(e_rp*xGB*Mp*Omega_rp^2)/(2*rho*pi*R_rp^2*R_rp*(Omega_rp*R_rp)^2);
    
    m_b = (b/2)*(lambda_beta^2-1)*Omega_rp^2*Ip/(rho*pi*R_rp^2*R_rp*(Omega_rp*R_rp)^2);
    
    epsilon_R = R_rp*Mp*xGB/Ip;
    
    CW = HM.peso*9.8/(rho*pi*R_rp^2*(Omega_rp*R_rp)^2);
    
%Rotor Antipar
    
    AirfdataRA = HM.RA.Perfil.AirfdataRA;

    a_ra = HM.RA.Perfil.cla; cmo_ra = HM.RA.Perfil.cmo;
    delta0_ra = HM.RA.Perfil.delta0; delta1_ra = HM.RA.Perfil.delta1; delta2_ra = HM.RA.Perfil.delta2;
    
    Omega_ra = HM.RA.Omega;
    e_ra = HM.RA.e; R_ra = HM.RA.R; b_ra = HM.RA.b; c_ra = HM.RA.c;

    e_ad_ra = e_ra/R_ra;
    sigma_ra = b_ra*c_ra/pi/R_ra;
    
    theta1_ra = HM.RA.theta1;
    
    
    
%Fuselaje

    kf = HM.F.FactorAmplifi;
    FusAcc = HM.F.ModeloAcciones;
    
    SP = HM.F.SP;   SS = HM.F.SS;
    levh = HM.F.Pos.EV.lEVH;

    sp_ad = SP/(pi*R_rp^2);    ss_ad = SS/(pi*R_rp^2);
    levh_ad = levh/R_rp;
    
%Estabilizadores
    
    AirfdataEHI = HM.E.EHI.Perfil.AirfdataEH;
    
    a_ehi = HM.E.EHI.Perfil.cla; cmo_ehi = HM.E.EHI.Perfil.cmo;
    delta0_ehi = HM.E.EHI.Perfil.delta0; delta1_ehi = HM.E.EHI.Perfil.delta1; delta2_ehi = HM.E.EHI.Perfil.delta2;

    AirfdataEHD = HM.E.EHD.Perfil.AirfdataEH;
       
    a_ehd = HM.E.EHD.Perfil.cla; cmo_ehd = HM.E.EHD.Perfil.cmo;
    delta0_ehd = HM.E.EHD.Perfil.delta0; delta1_ehd = HM.E.EHD.Perfil.delta1; delta2_ehd = HM.E.EHD.Perfil.delta2;
        
    AirfdataEV = HM.E.EV.Perfil.AirfdataEV;
    
    a_ev = HM.E.EV.Perfil.cla; cmo_ev = HM.E.EV.Perfil.cmo;
    delta0_ev = HM.E.EV.Perfil.delta0; delta1_ev = HM.E.EV.Perfil.delta1; delta2_ev = HM.E.EV.Perfil.delta2;

    Sehi = HM.E.EHI.SIzquierdo; Sehd = HM.E.EHD.SDerecho; Sev = HM.E.EV.SVertical;
    cehi = HM.E.EHI.c; cehd = HM.E.EHD.c; cev = HM.E.EV.c;
    
    Sehi_ad = Sehi/(pi*R_rp^2); Sehd_ad = Sehd/(pi*R_rp^2); Sev_ad = Sev/(pi*R_rp^2);
    cehi_ad = cehi/R_rp; cehd_ad = cehd/R_rp; cev_ad = cev/R_rp;
    
    theta_ev = HM.E.EV.theta_ev;
    theta_ehi = HM.E.EHI.theta_ehi;
    theta_ehd = HM.E.EHD.theta_ehd;

%Brazos adimensionalizados para los momentos
    %Centro de gravedad
    
    x_cg = HM.F.Pos.XCG/R_rp;
    y_cg = HM.F.Pos.YCG/R_rp;
    z_cg = HM.F.Pos.ZCG/R_rp;
    
    %Rotor principal
    dx_ad = HM.F.Pos.R.x/R_rp;
    dy_ad = HM.F.Pos.R.y/R_rp;
    h_ad = HM.F.Pos.R.h/R_rp;
    
        
    %Rotor antipar
    lRAH_ad = HM.F.Pos.RA.lRAH/R_rp;
    dRA_ad = HM.F.Pos.RA.dRA/R_rp;
    lRAV_ad = HM.F.Pos.RA.lRAV/R_rp;
        
    %Estabilizadores
    lEHH_ad = HM.F.Pos.EH.lEHH/R_rp; lEHV_ad = HM.F.Pos.EH.lEHV/R_rp;
    dEHD_ad = HM.F.Pos.EH.dEHD/R_rp; dEHI_ad = HM.F.Pos.EH.dEHI/R_rp;
    lEVH_ad = HM.F.Pos.EV.lEVH/R_rp; lEVV_ad = HM.F.Pos.EV.lEVV/R_rp;
    
    
    % Posición punto Of respecto al centro de masas
    
    OOfad = [-x_cg,-y_cg,-z_cg];
    
    % Posición punto A (rotor principal) respecto al centro de masas
    
    hinF = cambioFfA(epsilon_x,epsilon_y,[0;0;h_ad]);
    OfAad = [dx_ad,dy_ad,0]+hinF';
    OAad = OOfad+OfAad;
    
    % Posición punto Aa (rotor antipar) respecto al centro de masas
    
    OfAaad = [lRAH_ad,dRA_ad,lRAV_ad];
    OAaad = OOfad+OfAaad;
    
    % Posición punto EHI (Estabilizador horizontal izquierdo) respecto al centro de masas
    
    OfEHI = [lEHH_ad,dEHI_ad,lEHV_ad];
    OEHI = OOfad+OfEHI;
    
    % Posición punto EHD (Estabilizador horizontal derecho) respecto al centro de masas
    
    OfEHD = [lEHH_ad,dEHD_ad,lEHV_ad];
    OEHD = OOfad+OfEHD;
    
    % Posición punto EV (Estabilizador Vertical) respecto al centro de masas 
    
    OfEV = [lEVH_ad,0,lEVV_ad];
    OEV = OOfad+OfEV;
    
    
%Generación y ordenación de los datos de la estructura

CDG = struct('x_cg',x_cg,'y_cg',y_cg,'z_cg',z_cg);
Rotor = struct('dx_ad',dx_ad,'dy_ad',dy_ad,'h_ad',h_ad,'OAad',OAad);
Antipar = struct('lRAH_ad',lRAH_ad,'lRAV_ad',lRAV_ad,'dRA_ad',dRA_ad,'OAaad',OAaad);
EHorizontal = struct('lEHH_ad',lEHH_ad,'lEHV_ad',lEHV_ad,'dEHD_ad',dEHD_ad,'dEHI_ad',dEHI_ad,'OEHD',OEHD,'OEHI',OEHI);
EVertical = struct('lEVH_ad',lEVH_ad,'lEVV_ad',lEVV_ad,'OEV',OEV);

Pala_RP = struct('b',b,'theta1',theta1_rp,'Omega',Omega_rp,'R',R_rp,'sigma',sigma_rp,'e_ad',e_ad,...
                'gamma',gama,'lambda_beta',lambda_beta,'S_beta', S_beta,'m_k',m_k,'m_e',m_e,'m_b',m_b,'epsilon_R',epsilon_R,...
                'AirfdataRP',AirfdataRP,'a',a,'delta0',delta0,'delta1',delta1,'delta2',delta2,'Cmo',cmo);

            
Pala_RA = struct('theta1',theta1_ra,'Omega',Omega_ra,'R',R_ra,'sigma',sigma_ra,'e_ad',e_ad_ra,...
    'AirfdataRA',AirfdataRA,'a',a_ra,'delta0',delta0_ra,'delta1',delta1_ra,'delta2',delta2_ra,'Cmo',cmo_ra);

Fuselaje = struct('sp_ad',sp_ad,'ss_ad',ss_ad,'lRAH_ad',abs(lRAH_ad),'FactorAmplifi',kf,'ModeloAcciones',FusAcc);

Estabilizadorizquierdo = struct('Sehi_ad',Sehi_ad,'cehi_ad',cehi_ad,'theta_ehi',theta_ehi,...
    'AirfdataEHI',AirfdataEHI,'a',a_ehi,'delta0',delta0_ehi,'delta1',delta1_ehi,'delta2',delta2_ehi,'Cmo',cmo_ehi);

Estabilizadorderecho = struct('Sehd_ad',Sehd_ad,'cehd_ad',cehd_ad,'theta_ehd',theta_ehd,...
    'AirfdataEHD',AirfdataEHD,'a',a_ehd,'delta0',delta0_ehd,'delta1',delta1_ehd,'delta2',delta2_ehd,'Cmo',cmo_ehd);

Estabilizadorvertical = struct('Sev_ad',Sev_ad,'cev_ad',cev_ad,'theta_ev',theta_ev,...
    'AirfdataEV',AirfdataEV,'a',a_ev,'delta0',delta0_ev,'delta1',delta1_ev,'delta2',delta2_ev,'Cmo',cmo_ev);

Brazos = struct('CDG',CDG,'R',Rotor,'RA',Antipar,'EH',EHorizontal,'EV',EVertical);

MHAdim=struct('Analisis',Analisis,'Pala_RP',Pala_RP,'Pala_RA',Pala_RA,'Fuselaje',Fuselaje,'EHIzquierdo',Estabilizadorizquierdo,...
              'EHDerecho',Estabilizadorderecho,'EVertical',Estabilizadorvertical,...
              'Brazos',Brazos,...
              'epsilon_ra',epsilon_ra,'epsilon_x',epsilon_x,'epsilon_y',epsilon_y,'rho',rho,'peso_kg',peso_kg,'CW',CW);


end

