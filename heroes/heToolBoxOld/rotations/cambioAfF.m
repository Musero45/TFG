function [arrayinA]=cambioAfF(epsilon_x,epsilon_y,arrayinF)

%Cambio de Base de ejes  fuselaje a ejes arbol del principal
%OJO: si arrayinF es vector, ha de ser COLUMNA

TFfB=[-cos(epsilon_y) 0 -sin(epsilon_y); 0 1 0; sin(epsilon_y) 0 -cos(epsilon_y)];
TBfA=[1 0 0; 0 cos(epsilon_x) -sin(epsilon_x); 0 sin(epsilon_x) cos(epsilon_x)];
TBfF=TFfB';
TAfB=TBfA';
arrayinA=TAfB*TBfF*arrayinF;

end