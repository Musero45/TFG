function varVector = sensitivityWhatHow(he,MissionSegments,atm,...
    variableWn,variableHn,nplot,mode,save)
%SENSITIVITYWHATHOW Is the intersection of each What and How
%   Here the variables Whats and Hows are mixed one by one in each element
%   of the QFD matrix

% Select model, method and functions
model  = variableWn.modelQFD;
method = variableHn.addressesQFD.(model);
functH = method.functionQFD;
functW = variableWn.functionQFD;
labelH = variableHn.label;
labelW = variableWn.label;

% Cross What-How
varVector = functH(he,MissionSegments,atm,method,functW,nplot,labelH,labelW,mode,save);

end

