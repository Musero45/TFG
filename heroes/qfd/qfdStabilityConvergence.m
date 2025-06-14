function whalf = qfdStabilityConvergence(rigidhe,MissionSegments,atm)
%QFDSTABILITYCONVERGENCE Select here your model to calculate stability

V       = 55; % Speed in [m/s]
htest   = 0;  % test height

PL = MissionSegments.PayLoad;
MF = rigidhe.inertia.MFW/atm.g;
rigidhe = addMissionWeightsRigid(rigidhe,PL,MF,0,atm);

disp('[Trim and linear stability state previous calculations for convergence mode]')

modos = StabilityModes(rigidhe,V,htest);

disp('[Trim and linear stability states: DONE]')

thalf = modos.MaxRealvalue.thalf;
modo1 = modos.MaxRealvalue.Modetype;
modo1 = regexp(modo1,',','split');
modo1 = modo1{1};

if  strcmp(modo1 ,'convergent')
    thalf = abs(thalf);
    whalf = 1/thalf;
elseif strcmp(modo1 ,'divergent') 
    thalf = -abs(thalf);
    whalf = 1/thalf;
elseif strcmp(modo1 ,'constant amplitude')
    whalf = 0;
else 
    thalf = abs(thalf);
    whalf = 1/thalf;
end


end

