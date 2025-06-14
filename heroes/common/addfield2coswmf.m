function coswmfOut = addfield2coswmf(coswmfIn,paramstr,paramval)
%cosws2coswmf  Extracts the substructure named with a fieldname from a 
%              cell of structures with substructures
%
%   TODO
%   - Rename function to something like: slice_cosws
%   - For the moment being the function is too smart, perhaps we should
%   configure mode string to be an option instead of leaving the function
%   to make so clever actions
%


% This is the default behaviour
mode = 'insertParamval';


% check that size of matrix fields are of the same size than paramval
% here we have assumed that each slot of coswmfIn are of the same type
fldnm = fieldnames(coswmfIn{1});
if any( size(coswmfIn{1}.(fldnm{1}))  ~= size(paramval) )
   % This logical check detects that paramval and matrix field data have
   % different sizes. This means that size of paramval should be equal to
   % size of the input coswmf, and it also means that paramval should be
   % sliced and added as a scalar field at each slot of the output cell
   % coswmfOut
   if any(size(paramval) == size(coswmfIn))
      mode = 'sliceParamval';
      display('warning addfield2coswmf: ')
      display('paramval and matrix fields of the coswmf should have the same size')
   else
      error('addfield2coswmf: paramval and coswmf should have the same size')
   end
end

% The size of the fields of the output structure, swmf, is the same then
% cell of structures with scalar fields, coswsf. 
sizecosws     = size(coswmfIn);
numelcosws    = numel(coswmfIn);
coswmfOut     = cell(sizecosws);


for i = 1:numelcosws
    c             = coswmfIn{i};
    % Extends old functionality to subsstructuring
    S             = struct('type','.','subs',regexp(paramstr,'\.','split'));
    if strcmp(mode,'insertParamval')
       coswmfOut{i}  = subsasgn(c, S,paramval); 
    elseif strcmp(mode,'sliceParamval')
       coswmfOut{i}  = subsasgn(c, S,paramval(i));  
    end
end


