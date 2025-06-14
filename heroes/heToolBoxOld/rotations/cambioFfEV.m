function [arrayinF]=cambioFfEV(arrayinEV)

%Cambio de Base de ejes  estabilizador vertical a ejes fuselaje
%OJO: si arrayinEV es vector, ha de ser COLUMNA

TFfEV=[0  -1 0; 0 0 1; -1 0 0];

arrayinF=TFfEV*arrayinEV;

end