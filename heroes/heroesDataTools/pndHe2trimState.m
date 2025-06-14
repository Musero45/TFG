function tsOut = pndHe2trimState(ndHe,tsIn,paramstr,paramval)

% nvalues, n and nts should be the same
nvalues = length(paramval);
n       = length(ndHe);
nts     = length(tsIn);

if nvalues ~= n   || ...
   nvalues ~= nts
   error('pndHe2trimState: wrong number of vector length')
end

% First get the fieldnames of input trim state: tsIn
% we should have a isTrimState to check the validity of the cell of
% trimStates, but for the moment we trust that ts is a valid one


% names is a cell containing at every slot the name of fields of the
% structure
%names  = fieldnames(tsIn{1});
names  = fieldnames(tsIn{1}.solution);%ALVARO
nNames = length(names);

sNames = cell(nNames,1);
sField = cell(nNames,1);
fNames = cell(nNames,1);
nsnames = 0;
nfnames = 0;

% divide into fields which are structures values (sNames) and 
% fields which are float ones (fNames)
%
%     S            = struct('type','.','subs',regexp(parstr{i},'\.','split'));
%     parNom       = subsref(he, S);
%     if parNom == 0
%        parval(:,i)  = parNom + linspace(0.9,1.1,nv);
%     else
%        parval(:,i)  = parNom*linspace(0.9,1.1,nv);
%     end
%
% Think about the possibility of using subsasgn and subsref to skip all the
% dirty code belowe

% Extract from tsIn the field names which are structures, sNames, and
% the fields which are matrix of floats, fNames. From the structures of 
% tsIn, that is, sNames we get also the names of the fields, and they are 
% stored at sField cell.
for i = 1:nNames
    % get the value of the fieldname
    %y = tsIn{1}.(names{i});
    y = tsIn{1}.solution.(names{i});%ALVARO
    if isstruct(y)
       nsnames         = nsnames + 1;
       sNames{nsnames} = names{i};
       sField{nsnames} = fieldnames(y);
    elseif isnumeric(y) && length(y) == 1
       nfnames         = nfnames + 1;
       fNames{nfnames} = names{i};
    else
    end
end

% resizing of the sNames and fNames cells skipping empty slots
sNames    = sNames(~cellfun('isempty',sNames));
sField    = sField(~cellfun('isempty',sField));
fNames    = fNames(~cellfun('isempty',fNames));


% Initialise tsOut
% tsOut = struct([]);

% Looping through structure valued fields
s         = length(sNames);


for i = 1:s
    nf     = length(sField{i});
    % Get the total number of rows of matrix par: nrp
    nrp   = 0;
    for k = 1:nf
        %fv     = tsIn{1}.(sNames{i}).(sField{i}{k});ALVARO
        fv     = tsIn{1}.solution.(sNames{i}).(sField{i}{k});%ALVARO
        idx    = size(fv,1);
        nrp    = nrp + idx;
    end
    par    = zeros(nrp,n);
    for j=1:n
        % Get structure value of sName{i} 
        % and store it at y
        %y      = tsIn{j}.(sNames{i});ALVARO
        y      = tsIn{j}.solution.(sNames{i});%ALVARO
        i1     = 1;
        % Define matrix par with values ready to plugin at tsOut, par.
        for k = 1:nf
            fv                 = y.(sField{i}{k});
            idx                = size(fv,1);
            par(i1:i1+idx-1,j) = y.(sField{i}{k});
            i1                 = i1+idx;
        end
    end
    i1 = 1;
    for k=1:nf
        y                = tsIn{j}.(sNames{i});
        fv               = y.(sField{i}{k});
        idx              = size(fv,1);
        A.(sField{i}{k}) = par(i1:i1+idx-1,:);
        i1               = i1+idx;
    end
    tsOut.(sNames{i}) = A;
end

% Looping through float valued fields
f         = length(fNames);
par       = zeros(1,n);

for i = 1:f
    for j=1:n
        %y      = tsIn{j}.(fNames{i});
        y      = tsIn{j}.solution.(fNames{i});%ALVARO
        par(j) = y;
    end
    tsOut.(fNames{i}) = par;
end


% Finally add the non-dimensional parameter paramstr and its vector
% valued paramval


% Add the parameter of the study
tsOut.(paramstr) = paramval'; 

