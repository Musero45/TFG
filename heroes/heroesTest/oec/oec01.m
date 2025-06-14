function io = oec01(mode)


% Atmosphere
atm = getISA;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% INITIAL HELICOPTER
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% DR
numEngines = 2;
engine = Allison250C28C(atm,numEngines);
desreq = cesarDR;

% DIMENSIONING HELICOPTER
stathe = desreq2stathe(desreq,engine);
stathe = heliplusDR(stathe,desreq);

% RIGID HELICOPTER
[optStatHe Svt cHTP] = optionDataBo105;
rigidHe = stathe2rigidhe(stathe,atm,cHTP,Svt,optStatHe);
rigidHe = heliplusDR(rigidHe,desreq);

% ENERGY HELICOPTER
ehe = rigidHe2ehe(rigidHe,atm);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% MISSION parameters
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
PL = 75*atm.g; %N
ehe = addMissionWeightsEnergy(ehe,PL,0,0,atm);
missDR = missionDR('missionType','custom');
MissionSegments = missionDefinition(ehe,missDR,PL,atm,'missionType','custom');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% QFD ANALYSIS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Whats = WHATS;
Hows  = HOWS;
%QFDzeros = generateQFDmatrix(Whats,Hows);
%QFDpercents = fillQFD(Whats,Hows,QFDzeros,he,atm,0,0);
%nCat = 5;
%QFDcathegories = interpreteQFDmatrix_rows(QFDpercents,nCat);
%[sortHows Imp Order Rank] = rankHows(QFDcathegories,Hows,Whats);
Order = [2 1];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% MASTER VARIABLES
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Number of master variables
nMasterVariables = 2;

% Vector cut off
vectRankHows = vectorCutOff(Order,nMasterVariables);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% OEC ANALYSIS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Generate cell of helicopters
nVal = 3;
heCell = generateCellHelicopters(rigidHe,Hows,vectRankHows,nVal);

% Performance calculations
hePerf = addPerformances(heCell,Whats,MissionSegments,atm);

% Eliminate helicopters by restrictions
%[heCand heNonCand] = restrictions(hePerf);
heCand = hePerf;

% OEC calculation
scaleMark = 10;
heMark = overalEvaluationCriteria(heCand,Whats,scaleMark);

% Rank Helicopters
heRank = rankOEChelicopters(heMark);

% Plot OEC results
nGraf = 5;
Graf  = [1 5];
plotOECstate(heRank,nGraf,1,'test',0);
plotOECevolution(heRank,'test',0);
plotOECmarks(heRank,Graf,'test',0);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% HELICOPTER SOLUTION
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
HeSOLUTION = heRank{1};
disp(['Helicopter Solution: OEC = ',num2str(HeSOLUTION.OEC.OEC,'%4.2f'),'/',int2str(scaleMark)])
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

io = 1;

end