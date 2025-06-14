clear all
close all
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Input helicopter
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Atmosphere
atm = getISA;

% Helicopter
he = energyEC135(atm);

% PL and fuel for missions
PL = 75*atm.g; %N
Mf = 400; % kg
Rf = 50;  % kg

% Configurate helicopter for mission: weights into the helicopter data
he = addMissionWeightsEnergy(he,PL,Mf,Rf,atm);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Military Command Post mission
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
disp('MilCommandPostMission')
% Mission DR
missPar = milCommandPostPAR(10000,600,1200,50000,50000);

% Calculate mission
MissionSegments = missionDefinition(he,missPar,PL,atm,'missionType','milCommand');
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
% Military ASW Dipping Sonar mission
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
disp('MilDippingSonarMission')
% Mission DR
missPar = milDippingSonarPAR(15,120,8000,0,900,20,300,100000,100000);

% Calculate mission
MissionSegments = missionDefinition(he,missPar,PL,atm,'missionType','milASWDippingSonar');
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
% Military ASW MAD mission
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
disp('MilMADMission')
% Mission DR
missPar = milASWMadPAR(7200,0,100,50000,50000);

% Calculate mission
MissionSegments = missionDefinition(he,missPar,PL,atm,'missionType','milASWMAD');
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
% Military Medical Evacuation mission
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
disp('MilMedicalEvacMission')
% Mission DR
missPar = milMedicalEvacPAR(900,600,1000,100,1000,700,150000,150000);

% Calculate mission
MissionSegments = missionDefinition(he,missPar,PL,atm,'missionType','milMEDEVAC');
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
% Military Recognition mission
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
disp('MilRecognitionMission')
% Mission DR
missPar = milRecognitionPAR(10000,600,2000,150000,150000);

% Calculate mission
MissionSegments = missionDefinition(he,missPar,PL,atm,'missionType','milRecon');
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
% Military Scort mission
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
disp('MilScortMission')
% Mission DR
missPar = milScortPAR(1,1800,600,700,400,150000,10000,150000);

% Calculate mission
MissionSegments = missionDefinition(he,missPar,PL,atm,'missionType','milScort');
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
% Military Troop Transport mission
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
disp('MilTroopTransportMission')
% Mission DR
missPar = milTroopTransportPAR(144,600,500,600,500,150000,150000);

% Calculate mission
MissionSegments = missionDefinition(he,missPar,PL,atm,'missionType','milTroopTransport');
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