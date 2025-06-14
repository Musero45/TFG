function io = PFCesarREVERSE
% PFCesarREVERSE Allows to obtain the performances for the helicopter Bo105
% using all the methods configurated in the QGF and OEC methods.
%   Runing this PFCesarREVERSE it's posible to obtain all the performances
%   for the helicopter Bo105Rigid. This results can be used as tarjets for
%   a design process and test if it's possible to obtain the Bo105
%   configuration with the methodology QFD-OEC.
%
%   Use: run PFCesarREVERSE and copy all the results shown at the display.
%        This elements are used to compare the results using models and 
%        the real performances of the selected helicopter.
%        Then include this results in your Whats (tarjets) and run PFCesar 
%        in order to verify if the Bo105 is obtained.


% Atmosphere
atm = getISA;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% INITIAL DATA
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
disp('------------Initial Data--------------------');
% DR
numEngines = 2;
engine = Allison250C28C(atm,numEngines);
desreq = cesarDR;
disp(['DR = ',desreq.id]);

% Pmt
Pmt   = 620e3;
disp(['...Pmt = ',num2str(Pmt)]);

% Mission
missionType = 'custom';
PL = 75*atm.g;%N
disp(['Mission = ',missionType]);
disp(['...PL = ',num2str(PL/atm.g),' [kg]']);


% OEC Scale Mark
scaleMark = 10;
disp(['OEC scale mark = ',int2str(scaleMark)]);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% INITIAL HELICOPTER
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
disp('------------Initial Dimensioning------------');

% DIMENSIONING HELICOPTER
disp('Dimensioning...');
stathe = desreq2stathe(desreq,engine);
stathe = heliplusDR(stathe,desreq);

% Configure transmission
stathe.Performances.TakeOffTransmissionRating = Pmt;

% Transform statistical helicopter to energy helicopter
disp('Energy helicopter...');
ehe   = stathe2ehe(atm,stathe);

% Load rigidBo105 and include some elements that are obtained by
% dimensioning helicopter
disp('Rigid helicopter...');
heModel = rigidBo105(atm);
heModel.dimensioningPerformances = stathe.Performances;
heModel.engine = engine;
heModel.inertia.W = 2600*atm.g;
heModel.inertia.MPL  = 637*atm.g;
heModel.inertia.OEW  = 1507*atm.g;
heModel.inertia.MTOW = 2600*atm.g;
heModel.inertia.MFW  = 456*atm.g;
heModel.inertia.usefulLoad = stathe.Weights.usefulLoad;
heModel.inertia.Wcrew = stathe.Weights.Wcrew;
heModel.inertia.Vf = stathe.Weights.Vf;
heModel.inertia.DL = stathe.Weights.discLoading;

% Configure WTOW
Mf = heModel.inertia.MFW/atm.g;
Rf = 0;
heModel = addMissionWeightsRigid(heModel,PL,Mf,Rf,atm);

% Add DR
heModel = heliplusDR(heModel,desreq);

% Include the helicopter in an 1 dimentional cell because OEC analysis need
% helicopters in a cell.
heCellone = {heModel};
heCellone{1}.N = 1;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% MISSION
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
disp('------------Mission analysis----------------');
disp(['Selected mission: ',missionType]);
disp(['PL = ',num2str(PL/atm.g,'%5.2f'),' [kg]']);

disp('Add Mission weights...');
ehe = addMissionWeightsEnergy(ehe,PL,400,50,atm);
disp('Mission DR...');
missDR = missionDR('missionType',missionType);
disp('Mission Segments...');
MissionSegments = missionDefinition(ehe,missDR,PL,atm,'missionType',missionType);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% OEC ANALYSIS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
disp('------------OEC analysis--------------------');
% Get Whats
Whats = WHATS;

% Performance calculations
hePerfone = addPerformances(heCellone,Whats,MissionSegments,atm);
heCandone = hePerfone;

% OEC calculation
heMarkone = overalEvaluationCriteria(heCandone,Whats,scaleMark);

% Rank Helicopters
heRankone = rankOEChelicopters(heMarkone);

% Plot OEC results
plotOECstate(heRankone,1,1,'reverse',0);
plotOECmarks(heRankone,1,'reverse',0);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PERFORMANCE RESULTS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
disp('------------Performances results------------');
Nperf = size(heRankone{1}.Performances.labels,2);
for i=1:Nperf
    disp([heRankone{1}.Performances.legends{i},' = ',...
        num2str(heRankone{1}.Performances.(heRankone{1}.Performances.labels{i})),...
        heRankone{1}.Performances.units{i}]);
end

io = 1;

end


