% clear all
close all

%Atmosphere
atm = getISA;

% Helicopter
he = ec135e(atm);

OmegaN =  he.mainRotor.Omega;

%Initial mission definition
PL0 = 150*atm.g;%N
Mf0 = 180;%kg
RF  = 65;%kg
       
mission = {@(pos)HoverSegmentBuilder(pos,60,0,OmegaN),...
           @(pos)TaxiSegmentBuilder(pos,100,4,0,OmegaN),...
           @(pos)ClimbSegmentBuilder(pos,650,50,15*pi/180,0,OmegaN),...
           @(pos)CruiseRangeSegmentBuilder(pos,50*10^3,60,0,OmegaN),...
           @(pos)GlideGammaTSegmentBuilder(pos,-300,-16.1116*pi/180,0,OmegaN),...
           @(pos)BestCruiseRangeSegmentBuilder(pos,100*10^3,0,OmegaN),...
           @(pos)BestClimbSegmentBuilder(pos,300,0,OmegaN),...
           @(pos)CruiseTimeSegmentBuilder(pos,600,50,0,OmegaN),...
           @(pos)GlideVSegmentBuilder(pos,-300,52.9831,0,OmegaN),...
           @(pos)BestCruiseTimeSegmentBuilder(pos,600,0,OmegaN),...
           @(pos)MinFuelClimb4VbSegmentBuilder(pos,300,0,OmegaN),...
           @(pos)MaxVelCruiseRangeBuilder(pos,50*10^3,0,OmegaN),...
           @(pos)DescentSegmentBuilder(pos,-100,40,-15*pi/180,0,OmegaN),...
           @(pos)GlideVhSegmentBuilder(pos,-200,40,0,OmegaN),...
           @(pos)MinFuelClimb4VSegmentBuilder(pos,300,50,0,OmegaN),...
           @(pos)GlideMinVSegmentBuilder(pos,-300,0,OmegaN),...
           @(pos)MinFuelClimb4VhSegmentBuilder(pos,300,40,0,OmegaN),...
           @(pos)GlideMinVvSegmentBuilder(pos,-100,0,OmegaN),...
           @(pos)BestGlideSegmentBuilder(pos,-550,0,OmegaN)};


[MfBurnt,missState] = getMissionState(he,atm,mission,PL0,Mf0,RF);

plotHelicopterMission(missState)

Mf0opt = getOptimumFuelMass(he,atm,mission,PL0,Mf0,RF);
 

% %%%%Some plots%%%%
% 
%  for s = 1:length(missState.mSeg);
%      
%      figure (1)
%      
%      subplot(2,2,1)
%      grid on
%      semilogx(missState.mSeg{s}.R,missState.mSeg{s}.Mf,'o-');
%      hold on
%      xlabel('R [m]');
%      ylabel('Mf [kg]');
%      
%      subplot(2,2,2)
%      grid on
%      plot(missState.mSeg{s}.T,missState.mSeg{s}.Mf,'o-');
%      hold on
%      xlabel('T [s]');
%      ylabel('Mf [kg]');
%      
%      subplot(2,2,3)
%      grid on
%      semilogx(missState.mSeg{s}.T,missState.mSeg{s}.R,'o-');
%      hold on
%      xlabel('T [s]');
%      ylabel('R [m]');
%      
%      subplot(2,2,4)
%      grid on
%      semilogx(missState.mSeg{s}.T,missState.mSeg{s}.V,'o-');
%      hold on
%      xlabel('T [s]');
%      ylabel('V [m/s]');
%      
%      
%      figure (2)
%      
%      subplot(2,2,1)
%      grid on
%      semilogx(missState.mSeg{s}.R,missState.mSeg{s}.H,'o-');
%      hold on
%      xlabel('R [m]');
%      ylabel('H [m]');
%      
%      subplot(2,2,2)
%      grid on
%      semilogx(missState.mSeg{s}.T,missState.mSeg{s}.H,'o-');
%      hold on
%      xlabel('T [s]');
%      ylabel('H [m]');
%      
%      subplot(2,2,3)
%      grid on
%      plot(missState.mSeg{s}.T,missState.mSeg{s}.P/10^3,'o-');
%      hold on
%      xlabel('T [s]');
%      ylabel('P [kW]');
%      
%      subplot(2,2,4)
%      grid on
%      plot(missState.mSeg{s}.T,missState.mSeg{s}.GW,'o-');
%      hold on
%      xlabel('T [s]');
%      ylabel('GW [kg]');
%      
%      
%           
%  end
