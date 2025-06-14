function engines = getEngine_db

% List Of Engines
sr         = heroesRoot;
enginePath = fullfile(sr,'heroesData',filesep,'engine');

% List of engines m files
loe = dir(strcat(enginePath,filesep,'*.m'));

% number of engines
ne = length(loe);

% allocate engine cell output
engines = cell(1,ne);

% Set the number of engines to 1
numEngines = 1;

% Load atmosphere
atm        = getISA;

for i = 1:ne
    engineNameI = regexp(loe(i).name,'\.m');
    engineFunc  = str2func(loe(i).name(1:engineNameI-1));
    engines{i}  = engineFunc(atm,numEngines);
end
