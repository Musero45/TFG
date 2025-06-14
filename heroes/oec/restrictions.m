function [heCand, heNonCand] = restrictions(hePerf)
%RESTRICTIONS Evaluates the different kinds of restrictions and returns the
%helicopters that satisfy all the restrictions (candidates) and the
%helicopters that don't satisfy the restrictions (non candidates).
%   There are 3 kinds of restrictions: Fisical restrictions (fisical rules
%   for the helicopter system), Rules (CS27 and CS29) and Mission (be able
%   to accomplish the selected mission by the customer.

% Restrictions filter
disp('Restrictions filter...')
Nhe = size(hePerf,2); 

Ncand = 0;
for i=1:Nhe
    
    % Fisical restrictions
    ioFisical = restrictionsFisical(hePerf{i});
    hePerf{i}.fisicalRestrictions = ioFisical;

    % Rules
    ioRules   = restrictionsRules(hePerf{i});
    hePerf{i}.rulesRestrictions = ioRules;

    % Mission
    ioMission = restrictionsMission(hePerf{i});
    hePerf{i}.missionRestriction = ioMission;
    
    % All restrictions together
    allRestrictions = ioFisical*ioRules*ioMission;
    hePerf{i}.allRestrictions = allRestrictions;

    Ncand = Ncand+allRestrictions;
    
end

% Separate Candidates and non candidates
disp('Evaluating Candidates and non candidates...')

Nnoncand = Nhe - Ncand;

disp(['...N candidates =  ',int2str(Ncand)])
disp(['...N non candidates =  ',int2str(Nnoncand)])
heCand    = cell(1,Ncand);
heNonCand = cell(1,Nnoncand);

cand  = 0;
ncand = 0;
for i=1:Nhe
    if hePerf{i}.allRestrictions == 1
        cand = cand+1;
        heCand{cand} = hePerf{i};
    else
        ncand = ncand+1;
        heNonCand{ncand} = hePerf{i};
    end
end

end

