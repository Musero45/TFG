function [arrayinA]=cambioAfA1(psi,arrayinA1)

%Cambio de Base de ejes  A1 a ejes arbol A del principal
%OJO: si arrayinA1 es vector, ha de ser COLUMNA

TA1fA=[cos(psi) sin(psi) 0; -sin(psi) cos(psi) 0; 0 0 1];
TAfA1=TA1fA';
arrayinA=TAfA1*arrayinA1;

end