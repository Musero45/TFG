function variable = getHOW(name,unit,saveName,dimensioning,energy,rigid,...
                            oecAddress)
%GETHOW Organizes each How in a structure including all the elements for
%qfd and oec analysis

% Variable addresses
addresses = struct(...
    'dimensioning',dimensioning,...
    'energy',energy,...
    'rigid',rigid...
    );

% Labels
label = struct('name',name,'unit',unit,'saveName',saveName);

% How
variable = struct('label',label,'addressesQFD',addresses,'addressOEC',oecAddress);
    

end

