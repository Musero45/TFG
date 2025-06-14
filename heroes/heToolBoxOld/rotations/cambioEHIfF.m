function [arrayinEHI]=cambioEHIfF(arrayinF)

%Cambio de Base de ejes fuselaje a ejes estabilizador horizontal izquierdo
%OJO: si arrayinF es vector, ha de ser COLUMNA

TFfEHI=[0 -1 0; -1 0 0; 0 0 -1];
TEHIfF=TFfEHI';
arrayinEHI=TEHIfF*arrayinF;

end