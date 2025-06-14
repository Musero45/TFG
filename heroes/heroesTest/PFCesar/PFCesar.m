function io = PFCesar
%% PFCesar   Obtains the best helicopter for the customer's requirements
%
%   io = PFCesar tests the general method in order to obtain the best
%   helicopter for the customer's requirements. This methodology uses 
%   statistical dimensioning methods, mission configuration, matrix QFD and 
%   OEC evaluation. This is only a tester which allows to obtain io= 1 in case 
%   the tester works properly, it can be used also to generate a cell with
%   helicopters ranked by OEC. In this case BO 105 LS is used as example to
%   test the method so all the values have been taken from [1].
%
%   References
%   [1] Eurocopter, Technical Definition BO 105 LS A-3.
%
%    Example of Design process, steps:
%       0.- Choose the design purposes, find closer helicopters already
%       designed and estimate the general configuration (elements, 
%       dimentions, power).
%       1.- Choose the desing requirements (DR) selecting elements between
%       the general configuration.
%       2.- Choose number and model of engine (engine) using general
%       configuration.
%       3.- Select a transmission and find Pmt (Pmt).
%       4.- Choose a Main mission for your helicopter. It should include
%       the main purpose (Ex: civilTimeSurvey), the Payload (PL) and the
%       equipment (to include in the DR).
%       5.- Using DR and engine, obtain the initial dimensioning helicopter
%       stathe. Include DR and the selected transmission Pmt.
%       6.- Select specific aerodynamic configuration (optStatHe) for the
%       statistical helicopter using the selected general configuration.
%       7.- Obtain the initial rigid helicopter (rigidHe) using stathe and
%       optStatHe. Add DR and configure mission weight
%       (addMissionWeightsRigid). 
%       8.- Obtain initial energy helicopter (ehe).
%       9.- Run mission definition function (missionDefinition) in order to
%       obtain the specific main mission characteristics for the selected
%       helicopter. This step allows to obtain the mission segments and all
%       the variables needeed.
%       10.- Choose customer's WHATS. Here the customer selects all the
%       elements weights, kind of tarjet and numeric tarjets that he wants
%       to achieve. Whats include the main switches to QFD and OEC me
%       differents models are selected in this step by qfdmodelfunctions 
%       and oecmodelfunctions. Plotting names are also included.
%       11.- Choose engineering HOWS. Here the engineer should think in all
%       the main variables in an helicopter and include all the main
%       systems like aerodynamics, propultion and structure.
%       12.- Run QFD functions: generateQFDmatrix, fillQFD,
%       interpreteQFDmatrix_rows, (plotQFD) and rankHows. This step allows
%       you to obtain the master variables of the project in funstion of
%       Whats and Hows.
%       13.- Select the number of master vaiables that are going to be used
%       in the OEC helicopters generation (vectorCutOff).
%       14.- Run OEC functions: generateCellHelicopters, addPerformances, restrictions
%       overalEvaluationCriteria and rankOEChelicopters. That obtains an
%       helicopter cell ranked by OEC mark. You can plot the results with
%       plotOECstate (plot every mark performance of the helicopters), 
%       plotOECevolution (plot the OEC evolution throught the ranking), 
%       plotOECmarks (plot a spider diagram comparing helicopters performances marks)
%       plotOECwhatsComparation (plot the evolution of the what's results
%       over the ranking)
%       15.- The solutions proposed to the customer are:
%               - the best OEC helicopter (can not achieve some tarjets but
%               has max OEC result)
%               - the first helicopter achieving all tarjets (achieve all
%               tarjets with max OEC result, can be other helicopter than
%               the previous one)
%       16.- Plot PL-R diagram to evaluate results.
%
%
%   In this function PFCesar, there are 3 exercises that allow to
%   understand the main methodology:
%       1.- Full design process with 11 Whats and 21 Hows emulating Bo105
%       design process.
%       2.- Same design process than previous one but reducing Whats: 
%       PL, Range, Endurance and Vm.
%       3.- Same reduced design process than in 2 with new tarjets obtained
%       evaluating models with the real Bo105.
%
%   TODO
%   * In QFD method, add a function that evaluates every single QFD change
%   in variables and correct if any physic rule is broken. (add roof to the
%   QFD matrix)
%   * In QFD and OEC add a function that calculates the OEW of each
%   geerated helicopter in function of the selected configuration.
%   * Include Trim model to calculate the required power in flight in order
%   to improve Range, Endurance, Vm and mission calculations.
%   



%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CONTROL Switches
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% QFD
modeQFD = 0; % Enter QFD method or define Order directly
disp(['ENABLE/DISABLE QFD => ',int2str(modeQFD)]);

    % QFD Fill
    modeFill = 0; %1 to plot sensitivity
    saveoptionFill = 0; %1 to save plot
    disp(['...Plot sensitivity => ',int2str(modeFill)]);
    disp(['...Save Plot sensitivity => ',int2str(saveoptionFill)]);

    % QFD Plot
    modePlot = 0; %1 to plot QFD
    saveoptionPlot = 0; %1 to save QFD plot
    disp(['..Plot QFD => ',int2str(modePlot)]);
    disp(['..Save Plot QFD => ',int2str(saveoptionPlot)]);

% Master Variables
nMasterVariables = 3; % Number of Master Variables
disp(['Number of master variables to use OEC = ',int2str(nMasterVariables)]);

% OEC
disp('OEC evaluation method ');
    % Continious geneation values
    nVal = 3; % number of helicopters in every segment
    disp(['...Continious generation number values = ',int2str(nVal)]);

    % Mode OEC Performances
    modeOECperf = 0; % Enter addperformances or load hePerf.dat

    % OEC Scale Mark
    scaleMark = 10; % Max mark that can be obtained
    disp(['...OEC scale mark = ',int2str(scaleMark)]);

    % OEC Plot options
    nGraf = 10; % Marks: First N helicopters in ranking
    Graf  = [1 3 5]; % Spider plot: helicopter rank
    saveOEC = 0; %1 to save OEC plots
    disp(['...Plot Number marks grafs = ',int2str(nGraf)]);
    disp(['...Plot spider helicopters # = ',int2str(Graf)]);
    disp(['...Save Plot OEC => ',int2str(saveOEC)]);

    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%     EXERCISE 1    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%       Full design process with 11 Whats and 20 Hows emulating Bo105
%       design process.
disp('--------------------------------------------');
disp('------------     EXERCISE 1     ------------');
disp('--------------------------------------------');

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% INITIAL DATA
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
disp('------------Initial Data--------------------');

% Atmosphere
atm = getISA;

% DR
desreq = cesarDR;
disp(['DR = ',desreq.id]);

% Engine
numEngines = 2;
engine = Allison250C28C(atm,numEngines);
disp(['Engine = ',engine.model]);

% Pmt
Pmt   = 620e3;
disp(['...Pmt = ',num2str(Pmt)]);

% Mission
missionType = 'custom';
PL = 75*atm.g;%N
disp(['Mission = ',missionType]);
disp(['...PL = ',num2str(PL/atm.g),' [kg]']);



%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% INITIAL HELICOPTER
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
disp('------------Initial Dimensioning------------');

% DIMENSIONING HELICOPTER
disp('Dimensioning...');
stathe = desreq2stathe(desreq,engine);
stathe = heliplusDR(stathe,desreq);

stathe.Performances.TakeOffTransmissionRating = Pmt;

% RIGID HELICOPTER
disp('Rigid helicopter...');
[optStatHe, Svt, cHTP] = optionDataBo105;
rigidHe = stathe2rigidhe(stathe,atm,cHTP,Svt,optStatHe);
Mf = rigidHe.inertia.MFW/atm.g;
Rf = 0;
rigidHe = addMissionWeightsRigid(rigidHe,PL,Mf,Rf,atm);
rigidHe = heliplusDR(rigidHe,desreq);

rigidHe.inertia.OEW = 1507*9.81;

% ENERGY HELICOPTER, Transform rigid helicopter to energy helicopter
ehe = rigidHe2ehe(rigidHe,atm);
ehe = addMissionWeightsEnergy(ehe,PL,Mf,Rf,atm);
disp('Energy helicopter...');



%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% MISSION
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
disp('------------Mission analysis----------------');
disp(['Selected mission: ',missionType]);
disp(['PL = ',num2str(PL/atm.g,'%5.2f'),' [kg]']);

disp('Mission DR...');
missDR = missionDR('missionType',missionType);
disp('Mission Segments...');
MissionSegments = missionDefinition(ehe,missDR,PL,atm,'missionType',missionType);



%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% QFD ANALYSIS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
disp('------------QFD analysis--------------------');
disp('Get Whats...');
disp('Get Hows...');
Whats = WHATS;
Hows  = HOWS;

if modeQFD == 1 
    % Generate QFD matrix
    QFDzeros = generateQFDmatrix(Whats,Hows);

    % Fill QFD matrix
    QFDpercents = fillQFD(Whats,Hows,QFDzeros,stathe,MissionSegments,atm,modeFill,saveoptionFill);
    QFDpercents(1,19) = 0;
    QFDpercents(4,19) = 0;
    QFDpercents(6:11,19) = 0;
    
    %save('QFDpercents.mat','QFDpercents');
    
    % Interprete QFD matrix
    nCat = 5;
    QFDcathegories = interpreteQFDmatrix_rows(QFDpercents,nCat);

    % Plot QFD matrix
    if modePlot == 1
    plotQFD(QFDcathegories,saveoptionPlot)
    end

    % Sort QFD matrx
    [sortHows, Imp, Order, Rank] = rankHows(QFDcathegories,Hows,Whats);
    disp(sortHows);
    disp(Imp);
    disp(Order);
    disp(Rank);

else
    Order = [4 2 5 13 15]; % Manual Order
end

disp('QFD analysis done.--');


%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% MASTER VARIABLES
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
disp('------------Master variables----------------');
% Number of master variables
disp(['Number of Master Variables = ',int2str(nMasterVariables)]);

% Vector cut off
if modeQFD == 1 
    vectRankHows = vectorCutOff(Order,nMasterVariables);
else
    vectRankHows = Order;
end

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% OEC ANALYSIS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
disp('------------OEC analysis--------------------');

if modeOECperf == 1 
    % Generate cell of helicopters
    heCell = generateCellHelicopters(rigidHe,Hows,vectRankHows,nVal);
    % Performance calculations
    hePerf = addPerformances(heCell,Whats,MissionSegments,atm);
    %save('hePerf.mat','hePerf');
else
    load('hePerf.mat');
end

% Eliminate helicopters by restrictions
heCand = restrictions(hePerf);

% OEC calculation
heMark = overalEvaluationCriteria(heCand,Whats,scaleMark);

% Rank Helicoptersa
heRank = rankOEChelicopters(heMark);

disp('OEC analysis done.--');

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% HELICOPTER SOLUTION
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
disp('------------HELICOPTER SOLUTIONS------------');
HeSOLUTIONbest = heRank{1};
HeSOLUTIONrequ = heRank{5};
disp(['Helicopter Best Solution: OEC = ',num2str(HeSOLUTIONbest.OEC.OEC,'%4.2f'),'/',int2str(scaleMark)])
disp(['Helicopter All requirements SatisfiedSolution: OEC = ',num2str(HeSOLUTIONrequ.OEC.OEC,'%4.2f'),'/',int2str(scaleMark)])
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Plot OEC results
plotOECstate(heRank,nGraf,600,'OECproyect_',saveOEC);
plotOECevolution(heRank,'Evolproyect_',saveOEC);
plotOECmarks(heRank,[1 5],'Spiderproyect_',saveOEC);
plotOECwhatsComparation(heRank,501,'WhatsCompproyect_','Referencia: Bo 105',saveOEC);

% Transform solutions >> energy
ehewin = rigidHe2ehe(HeSOLUTIONbest,atm);
ehewin.Mf = ehewin.weights.MFW/atm.g;
disp('Mission PL-R analysis...');
ehereq = rigidHe2ehe(HeSOLUTIONrequ,atm);
ehereq.Mf = ehereq.weights.MFW/atm.g;

% PL-R diagram obtained using dim-->energy
[ PLc{1}, Rc{1} ] = getPLRdiagram(ehewin,atm);
sty{1} = 'ro-';
leg{1} = 'Helicóptero #1';

[ PLc{2}, Rc{2} ] = getPLRdiagram(ehereq,atm);
sty{2} = 'go-';
leg{2} = 'Helicóptero #5';

% PL-R real from Bo105
[ PLc{3}, Rc{3} ] = getDataPLRBo105;
sty{3} = 'k-';
leg{3} = 'Bo 105';

plotPLRdiagram(301,PLc,Rc,sty,leg);
    

disp('¡¡PFCesarEx 1 done!!')


%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%     EXERCISE 2    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%       Same design process than previous one but reducing Whats: 
%       PL, Range, Endurance and Vm.
disp('--------------------------------------------');
disp('------------     EXERCISE 2     ------------');
disp('--------------------------------------------');

% Reduce Whats: PL, Range, Endurance and Vm
Whats.cat1.var1.activeOEC = 'yes';
Whats.cat1.var2.activeOEC = 'yes';
Whats.cat1.var3.activeOEC = 'yes';
Whats.cat1.var4.activeOEC = 'yes';
Whats.cat2.var1.activeOEC = 'no';
Whats.cat3.var1.activeOEC = 'no';
Whats.cat4.var1.activeOEC = 'no';
Whats.cat4.var2.activeOEC = 'no';
Whats.cat5.var1.activeOEC = 'no';
Whats.cat5.var2.activeOEC = 'no';
Whats.cat5.var3.activeOEC = 'no';

% Eliminate helicopters by restrictions
heCandredu = restrictions(hePerf);
%heCand = hePerf;

% OEC calculation
heMarkredu = overalEvaluationCriteria(heCandredu,Whats,scaleMark);

% Rank Helicoptersa
heRankredu = rankOEChelicopters(heMarkredu);

% Helicopters solutions
disp('------------HELICOPTER SOLUTIONS------------');
HeSOLUTIONbest = heRankredu{1};
HeSOLUTIONrequ = heRankredu{5};

% Plot OEC results
plotOECstate(heRankredu,nGraf,620,'OECreduced_',saveOEC);
plotOECevolution(heRankredu,'Evolreduced_',saveOEC);
plotOECmarks(heRankredu,[1 6],'Spiderreduced_',saveOEC);
plotOECwhatsComparation(heRankredu,502,'WhatsCompreduced_','Referencia: Bo 105',saveOEC);

% Transform solutions >> energy   
ehewin = rigidHe2ehe(HeSOLUTIONbest,atm);
ehewin.Mf = ehewin.weights.MFW/atm.g;
ehereq = rigidHe2ehe(HeSOLUTIONrequ,atm);
ehereq.Mf = ehereq.weights.MFW/atm.g;
disp('Mission PL-R analysis...');

% PL-R diagram obtained using dim-->energy
[ PLc{1}, Rc{1} ] = getPLRdiagram(ehewin,atm);
sty{1} = 'ro-';
leg{1} = 'Helicóptero #1';

[ PLc{2}, Rc{2} ] = getPLRdiagram(ehereq,atm);
sty{2} = 'go-';
leg{2} = 'Helicóptero #6';

% PL-R real from Bo105
[ PLc{3}, Rc{3} ] = getDataPLRBo105;
sty{3} = 'k-';
leg{3} = 'Bo 105';

plotPLRdiagram(302,PLc,Rc,sty,leg);
    

disp('¡¡PFCesar Ex 2 done!!')


%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%     EXERCISE 3    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%       Same reduced design process than in 2 with new tarjets obtained
%       evaluating models with the real Bo105.
disp('--------------------------------------------');
disp('------------     EXERCISE 3     ------------');
disp('--------------------------------------------');

% New numeric tarjets (obtained using tester PFCesarREVERSE)
newPL        = 6240;
newRange     = 625000;
newEndurance = 15100;
newVm        = 80;

Whats.cat1.var1.tarjet.value = newPL;
Whats.cat1.var2.tarjet.value = newRange;
Whats.cat1.var3.tarjet.value = newEndurance;
Whats.cat1.var4.tarjet.value = newVm;

Whats.cat1.var1.activeOEC = 'yes';
Whats.cat1.var2.activeOEC = 'yes';
Whats.cat1.var3.activeOEC = 'yes';
Whats.cat1.var4.activeOEC = 'yes';
Whats.cat2.var1.activeOEC = 'no';
Whats.cat3.var1.activeOEC = 'no';
Whats.cat4.var1.activeOEC = 'no';
Whats.cat4.var2.activeOEC = 'no';
Whats.cat5.var1.activeOEC = 'no';
Whats.cat5.var2.activeOEC = 'no';
Whats.cat5.var3.activeOEC = 'no';


% Eliminate helicopters by restrictions
heCandnew = restrictions(hePerf);

% OEC calculation
heMarknew = overalEvaluationCriteria(heCandnew,Whats,scaleMark);

% Rank Helicoptersa
heRanknew = rankOEChelicopters(heMarknew);

% Helicopters solutions
disp('------------HELICOPTER SOLUTIONS------------');
HeSOLUTIONbest = heRanknew{1};
HeSOLUTIONrequ = heRanknew{2};

% Plot OEC results
plotOECstate(heRanknew,nGraf,640,'OECnew_',saveOEC);
plotOECevolution(heRanknew,'Evolnew_',saveOEC);
plotOECmarks(heRanknew,[1 2],'Spidernew_',saveOEC);
plotOECwhatsComparation(heRanknew,503,'WhatsCompnew_','Referencia: aplicación de modelos al Bo 105',saveOEC);

% Transform solutions >> energy
ehewin = rigidHe2ehe(HeSOLUTIONbest,atm);
ehewin.Mf = ehewin.weights.MFW/atm.g;
ehereq = rigidHe2ehe(HeSOLUTIONrequ,atm);
ehereq.Mf = ehereq.weights.MFW/atm.g;
disp('Mission PL-R analysis...');

% PL-R diagram obtained using dim-->energy
[ PLc{1}, Rc{1} ] = getPLRdiagram(ehewin,atm);
sty{1} = 'ro-';
leg{1} = 'Helicóptero #1';

[ PLc{2}, Rc{2} ] = getPLRdiagram(ehereq,atm);
sty{2} = 'go-';
leg{2} = 'Helicóptero #2';

% PL-R calculations to Bo105
[ PLc{3}, Rc{3} ] = getDataPLRCalculationsBo105;
sty{3} = 'k--';
leg{3} = 'Aplicación de modelos al Bo 105';

% PL-R real from Bo105
[ PLc{4}, Rc{4} ] = getDataPLRBo105;
sty{4} = 'k-';
leg{4} = 'Bo 105';

plotPLRdiagram(303,PLc,Rc,sty,leg);     
    


disp('¡¡PFCesar Ex 3 done!!')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

io = 1;


end


