function VAR = discreteSensibility(he,MissionSegments,atm,method,funct,...
    nplot,labelX,labelY,mode,save)
%DISCRETESENSIBILITY Computes the What sensibility to the discrete How
%variation

% Address and values for analysis
address = method.address;
values  = method.values;

% Helicopter
he1 = he;

% center values
centerX = getnestedstructvalue(he,address);
centerY = funct(he1,MissionSegments,atm);

% Variables values
VarX = values;
np   = size(VarX,2);

% Vector
VarY = zeros(1,np);

% Sensibility calculations
for i=1:np  
    he1     = setnestedstructvalue(he1,address,VarX(i));
    VarY(i) = funct(he1,MissionSegments,atm);   
end

% Discrete Sensibility 
VAR = (VarY(2)-VarY(1))/(VarX(2)-VarX(1))*1*centerX*2;

% Plot
if mode==1
    prefix = 'qfd_';
    nameX = labelX.name;
    nameY = labelY.name;
    unitX = labelX.unit;
    unitY = labelY.unit;
    saveX = labelX.saveName;
    saveY = labelY.saveName;
    
    plotDiscreteSensitivity(nplot,VarX,VarY,centerX,centerY,nameX,nameY,...
        unitX,unitY,saveX,saveY,prefix,save)
end


end
