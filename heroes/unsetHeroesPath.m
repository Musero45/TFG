function unsetHeroesPath
% unsetHeroesPath removes HEROES directories from MATLAB search path.
%

sd            = heroesDirs;

for i=1:length(sd)
    rmpath(sd{i});
end

% This restores the default values that were changed by setWTToolBoxPath
set(0,'defaulttextinterpreter','factory')
set(0,'defaultlegendinterpreter','factory')

disp('Default text interpreter is set to FACTORY value')
disp('HEROES path has been removed from MATLAB path')