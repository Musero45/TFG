function [gammaT_mgT VV_mgT VH_mgT]    = gammaTminGammaT(he,fC,atm,varargin)
%   Get the minimum gammaT for a given value of power


options    = parseOptions(varargin,@setHeroesEnergyOptions);

% Power goal
PCgoal = fC.P;

% System resolution
gamma0             = pi/180.*[0  -90];
gammaEnergy        = @(gammaT) defineGoal(gammaT,he,fC,PCgoal,atm,options);
ops                = optimset('Display','off');
gammaT_mgT         = fzero(gammaEnergy,gamma0,ops);

% Define output
fC.gammaT          = gammaT_mgT;
v_gTmin            = vMaxEndurance(he,fC,atm,options);
VV_mgT             = v_gTmin*sin(gammaT_mgT);
VH_mgT             = v_gTmin*cos(gammaT_mgT);

function f = defineGoal(gammaT,he,fC,PCg,atm,options)

fC.gammaT = gammaT;
[vCc,PCc] = vMaxEndurance(he,fC,atm,options);
f  = PCg-PCc;


