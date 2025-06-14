function [CX_ginF, CY_ginF, CZ_ginF] = fza_gravedad (MHAdim, angulo_guinada, angulo_cabeceo, angulo_balance)



rho = MHAdim.rho;
R = MHAdim.Pala_RP.R;
Omega = MHAdim.Pala_RP.Omega;

CW = MHAdim.CW;

% [TTfF]=cambioTierrafF(angulo_guinada,angulo_cabeceo,angulo_balance,eye(3));
[TFfT]=cambioFfTierra(angulo_guinada,angulo_cabeceo,angulo_balance,eye(3));

CWinF = TFfT*[0; 0; 1]*CW;
% grav = [0; 0; 1]*gravedad/(rho*pi*R^4*Omega^2);


% grav = [-sin(angulo_cabeceo); sin(angulo_balance)*cos(angulo_cabeceo); cos(angulo_balance)*cos(angulo_cabeceo)]*gravedad/(rho*pi*R^4*Omega^2);


CX_ginF = CWinF(1);

CY_ginF = CWinF(2);

CZ_ginF = CWinF(3);


end