function [arrayinA2]=cambioA2fA3(theta,arrayinA3)

%Cambio de Base de ejes  A2 a ejes A3
%OJO: si arrayinA2 es vector, ha de ser COLUMNA

TA3fA2=[1 0 0; 0 cos(theta) sin(theta); 0 -sin(theta) cos(theta)];
TA2fA3=TA3fA2'
arrayinA2=TA2fA3*arrayinA3;

end