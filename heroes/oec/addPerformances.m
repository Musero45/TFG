function hePerf = addPerformances(heCell,Whats,MissionSegments,atm)
%ADDPERFORMANCES Calculates all the performances selected in Whats for all
%the helicopters in heCell.
%   This function searchs all the elements that are selected in Whats and
%   calculates each performance with the functions @oecfunction. The
%   performances are stored in each helicopter of the cell. After that it
%   calculates special features needed like evaluating restrictions.

disp('Adding performances:');


Nhe = size(heCell,2); 
hePerf = heCell;

for k=1:Nhe
    
    disp(['...Helicopter ',int2str(k),' of ',int2str(Nhe)])
    
    NcatW = Whats.Ncat;
    for i=1:NcatW

        CatW  = strcat('cat',num2str(i,'%2.0f'));
        NWcat = Whats.(CatW).N;
        for j=1:NWcat
            
            varW = strcat('var',num2str(j,'%2.0f'));
            if strcmp(Whats.(CatW).(varW).activeOEC,'yes')
                
                model = Whats.(CatW).(varW).modelOEC;
                he = transformoecHe(heCell{k},model,atm);

                funct = Whats.(CatW).(varW).functionOEC;
                Perf = funct(he,MissionSegments,atm);

                name = Whats.(CatW).(varW).label.saveName;
                hePerf{k}.Performances.(name) = Perf;

                if size(Perf,2)==2
                    hePerf{k}.Restrictions.MissionAchieve = Perf(2);
                    disp(['... ',name, ' Achieve = ', int2str(Perf(2))])
                else
                    disp(['... ',name])
                end
            end   
        end
    end
    
    % ADD SPECIAL FEATURES HERE
    % (elements that are needed in other analysis, like restrictions)
    
    % Trim State analysis in Hover
    name = 'trimStatePF';
    muAv = 0;
    [Theta, Phi] = getTrimAngles(heCell{k},muAv,atm);
    hePerf{k}.Restrictions.(name).Theta = Theta;
    hePerf{k}.Restrictions.(name).Phi = Phi;
     
    % Trim State analysis in max endurance cruise 
    name = 'trimStateCruise';
    ehe = rigidHe2ehe(heCell{k},atm);
    fC = get1flightCondition(0,0,0,10000);
    vC = vMaxEndurance(ehe,fC,atm);
    muAv = vC/(heCell{k}.mainRotor.Omega*heCell{k}.mainRotor.R);
    [Theta, Phi] = getTrimAngles(heCell{k},muAv,atm);
    hePerf{k}.Restrictions.(name).Theta = Theta;
    hePerf{k}.Restrictions.(name).Phi = Phi;
    
end


end

