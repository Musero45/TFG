function [arrayinA3]=cambioA3fA2(theta,arrayinA2)

%Cambio de Base de ejes  A2 a ejes A3
%OJO: si arrayinA2 es vector, ha de ser COLUMNA

TA3fA2=[1 0 0; 0 cos(theta) sin(theta); 0 -sin(theta) cos(theta)];

arrayinA3=TA3fA2*arrayinA2;

end