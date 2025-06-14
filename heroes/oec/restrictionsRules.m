function ioRules   = restrictionsRules(hePerf)
%RULESRESTRICTIONS Evaluates the rules restrictions


if hePerf.inertia.MTOW <= 3175*9.81
    %io = CS27(hePerf);
    io=1; % Provisional
else
    %io = CS29(hePerf);
    io=1; % Provisional
end

ioRules = io;

end

