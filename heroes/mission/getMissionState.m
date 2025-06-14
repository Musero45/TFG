function [MfBurnt,missState] = getMissionState(he,atm,mission,PL0,Mf0,RF,varargin)
% getMissionState calculates the mission final state with all its segments 
% and fuel mass burnt during the mission for given helicopter,he, atmosphere, 
% atm, mission builder, mission, initial payload, PL0, initial fuel mass, 
% Mf0, and fuel reserve, RF.
%
% The output of this function is an array with the following fields:
%
%      MfBurnt: [1x1 double] fuel mass consumption during the mission [Kg]
%    missState: structure composed of fields missSet and mSeg
%
%       missSet is astructure composed of the following fields:
%
%             PL0: [1x1 double] initial payload [Kg]
%             Mf0: [1x1 double] initial fuel mass [Kg]
%              RF: [1x1 double] fuel reserve [Kg]
%
%       mSeg is a cell composed of the mission segments, being each segment 
%       a struct with the fields:
%
%           class: 'missionSegment'
%              id: [string], (segment's label)
%          solver: segment solver function
%             pos: [1x1 double] is the segment position
%               V: [1x2 double] is the segment flight velocity [m/s]
%          gammaT: [1x2 double] is the climb angle [rad]
%              VH: [1x2 double] is the segment flight horizontal velocity [m/s]
%              VV: [1x2 double] is the segment flight vertical velocity [m/s]
%           Omega: [1x2 double] is the main rotor angular velocity [rad/s]
%               Z: [1x2 double] is the flight segment height considered by 
%                               ground effect [m]
%               H: [1x2 double] is the flight segment altitude [m]
%              DH: [1x1 double] is the altitude increment during the flight 
%                               segment [m]
%               R: [1x2 double] is the flight segment range [m]
%              DR: [1x1 double] is the range increment during the flight 
%                               segment [m]
%               T: [1x2 double] is the segment flight time [s]
%              DT: [1x1 double] is the time increment during the segment 
%                               flight [s]
%              GW: [1x2 double] is the flight segment  gross weight [N]
%             DGW: [1x1 double] is the gross weight increment during the flight
%                               segment [N]
%              Mf: [1x2 double] is the flight segment fuel mass [Kg]
%             DMf: [1x1 double] is the fuel mass increment during the flight
%                               segment [Kg]
%              PL: [1x2 double] is the flight segment payload [N]
%             DPL: [1x1 double] is the payload increment during the flight 
%                               segment [N]
%               P: [1x2 double] is the power required in the flight segment [kW]
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
%
%   [MfBurnt,missState] = getMissionState(he,atm,mission,PL0,Mf0,RF);
%

options   = parseOptions(varargin,@setHeroesEnergyOptions);

% Definition of the mission pattern. With initial dummy phase 1

missState = missionIni(he,atm,PL0,Mf0,RF,options);

for m = 2:length(mission)+1
    
    missState.mSeg{m} = mission{m-1}(m);    
    
    segment = missState.mSeg{m}.solver(he,atm,missState,m,options);
    
    missState.mSeg{m} = segment.mSeg{m};

end

 MfBurnt = missionFuelMassConsumed(missState);
          
 end
 
 
