function io = qfd01(mode)


% Atmosphere
atm = getISA;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% INITIAL HELICOPTER
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% DR
numEngines = 2;
engine = Allison250C28C(atm,numEngines);
desreq = cesarDR;

% Dimensioning
heli = desreq2stathe(desreq,engine);

% Add DR to helicopter
he = heliplusDR(heli,desreq);

% Transform statistical helicopter to energy helicopter
ehe         = stathe2ehe(atm,he);
Pmt   = 620e3;
fPmt  = @(h) Pmt*ones(size(h));
ehe.transmission.fPmt   = fPmt;
ehe.transmission.Pmt    = Pmt;
availablePower = engine_transmission2availablePower(ehe.engine,ehe.transmission);
ehe.availablePower = availablePower;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% MISSION
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% MISSION parameters
PL = 75*atm.g; %N
ehe = addMissionWeightsEnergy(ehe,PL,0,0,atm);
missDR = missionDR('missionType','custom');
MissionSegments = missionDefinition(ehe,missDR,PL,atm,'missionType','custom');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% QFD
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Get WHATS and HOWS
[Whats] = WHATS; 
[Hows]  = HOWS;

% Generate QFD matrix
QFDzeros = generateQFDmatrix(Whats,Hows);

% Fill QFD matrix
mode = 0; %1 to plot sensitivity
saveoption = 0; %1 to save plot
QFDpercents = fillQFD(Whats,Hows,QFDzeros,he,MissionSegments,atm,mode,saveoption);

% Interprete QFD matrix
nCat = 5;
QFDcathegories = interpreteQFDmatrix_rows(QFDpercents,nCat);

% Plot QFD matrix
mode = 1; %1 to plot QFD
saveoption = 0; %1 to save QFD graph
if mode == 1
    plotQFD(QFDcathegories,saveoption)
end

% Sort QFD matrx
[sortHows, Imp, Order, Rank] = rankHows(QFDcathegories,Hows,Whats);
disp(sortHows);
disp(Imp);
disp(Order);
disp(Rank);

io = 1;

end