function he = transformqfdHe(heli,model,atm)
%TRANSFORMHE Transform helicopter into the method that is used by the
%selected model (stat, energy and rigid)

if strcmp(model,'dimensioning')
    
    he = heli; 
    
elseif strcmp(model,'energy')  
    
    he = stathe2ehe(atm,heli);
    
elseif strcmp(model,'rigid') 
    
    [optStatHe, Svt, cHTP] = optionData;
    he = stathe2rigidhe(heli,atm,cHTP,Svt,optStatHe); 
    
else 
    disp('transformHe error'); 
    he = heli;
end


end

