function structure = setnestedstructvalue(structure,address,value)
%Function to set the value of a field in a structure that is nested
%inside other structures.
%   This function receives three arguments:
%   - structure: variable that contains nested structures.
%   - address: String variable that contains the path to the field i want
%              to set the value in relative to the top-most structure.
%   - value: the value i want to set in the field.
%   The function outputs the same received structure with the value
%   changed.
%   Note: The function also accepts a vector specific component address as
%   input if that field contains a vector. This is done just appending the
%   vector index between parenthesis after the field name.
%   Ex: 
%       If the field: struct.field1.field2 contains a vector, the address
%       'field1.field2(3)' would set the value in the third element of that 
%       vector.

tree = regexp(address,'\.','split');
deep = size(tree,2);

tempstr = 'structure.(tree{1})';

for i=2:deep
    tempstr = strcat(tempstr,'.(tree{',sprintf('%d',i),'})');
end

str = strcat(tempstr,'=value;');

try
    eval(str);
catch
    indexstr = regexp(tree{deep},'\((\d+)\)\>','tokens');
    index = str2double(indexstr{1});
    leading = regexp(tree{deep},'\((\d+)\)\>','split');
    tree{deep} = leading{1};
    str = strcat('vector =',tempstr,';');
    eval(str);
    vector(index) = value;
    str = strcat(tempstr,'=vector;');
    eval(str);
end

end