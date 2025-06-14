function R = getRange4givenVHM2(r4fRigidHe,V,H,atm,vWT,FC4,options)
% R = getRange4givenVHM2(r4fRigidHe,V,H,atm,vWT,FC4,options) provides the
% range R [m], for a given velocity V [m/s], altitude H [m], wind velocity
% vector expressed in the ground reference system vWT [m/s] and 
% flight condition 4 FC4.
%
% The so called model M2 considers the variation of fuel weight, and,
% therefore the variation of required power PM for fixed V and H due to
% the variation of weight

 FW       = r4fRigidHe.weightConf.FW;
 ConFWvec = linspace(0,FW,15);

 for i = 1:length(ConFWvec)
     
    ConFW = ConFWvec(i);
    SAR(:,i) = getSAR(r4fRigidHe,V,H,ConFW,atm,vWT,FC4,options);
 
 end
 
 R = (1/atm.g)*trapz(ConFWvec,SAR,2);

end