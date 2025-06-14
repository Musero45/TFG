function value = getnestedstructvalue(structure,address)
%Function to obtain the value of a field in a structure that is nested
%inside other structures.
%   This function receives two arguments:
%   - structure: variable that contains nested structures.
%   - address: String variable that contains the path to the field i want
%              to obtain relative to the top-most structure.
%   The function outputs the value of the specified field.
%   Note: The function also accepts a vector specific component address as
%   input if that field contains a vector. This is done just appending the
%   vector index between parenthesis after the field name.
%   Ex: 
%       If the field: struct.field1.field2 contains a vector, the address
%       'field1.field2(3)' would return the third element of that vector.

tree = regexp(address,'\.','split');
deep = size(tree,2);

temp = structure.(tree{1});

for i=2:deep
    
    try
        temp = temp.(tree{i});
    catch
        indexstr = regexp(tree{i},'\((\d+)\)\>','tokens');
        index = str2double(indexstr{1});
        leading = regexp(tree{i},'\((\d+)\)\>','split');
        vector = temp.(leading{1});
        temp = vector(index);
    end
   
end

value = temp;

end