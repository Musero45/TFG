function setHeroesPath
% setHeroesPath add heroes directories to MATLAB search path.
%

% This is not the best place to do this task because this function is
% intendend to be a set path function and we are cluttering the
% functionality of the setHeroesPath
set(0,'defaulttextinterpreter','latex') % FIXME
set(0,'defaultlegendinterpreter','latex') % FIXME
disp('Default text interpreter is set to LaTeX')

sd            = heroesDirs;

for i=1:length(sd)
    addpath(sd{i});
end
disp('HEROES path has been added to MATLAB path')
disp('To startup: please type at MATLAB prompt >> help heroes')


