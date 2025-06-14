% Civil Firefighting Mission with automatic segment addition
atm    = getISA;
he     = ec135e(atm);
OmegaN = he.mainRotor.Omega;

PL0 = 150 *atm.g;
Mf0 = 300;
RF  = 65;

% Initial mission (only one refill and discharge
mission = {@(pos)HoverSegmentBuilder(pos,60,0,OmegaN),...
           @(pos)MinFuelClimb4VSegmentBuilder(pos,550,40,0,OmegaN),...
           @(pos)BestCruiseRangeSegmentBuilder(pos,10^4,0,OmegaN),...
           @(pos)BestGlideSegmentBuilder(pos,-540,0,OmegaN),...
           @(pos)HoverSegmentBuilder(pos,30,10^4,OmegaN),...
           @(pos)MinFuelClimb4VSegmentBuilder(pos,540,40,0,OmegaN),...
           @(pos)BestCruiseRangeSegmentBuilder(pos,3*10^4,0,OmegaN),...
           @(pos)BestGlideSegmentBuilder(pos,-450,0,OmegaN),...
           @(pos)BestCruiseRangeSegmentBuilder(pos,1000,-10^4,OmegaN),...
           @(pos)MinFuelClimb4VSegmentBuilder(pos,450,40,0,OmegaN)};
          
[MfB missState] = getMissionState(he,atm,mission,PL0,Mf0,RF);

Ttotal = missState.mSeg{size(missState.mSeg,2)}.T(2);

refill = {@(pos)BestCruiseRangeSegmentBuilder(pos,3.6*10^4,0,OmegaN),...
          @(pos)BestGlideSegmentBuilder(pos,-540,0,OmegaN),...
          @(pos)HoverSegmentBuilder(pos,30,10^4,OmegaN),...
          @(pos)MinFuelClimb4VSegmentBuilder(pos,540,40,0,OmegaN),...
          @(pos)BestCruiseRangeSegmentBuilder(pos,3*10^4,0,OmegaN),...
          @(pos)BestGlideSegmentBuilder(pos,-450,0,OmegaN),...
          @(pos)BestCruiseRangeSegmentBuilder(pos,1000,-10^4,OmegaN),...
          @(pos)MinFuelClimb4VSegmentBuilder(pos,450,40,0,OmegaN)};
      
% Añadimos refills hasta que se supera el tiempo máximo de extinción
% fijado por normativa.
while (Ttotal < 7200)
    
    n = size(mission,2) + 1;
    m = n - 1 + size(refill,2);
    
    mission(1,n:m) = refill;
    
    [MfB missState] = getMissionState(he,atm,mission,PL0,Mf0,RF);

    Ttotal = missState.mSeg{size(missState.mSeg,2)}.T(2);

end

% Se quita el ultimo refill que es el que hace Ttotal > 7200, para calcular
% la misión de extinción que cumpla la condición: Textinction < Tmax 
x       = size(mission,2)-size(refill,2);
mission = mission(1,1:x);

% Añadir a mission los segmentos de vuelta al helipuerto
return2Heliport = {@(pos)MinFuelClimb4VSegmentBuilder(pos,200,40,0,OmegaN),...
                   @(pos)BestCruiseRangeSegmentBuilder(pos,7.73*10^4,0,OmegaN),...
                   @(pos)BestGlideSegmentBuilder(pos,-750,0,OmegaN),...
                   @(pos)TaxiSegmentBuilder(pos,72,4,0,OmegaN)};
               
mission(1,x+1:x+size(return2Heliport,2)) = return2Heliport;
 

[MfBurnt missState] = getMissionState(he,atm,mission,PL0,Mf0,RF);

plotHelicopterMission(missState)

Mf0opt = getOptimumFuelMass(he,atm,mission,PL0,Mf0,RF);
