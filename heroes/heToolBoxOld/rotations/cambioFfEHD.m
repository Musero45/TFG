function [arrayinF]=cambioFfEHD(arrayinEHD)

%Cambio de Base de ejes  estabilizador horizontal derecho a ejes fuselaje
%OJO: si arrayinEHD es vector, ha de ser COLUMNA

TFfEHD=[0 -1 0; -1 0 0; 0 0 -1];

arrayinF=TFfEHD*arrayinEHD;

end