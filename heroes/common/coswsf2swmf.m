function swmf = coswsf2swmf(coswsf)
% coswsf2swmf Transforms a Cell Of Structures With Scalar Fields, 
%                 COSWMF, into a structure with matrix fields, SWMF.
%
%


% The size of the fields of the output structure, swmf, is the same then
% cell of structures with scalar fields, coswsf. 
sizeOf_swmf     = size(coswsf);




% To use linear indexing we need to obtain the number of elements of the
% cell of structures with matrix fields.
numelOf_coswsf  = numel(coswsf);

% In order to initialise the output structure and taking into account that
% each structure with matrix fields is of the same nature, i.e. the same
% fieldnames are present at each structure, we can pick the very first one
% and then overwrite every field. In this way we are avoiding the common
% problems encountered trying to add fields to empty structures. Therefore,
% we define the output structure swmf as the first structure of the cell
swmf            = coswsf{1};

% Get the fieldnames of the output structure
fldnms          = fieldnames(swmf);

% Number of fieldnames of the output structure
nf              = length(fldnms);

% We define an empty matrix, mf, to store the contents of each field of the
% output structure swmf
mf              = zeros(sizeOf_swmf);


for i = 1:nf
    if strcmp(fldnms{i},'class')
        % This is a really dirty hack
        swmf.(fldnms{i})   = coswsf{1}.(fldnms{i});
    else
        % Loop through linear indexing of the coswmf in order to assign each
        % scalar of the field of the cell to the matrix mf
        for j = 1:numelOf_coswsf
            mf(j) = coswsf{j}.(fldnms{i});
        end
        % Now overwrite the fieldname of the output structure, swmf, with the
        % contents of the matrix formed by the scalar fields
        swmf.(fldnms{i})   = mf;
    end
end


