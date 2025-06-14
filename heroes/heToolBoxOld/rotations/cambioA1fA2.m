function [arrayinA1]=cambioA1fA2(beta,arrayinA2)

%Cambio de Base de ejes  A2 a ejes A1
%OJO: si arrayinA2 es vector, ha de ser COLUMNA

TA2fA1=[cos(beta) 0 sin(beta); 0 1 0; -sin(beta) 0 cos(beta)];
TA1fA2=TA2fA1';
arrayinA1=TA1fA2*arrayinA2;

end