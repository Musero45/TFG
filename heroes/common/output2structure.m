function s  = output2structure(S)

if iscell(S)
   s  = S{1};
elseif isstruct(S)
   s  = S;
end
