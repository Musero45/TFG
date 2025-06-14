function saveaspdf(gcf,name)

x1   = {' '};
% This snippet is very dangerous
% if exist([pwd filesep name '.eps'], 'file')==2
%    system(cell2mat(strcat('epstopdf ',x1,name,'.eps')));
% else
% The else statement is safer, more costly for linux
% but the correct way to go
   saveas(gcf,name,'epsc');
   system(cell2mat(strcat('epstopdf ',x1,name,'.eps')));
% end
