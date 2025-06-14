function PerfLabelsOUT = addLabels(PerfLabelsIN,name)
%ADDLABELS Adds one label to the previous vector

if strcmp(PerfLabelsIN,'start')
    PerfLabelsOUT = cellstr(name);
else
    n = size(PerfLabelsIN,2);
    PerfLabelsOUT = PerfLabelsIN;
    PerfLabelsOUT{n+1} = name;
end

end
