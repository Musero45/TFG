function SAR = getSAR(r4fRigidHe,V,H,ConFW,atm,vWT,FC4,options)

% SAR = getSAR(r4fRigidHe,V,H,ConFW,atm,vWT,FC4,options) provides the
% Specific Air Range SAR [m/kg] for given flight velocity V [m/s],
% altitude H [m], consumed fuel weight ConFW [N]. The consumed fuel
% weight ConFW is 0<=ConFW<=FW, being the FW, the total fuel weight of
% the helicopter configuration.
%
% FC4 is the flight condition 4 and vWT is the wind velocity vector in
% ground reference system
% 
% SAR units are in m/kg

  he    = r4fRigidHe;
    
  FW0              = he.weightConf.FW;
  W0               = he.inertia.W;
       
  he.weightConf.FW = FW0-ConFW;
  he.inertia.W     = W0-ConFW;
    
  PM  = getRequiredPower(he,vWT,FC4,V,atm,H,options);
  SFC = he.engine.PSFC;
  SAR = (V'./(SFC*PM));
  
  end
    


    
