function y= engineSelection(engine,performances)

%required power
reqPower= performances.TakeOffTotalPower;

%algorithm initialization
bestConsumption=1000000;
bestEngine=10000000;
bestWeight=100000000;
posi=1;
numOfBestEngines=5;
candidatos=1:1:1;

% loop through engines
for i=1:length(engine)
    unitPower=engine{i}.PowerTakeOff;
    
    numEngines=reqPower/unitPower;
    numEngines=ceil(numEngines);
    % We don?t want more than oversized power
    if  numEngines>0.8 && numEngines*unitPower/reqPower<1.1

        totalConsumptiom=engine{i}.SPC*reqPower;
    
        %check if it has the best fuel consumption
        if totalConsumptiom<=bestConsumption
            bestConsumption=totalConsumptiom;
            numOfBestEngines=numEngines;
            
            %keep track of them and store a array called candidatos
            %contaning their position
            candidatos(posi)=i;
            posi=posi+1;
        end
    end  
end


%from those having the best SPC we choose te lightest
for i=1:length(candidatos)
      if engine{candidatos(i)}.weight*numOfBestEngines < bestWeight
                bestEngine=(candidatos(i));
                
      end
end
 
 
engine{bestEngine}.numEngines=numOfBestEngines;
 %  make the best engine our engine
 y=engine{bestEngine};

end

