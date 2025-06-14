function heAll = addAllPerformances(hePerf,Whats)
%ADDALLPERFORMANCES Adds the names of the desired performances in Whats
%   This function searchs the desired Whats and loads the names, dateticks,
%   legend name and unit for the customer requirements


Nhe = size(hePerf,2);
heAll = hePerf;
PerfLabels = 'start';
ticksLabels = 'start';
legendLabels = 'start';
unitLabels = 'start';

NcatW = Whats.Ncat;
for i=1:NcatW

    CatW  = strcat('cat',num2str(i,'%2.0f'));
    NWcat = Whats.(CatW).N;
    for j=1:NWcat

        varW = strcat('var',num2str(j,'%2.0f'));
        if strcmp(Whats.(CatW).(varW).activeOEC,'yes')
            
            name       = Whats.(CatW).(varW).label.saveName;
            namedate   = Whats.(CatW).(varW).label.datetick;
            namelegend = Whats.(CatW).(varW).label.legend;
            nameunit   = Whats.(CatW).(varW).label.unit;
            
            PerfLabels   = addLabels(PerfLabels,name); 
            ticksLabels  = addLabels(ticksLabels,namedate);
            legendLabels = addLabels(legendLabels,namelegend);
            unitLabels   = addLabels(unitLabels,nameunit);

        end   
    end
end

% Add labels to OEC analysis (name, dateticks, legends and units)
for k=1:Nhe
    
    heAll{k}.Performances.labels    = PerfLabels;
    heAll{k}.Performances.dateticks = ticksLabels;
    heAll{k}.Performances.legends   = legendLabels;
    heAll{k}.Performances.units     = unitLabels;
    
end

end