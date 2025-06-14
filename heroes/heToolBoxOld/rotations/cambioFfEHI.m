function [arrayinF]=cambioFfEHI(arrayinEHI)

%Cambio de Base de ejes  estabilizador horizontal izquierdo a ejes fuselaje
%OJO: si arrayinEHI es vector, ha de ser COLUMNA

TFfEHI=[0 -1 0; -1 0 0; 0 0 -1];

arrayinF=TFfEHI*arrayinEHI;

end