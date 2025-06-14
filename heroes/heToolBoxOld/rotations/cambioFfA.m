function [arrayinF] = cambioFfA(epsilon_x,epsilon_y,arrayinA)

%Cambio de Base de ejes arbol del principal a ejes fuselaje
%OJO: si arrayinA es vector, ha de ser COLUMNA

TFfB=[-cos(epsilon_y) 0 -sin(epsilon_y); 0 1 0; sin(epsilon_y) 0 -cos(epsilon_y)];
TBfA=[1 0 0; 0 cos(epsilon_x) -sin(epsilon_x); 0 sin(epsilon_x) cos(epsilon_x)];

arrayinF=TFfB*TBfA*arrayinA;

end