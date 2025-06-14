function QFDfilled = fillQFD(Whats,Hows,QFDzeros,heli,MissionSegments,atm,mode,save)
%FILLQFD obtains the inside part of the matrix QFD
%   This function obtains the Whats/Hows sensibility and configure the
%   matrix QFD with these results

A = QFDzeros;

disp('Filling QFD matrix;');

Nplot = 100;
posI  = 0;
NcatW = Whats.Ncat;
NcatH = Hows.Ncat;
for i=1:NcatW
    
    CatW  = strcat('cat',num2str(i,'%2.0f'));
    NWcat = Whats.(CatW).N;
    for j=1:NWcat
        
        varW = strcat('var',num2str(j,'%2.0f'));
        if strcmp(Whats.(CatW).(varW).activeQFD,'yes')
            
            posI = posI+1;
        
            model = Whats.(CatW).(varW).modelQFD;
            he = transformqfdHe(heli,model,atm);

            disp(['Evaluation: ',Whats.(CatW).(varW).label.saveName,'...']);

            posJ = 0;
            for k=1:NcatH

                CatH  = strcat('cat',num2str(k,'%2.0f'));
                NHcat = Hows.(CatH).N;
                for l=1:NHcat
                    Nplot = Nplot+1;
                    posJ  = posJ+1;

                    varH  = strcat('var',num2str(l,'%2.0f'));

                    varWn = Whats.(CatW).(varW);
                    varHn = Hows.(CatH).(varH);

                    disp(['... ',Hows.(CatH).(varH).label.saveName]);

                    var          = sensitivityWhatHow(he,MissionSegments,atm,varWn,varHn,Nplot,mode,save);
                    varValue     = selectVARelement(var);
                    A(posI,posJ) = varValue;

                end

            end
        end
    end

end

QFDfilled = A;

end

