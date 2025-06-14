function coswmf = cosws2coswmf(cosws,fieldname,varargin)
%cosws2coswmf  Extracts the substructure named with a fieldname from a 
%              cell of structures with substructures
%
%   TODO
%   - Rename function to something like: slice_cosws
%   --FIXME DOCS--
%   PLOTPOWERSTATE(X,LEG) plots a dimensional power state defined
%   by cell of structures, X, using the cell of legends, LEG. X should be





% The size of the fields of the output structure, swmf, is the same then
% cell of structures with scalar fields, coswsf. 
sizecosws     = size(cosws);
numelcosws    = numel(cosws);
coswmf        = cell(sizecosws);

for i = 1:numelcosws
    c          = cosws{i};
    % Extends old functionality to subsstructuring
    S          = struct('type','.','subs',regexp(fieldname,'\.','split'));

    % check for the data type of fieldname substructure
    fieldnameData = subsref(c, S);

    if isstruct(fieldnameData)
        % In case fieldname data is an structure we can output directly
        coswmf{i}  = fieldnameData; 
    else
        % Because we should return a coswmf in case fieldname data is not a
        % structure we should structurify it by adding a field.
        % The name of the field to be added is the 
        % last dot regexp of S, that is S(end) contains the last string before 
        % dot
        s.(S(end).subs) = fieldnameData;
        coswmf{i}       = s;
    end
end


