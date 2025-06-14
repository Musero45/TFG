function [arrayinA1]=cambioA1fA(psi,arrayinA)

%Cambio de Base de ejes  arbol A del principal a ejes A1
%OJO: si arrayinA1 es vector, ha de ser COLUMNA

TA1fA=[cos(psi) sin(psi) 0; -sin(psi) cos(psi) 0; 0 0 1];

arrayinA1=TA1fA*arrayinA;

end