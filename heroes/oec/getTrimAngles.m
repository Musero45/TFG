function [Theta, Phi] = getTrimAngles(he,muAx,atm)
%GETTRIMANGLES Obtains the trim angles in function of the fC
%   This function is udes to evaluate the angles Phi and Theta in order to
%   verify this angles as fisical restrictions


% Options
opt1       = {... 
              'linearInflow',@LMTCuerva,...
              'mrForces',@thrustF,...
              'trForces',@thrustF,...
              'mrMoments',@aerodynamicM,...
              'trMoments',@aerodynamicM,...
              'GT',0};
options    = parseOptions(opt1,@setHeroesRigidOptions);

% Flight condition
mu   = [muAx;0;0];
muWT = [0; 0; 0];
flightConditionT = [mu;muWT];

% Non dimentional helicopter
ndHe = rigidHe2ndHe(he,atm,0); % FIXME it is only valid for sea level

% Obtain trim state
trimState   = getTrimState(flightConditionT,muWT,ndHe,options);

% Theta and Phi angles
Theta = trimState.Theta;
Phi   = trimState.Phi;

end




