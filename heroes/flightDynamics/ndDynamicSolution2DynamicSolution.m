function DynamicState = ndDynamicSolution2DynamicSolution(ndDynamicSolution,he)
% ndDynamicSolution2DynamicSolution gives dimensional sense to a non
% dimensional Dynamic solution
%
% DYNSTATE = ndDynamicSolution2DynamicSolution(NDDYNSOL,HE)
% Transformation from nondimensional variables of state, trajectory and 
% time from NDDYNSOL, to dimensional ones for the helicopter HE.
% 
% 
% See also getndHeLinDynSolution, getndHeNonLinearDynamics

Omega      = he.mainRotor.Omega;
R          = he.mainRotor.R;
OR         = Omega*R;


statesolution  = struct('u',ndDynamicSolution.ndstate.uOR*OR,...
                        'w',ndDynamicSolution.ndstate.wOR*OR,...
                        'omy',ndDynamicSolution.ndstate.omyad*Omega,...
                        'Theta',ndDynamicSolution.ndstate.Theta,...
                        'v',ndDynamicSolution.ndstate.vOR*OR,...
                        'omx',ndDynamicSolution.ndstate.omxad*Omega,...
                        'Phi',ndDynamicSolution.ndstate.Phi,...
                        'omz',ndDynamicSolution.ndstate.omzad*Omega,...
                        'Psi',ndDynamicSolution.ndstate.Psi,...
                        'Delta_u',ndDynamicSolution.ndstate.Delta_uOR*OR,...
                        'Delta_w',ndDynamicSolution.ndstate.Delta_wOR*OR,...
                        'Delta_omy',ndDynamicSolution.ndstate.Delta_omyad*Omega,...
                        'Delta_Theta',ndDynamicSolution.ndstate.Delta_Theta,...
                        'Delta_v',ndDynamicSolution.ndstate.Delta_vOR*OR,...
                        'Delta_omx',ndDynamicSolution.ndstate.Delta_omxad*Omega,...
                        'Delta_Phi',ndDynamicSolution.ndstate.Delta_Phi,...
                        'Delta_omz',ndDynamicSolution.ndstate.Delta_omzad*Omega,...
                        'Delta_Psi',ndDynamicSolution.ndstate.Delta_Psi);
                    
trajectorysolution = struct('xT0trim',ndDynamicSolution.ndtrajectory.ndxT0trim*R,...
                            'yT0trim',ndDynamicSolution.ndtrajectory.ndyT0trim*R,...
                            'zT0trim',ndDynamicSolution.ndtrajectory.ndzT0trim*R,...
                            'DeltaxT0',ndDynamicSolution.ndtrajectory.DeltandxT0*R,...
                            'DeltayT0',ndDynamicSolution.ndtrajectory.DeltandyT0*R,...
                            'DeltazT0',ndDynamicSolution.ndtrajectory.DeltandzT0*R,...
                            'xG',ndDynamicSolution.ndtrajectory.ndxG*R,...
                            'yG',ndDynamicSolution.ndtrajectory.ndyG*R,...
                            'zG',ndDynamicSolution.ndtrajectory.ndzG*R);

controlsolution    = ndDynamicSolution.control;

timesolution        = struct('solution',ndDynamicSolution.tau.solution/Omega);


DynamicState   =  struct('state',statesolution,...
                         'trajectory',trajectorysolution,...
                         'control',controlsolution,...
                         'time',timesolution); 
                     
end

