function variable = getWHAT(name,unit,saveName,date,legend,funqfd,...
                            modelqfd,activeqfd,funoec,modeloec,activeoec,...
                            tarjet,direction,weightqfd)
%GETWHAT Organizes each What in a structure including all the elements for
%qfd and oec analysis

% Labels
label = struct('name',name,'unit',unit,...
    'saveName',saveName,'datetick',date,'legend',legend);
% Customer weights
weights = struct('qfd',weightqfd);
% Project tarjets
tarjet = struct('value',tarjet,'direction',direction);

% What
variable = struct('label',label,...
    'functionQFD',funqfd,'modelQFD',modelqfd,'activeQFD',activeqfd,...
    'functionOEC',funoec,'modelOEC',modeloec,'activeOEC',activeoec,...
    'tarjet',tarjet,'weights',weights);
    

end

