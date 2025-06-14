function [Veloc] = Velocidades(MHAdim,mu_xT,mu_yT,mu_zT,mu_WxT,mu_WyT,mu_WzT,angulo_guinada, angulo_cabeceo, angulo_balance)

%PARA EL VERTICAL USO LA INDUCIDA DEL ANTIPAR

%SOLO FALTA INCLUIR LA VELOCIDAD EN EJES TIERRA

[TFfT] = cambioFfTierra(angulo_guinada,angulo_cabeceo,angulo_balance,eye(3));

velz = TFfT*[mu_xT; mu_yT; mu_zT];
velzW = TFfT*[mu_WxT; mu_WyT; mu_WzT];

mu_xF = velz(1);
mu_yF = velz(2);
mu_zF = velz(3);

mu_WxF = velzW(1);
mu_WyF = velzW(2);
mu_WzF = velzW(3);

%Ordenación de la netrada natural en forma de vector.
mu_F = [mu_xF;mu_yF;mu_zF];
mu_WF= [mu_WxF;mu_WyF;mu_WzF];

%Carga de los parámetros geometricos para las matrices de cambio
epsilon_x = MHAdim.epsilon_x;
epsilon_y = MHAdim.epsilon_y;

epsilon_ra = MHAdim.epsilon_ra;

%Creación de las matrices de cambio
[TAF] = cambioAfF(epsilon_x,epsilon_y,eye(3));
[TFA] = cambioFfA(epsilon_x,epsilon_y,eye(3));

[TEHIF] = cambioEHIfF(eye(3));
[TEHDF] = cambioEHDfF(eye(3));

[TEVF] = cambioEVfF(eye(3));

[TARAF] = cambioARAfF(epsilon_ra,eye(3));
[TFARA] = cambioFfARA(epsilon_ra,eye(3));

%Cálculo de las velocidades en los distintos ejes
%En ejes fuselaje

%En ejes rotor
mu_A = TAF*mu_F;
mu_WA = TAF*mu_WF;
mu_xA = mu_A(1); mu_yA = mu_A(2); mu_zA = mu_A(3);
mu_WxA = mu_WA(1); mu_WyA = mu_WA(2); mu_WzA = mu_WA(3);

%En ejes estabilizador izquierdo
mu_EHI = TEHIF*mu_F;
mu_WEHI = TEHIF*mu_WF;

mu_xEHI = mu_EHI(1); mu_yEHI = mu_EHI(2); mu_zEHI = mu_EHI(3);
mu_WxEHI = mu_WEHI(1); mu_WyEHI = mu_WEHI(2); mu_WzEHI = mu_WEHI(3);

%En ejes estabilizador derecho
mu_EHD = TEHDF*mu_F;
mu_WEHD = TEHDF*mu_WF;

mu_xEHD = mu_EHD(1); mu_yEHD = mu_EHD(2); mu_zEHD = mu_EHD(3);
mu_WxEHD = mu_WEHD(1); mu_WyEHD = mu_WEHD(2); mu_WzEHD = mu_WEHD(3);

%En ejes estabilizador vertical
mu_EV = TEVF*mu_F;
mu_WEV = TEVF*mu_WF;

mu_xEV = mu_EV(1); mu_yEV = mu_EV(2); mu_zEV = mu_EV(3);
mu_WxEV = mu_WEV(1); mu_WyEV = mu_WEV(2); mu_WzEV = mu_WEV(3);

%En ejes rotor antipar
mu_ARA = TARAF*mu_F;
mu_WARA = TARAF*mu_WF;
mu_xARA = mu_ARA(1); mu_yARA = mu_ARA(2); mu_zARA = mu_ARA(3);
mu_WxARA = mu_WARA(1); mu_WyARA = mu_WARA(2); mu_WzARA = mu_WARA(3);


%Ordenación de las velocidades en forma de estructura
Fuselaje = struct('mu_xF',mu_xF,'mu_yF',mu_yF,'mu_zF',mu_zF,...
                  'mu_WxF',mu_WxF,'mu_WyF',mu_WyF,'mu_WzF',mu_WzF);
Rotor = struct('mu_xA',mu_xA,'mu_yA',mu_yA,'mu_zA',mu_zA,...
               'mu_WxA',mu_WxA,'mu_WyA',mu_WyA,'mu_WzA',mu_WzA);
Estabilizadorizquierdo = struct('mu_xEHI',mu_xEHI,'mu_yEHI',mu_yEHI,'mu_zEHI',mu_zEHI,...
                                'mu_WxEHI',mu_WxEHI,'mu_WyEHI',mu_WyEHI,'mu_WzEHI',mu_WzEHI);
Estabilizadorderecho = struct('mu_xEHD',mu_xEHD,'mu_yEHD',mu_yEHD,'mu_zEHD',mu_zEHD,...
                                'mu_WxEHD',mu_WxEHD,'mu_WyEHD',mu_WyEHD,'mu_WzEHD',mu_WzEHD);
Estabilizadorvertical = struct('mu_xEV',mu_xEV,'mu_yEV',mu_yEV,'mu_zEV',mu_zEV,...
                                'mu_WxEV',mu_WxEV,'mu_WyEV',mu_WyEV,'mu_WzEV',mu_WzEV);
Rotorantipar = struct('mu_xARA',mu_xARA,'mu_yARA',mu_yARA,'mu_zARA',mu_zARA,...
               'mu_WxARA',mu_WxARA,'mu_WyARA',mu_WyARA,'mu_WzARA',mu_WzARA);

Veloc = struct('F',Fuselaje,'A',Rotor,'EHI',Estabilizadorizquierdo,'EHD',Estabilizadorderecho,'EV',Estabilizadorvertical,'ARA',Rotorantipar);

end