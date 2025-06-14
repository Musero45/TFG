function swmf = coswmf_cos2swmf(coswmf,cos,paramstr,varargin)
% COSWMF_COS2SWMF Transforms a Cell Of Structures With Matrix Fields, 
%                 COSWMF, together with a Cell Of Structures, COS, 
%                 into a structure with matrix fields, SWMF.
%
%   SWMF = COSWMF_COS2SWMF(COSWMF,COS,STR) Transforms a cell of structures 
%   with matrix fields, COSWMF, together with a cell of structures, COS, 
%   into a structure with matrix fields, SWMF using the cell of strings
%   STR. COSWMF and COS are both cells of structures of the same type, i.e 
%   each slot of the cell is a structure with the same fieldnames. 
%   Moreover, both cells shlould be of the same size, i.e. 
%   size(COS)==size(COSWMF) and it is assumed that COSWMF does not 
%   have nested structures. The resulting structure with matrix 
%   fields, SWMF, is a structure with the following properties: 
%   # SWMF is a structure of the same type than each structure of COSWMF, 
%   it means that the fieldnames of COSWMF{i} are included into SWMF. 
%   The values of the SWMF fieldnames are stored into vector or 
%   2D-matrices depending on the dimensions of COS and COSWMF 
%   in such a way that ndims(SWMF.whatever)<=2. 
%   # The fieldname defined by STR and the values of the fieldname STR
%   which are contained into COS are stored into the newly created 
%   fieldname of SWMF, i.e. SWMF.(STR), as a vector or matrix in such 
%   a way that ndims(SWMF.whatever)<=2. Of course STR should be a string
%   which is a valid fieldname of COS{i}.
%
%   This function is developed to join COSWMF such as power states, trim
%   states, stability states, with COS, such as parametric helicopter
%   cells. When a parameter of one helicopter is changed a cell of
%   helicopter structures, COS, is generated and heroes functions 
%   acting upon the cell of helicopters produce COSWMF. However, the plot
%   function of COSWMF, such as plotPowerState, plotTrim,
%   plotStatbilityState, does not know what helicopter parameter has
%   changed because this information is missing. Therefore, we require to
%   add this information in a consistent way by transforming COSWMF into a 
%   SWMF by adding the active helicopter parameter. Summing up, 
%   coswmf_cos2swmf produces a valid SWMF to be used by heroes plot
%   functions when a parameter helicopter cell have been used to produce a
%   cell of heroes data type, COSWMF. 
%
%   SWMF = COSWMF_COS2SWMF(COSWMF,COS,STR1,STR2) computes as above with 
%   by providing a second fieldname string STR2 to be extracted from COS
%   to COSWMF. As before, STR2 should be another string which is a valid 
%   fieldname of COS{i}.
%
%
%
%
% swmf stands for structure with matrix fields, i.e. like non parametric
% powers states. It is assumed that swmf DOES NOT HAVE nested fields
% coswmf stands for cell of structures with matrix fields, like parametric 
% power states, 
% cos stands for cell of structures like cell, i. e. helicopter
% cells, 
%
% paramstr should be a valid fieldname of cos{i}
% paramval is extracted from the cell of structures cos

if ndims(cos) > 2
   error('jointcos2swmf: cell of structure dimension should be less or equal to 2 ');
end
if ndims(coswmf) > 2
   error('jointcos2swmf: cell of structure dimension with matrix fields should be less or equal to 2 ');
end
if length(varargin)>2
   error('jointcos2swmf: wrong number of input variables')
elseif length(varargin)==2
   cos2      = varargin{1};
   paramstr2 = varargin{2};
end

% Dimensions of the output ndHe
n         = numel(cos);
s         = size(cos);

paramval  = zeros(s);

% we split the parameter string, paramstr, looking for dots and 
% the subfields are stored at cell subfieldcell
subfieldcell       = regexp(paramstr,'\.','split');

% Loop using linear indexing to get the values of the fieldname of COS 
% defined by the parameter paramstr. 
for i = 1:n
    paramval(i)   = getfield(cos{i}, subfieldcell{:});
end

% The last slot of the cell subfieldcell is the fieldname to be 
% added to swmf output structure
paramfld  = subfieldcell(end);

% The next if statement deals with the second available parameter string
if length(varargin)==2
    % Dimensions of the output ndHe
    n2        = numel(cos2);
    s2        = size(cos2);

    paramval2 = zeros(s2);
    subfieldcell       = regexp(paramstr2,'\.','split');
    for i = 1:n2
        paramval2(i)   = getfield(cos2{i}, subfieldcell{:});
    end
    % The last slot of the cell c is the fieldname to be added to swmf
    paramfld2 = subfieldcell(end);
else
    paramval2 = [];
    paramfld2 = {''};
end


swmf       = coswmf2swmf(coswmf,paramfld,paramval,paramfld2,paramval2);

function swmf = coswmf2swmf(coswmf,paramfld,paramval,paramfld2,paramval2)


% it is assumed that every slot of coswmf is of the same type and
% therefore the first slot is representative of all of them
swmfFieldNames = fieldnames(coswmf{1});
nFields       = length(swmfFieldNames);

% Get the dimension of the struture with matrix fields of each slot of coswmf
% The first field with numeric contents is the one that defines the
% dimensions of coswmf slots
for i = 1: nFields
    y = coswmf{1}.(swmfFieldNames{i});
    if isnumeric(y)
       numFieldName = swmfFieldNames{i};
       nm_coswmf    = numel(y);
       sz_coswmf    = size(y);
       break
    end
end


% dimensions of the parameter values
np        = size(paramval);

% % % % 
% % % % % dimensions of the values of the fields of the 
% % % % % cell of structure with matrix fields
% % % % nc         = s;
n          = length(coswmf);

% % % % % % if min(np)*min(nc) >= 2
% % % % % %    error('coswmf2swmf: the maximum number of dimensions to be managed is 2')
% % % % % % end

% Case1: paramfield is vector and coswmf contains scalar fields
% if min(size(np))==1 && isscalar(coswmf{1}.(numFieldName))
if min(np)==1 && isscalar(coswmf{1}.(numFieldName))

    for i = 1:nFields
        % Check the kind of field values using first slot of coswmf
        y = coswmf{1}.(swmfFieldNames{i});
        if ischar(y) && strcmp(swmfFieldNames{i},'class')
           % the output swmf inherits the class name string
           swmf.class = y;
        elseif isnumeric(y)
    %         fieldval  = zeros();
            % Loop through cell of structures with matrix fields 
            % using linear indexing
            for j = 1:n
                  fieldval(j)   = coswmf{j}.(swmfFieldNames{i});
            end
            swmf.(swmfFieldNames{i}) = fieldval;
        end
    end
    % Add the parameter field name and assign paramval to this field
    swmf.(paramfld{:})      = paramval;



% elseif min(size(np))==1 && isvector(coswmf{1}.(numFieldName))
elseif min(np)==1 && isvector(coswmf{1}.(numFieldName))

    for i = 1:nFields
        % Check the kind of field values using first slot of coswmf
        y = coswmf{1}.(swmfFieldNames{i});
        if ischar(y) && strcmp(swmfFieldNames{i},'class')
           % the output swmf inherits the class name string
           swmf.class = y;
        elseif isnumeric(y)
            % Loop through cell of structures with matrix fields 
            % using linear indexing
            fieldval = zeros(nm_coswmf,n);
            for j = 1:n
                  a             = coswmf{j}.(swmfFieldNames{i});
                  % We fix that we store by rows the vector field contained
                  % into coswmf
                  fieldval(:,j)   = a(:);
            end
            swmf.(swmfFieldNames{i}) = fieldval;
        end
    end
    % Add the parameter field name and assign paramval to this field
    swmf.(paramfld{:})      = repmat(paramval,nm_coswmf,1);


% elseif min(size(np)) > 1 && isscalar(coswmf{1}.(numFieldName))
elseif min(np) > 1 && isscalar(coswmf{1}.(numFieldName))

    for i = 1:nFields
        % Check the kind of field values using first slot of coswmf
        y = coswmf{1}.(swmfFieldNames{i});
        if ischar(y) && strcmp(swmfFieldNames{i},'class')
           % the output swmf inherits the class name string
           swmf.class = y;
        elseif isnumeric(y)
            % Loop through cell of structures with matrix fields 
            % using linear indexing
            n        = numel(paramval);
            s        = size(paramval);
            fieldval = zeros(s);
            for j = 1:n
                  a             = coswmf{j}.(swmfFieldNames{i});
                  % We fix that we store by rows the vector field contained
                  % into coswmf
                  fieldval(j)   = a;
            end
            swmf.(swmfFieldNames{i}) = fieldval;
        end
    end
    % Add the parameter field name and assign paramval to this field
    swmf.(paramfld{:})      = paramval;
    swmf.(paramfld2{:})     = paramval2;

else
   error('coswmf2swmf: wrong combination of dimensions. Maximum allowed to plot are 2');
end



