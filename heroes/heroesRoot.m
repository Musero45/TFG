function exedir=heroesRoot
% HEROESROOT Root directory of HEROES installation.
%
% CALL:  Str = heroesRoot
% 
%    Str = string with the path name to the directory where
%          HEROES is installed.
%
%  HEROESROOT is used to produce platform dependent paths
%  to the various HEROES directories.
% 
%  Example:
%    fullfile(heroesRoot,filesep, 'spec','')
%
%    produces a full path to the <heroesRoot>/spec directory that
%    is correct for platform it's executed on.
% 
%    See also: fullfile.


exedir=which('heroesRoot');
i=max(findstr(exedir,'heroesRoot'))-2; %#ok<*REMFF1>
if i>0
  exedir=exedir(1:i);
else
  exedir=[];
  error('Cannot locate heroesRoot.m. You must add the path to the HEROES Toolbox')
end
