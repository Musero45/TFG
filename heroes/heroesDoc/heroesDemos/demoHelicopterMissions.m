%% Helicopter missions
%
% This demo shows the usage of mission module to help in the construction 
% of helicopters missions. 
% 
%
%% Introduction 
%
% The term _*mission*_ refers to the intended use of the aircraft and 
% determines its design since it specifies what is required in the usage 
% of the helicopter. These requirements are used in the design chain to 
% evaluate the quality and need to be studied in order to check if a 
% helicopter is able to carry out what is entrusted.
%
% Mission is a set of flight segments that need to be executed under agreed 
% conditions. The choice of flight variables included in these segments 
% must be consistent with what the mission requires and therefore being 
% able to calculate all that is needed. A mission involves burning fuel 
% during its performance, so it is necessary to consider modifying the mass 
% conditions along it.
% 
% To verify the performance of a task by a helicopter, it is required to 
% develop the tools to configure this mission. To do this, it will proceed 
% first by defining the elements forming a mission.
%
%
close all
setPlot

%% Description of usage
%
% The example chosen to assist the usage of this module, mission, is that 
% of a simple mission formed by a pair of segments. It is displayed below:
%
%%
% First we always have to set up heroes environment by defining an ISA+0 
% atmosphere and a Eurocopter EC135 helicopter. The variable _*atm*_ stores 
% the atmosphere, _*he*_ stores the helicopter and _*OmegaN*_ saves  the
% main rotor angular speed of the helicopter setup.

atm    = getISA;
he     = ec135e(atm);
OmegaN = he.mainRotor.Omega;

%%
% Then, the payload, the initial fuel mass and the fuel reserve are set up.
% It is important to remember that the payload dimensions are _[N]_, and 
% the dimensions of fuel mass and fuel reserve are _[Kg]_.
%
% The Reserve of fuel must be set according to the regulations:
% In the case of VFR operations, the regulations establish that the fuel 
% reserves should be enough to fly for 20 minutes at maximum speed range. 
% While in the case of IFR, fuel reserve must be sufficient to fly for 
% 30 minutes at hover speed at 450 m (1500 ft) above the aerodrome of 
% destination.

PL0 = 150*atm.g;
Mf0 = 100;
RF  = 65;

%%
% Once the mission requirements have been loaded, it is necessary to define
% the type of mission to be performed by the selected helicopter, in this 
% case the Eurocopter EC135.
% Each segment needs several inputs, being the first, last and penultimate 
% entries common for all segment builders. These three inputs correspond 
% respectively to the segment position, the main rotor angular speed and 
% payload variation of the flight segment. The other inputs are different
% for each segment and match with for example, the hight variation of the 
% flight segment, ascent or descent angle, the time increment of the flight 
% segment and other variables. The help of each segment builder explains 
% all the inputs needed for this segment.

mission = {@(pos)TaxiSegmentBuilder(pos,120,4,0,OmegaN),...
           @(pos)ClimbSegmentBuilder(pos,580,36,5*pi/180,0,OmegaN)};
%%
% A list of all possible segments, as well as all the requested help for 
% building helicopter missions can be found by typing on cosole:
% 
%       >> help mission
%
%%
% Next step, after defining the required mission, is to solve the whole 
% mission using _*getMissionState*_. This function saves the results of the 
% mission in two variables, _*MfBurnt*_ and _*missState*_.
%
% * _*MfBurnt*_ stores the fuel mass consumed during the mission, which has 
% been obtained with the given initial parameters.
%
% * _*missState*_ saves the mission segments parameters. 
%
% The help of this function explains how these variables are, which the 
% saved parameters are and how to use the function.
%
% In order to calculate the mission, this function includes a dummy hover
% segment which is common for all the missions. That is why, in _*missState*_
% this dummy hover segment is the first saved and then saves the rest of 
% them. So the final number of segments is, in this case, three.
%

[MfBurnt,missState] = getMissionState(he,atm,mission,PL0,Mf0,RF);

%%
% Finally, this module aims to optimize the fuel mass that the helicopter 
% should carry to complete the mission without problems and with zero fuel 
% mass at the end. This optimization is carried out with the function
% _*getOptimumFuelMass*_ and the optimum initial fuel mass obtained is kept 
% in the variable _*Mf0opt*_.
%

Mf0opt = getOptimumFuelMass(he,atm,mission,PL0,Mf0,RF);

%%
% After obtaining the results of the mission, it is useful plotting these 
% results to see what is the mission state and to check if it was 
% successful.
%
% The most representative plot of the mission route is the hight versus
% the range.
%

for s = 1:length(missState.mSeg);
     
     figure (100)
     grid on
     plot(missState.mSeg{s}.R,missState.mSeg{s}.H,'o-');
     hold on
     xlabel('R [m]');
     ylabel('H [m]');
                
end

%%
% Another representative plot of the mission parameters is the fuel mass
% variation and the payload variation with range and time
 
for s = 1:length(missState.mSeg);
     
     figure (102)
     
     subplot(2,2,1)
     grid on
     plot(missState.mSeg{s}.R,missState.mSeg{s}.Mf,'o-');
     hold on
     xlabel('R [m]');
     ylabel('Mf [kg]');
     
     subplot(2,2,2)
     grid on
     plot(missState.mSeg{s}.T,missState.mSeg{s}.Mf,'o-');
     hold on
     xlabel('T [s]');
     ylabel('Mf [kg]');
     
     subplot(2,2,3)
     grid on
     plot(missState.mSeg{s}.R,missState.mSeg{s}.PL,'o-');
     hold on
     xlabel('R [m]');
     ylabel('PL [N]');
     
     subplot(2,2,4)
     grid on
     plot(missState.mSeg{s}.T,missState.mSeg{s}.PL,'o-');
     hold on
     xlabel('T [s]');
     ylabel('PL [N]');
    
end

%%
% At the end, other important plots could be the following:

for s = 1:length(missState.mSeg);
     
     figure (103)
     
     subplot(2,2,1)
     grid on
     plot(missState.mSeg{s}.T,missState.mSeg{s}.V,'o-');
     hold on
     xlabel('T [s]');
     ylabel('V [m/s]');
     
     subplot(2,2,2)
     grid on
     x = missState.mSeg{s}.T;
     y = missState.mSeg{s}.R;
     plot(x,y,'o-');
     hold on
     ylabel('R [m]');
     xlabel('T [s]');
     
     subplot(2,2,3)
     grid on
     plot(missState.mSeg{s}.T,missState.mSeg{s}.H,'o-');
     hold on
     xlabel('T [s]');
     ylabel('H [m]');
     
     subplot(2,2,4)
     grid on
     plot(missState.mSeg{s}.T,missState.mSeg{s}.P/10^3,'o-');
     hold on
     xlabel('T [s]');
     ylabel('P [kW]');
              
end


%% Example of a simple mission type: Civil Surveillance Mission
%
% One of the easiest helicopter missions is the *Civil Surveillance*
% *Mission*. This mission type has seven segments, without counting the 
% dummy segment, in which a cruise speed of maximum endurance is included. 
% The reason of this type of cruise segment is that the aim of the mission 
% consists on surveilling an area for the maximum, possible time. After 
% this cruise, there is a hover flight segment to focuse on the main area 
% of the surveillance. 
%
%%
% First we setup heroes environment by defining an ISA+0 atmosphere and a 
% Eurocopter EC135 helicopter. The variable _*atm*_ stores the atmosphere, 
% _*he*_ stores the helicopter and _*OmegaN*_ saves the main rotor angular 
% speed.

atm    = getISA;
he     = ec135e(atm);
OmegaN = he.mainRotor.Omega;

%%
% Then the payload, the initial fuel mass and the fuel reserve are setup.
% Remember that the payload dimensions are _[N]_, and the dimensions of 
% fuel mass and reserve of fuel are _[Kg]_.
%

PL0 = 150*atm.g;
Mf0 = 120;
RF  = 65;

%%
% In this type of mission the payload variation is zero, all necessary 
% payload is set up at the begining of the mission and it is not variable 
% through the mission.
%
%% 
% Now, we have to define the mission segments:
%
% First, there is a _*HOVER*_ segment which will be defined by the time 
% increment, DT, and like all segments, by payload variation and the main
% rotor angular speed. The second is a _*TAXI*_ segment, it is defined by
% time increment, DT, and flight velocity, DV. For defining the third
% segment, _*CLIMB*_, we have as inputs hight increment,DH, the flight
% velocity, DV, and the ascent angle, gammaT. The fourth segment is a
% _*CRUISE*_, which is defined only by time increment, DT, because this
% segment is calculated with the maximum endurance velocity. The fifth
% mission segment is a _*HOVER*_, defined as in the previous case. Finally,
% the mission has a _*DESCENT*_ segment defined as a climb segment but with
% negative angle and negative hight increment, and a _*TAXI*_ segment 
% defined as in the previous case.
%

mission = {@(pos)HoverSegmentBuilder(pos,60,0,OmegaN),...
           @(pos)TaxiSegmentBuilder(pos,90,4,0,OmegaN),...
           @(pos)ClimbSegmentBuilder(pos,650,30,15*pi/180,0,OmegaN),...
           @(pos)BestCruiseTimeSegmentBuilder(pos,3600,0,OmegaN),...
           @(pos)HoverSegmentBuilder(pos,180,0,OmegaN),...
           @(pos)DescentSegmentBuilder(pos,-650,30,-15*pi/180,0,OmegaN),...
           @(pos)TaxiSegmentBuilder(pos,90,4,0,OmegaN)};
%%
% Remember that a list of all possible segments, as well as all the 
% requested help for building helicopter missions can be found by typing 
% on cosole:
% 
%       >> help mission
%
%%
% In this moment we are ready to solve the mission:
%

[MfBurnt,missState] = getMissionState(he,atm,mission,PL0,Mf0,RF);

disp('Civil Surveillance Mission')
formatSpec = 'The consumed fuel mass is %d.';
A    = MfBurnt;
MfB1 = sprintf(formatSpec,A);
disp(MfB1);

%%
% Once the fuel mass consumption and mission state are obtained, we can
% optimize the initial fuel mass to carry out the mission without problem,
% with the minimum initial fuel masss possible.
%

Mf0opt = getOptimumFuelMass(he,atm,mission,PL0,Mf0,RF);

formatSpec = 'The optimum fuel mass is %d.';
B    = Mf0opt;
MfO1 = sprintf(formatSpec,B);
disp(MfO1);

%%
% Sometimes it may also be useful to print some mission data. For example
% the total mission time or the range the climb segment takes.
%
formatSpec = 'The total mission time is %d.';
C  = missState.mSeg{8}.T(2);
C1 = sprintf(formatSpec,C);
disp(C1);

formatSpec = 'The range the climb segment takes is %d.';
D  = missState.mSeg{4}.DR;
D1 = sprintf(formatSpec,D);
disp(D1);

%%
% Finally we can plot some mission parameters to see the mission final
% state.

for s = 1:length(missState.mSeg);
     
     figure (104)
     grid on
     plot(missState.mSeg{s}.R,missState.mSeg{s}.H,'o-');
     hold on
     xlabel('R [m]');
     ylabel('H [m]');
      
end

%%
for s = 1:length(missState.mSeg); 
     figure (105)
     
     subplot(2,2,1)
     grid on
     plot(missState.mSeg{s}.R,missState.mSeg{s}.Mf,'o-');
     hold on
     xlabel('R [m]');
     ylabel('Mf [kg]');
     
     subplot(2,2,2)
     grid on
     plot(missState.mSeg{s}.T,missState.mSeg{s}.Mf,'o-');
     hold on
     xlabel('T [s]');
     ylabel('Mf [kg]');
     
     subplot(2,2,3)
     grid on
     plot(missState.mSeg{s}.R,missState.mSeg{s}.PL,'o-');
     hold on
     xlabel('R [m]');
     ylabel('PL [N]');
     
     subplot(2,2,4)
     grid on
     plot(missState.mSeg{s}.T,missState.mSeg{s}.PL,'o-');
     hold on
     xlabel('T [s]');
     ylabel('PL [N]');
     
end

%%
for s = 1:length(missState.mSeg);
     figure (106)
     
     subplot(2,2,1)
     grid on
     plot(missState.mSeg{s}.T,missState.mSeg{s}.V,'o-');
     hold on
     xlabel('T [s]');
     ylabel('V [m/s]');
     
     subplot(2,2,2)
     grid on
     x = missState.mSeg{s}.T;
     y = missState.mSeg{s}.R;
     plot(x,y,'o-');
     hold on
     ylabel('R [m]');
     xlabel('T [s]');
     
     subplot(2,2,3)
     grid on
     plot(missState.mSeg{s}.T,missState.mSeg{s}.H,'o-');
     hold on
     xlabel('T [s]');
     ylabel('H [m]');
     
     subplot(2,2,4)
     grid on
     plot(missState.mSeg{s}.T,missState.mSeg{s}.P/10^3,'o-');
     hold on
     xlabel('T [s]');
     ylabel('P [kW]');
     
end

%% Example of a complex mission type: Civil Firefighting Mission
%
% In firefighting mission,it is difficult to define the segments 
% compounding this mission because the refill segments for the complete 
% extinction of fire are not defined. 
% The time a helicopter can be extinguishing a fire is regulated, and 
% usually it is set to two hours. So there are two possible ways to set the 
% refill and extinction mission segments.
%
% * Fixing a number of segments
%
% * Fixing the maximum time of extinction
%
%%
% *Fixing number of segments:*
%
% In this case, the number of water refills must be fixed at first. Since 
% the extinction time is limited for two hours, once the mission is 
% calculated you should check if this constraint is satisfied by the number 
% of segments that had been planned for the mission.
% 
% Example of usage:
% 
% First we setup heroes environment, a helicopter and the initial payload 
% and fuel mass and the fuel reserve:
% 

atm    = getISA;
he     = ec135e(atm);
OmegaN = he.mainRotor.Omega;

PL0 = 150*atm.g;
Mf0 = 130;
RF  = 65;

%%
% Setting the mission segments. 
% 
% *Refills number: 1* Segments involved in the extinction of fire must be
% repeated as much times as refills number.
%
% The segments involved in the filling and discharge of water for the 
% extinction are:
%
% *DescentSegment*     for approaching the sea, lake or dam.
% *HoverSegment*       for refilling water.
% *ClimbSegment*       for ascending at flight hight.
% *CruiseRangeSegment* for reaching the fire area.
% *DescentSegment*     for approaching the fire area.
% *CruiseRangeCruise*  for discharging the water.
% *ClimbSegment*       for ascending at flight hight.
% *CruiseRangeSegment* for returning to the sea, lake or dam.
%
% In such a mission, payload variation must be considered due to the charge 
% and discharge of water.

mission = {... Route heliport - area of water
           @(pos)HoverSegmentBuilder(pos,60,0,OmegaN),...
           @(pos)MinFuelClimb4VSegmentBuilder(pos,300,40,0,OmegaN),...
           @(pos)BestCruiseRangeSegmentBuilder(pos,4*10^4,0,OmegaN),...
           ... 1 refill and discharge of water
           @(pos)BestGlideSegmentBuilder(pos,-280,0,OmegaN),...
           @(pos)HoverSegmentBuilder(pos,30,10^4,OmegaN),...
           @(pos)MinFuelClimb4VSegmentBuilder(pos,280,40,0,OmegaN),...
           @(pos)BestCruiseRangeSegmentBuilder(pos,3*10^4,0,OmegaN),...
           @(pos)BestGlideSegmentBuilder(pos,-200,0,OmegaN),...
           @(pos)BestCruiseRangeSegmentBuilder(pos,1000,-10^4,OmegaN),...
           ... Back to the heliport
           @(pos)MinFuelClimb4VSegmentBuilder(pos,380,40,0,OmegaN),...
           @(pos)BestCruiseRangeSegmentBuilder(pos,71*10^3,0,OmegaN),...
           @(pos)BestGlideSegmentBuilder(pos,-480,0,OmegaN),...
           @(pos)TaxiSegmentBuilder(pos,72,4,0,OmegaN)};
       
%%
% Remember that a list of all possible segments, as well as all the 
% requested help for building helicopter missions can be found by typing 
% on cosole:
% 
%       >> help mission
%
%%
% Solving the mission and optimizing initial fuel mass:
%

[MfBurnt,missState] = getMissionState(he,atm,mission,PL0,Mf0,RF);

disp('Civil Firefighting Mission')
formatSpec = 'The consumed fuel mass is %d.';
E    = MfBurnt;
MfB2 = sprintf(formatSpec,E);
disp(MfB2);


Mf0opt = getOptimumFuelMass(he,atm,mission,PL0,Mf0,RF);

formatSpec = 'The optimum fuel mass is %d.';
F    = Mf0opt;
MfO2 = sprintf(formatSpec,F);
disp(MfO2);

%%
% Finally some plots to see the final state of the mission.

for s = 1:length(missState.mSeg);
     
     figure (107)
     grid on
     plot(missState.mSeg{s}.R,missState.mSeg{s}.H,'o-');
     hold on
     xlabel('R [m]');
     ylabel('H [m]');
      
end

%%
for s = 1:length(missState.mSeg); 
     figure (108)
     
     subplot(2,2,1)
     grid on
     plot(missState.mSeg{s}.R,missState.mSeg{s}.Mf,'o-');
     hold on
     xlabel('R [m]');
     ylabel('Mf [kg]');
     
     subplot(2,2,2)
     grid on
     plot(missState.mSeg{s}.T,missState.mSeg{s}.Mf,'o-');
     hold on
     xlabel('T [s]');
     ylabel('Mf [kg]');
     
     subplot(2,2,3)
     grid on
     plot(missState.mSeg{s}.R,missState.mSeg{s}.PL,'o-');
     hold on
     xlabel('R [m]');
     ylabel('PL [N]');
     
     subplot(2,2,4)
     grid on
     plot(missState.mSeg{s}.T,missState.mSeg{s}.PL,'o-');
     hold on
     xlabel('T [s]');
     ylabel('PL [N]');
     
end

%%
for s = 1:length(missState.mSeg);
     figure (109)
     
     subplot(2,2,1)
     grid on
     plot(missState.mSeg{s}.T,missState.mSeg{s}.V,'o-');
     hold on
     xlabel('T [s]');
     ylabel('V [m/s]');
     
     subplot(2,2,2)
     grid on
     x = missState.mSeg{s}.T;
     y = missState.mSeg{s}.R;
     plot(x,y,'o-');
     hold on
     ylabel('R [m]');
     xlabel('T [s]');
     
     subplot(2,2,3)
     grid on
     plot(missState.mSeg{s}.T,missState.mSeg{s}.H,'o-');
     hold on
     xlabel('T [s]');
     ylabel('H [m]');
     
     subplot(2,2,4)
     grid on
     plot(missState.mSeg{s}.T,missState.mSeg{s}.P/10^3,'o-');
     hold on
     xlabel('T [s]');
     ylabel('P [kW]');
     
end

%%
% *Fixing the maximum time of extinction:*
%
% In this other case, the extinction time is fixed for two hours and in
% this way the segments are fixed with this constrain too.
% 
% First we setup heroes environment, a helicopter and the initial payload 
% and fuel mass and the fuel reserve:
%

atm    = getISA;
he     = ec135e(atm);
OmegaN =  he.mainRotor.Omega;

PL0  = 180*atm.g;
Mf0  = 300;
RF   = 65;
%%
% It is also necessary to setup the maximum allowed time for the
% fire extinction, specified by the regulations of the country.

Tmax = 7200;

%%
% Now the maximum number of possible refills for this specified time is
% calculated. To do that, it is necessary to calculate the time employed 
% to perform the water refilling  and fire fighting segments.
%
% The segments involved in the filling and discharge of water for the 
% extinction are:
%
% *DescentSegment*     for approaching the sea, lake or dam.
% *HoverSegment*       for refilling water.
% *ClimbSegment*       for ascending at flight hight.
% *CruiseRangeSegment* for reaching the fire area.
% *DescentSegment*     for approaching the fire area.
% *CruiseRangeCruise*  for discharging the water.
% *ClimbSegment*       for ascending at flight hight.
% *CruiseRangeSegment* for returning to the sea, lake or dam.
%

extinctionPlan = {... Route heliport - area of water
                  @(pos)HoverSegmentBuilder(pos,60,0,OmegaN),...
                  @(pos)MinFuelClimb4VSegmentBuilder(pos,550,40,0,OmegaN),...
                  @(pos)BestCruiseRangeSegmentBuilder(pos,10^4,0,OmegaN),...
                  ... Extinction plan 
                  @(pos)BestGlideSegmentBuilder(pos,-540,0,OmegaN),...
                  @(pos)HoverSegmentBuilder(pos,30,10^4,OmegaN),...
                  @(pos)MinFuelClimb4VSegmentBuilder(pos,540,40,0,OmegaN),...
                  @(pos)BestCruiseRangeSegmentBuilder(pos,3*10^4,0,OmegaN),...
                  @(pos)BestGlideSegmentBuilder(pos,-450,0,OmegaN),...
                  @(pos)BestCruiseRangeSegmentBuilder(pos,1000,-10^4,OmegaN),...
                  @(pos)MinFuelClimb4VSegmentBuilder(pos,450,40,0,OmegaN),...
                  @(pos)BestCruiseRangeSegmentBuilder(pos,3.6*10^4,0,OmegaN)};

%%
% Remember that a list of all possible segments, as well as all the 
% requested help for building helicopter missions can be found by typing 
% on cosole:
% 
%       >> help mission
%

[MfBurntExt,missStateExt] = getMissionState(he,atm,extinctionPlan,PL0,Mf0,RF);

iniTime2Water  = missStateExt.mSeg{1}.DT + missStateExt.mSeg{2}.DT + ...
                 missStateExt.mSeg{3}.DT + missStateExt.mSeg{4}.DT;

extinctionTime = missStateExt.mSeg{5}.DT  + missStateExt.mSeg{6}.DT + ...
                 missStateExt.mSeg{7}.DT  + missStateExt.mSeg{8}.DT + ...
                 missStateExt.mSeg{9}.DT  + missStateExt.mSeg{10}.DT + ...
                 missStateExt.mSeg{11}.DT + missStateExt.mSeg{12}.DT ;
             
%%
% Calculating the possible extinctions number:

extinctionsNumber = floor ( (Tmax - iniTime2Water) / extinctionTime );

disp('Civil Firefighting Mission');

formatSpec = 'The Extinctions Number is %d.';
G      = extinctionsNumber;
extNum = sprintf(formatSpec,G);
disp(extNum);

%%
% Once the extinction number is calculated, it is possible to define the
% entire mission.
%
mission = {... Route heliport - area of water 
           @(pos)HoverSegmentBuilder(pos,60,0,OmegaN),...
           @(pos)MinFuelClimb4VSegmentBuilder(pos,550,40,0,OmegaN),...
           @(pos)BestCruiseRangeSegmentBuilder(pos,10^4,0,OmegaN),...
           ... 1 refill and discharge of water
           @(pos)BestGlideSegmentBuilder(pos,-540,0,OmegaN),...
           @(pos)HoverSegmentBuilder(pos,30,10^4,OmegaN),...
           @(pos)MinFuelClimb4VSegmentBuilder(pos,540,40,0,OmegaN),...
           @(pos)BestCruiseRangeSegmentBuilder(pos,3*10^4,0,OmegaN),...
           @(pos)BestGlideSegmentBuilder(pos,-450,0,OmegaN),...
           @(pos)BestCruiseRangeSegmentBuilder(pos,1000,-10^4,OmegaN),...
           @(pos)MinFuelClimb4VSegmentBuilder(pos,450,40,0,OmegaN),...
           @(pos)BestCruiseRangeSegmentBuilder(pos,3.6*10^4,0,OmegaN),...
           ... 2 refill and discharge of water
           @(pos)BestGlideSegmentBuilder(pos,-540,0,OmegaN),...
           @(pos)HoverSegmentBuilder(pos,30,10^4,OmegaN),...
           @(pos)MinFuelClimb4VSegmentBuilder(pos,540,40,0,OmegaN),...
           @(pos)BestCruiseRangeSegmentBuilder(pos,3*10^4,0,OmegaN),...
           @(pos)BestGlideSegmentBuilder(pos,-450,0,OmegaN),...
           @(pos)BestCruiseRangeSegmentBuilder(pos,1000,-10^4,OmegaN),...
           @(pos)MinFuelClimb4VSegmentBuilder(pos,450,40,0,OmegaN),...
           @(pos)BestCruiseRangeSegmentBuilder(pos,3.6*10^4,0,OmegaN),...
           ... 3 refill and discharge of water
           @(pos)BestGlideSegmentBuilder(pos,-540,0,OmegaN),...
           @(pos)HoverSegmentBuilder(pos,30,10^4,OmegaN),...
           @(pos)MinFuelClimb4VSegmentBuilder(pos,540,40,0,OmegaN),...
           @(pos)BestCruiseRangeSegmentBuilder(pos,3*10^4,0,OmegaN),...
           @(pos)BestGlideSegmentBuilder(pos,-450,0,OmegaN),...
           @(pos)BestCruiseRangeSegmentBuilder(pos,1000,-10^4,OmegaN),...
           @(pos)MinFuelClimb4VSegmentBuilder(pos,450,40,0,OmegaN),...
           @(pos)BestCruiseRangeSegmentBuilder(pos,3.6*10^4,0,OmegaN),...
           ... 4 refill and discharge of water
           @(pos)BestGlideSegmentBuilder(pos,-540,0,OmegaN),...
           @(pos)HoverSegmentBuilder(pos,30,10^4,OmegaN),...
           @(pos)MinFuelClimb4VSegmentBuilder(pos,540,40,0,OmegaN),...
           @(pos)BestCruiseRangeSegmentBuilder(pos,3*10^4,0,OmegaN),...
           @(pos)BestGlideSegmentBuilder(pos,-450,0,OmegaN),...
           @(pos)BestCruiseRangeSegmentBuilder(pos,1000,-10^4,OmegaN),...
           @(pos)MinFuelClimb4VSegmentBuilder(pos,450,40,0,OmegaN),...
           @(pos)BestCruiseRangeSegmentBuilder(pos,3.6*10^4,0,OmegaN),...
           ... 5 refill and discharge of water
           @(pos)BestGlideSegmentBuilder(pos,-540,0,OmegaN),...
           @(pos)HoverSegmentBuilder(pos,30,10^4,OmegaN),...
           @(pos)MinFuelClimb4VSegmentBuilder(pos,540,40,0,OmegaN),...
           @(pos)BestCruiseRangeSegmentBuilder(pos,3*10^4,0,OmegaN),...
           @(pos)BestGlideSegmentBuilder(pos,-450,0,OmegaN),...
           @(pos)BestCruiseRangeSegmentBuilder(pos,1000,-10^4,OmegaN),...
           ... Back to the heliport
           @(pos)MinFuelClimb4VSegmentBuilder(pos,650,40,0,OmegaN),...
           @(pos)BestCruiseRangeSegmentBuilder(pos,7.73*10^4,0,OmegaN),...
           @(pos)BestGlideSegmentBuilder(pos,-750,0,OmegaN),...
           @(pos)TaxiSegmentBuilder(pos,72,4,0,OmegaN)};
       
%%
% Solving the mission:
%
[MfBurnt,missState] = getMissionState(he,atm,mission,PL0,Mf0,RF);

formatSpec = 'The fuel mass consumed is %d.';
I    = MfBurnt;
MfB3 = sprintf(formatSpec,I);
disp(MfB3);

%% 
% It is possible to check that the maximum extinction time is according to
% the regulations and that it is not possible to do one more extinction 
% section because the maximum time of extinction would be exceeded.
%
tExtTotal  = (missState.mSeg{43}.T(2));
formatSpec = 'The total extinction time is %d.';
K      = tExtTotal;
TextTot = sprintf(formatSpec,K);
disp(TextTot);

tRefill    = (missState.mSeg{12}.T(2)-missState.mSeg{4}.T(2));
formatSpec = 'The time of each refill and discharge of water is %d.';
L    = tRefill;
Tref = sprintf(formatSpec,L);
disp(Tref);

formatSpec = 'The total extinction time, adding another section extinction is %d.';
M     = tExtTotal + tRefill;
T6ext = sprintf(formatSpec,M);
disp(T6ext);

%%
% Optimizing the initial fuel mass:
%

Mf0opt = getOptimumFuelMass(he,atm,mission,PL0,Mf0,RF);

formatSpec = 'The optimum fuel mass is %d.';
J    = Mf0opt;
MfO3 = sprintf(formatSpec,J);
disp(MfO3);

%%
% Finally some plots to see the final state of the mission.

for s = 1:length(missState.mSeg);
     
     figure (110)
     grid on
     plot(missState.mSeg{s}.R,missState.mSeg{s}.H,'o-');
     hold on
     xlabel('R [m]');
     ylabel('H [m]');
      
end

%%
for s = 1:length(missState.mSeg); 
     figure (111)
     
     subplot(2,2,1)
     grid on
     plot(missState.mSeg{s}.R,missState.mSeg{s}.Mf,'o-');
     hold on
     xlabel('R [m]');
     ylabel('Mf [kg]');
     
     subplot(2,2,2)
     grid on
     plot(missState.mSeg{s}.T,missState.mSeg{s}.Mf,'o-');
     hold on
     xlabel('T [s]');
     ylabel('Mf [kg]');
     
     subplot(2,2,3)
     grid on
     plot(missState.mSeg{s}.R,missState.mSeg{s}.PL,'o-');
     hold on
     xlabel('R [m]');
     ylabel('PL [N]');
     
     subplot(2,2,4)
     grid on
     plot(missState.mSeg{s}.T,missState.mSeg{s}.PL,'o-');
     hold on
     xlabel('T [s]');
     ylabel('PL [N]');
     
end

%%
for s = 1:length(missState.mSeg);
     figure (112)
     
     subplot(2,2,1)
     grid on
     plot(missState.mSeg{s}.T,missState.mSeg{s}.V,'o-');
     hold on
     xlabel('T [s]');
     ylabel('V [m/s]');
     
     subplot(2,2,2)
     grid on
     x = missState.mSeg{s}.T;
     y = missState.mSeg{s}.R;
     plot(x,y,'o-');
     hold on
     ylabel('R [m]');
     xlabel('T [s]');
     
     subplot(2,2,3)
     grid on
     plot(missState.mSeg{s}.T,missState.mSeg{s}.H,'o-');
     hold on
     xlabel('T [s]');
     ylabel('H [m]');
     
     subplot(2,2,4)
     grid on
     plot(missState.mSeg{s}.T,missState.mSeg{s}.P/10^3,'o-');
     hold on
     xlabel('T [s]');
     ylabel('P [kW]');
     
end
