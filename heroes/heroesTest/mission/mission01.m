function ioi = mission01 (mode)
% MISSION Mission module tester
%   This test calculates mission elements loading an helicopter from
%   dimensioning and the mission desired requirements, and calculating
%   mission segments, performances, fuel and optimizating mission with the
%   helicopter.


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Input helicopter
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Atmosphere
atm = getISA;

% DR
numEngines = 2;
engine = Allison250C28C(atm,numEngines);
desreq = cesarDR;

% Dimensioning
stathe = desreq2stathe(desreq,engine);

% Dimensioning 2 energy helicopter
ehe = stathe2ehe(atm,stathe);

% One problem of stathe2ehe is that the maximum transmission power is
% limitating most of the altitude envelope, for this example up to 10000
% and 11000 meters
% Therefore to obtain a nice flight envelope we set a maximum transmission
% power of 1e6 W and we override ehe data
Pmt                    = 620e3;
fPmt                   = @(h) Pmt*ones(size(h));
he.transmission.fPmt   = fPmt;
he.transmission.Pmt    = Pmt;

% Next we recompute available power
% Get available power taken into account transmission power limitation
availablePower = engine_transmission2availablePower(ehe.engine,he.transmission);
ehe.availablePower = availablePower;

% PL and fuel for missions
PL = 75*atm.g; %N
Mf = 400; % kg
Rf = 50;  % kg

% Configurate helicopter for mission: weights into the helicopter data
ehe = addMissionWeightsEnergy(ehe,PL,Mf,Rf,atm);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Main Mission: Civil time survey
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Mission DR
missDR = missionDR('missionType','civilTimeSurvey');
missDR.T.tcruise34 = 3600;

% Calculate mission
MissionSegments = missionDefinition(ehe,missDR,PL,atm,'missionType','civilTimeSurvey');
save = 0;
plotMission(50,MissionSegments,save);

% Mission fuel calculation
Mission  = missionFuelCalculation(ehe,MissionSegments,atm);
disp(Mission.io);
% Weights optimization for fuel mass and gross weight
[ eheOpt, MissionOpt, io ] = missionWeightOptimization(ehe,MissionSegments,PL,atm);
disp(io);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Diferent missions
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
missCases = {'civilTimeSurvey','civilRangeSurvey','civilRangeTransport',...
    'civilMedical','civilSurveillance','civilFirefighting',...
    'milASWDippingSonar','milMEDEVAC','milRecon','milScort',...
    'milTroopTransport','milCommand',...
    'custom'};
Nmiss     = length(missCases);

for i=1:Nmiss
    missDR  = missionDR('missionType',missCases{i});
    Missseg = missionDefinition(ehe,missDR,PL,atm,'missionType',missCases{i});
    Miss    = missionFuelCalculation(ehe,Missseg,atm);
    plotMission(i,Miss,0); 
    disp(['Mission: ',missCases{i}]);
end


ioi = 1;

end






