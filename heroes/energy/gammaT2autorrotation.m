function [gTmin,v_gTmin,PC_gTmin]    = gammaT2autorrotation(he,fC,atm,varargin)
%   Get the gammaT of climbing in autorrotation for max endurance in this
%     flight condition



options    = parseOptions(varargin,@setHeroesEnergyOptions);

% flight condition
H       = fC.H;
Z       = fC.Z;


% Power goal
PCgoal = 0;

% System resolution
gamma0   = pi/180.*[0  -90];
gammaEnergy  = @(gammaT) defineGoal(gammaT,he,fC,PCgoal,atm,options);
ops = optimset('Display','off');
gTmin  = fzero(gammaEnergy,gamma0,ops);

fC.gammaT = gTmin;
[v_gTmin,PC_gTmin] = vMaxEndurance(he,fC,atm,options);

function f = defineGoal(gammaT,he,fC,PCg,atm,options)

fC.gammaT = gammaT;
[vCc,PCc] = vMaxEndurance(he,fC,atm,options);
f  = PCg-PCc;


