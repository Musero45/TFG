function C = add2structures(A,B)
%  ADD2STRUCTURES Adds two structures.
%     
%  Z = ADD2STRUCTURES(X,Y) adds the structures X and Y to give the
%  structure Z. The resulting structure Z is a structure with fields
%  the fields of X and Y. Please be aware that performancewise, 
%  the algorithm used to add the structures is sensitive to 
%  the number of fields of every structure. It is recommended that
%  the structure with more fields is the first input variable.
%

C      = A;
fNames = fieldnames(B);
n      = length(fNames);
for i=1:n
    C.(fNames{i})  = B.(fNames{i}); 
end
