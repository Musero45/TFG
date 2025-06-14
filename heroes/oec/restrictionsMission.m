function io = restrictionsMission(he)
%MISSIONRESTRICTION Evaluates if the helicopter is able to accomplish the
%mission

if isfield(he.Restrictions, 'MissionAchieve')
    io = he.Restrictions.MissionAchieve;
else
    io = 1;
end

end

