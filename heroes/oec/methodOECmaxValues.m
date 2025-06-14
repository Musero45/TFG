function maxVals = methodOECmaxValues(heCand)
%OECMAXVALUES Obtains the max an min results of the performances calculated
%for the OEC method (Whats)

disp('...searching performances max values.')

Perflabels = heCand{1}.Performances.labels;

Nperf = size(Perflabels,2); 
Nhe = size(heCand,2); 

val = zeros(1,Nhe);
maxVals.itemsList = Perflabels;

for i=1:Nperf
    name = Perflabels{i};
    for k=1:Nhe
        val(k) = heCand{k}.Performances.(name)(1);
    end
    
    valmin = min(val);
    valmax = max(val);
    
    itemOEC = strcat('itemOEC',num2str(i,'%2.0f'));
    
    maxVals.(itemOEC).minVal = valmin;
    maxVals.(itemOEC).maxVal = valmax;
end    


end

