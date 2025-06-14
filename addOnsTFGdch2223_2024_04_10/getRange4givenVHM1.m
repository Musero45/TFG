function R = getRange4givenVHM1(r4fRigidHe,V,H,atm,vWT,FC4,options)
% R = getRange4givenVHM1(r4fRigidHe,V,H,atm,vWT,FC4,options) provides the
% range R [m] for a given velocity V [m/s], altitude H [m], wind velocity
% vector expressed in the ground reference system vWT [m/s] and 
% flight condition 4 FC4.
%
% The model uses the so called model 1 (M1) based in the hypotheis of
% constant weight = W0-FW/2, being W0 the initial weight and FW 
% the total fuel weight.


FW  = r4fRigidHe.weightConf.FW;
SAR = getSAR(r4fRigidHe,V,H,FW/2,atm,vWT,FC4,options);

R   = SAR*FW/atm.g;

end
