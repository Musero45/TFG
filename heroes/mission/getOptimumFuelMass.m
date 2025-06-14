function Mf0opt = getOptimumFuelMass(he,atm,mission,PL0,Mf0,RF)
% getOptimunFuelMass calculates the initial fuel mass needed to complete 
% the mission with zero fuel mass at the end, for given helicopter, he,
% atmosphere, atm, mission builder, mission, initial payload, PL0, initial 
% fuel mass, Mf0, and fuel reserve, RF.
%
% The output of this function is optimum initial fuel mass:
%
%       Mf0opt: [1x1 double] fuel mass consumption during the mission.
% 
% Example of usage:
%
% % Atmosphere
%   atm = getISA;
% % Helicopter
%   he     = ec135e(atm);
%   OmegaN =  he.mainRotor.Omega;
% % Initial mission definition
%   PL0 = 1500;%N
%   Mf0 = 2000;%kg
%   RF  = 100;%kg
%   mission = {@(pos)HoverSegmentBuilder(pos,60,0,OmegaN),...
%              @(pos)TaxiSegmentBuilder(pos,100,4,0,OmegaN),...
%              @(pos)MinFuelClimb4VSegmentBuilder(pos,300,56,0,OmegaN),...
%              @(pos)CruiseRangeSegmentBuilder(pos,50*10^3,40,0,OmegaN),...
%              @(pos)DescendSegmentBuilder(pos,-100,10,-5*pi/180,0,OmegaN),...
%              @(pos)TaxiSegmentBuilder(pos,100,4,0,OmegaN)};
% % Mission
%   [MfBurnt,missState] = getMissionState(he,atm,mission,PL0,Mf0,RF);
% % Optimum initial fuel mass
%   Mf0opt = getOptimumFuelMass(he,atm,mission,PL0,Mf0,RF);
%

  goalFuel = @(Mf) (getMissionState(he,atm,mission,PL0,Mf,RF)-Mf);

   Mf0opt = fzero(goalFuel,Mf0);
   
end


