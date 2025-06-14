function [arrayinF]=cambioFfARA(epsilon_RA,arrayinARA)

%Cambio de Base de ejes  arbol antipar a ejes del fuselaje
%OJO: si arrayinaRA es vector, ha de ser COLUMNA

TFfARA=[-1 0 0; 0 sin(epsilon_RA) cos(epsilon_RA); 0 cos(epsilon_RA) -sin(epsilon_RA)];

arrayinF=TFfARA*arrayinARA;

end