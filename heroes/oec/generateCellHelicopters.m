function heCell = generateCellHelicopters(heli,Hows,vectRankHows,nVal)
%GENERATECELLHELICOPTERS Generates a multidimentional cell of helicopters
%using all the possible combinations for the desired variable Hows


numvars = size(vectRankHows,2);

valuesstruct = getHowValuesOEC(heli,Hows,vectRankHows,nVal);

sizesvector = zeros(1,numvars);
nextstepvector = zeros(1,numvars);

for i=1:numvars
    label = strcat('OECvar',num2str(i,'%2.0f'));
    valuesvector = valuesstruct.(label).values;
    sizesvector(i) = size(valuesvector,2);
end

totalhenumber = prod(sizesvector);
disp(['Generate cell Helicopters: ','N helicopters = ', int2str(totalhenumber)]);

heCell = cell(1,totalhenumber);

nextstepvector(1) = 1;
    
for i=2:numvars
    nextstepvector(i) = prod(sizesvector(1:i-1));
end

indexvector = ones(1,numvars);
stepcountervector = ones(1,numvars);
resetcountervector = ones(1,numvars);

for i=1:totalhenumber
   
    disp(['Generating helicopter ',int2str(i),' of ',int2str(totalhenumber)])
    temphe = heli;
    
    for j=1:numvars
        
        structlabel = strcat('OECvar',num2str(j,'%2.0f'));
        address = valuesstruct.(structlabel).rigidaddress;
        valuesvector  = valuesstruct.(structlabel).values;
        value = valuesvector(indexvector(j));
        temphe = setnestedstructvalue(temphe,address,value);
        
        if stepcountervector(j)==nextstepvector(j) && resetcountervector(j)<sizesvector(j)
            indexvector(j) = indexvector(j) + 1;
            stepcountervector(j) = 1;
            resetcountervector(j) = resetcountervector(j) + 1;
        elseif stepcountervector(j)==nextstepvector(j) && resetcountervector(j)==sizesvector(j)
            indexvector(j) = 1;
            stepcountervector(j) = 1;
            resetcountervector(j) = 1;
        else
            stepcountervector(j) = stepcountervector(j) + 1;
        end
    end
    
    heCell{i} = temphe;
    heCell{i}.N = i;
    
end

end

