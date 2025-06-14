function VAR = continuousSensibility(he,MissionSegments,atm,method,funct,...
    nplot,labelX,labelY,mode,save)
%CONTINUOUSSENSIBILITY Computes the What sensibility to the continious How
%variation

% Address
address = method.address;

% Helicopter
he1 = he;

% Center values
centerX = getnestedstructvalue(he,address);
centerY = funct(he1,MissionSegments,atm);

% Number of analysis and percent
Porc = 0.2;
np  = 5;

% Variables vectors
VarX = linspace((1-Porc)*centerX,(1+Porc)*centerX,np);
VarY = zeros(1,np);

% Sensibility calculations
for i=1:np  
    he1     = setnestedstructvalue(he1,address,VarX(i));
    VarY(i) = funct(he1,MissionSegments,atm);
end

% Derivative in centerX
fk   = @(x) interp1(VarX,VarY,x);
dfk1 = derivest(fk,centerX);

if isnan(dfk1)
    p = polyfit(VarX,VarY,10);
    k = polyder(p);
    dfk1 = polyval(k,centerX);
end

% if dfk1<=1e-16
%     dfk1 = 0;
% end

% Continious Sensibility
VAR  = dfk1*2*Porc*1*centerX;

% Plot
if mode==1
    prefix = 'qfd_';
    nameX = labelX.name;
    nameY = labelY.name;
    unitX = labelX.unit;
    unitY = labelY.unit;
    saveX = labelX.saveName;
    saveY = labelY.saveName;
    
    plotContinuousSensitivity(nplot,VarX,VarY,centerX,centerY,nameX,nameY,...
        unitX,unitY,saveX,saveY,prefix,save)
end 


end
