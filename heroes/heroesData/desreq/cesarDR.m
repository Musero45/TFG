function desreq = cesarDR
% cesarDR is a design requirement corresponding to an 2600 kg helicopter.
% The most well-known helicopter with design requirements similar to this 
% is the Bo-105 LS. 
%
%   From wikipedia
%     The Messerschmitt-B\"olkow-Blohm Bo-105 is a light, twin-engine, 
%     multi-purpose helicopter developed by B\"olkow of Stuttgart, Germany. 
%     It featured a revolutionary hingeless rotor system, at that time a 
%     pioneering innovation in helicopters when it was introduced into service 
%     in 1970. Production of the Bo 105 began at the then recently merged 
%     Messerschmitt-B\"olkow-Blohm (MBB).
%
% This DR comes from Cesar Garcia (2014) cesar.garcia.lozano@alumnos.upm.es
% These DR are used with Rand-Johnson model so they cover all the
% parameters that are required to this dimensioning method.
%
%   References
%   [1] Eurocopter, Technical Definition BO 105 LS A-3.
%   [2] Johnson, W - NASA Design and Analysis of Rotorcraft, 2009
%   [3] U.S., Bureau of Labor Statistics, Consumer Price Index Forecast, 2013
%   {http://www.seattle.gov/financedepartment/cpi/documents/US_CPI_Forecast_--_Annual_09-17-13.pdf}
%   [4] F.A.A Federal Aviation Administration, Aerospace forecast of fisical
%   years 2013-2033, 2002
%   {http://www.faa.gov/about/office_org/headquarters_offices/apl/aviation_forecasts/aerospace_forecasts/2013-2033/media/2013_Forecast.pdf}
%   [5] J. G. Leishman, Principles of Helicopter Aerodynamics, 2002
%   [6] Mike Overd, Composite helicopter structures, current and future
%   challenges, 2011
% 
% ELEMENTS TO CONFIGURE:
%   Each element has first the unit [], description, reference and type of
%   variable (internal of models or configurable). 
%      Ex: 'Range',515000,... %[m]Range[1](DM)
%
%   Here are the equivalences for the configurable elements of these DR:
%    DM = Desired Mission
%    FE = First Estimation
%    CE = Configuration Estimation
%    CC = Component configuration (technology factor)
%


g    = 9.81;

%% Rand inputs 
% Rand's inputs are general mission parameters and general configuration 
% estimations
rand = struct( ...
       'Range',515000,... %[m]   Range [1] (DM)
          'Vm',67.5,...   %[m/s] Max Vel [1] (DM)
        'MTOW',2600*g,... %[N] Max Take Off Weight (FE)
           'b',4,...      %[-] Main rotor blades (FE)
         'btr',2,...      %[-] Tail rotor blades (FE)
        'Crew',2 ...      %[-] Crew people (FE)
);

%% Configuration estimations
% 
estimations = struct( ...
                  'Nlg',2,... %[-] Landing gear number (CE)
                  'Nds',2,... %[-] Main transmission number(CE)
                  'Nat',0,... %[-] Auxiliar engines number(CE)
                  'Tat',0,... %[N] Trust for each auxiliar engine (CE)
                  'Aat',1,... %[m^2] Auxiliar engines surface(CE)
                  'Aht',0,... %[-] Horizontal tail dimention relation (CE)
                  'Svt',0,... %[m^2] Vertical tail surface(CE)
                  'Avt',0,... %[-] Vertical tail dimention relation (CE)
                 'Nint',1,... %[-] Internal auxiliary fuel tanks (CE)
               'Nplumb',2,... %[-] Fuel plumbs number (CE)
                   'wb',1.1000,... %[s^-1] Natural blade frecuency (CE)
                   'wh',1.1000,... %[s^-1] Natural shaft frecuency (CE)
                'Dspin',0 ... %[m] Spin diameter (CE)
);

%% Technology factors
% From [2] The technology factors defined by Johnson are simply switches to
% select the configuration of the helicopter's components
technologyFactors = struct( ...
                       'lg',1, ... %[-] Alighting Gear: Landing gear [1] (CC)
                    'lgret',1, ... %[-] Alighting Gear: Landing gear retraction [1] (CC)
        'lgcrashworthiness',1, ... %[-] Alighting Gear: Landing gear crashworthiness [1] (CC)
                'gearBoxes',1, ... %[-] Drive System: Gear boxes [1] (CC)
               'rotorShaft',1, ... %[-] Drive System: Rotor shaft [1] (CC)
               'driveShaft',1, ... %[-] Drive System: Drive shaft [1] (CC)
               'rotorBrake',1, ... %[-] Drive System: Rotor brake [1] (CC)
                       'ht',1, ... %[-] Empennage Group: Horizontal tail [1] (CC)
                       'vt',1, ... %[-] Empennage Group: Vertical tail [1] (CC)
                       'tr',1, ... %[-] Empennage Group: Tail rotor [1] (CC)
                       'at',1, ... %[-] Empennage Group: Tail [1] (CC)
               'mainEngine',1, ... %[-] Engine System: Main engine [1] (CC)
      'engineExhaustSystem',1, ... %[-] Engine System: Engine exhaust system [1] (CC)
         'engineAccesories',1, ... %[-] Engine System: Engine accesories [1] (CC)'at',1, ... %[-] Empennage Group Auxiliar propultion [1] (CC)
   'engineSupportStructure',1, ... %[-] Engine Section: Engine support structure [1] (CC)
            'engineCowling',1, ... %[-] Engine Section: Engine cowling [1] (CC)
    'pylonSupportStructure',1, ... %[-] Engine Section: Pylon support structure [1] (CC)
        'airInductionGroup',1, ... %[-] Engine Section: Air induction group [1] (CC)
      'fixedWingNonBoosted',1, ... %[-] Flight Controls: Fixed wing non boosted [1] (CC)
 'fixedWingBoostMechanisms',1, ... %[-] Flight Controls: Fixed wing boost mechanisms [1] (CC)
     'rotaryWingNonBoosted',1, ... %[-] Flight Controls: Rotary wing non boosted [1] (CC)
'rotaryWingBoostMechanisms',1, ... %[-] Flight Controls: Rotary wing boost mechanisms [1] (CC)
        'rotaryWingBoosted',1, ... %[-] Flight Controls: Rotary wing boosted [1] (CC)
                     'tank',1, ... %[-] Fuel System: Fuel tank [1] (CC)
                    'plumb',1, ... %[-] Fuel System: Fuel plumb [1] (CC)
                    'basic',1, ... %[-] Fuselaje Group: Basic structure [1] (CC)
                    'tfold',1, ... %[-] Fuselaje Group: Tail fold [1] (CC)
                    'wfold',1, ... %[-] Fuselaje Group: Wing and Rotor fold [1] (CC)
                      'mar',1, ... %[-] Fuselaje Group: Marinization [1] (CC)
                    'press',1, ... %[-] Fuselaje Group: Pressuritation [1] (CC)
          'crashworthiness',1, ... %[-] Fuselaje Group: Crashworthiness [1] (CC)
      'fixedWingHydraulics',1, ... %[-] Hydraulic Group: Fixed wing hydraulics [1] (CC)
     'rotaryWingHydraulics',1, ... %[-] Hydraulic Group: Rotary wing hydraulics [1] (CC)
                    'blade',1, ... %[-] Rotor Group: Rotors blades [1] (CC)
                      'hub',1, ... %[-] Rotor Group: Rotor group Hub [1] (CC)
                     'spin',1, ... %[-] Rotor Group: Rotor group Spin [1] (CC)
                     'fold',1, ... %[-] Rotor Group: Fold [1] (CC)
                 'aircraft',1, ... %[-] Aircraft Flyaway Cost: Aircraft [1] (CC)
              'maintenance',1 ...  %[-] Direct Operating Cost: Maintenance [1] (CC)
);

%% Cost factors
% From [6] the composite fraction for a small helicopter is around 40%
% From [2] these are the values of the general cost parameters:
%   engineType = [1.0 for turbine aircraft|0.557 for piston aircraft]
%   numEngines = [1.0 for multi-engine aircraft|0.736 for sigle-engine aircraft]
%   lgType = [1.0 for retractable landing gear|0.884 for fixed landing gear]
%   numMainRotors = [1.0 for single main rotor|1.057 twin main rotors|1.117 four main rotors]  
costFactors = struct( ...
 'compositeAdditionalPrice',1000, ... % [$/kg] Composite additional price, My own
        'compositeFraction',0.4, ...  % [-] Composite weight fraction (fraction of MTOW) [6] 
               'engineType',1.0, ...  % [-] Engine type [2] (CC)
               'numEngines',1.0, ...  % [-] Engine number [2] (CC)
                   'lgType',0.884, ...% [-] Landing gear type [2] (CC)
            'numMainRotors',1.0 ...   % [-] Main rotor number [2] (CC)
);


%% Mission configuration factors
% From [3] the index have been arranged into base 100 in 1994 as [2] Johnson's
% functions require.
% From [4] the fuel's forecast is in [$/gal] and need to be changed in [$/m3]
%   fuelCost = [ 2.1919 2.7441 2.9972 2.8089 2.5726 2.4207 2.4417 2.5622 ...
%   2.6616 2.7667 2.8569 2.9420 3.0197 3.1038 3.1876]  % $/gal
mission = struct( ...
              'fuelWeight',1226, ...        % [N] Fuel weight (DM)
                    'time',3600, ...        % [s] Mission time (DM)
       'avaibleBlockHours',720000, ...      % [s] Avaible blocks hours (DM)
       'sparesPerAircraft',0.001, ...       % [-] Spares per aircraft (fraction purchase price) My own
      'depreciacionPeriod',30, ...          % [yr] Depreciation period My own
           'residualValue',0.1, ...         % [-]Residual value (fraction) My own
              'loanPeriod',5, ...           % [yr] Loan period My own
            'interestRate',3, ...           % [%] Interest rate My own
       'nonFlightTimeTrip',720, ...         % [s] Non flight time per trip (DM)
           'numPassengers',2,...            % [-] Number of passengers (DM)
             'fuelDensity',804.035, ...     % [kg/m^3] Fuel density [3]
              'crewFactor',1, ...           % [-] Crew operation factor (DM)
    'initialOperationYear',2015, ...        % [yr] Initial operation year (DM)            
         'operationPeriod',1, ...           % [yr] Operation period (DM)
 'missionEquipmentPackage',500, ...         % [N] Weight of the mission equipement package (DM)
'flightControlElectronics',100, ...         % [N] Weight of the flight control electronics (DM)
           'costFactorMEP',1000, ...        % [$/kg] Cost factor MEP My own
           'costFactorFCE',1000, ...        % [$/kg] Cost factor FCE My own
            'purchaseYear',2015, ...        % [yr] Purchase year (DM)
'priceIndex',[ 147.13 151.77 154.91 157.26 160.25 163.94 167.57 171.89 ...
176.02 180.25 184.58 189.01 193.55 198.19 202.95], ... % [%] Price Index CPI [3] CPI forecast
'fuelCost',[ 579.0 724.9 791.8 742.0 679.6 639.5 645.0 676.9 ...
703.1 730.9 754.7 777.2 797.7 819.9 842.1]...  % [$/m3] Fuel cost FAA [4] Fuel cost forecast
);

%% Energy estimations
% From [5] page 217 Bo-105 has a equivalent flat plate area of 10 ft^2
% kindOfFuselage = {lowDragFuselage} | averageDragFuselage | highDragFuselage
energyEstimations =  struct( ...
        'kappa',1.15,... % [-] Energy kappa factor [5] (CE)
        'K',5,...        % [-] Energy K factor [5] (CE)
        'cd0',0.01,...   % [-] Energy constant blade drag coef [5] (CE)
        'kindOfFuselage','lowDragFuselage',... % [-] Kind of fuselage [5] (CE)
        'etaTra',0.07,... % [-] Tail rotor transmission wasting power percent [5] (CE)
        'etaTrp',0.12,... % [-] Main rotor transmission wasting power percent [5] (CE)
        'eta_ra',0.20 ... % [-] Power percent required by the tail rotor [5] (CE)
);

%% General components specific configuration (internal for the models)
options = struct( ...
                               'flgret',0.0800,...%[-] Alighting Gear: Landing gear retraction [1]
                   'flgcrashworthiness',0.1400,...%[-] Alighting Gear: Landing gear crashworthiness [1]
                                  'flg',0.0325,...%[-] 
                          'frotorShaft',0.1300,...%[-] Drive System: Rotor shaft [1]
                                  'ftr',1,...%[-] Empennage Group: Tail rotor [1]
                   'fairInductionGroup',0.3000,...% [-] Engine Section: Engine support structure [1]
                'pylonSupportStructure',0,...%[-] Engine Section: Pylon support structure [1]
                                'K0exh',0,...%[-] Engine System: Engine exhaust system [1]
                                'K1exh',0,...%[-] Engine System: Engine exhaust system [1]
                                 'flub',1,...%[-]
                 'ffixedWingNonBoosted',0,...%[-] Flight Controls: fixed wing non-boosted weight (fraction total fixed wing flight control weight) [1]
                'frotaryWingHydraulics',0.4000,...%[-] Flight Controls: rotary wing hydraulics weight (fraction hydraulics plus boost mechanisms) [1]
'frotaryWingHydraulicsSistemRedundancy',2,...%[-] Flight Controls: flight control hydraulic system redundancy factor [1]
                                'fnbsv',1,...%[-]
                                'fmbsv',1,...%[-]
                                 'fbsv',1,...%[-]
                                 'fcwb',1,...%[-]
                               'fwfold',0,...%[-] Fuselaje Group: WING AND ROTOR FOLD Weight [1]
                                 'fmar',0,...%[-] Fuselaje Group: MARINIZATION [1]
                               'fpress',0,...%[-] Fuselaje Group: PRESSURIZATION [1]
                               'ftfold',0.0500,...%[-] Fuselaje Group: WING AND ROTOR FOLD Tail [1]
                     'fcrashworthiness',0.0600,...%[-] Fuselaje Group: Crashworthiness [1]
                                'framp',1,...%[-]
                 'ffixedWingHydraulics',0,...%[-] Hydraulic Group: FIXED-WING FLIGHT CONTROLS [1]
                                'ftilt',1,...%[-] Rotor Group: Rotors blades [1]
                          'ffoldManual',1,...%[-]
                              'K0plumb',120,...%[-] Fuel System: Fuel plumbing [1]
                              'K1plumb',3,...%[-] Fuel System: Fuel plumbing [1]
                          'fballistict',1 ...%[-] Fuel System: TANKS AND SUPPORT STRUCTURE [1]
);
 

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%% DESIRED REQUIREMENTS  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
desreq = struct(...
                        'class','desreq',...
                           'id','cesar',...
                         'rand',rand,...
            'technologyFactors',technologyFactors,...
                  'costFactors',costFactors,...
                      'mission',mission,...
                      'options',options,...
            'energyEstimations',energyEstimations,...
                  'estimations',estimations ...
);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%




%% Estimations
% From here we add crude estimations
desreq.estimations.Sbody=57.459;  % [m^2] Body flat surface [5] (CE)
desreq.estimations.Wempty=1507*g; % [N] Empty weight [1] (CE)
desreq.estimations.f=0.9; % [m^2] Equivalent flat plate area [5] (CE)

