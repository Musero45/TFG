function Variable = getVar(varin)
%GETHOWCAT Takes the name of the variable and create the structure

Variable.N = size(varin,2);
for i=1:size(varin,2)
    name    = strcat('var',num2str(i,'%2.0f'));
    Variable.(name) = varin(i);
end

end

