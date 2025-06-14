% clear all
close all
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Input helicopter
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Atmosphere
atm = getISA;

% Helicopter
he = ec135e(atm);

% PL and fuel for missions
PL = 75*atm.g; %N
Mf = 400; % kg
Rf = 50;  % kg

% Configurate helicopter for mission: weights into the helicopter data
he = addMissionWeightsEnergy(he,PL,Mf,Rf,atm);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Civil time survey mission
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
disp('CivilTimeSurveyMission')
% Mission DR
missPar = civilTimeSurveyPAR(2000,180,600,300);

% Calculate mission
MissionSegments = missionDefinition(he,missPar,PL,atm,'missionType','civilTimeSurvey');
save = 0;
plotMission(50,MissionSegments,save);
disp(MissionSegments);

% Mission fuel calculation
Mission  = missionFuelCalculation(he,MissionSegments,atm);
disp(Mission.io);
disp(Mission)

% Weights optimization for fuel mass and gross weight
[ eheOpt, MissionOpt, io ] = missionWeightOptimization(he,MissionSegments,PL,atm);
disp(eheOpt);
disp(MissionOpt);
disp(io);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Civil range survey mission
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
disp('CivilRangeSurveyMission')
% Mission DR
missPar = civilRangeSurveyPAR(180,600,300,10000);

% Calculate mission
MissionSegments = missionDefinition(he,missPar,PL,atm,'missionType','civilRangeSurvey');
save = 0;
plotMission(50,MissionSegments,save);
disp(MissionSegments);

% Mission fuel calculation
Mission  = missionFuelCalculation(he,MissionSegments,atm);
disp(Mission.io);
disp(Mission)

% Weights optimization for fuel mass and gross weight
[ eheOpt, MissionOpt, io ] = missionWeightOptimization(he,MissionSegments,PL,atm);
disp(eheOpt);
disp(MissionOpt);
disp(io);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Civil range transport mission
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
disp('CivilRangeTransportMission')
% Mission DR
missPar = civilRangeTransportPAR(2,800,30,40000);

% Calculate mission
MissionSegments = missionDefinition(he,missPar,PL,atm,'missionType','civilRangeTransport');
save = 0;
plotMission(50,MissionSegments,save);
disp(MissionSegments);

% Mission fuel calculation
Mission  = missionFuelCalculation(he,MissionSegments,atm);
disp(Mission.io);
disp(Mission)

% Weights optimization for fuel mass and gross weight
[ eheOpt, MissionOpt, io ] = missionWeightOptimization(he,MissionSegments,PL,atm);
disp(eheOpt);
disp(MissionOpt);
disp(io);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Civil surveillance mission
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
disp('CivilSurveillanceMission')
% Mission DR
missPar = civilSurveillancePAR(3600,180,600,300);

% Calculate mission
MissionSegments = missionDefinition(he,missPar,PL,atm,'missionType','civilSurveillance');
save = 0;
plotMission(50,MissionSegments,save);
disp(MissionSegments);

% Mission fuel calculation
Mission  = missionFuelCalculation(he,MissionSegments,atm);
disp(Mission.io);
disp(Mission)

% Weights optimization for fuel mass and gross weight
[ eheOpt, MissionOpt, io ] = missionWeightOptimization(he,MissionSegments,PL,atm);
disp(eheOpt);
disp(MissionOpt);
disp(io);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Civil medical mission
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
disp('CivilMedicalMission')
% Mission DR
missPar = civilMedicalPAR(180,180,600,200,0,650,400,10000,10000,20000);

% Calculate mission
MissionSegments = missionDefinition(he,missPar,PL,atm,'missionType','civilMedical');
save = 0;
plotMission(50,MissionSegments,save);
disp(MissionSegments);

% Mission fuel calculation
Mission  = missionFuelCalculation(he,MissionSegments,atm);
disp(Mission.io);
disp(Mission)

% Weights optimization for fuel mass and gross weight
[ eheOpt, MissionOpt, io ] = missionWeightOptimization(he,MissionSegments,PL,atm);
disp(eheOpt);
disp(MissionOpt);
disp(io);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Civil Firefighting mission
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
disp('CivilFirefightingMission')
% Mission DR
missPar = civilFirefightingPAR(50,600,200,10,30,60000,2000,300);

% Calculate mission
MissionSegments = missionDefinition(he,missPar,PL,atm,'missionType','civilFirefighting');
save = 0;
plotMission(50,MissionSegments,save);
disp(MissionSegments);

% Mission fuel calculation
Mission  = missionFuelCalculation(he,MissionSegments,atm);
disp(Mission.io);
disp(Mission)

% Weights optimization for fuel mass and gross weight
[ eheOpt, MissionOpt, io ] = missionWeightOptimization(he,MissionSegments,PL,atm);
disp(eheOpt);
disp(MissionOpt);
disp(io);