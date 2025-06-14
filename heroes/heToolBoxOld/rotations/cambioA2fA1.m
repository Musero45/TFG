function [arrayinA2]=cambioA2fA1(beta,arrayinA1)

%Cambio de Base de ejes  A1 a ejes A2
%OJO: si arrayinA1 es vector, ha de ser COLUMNA

TA2fA1=[cos(beta) 0 sin(beta); 0 1 0; -sin(beta) 0 cos(beta)];

arrayinA2=TA2fA1*arrayinA1;

end