function marks   = methodOECmarkFunction(heCand,Whats,maxVals)
%OECMARKFUNCTION Obtains the marks(k,i)
%   This function calls for each performance i and helicopter k the
%   function that is going to calculate the specific mark.

disp('...calculating Marks.')

% Obtain the kind of What (FIX,MAX,MIN)
Perflabels = heCand{1}.Performances.labels;

Nhe = size(heCand,2); 
Nperf = size(Perflabels,2); 
direction = cell(1,Nperf);
tarjVal = cell(1,Nperf);
marks = zeros(Nhe,Nperf);

nI = 0;
NcatW = Whats.Ncat;
for i=1:NcatW

    CatW  = strcat('cat',num2str(i,'%2.0f'));
    NWcat = Whats.(CatW).N;
    for j=1:NWcat

        varW = strcat('var',num2str(j,'%2.0f'));
        if strcmp(Whats.(CatW).(varW).activeOEC,'yes')

            nI = nI+1;
            direction{nI} = Whats.(CatW).(varW).tarjet.direction;
            tarjVal{nI} = Whats.(CatW).(varW).tarjet.value;           
            
        end
    end
end

% List of performances
maxVals.itemsList = Perflabels;

% Calculate marks
for k=1:Nhe
    for i=1:Nperf
        name = Perflabels{i};
        Val = heCand{k}.Performances.(name)(1);
        tarjetVal = tarjVal{i};
        
        itemOEC = strcat('itemOEC',num2str(i,'%2.0f'));

        minVal = maxVals.(itemOEC).minVal;
        maxVal = maxVals.(itemOEC).maxVal;
        
        funct = direction{i};
        
        if     (minVal==maxVal)&&(strcmp(func2str(funct),'bestMAX'))
            marks(k,i) = 1;
        elseif (minVal==maxVal)&&(strcmp(func2str(funct),'bestMIN'))
            marks(k,i) = 1;
        elseif (strcmp(func2str(funct),'bestFIX'))&&(Val<=tarjetVal)
            marks(k,i) = Val/tarjetVal;
        elseif (strcmp(func2str(funct),'bestFIX'))&&(Val>tarjetVal)
            marks(k,i) = tarjetVal/Val;
        else
            marks(k,i) = funct(Val,tarjetVal,minVal,maxVal);
        end
    end
end   


end

