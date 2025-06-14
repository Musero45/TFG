function C = struct2pv_pairsCell(S)

% Get fieldnames cell, taht is parameter names, paramNames
paramNames  = fieldnames(S);

% Get the values of the parameter names, valueNames
valueNames  = struct2cell(S);

npn         =length(paramNames);
C           = cell(1,2*npn);
i1          = 1:2:2*npn;
for i = 1: npn
    C{i1(i)}    = paramNames{i};
    C{i1(i)+1}  = valueNames{i};   
end
