function T = qfdStabilityOscillation(rigidhe,MissionSegments,atm)
%QFDSTABILITYOSCILLATION Select here your model to calculate stability

V       = 55; % Speed in [m/s]
htest   = 0;  % test height

PL = MissionSegments.PayLoad;
MF = rigidhe.inertia.MFW/atm.g;
rigidhe = addMissionWeightsRigid(rigidhe,PL,MF,0,atm);

disp('[Trim and linear stability state previous calculations for oscillation mode]')

modos = StabilityModes(rigidhe,V,htest);

disp('[Trim and linear stability states: DONE]')

T    = modos.MaxImagvalue.T;
modo = modos.MaxImagvalue.Modetype;
modo = regexp(modo,',','split');
modo = modo{2};

if  strcmp(modo ,'oscillatory')
    T = abs(T);
elseif strcmp(modo ,'non oscillatory') 
    T = 0;
else 
    T = abs(T);
end

end

