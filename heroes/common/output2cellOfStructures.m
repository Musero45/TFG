function s  = output2cellOfStructures(S)

if isstruct(S)
  s{1} = S;
elseif iscell(S)
  s    = S;
end
