function [arrayinEV]=cambioEVfF(arrayinF)

%Cambio de Base de ejes  fuselaje a ejes estabilizador vertical
%OJO: si arrayinF es vector, ha de ser COLUMNA

TFfEV=[0  -1 0; 0 0 1; -1 0 0];
TEVfF=TFfEV';

arrayinEV=TEVfF*arrayinF;

end