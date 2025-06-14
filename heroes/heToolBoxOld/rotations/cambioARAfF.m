function [arrayinARA]=cambioARAfF(epsilon_RA,arrayinF)

%Cambio de Base de ejes  fuselaje a ejes arbol antipar
%OJO: si arrayinF es vector, ha de ser COLUMNA

TFfARA=[-1 0 0; 0 sin(epsilon_RA) cos(epsilon_RA); 0 cos(epsilon_RA) -sin(epsilon_RA)];
TARAfF=TFfARA';
arrayinARA=TARAfF*arrayinF;

end