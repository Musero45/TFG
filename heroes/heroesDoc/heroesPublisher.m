function io = heroesPublisher
% HEROESPUBLISHER   Tool to automatically generate heroes documentation 
% 
% 
% Documentation sets often contain:
% 
% * A roadmap page (that is, an initial landing page for the documentation)
% 
% * Examples and topics that explain how to use the toolbox
% 
% * Function or block reference pages
%
%

% Get heroes root dir
sr            = heroesRoot;

% Define output dir
outputDir     = fullfile(sr,'heroesDoc','html');

% Define publishing options
pubOptions = struct(...
'format','html', ...
'outputDir', outputDir, ...
'imageFormat','png' ...
);


% Define the main documentation files
% List of top documentation m files
mainFiles      = {...
'heroes_product_page',...
'heroes_gs',...
'heroes_ug', ...
'heroes_fcn', ...
'heroes_ex', ...
'heroes_devel', ...
'heroes_rn'  ...
};

mainFiles      = {};

% Define the demo documentation files
% List of demo m files
% demoFiles      = {...
% 'demoISA',...
% 'demoGetExcessPower', ...
% 'demoAutorotationCurve', ...
% 'demoParameterEnergyAnalysis',...
% 'demoHoverAeromechanics',...
% 'demoHelicopterTrimStability',...
% 'demoHelicopterMissions',...
% 'demoFlightDynamics' ...
% };
demoFiles      = {...
'demoFlightDynamics' ...
};
% TO BE INCLUDED in list of demo files (work in progress)
% The next list of demo files has to be put in shape because the files are
% not working properly, too much figures are generated and other problems
% 'demoParameterTrimAnalysis',...


%==========================================================================
% docmode sets the mode of generating heroes documentation
% docmode        = 'main'
% docmode        = 'demo'
docmode        = 'all';


switch docmode
case 'main'
    docfiles = mainFiles;
case 'demo'
    docfiles = {demoFiles{1},demoFiles{5}};
case 'all'
    docfiles = [mainFiles,demoFiles];
otherwise
    error('heroesPublisher: wrong option for docmode');
end


% Create documentation files
io            = listOfFile4publish(docfiles,pubOptions);

% Build a search database
builddocsearchdb(outputDir);

function io = listOfFile4publish(lof,pubOptions)


nd         = length(lof);
for i = 1:nd
   fullFileName = which(lof{i});
   disp(strcat('Publishing file:',lof{i}));
   publish(fullFileName,pubOptions); 
end

io   = 1;

