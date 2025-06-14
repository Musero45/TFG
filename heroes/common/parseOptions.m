function options   = parseOptions(pv_pairs,optionsFun)
% PARSEOPTIONS  Parses sets of property value pairs to produce
%               an option structure
%
%   O = PARSEOPTIONS(X,F) outputs an option structure, O,
%   given the set of property value pairs X compared to
%   the default set of options output by the function_handle
%   F.
%
%



if isempty(pv_pairs)
        options = optionsFun();
else
        options = optionsFun();
        options = parse_pv_pairs(options,pv_pairs);
end

