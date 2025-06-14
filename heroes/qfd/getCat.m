function Category = getCat(nameCat,catin)
%GETHOWCAT Takes the name of the category and create the structure

Category.nameCat = nameCat;
Category.N = size(catin,2);
for i=1:size(catin,2)
    name    = strcat('var',num2str(i,'%2.0f'));
    Category.(name) = catin(i);
end

end

