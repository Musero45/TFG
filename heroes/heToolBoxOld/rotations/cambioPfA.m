function [arrayinP]=cambioPfA(beta1c,beta1s,arrayinA)

%Cambio de Base de ejes  P (plano puntas) a ejes arbol A del principal
%OJO: si arrayinP es vector, ha de ser COLUMNA

TAfP=[1 0 -beta1c; 0 1 -beta1s; beta1c beta1s 1];
TPfA=TAfP';

arrayinP=TPfA*arrayinA;

end