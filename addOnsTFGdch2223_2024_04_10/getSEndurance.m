function SEnd = getSEndurance(r4fRigidHe,V,H,ConFW,atm,vWT,FC4,options)

% SEnd = getSEndurence(r4fRigidHe,V,H,ConFW,atm,vWT,FC4,options) 
% provides the Specific Endurance SE [s/kg] for a given consumed fuel weight,
% ConFW. The consumed fuel weight ConFW is 0<=ConFW<=FW, being the FW, 
% the total fuel weight of the helicopter configuration
% 
% SEnd units are in s/kg

  he    = r4fRigidHe;
    
  FW0              = he.weightConf.FW;
  W0               = he.inertia.W;
  he.weightConf.FW = FW0-ConFW;
  he.inertia.W     = W0-ConFW;
     
  PM   = getRequiredPower(he,vWT,FC4,V,atm,H,options);
  SFC  = he.engine.PSFC;
  SEnd = (1./(SFC*PM));
    
end

    
