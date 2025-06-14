function [arrayinEHD]=cambioEHDfF(arrayinF)

%Cambio de Base de ejes fuselaje a ejes estabilizador horizontal derecho
%OJO: si arrayinF es vector, ha de ser COLUMNA

TFfEHD=[0 -1 0; -1 0 0; 0 0 -1];
TEHDfF=TFfEHD';
arrayinEHD=TEHDfF*arrayinF;

end