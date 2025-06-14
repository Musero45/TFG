function [arrayinF]=cambioFfTierra(angulo_guinada,angulo_cabeceo,angulo_balance,arrayinTierra)

%Cambio de Base de ejes  Tierra a ejes fuselaje
%OJO: si arrayinTierra es vector, ha de ser COLUMNA

Tguinada=[cos(angulo_guinada) sin(angulo_guinada) 0; -sin(angulo_guinada) cos(angulo_guinada) 0; 0 0 1];
Tcabeceo=[cos(angulo_cabeceo) 0  -sin(angulo_cabeceo); 0 1 0; sin(angulo_cabeceo) 0  cos(angulo_cabeceo)];
Tbalance=[1 0 0; 0 cos(angulo_balance) sin(angulo_balance); 0 -sin(angulo_balance) cos(angulo_balance)];

TFfTierra=Tbalance*Tcabeceo*Tguinada;

arrayinF=TFfTierra*arrayinTierra;

end