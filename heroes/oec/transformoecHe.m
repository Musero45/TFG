function he = transformoecHe(rigidHe,model,atm)
%TRANSFORMOECHE Transforms the helicopter into the required model depending
%on the model used for calculations 
%   This functions transforms the rigid helicopter into the required model:
%   stathelicopter, energyhelicopter or rigidhelicopter (invariant)

if strcmp(model,'dimensioning')
    
    he = rigidHe2stathe(rigidHe);
    
elseif strcmp(model,'energy') 
    
    he = rigidHe2ehe(rigidHe,atm);
    
elseif strcmp(model,'rigid')  
    
    he = rigidHe;   
    
else 
    disp('transformHe error'); 
    he = heli;
end


end

