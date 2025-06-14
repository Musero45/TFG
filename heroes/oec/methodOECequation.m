function heCand = methodOECequation(heCand,Whats,maxVals,marks,weights,scaleMark)
%OECEQUATION Calculates the OEC result for each helicopter 
%   This method uses marks and weights obtained in previous functions and
%   implement the results in the equation:
%
%       OEC(k) = sum {i=1:NWhats}( mark(k,i)*weight(i) )
%

disp('...calculating OEC.')

% Obtain tarjets from Whats
Perflabels = heCand{1}.Performances.labels;
Legendlabels = heCand{1}.Performances.legends;

Nhe = size(heCand,2); 
Nperf = size(Perflabels,2);

tarjVal = cell(1,Nperf);

nI = 0;
NcatW = Whats.Ncat;
for i=1:NcatW

    CatW  = strcat('cat',num2str(i,'%2.0f'));
    NWcat = Whats.(CatW).N;
    for j=1:NWcat

        varW = strcat('var',num2str(j,'%2.0f'));
        if strcmp(Whats.(CatW).(varW).activeOEC,'yes')

            nI = nI+1;
            tarjVal{nI} = Whats.(CatW).(varW).tarjet.value;           
            
        end
    end
end

% Main OEC marks and weights sum
for k=1:Nhe
    
    heCand{k}.OEC.NitemsOEC = Nperf;
    
    OEC = 0;
    for i=1:Nperf
        
        itemOEC = strcat('itemOEC',num2str(i,'%2.0f'));
        
        % Obtain OEC elements
        name       = Perflabels{i};
        legend     = Legendlabels{i};
        val        = heCand{k}.Performances.(name)(1);
        tarjetVal  = tarjVal{i};
        minVal     = maxVals.(itemOEC).minVal;
        maxVal     = maxVals.(itemOEC).maxVal;
        mark       = marks(k,i);
        weight     = weights(i);
        weightMark = weight*mark;
        
        % Store elements
        heCand{k}.OEC.(itemOEC).label       = name;
        heCand{k}.OEC.(itemOEC).legend      = legend;
        heCand{k}.OEC.(itemOEC).value       = val;
        heCand{k}.OEC.(itemOEC).tarjetValue = tarjetVal;
        heCand{k}.OEC.(itemOEC).minValue    = minVal;
        heCand{k}.OEC.(itemOEC).maxValue    = maxVal;
        heCand{k}.OEC.(itemOEC).mark        = mark;
        heCand{k}.OEC.(itemOEC).weight      = weight;
        heCand{k}.OEC.(itemOEC).weightMark  = weightMark;
        
        % OEC equation
        OEC = OEC + weightMark;

    end
    
    % Store OEC and scalemark
    heCand{k}.OEC.scale = scaleMark;
    heCand{k}.OEC.OEC   = scaleMark*OEC;
    
end   


end

