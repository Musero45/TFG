function desreq = emoryDR
% This is the basic template to input design requirements (desreq)
% 
% TODO this function lacks the basic information of the explanation
% of the meaning of the symbols

g      = 9.81;
kmh2ms = 1/3.6;
rand = struct( ...
         'MTOW', 2400*g,... %[N]
         'Range',615e3,...  %[m]
         'Vm',235*kmh2ms,...%[m/s]
         'b',3,...          %[-]
         'btr',2,...        %[-]
         'Crew',2 ...       %[-]
);

estimations = struct( ...
       'Nlg',2,... %[-]
       'Nds',2,... %[-]
       'Nat',0,... %[-]
       'Tat',0,... %[N]
       'Aat',1,... %[-]
       'Aht',0,... %[-]
       'Svt',0,... %[m^2]
       'Avt',0,... %[m^2]
      'Nint',1,... %[-]
    'Nplumb',2,... %[-]
        'wb',1.1000,... %[s^-1]
        'wh',1.1000,... %[s^-1]
     'Dspin',0 ... %[-]
);

technologyFactors = struct( ...
                           'lg',1, ... %[-]
                        'lgret',1, ... %[-]
            'lgcrashworthiness',1, ... %[-]
                    'gearBoxes',1, ... %[-]
                   'rotorShaft',1, ... %[-]
                   'driveShaft',1, ... %[-]
                   'rotorBrake',1, ... %[-]
                           'ht',1, ... %[-]
                           'vt',1, ... %[-]
                           'tr',1, ... %[-]
                           'at',1, ... %[-]
       'engineSupportStructure',1, ... %[-]
                'engineCowling',1, ... %[-]
        'pylonSupportStructure',1, ... %[-]
            'airInductionGroup',1, ... %[-]
                   'mainEngine',1, ... %[-]
          'engineExhaustSystem',1, ... %[-]
             'engineAccesories',1, ... %[-]
          'fixedWingNonBoosted',1, ... %[-]
     'fixedWingBoostMechanisms',1, ... %[-]
         'rotaryWingNonBoosted',1, ... %[-]
    'rotaryWingBoostMechanisms',1, ... %[-]
            'rotaryWingBoosted',1, ... %[-]
                         'tank',1, ... %[-]
                        'plumb',1, ... %[-]
                        'basic',1, ... %[-]
                        'tfold',1, ... %[-]
                        'wfold',1, ... %[-]
                          'mar',1, ... %[-]
                        'press',1, ... %[-]
              'crashworthiness',1, ... %[-]
          'fixedWingHydraulics',1, ... %[-]
         'rotaryWingHydraulics',1, ... %[-]
                        'blade',1, ... %[-]
                          'hub',1, ... %[-]
                         'spin',1, ... %[-]
                         'fold',1, ... %[-]
                     'aircraft',1, ... %[-]
                  'maintenance',1  ... %[-]
);

% Blatant ripoff from Cesar's Design Requirements
costFactors = struct( ...
     'compositeAdditionalPrice',1000, ...   % [$/kg]
            'compositeFraction',0.4, ...    % [-] fraction W_MTO
                   'engineType',1.0,...     % [1.0 for turbine aircraft|0.557 for piston aircraft]
                   'numEngines',0.736,...   % [1.0 for multi-engine aircraft|0.736 for sigle-engine aircraft]
                       'lgType',0.884,...   % [1.0 for retractable landing gear|0.884 for fixed landing gear]
                'numMainRotors',1.0...      % [1.0 for single main rotor|1.057 twin main rotors|1.117 four main rotors]  
);

mission = struct( ...
                  'fuelWeight',3540, ...        % [N]
                        'time',3600, ...        % [s]
           'avaibleBlockHours',720000, ...      % [s]
           'sparesPerAircraft',0.001, ...       % [-]fraction purchase price
          'depreciacionPeriod',30, ...          % [yr]
               'residualValue',0.1, ...         % [-]fraction
                  'loanPeriod',5, ...           % [yr]
                'interestRate',3, ...           % [%]
           'nonFlightTimeTrip',720, ...         % [s]
               'numPassengers',2,...            % [-]
                 'fuelDensity',804.035, ...     % [kg/m^3]
                  'crewFactor',1, ...           % [-]
        'initialOperationYear',2015, ...        % [yr]                 
             'operationPeriod',1, ...           % [yr]
     'missionEquipmentPackage',500, ...         % [N]
    'flightControlElectronics',100, ...         % [N]
               'costFactorMEP',1000, ...        % [$/kg]
               'costFactorFCE',1000, ...        % [$/kg]
                'purchaseYear',2015, ...        % [yr]
'priceIndex',[ 147.13 151.77 154.91 157.26 160.25 163.94 167.57 171.89 ...
176.02 180.25 184.58 189.01 193.55 198.19 202.95], ... % [%]
'fuelCost',[ 579.0 724.9 791.8 742.0 679.6 639.5 645.0 676.9 ...
703.1 730.9 754.7 777.2 797.7 819.9 842.1]...  % [$/m3]
);

options = struct( ...
                                   'flgret',0.0800,...
                       'flgcrashworthiness',0.1400,...
                                      'flg',0.0325,...
                              'frotorShaft',0.1300,...
                                      'ftr',1,...
                       'fairInductionGroup',0.3000,...
                    'pylonSupportStructure',0,...
                                   'K0exh',0,...
                                    'K1exh',0,...
                                     'flub',1,...
                     'ffixedWingNonBoosted',0,...
                    'frotaryWingHydraulics',0.4000,...
    'frotaryWingHydraulicsSistemRedundancy',2,...
                                    'fnbsv',1,...
                                    'fmbsv',1,...
                                     'fbsv',1,...
                                  'K0plumb',120,...
                                  'K1plumb',3,...
                                     'fcwb',1,...
                                   'fwfold',0,...
                                     'fmar',0,...
                                   'fpress',0,...
                                   'ftfold',0.0500,...
                         'fcrashworthiness',0.0600,...
                                    'framp',1,...
                     'ffixedWingHydraulics',0,...
                                    'ftilt',1,...
                              'ffoldManual',1,...
                              'fballistict',1 ...
);

% From [1] page 217 Bo-105 has a equivalent flat plate area of 10 ft^2
% [1] J. G. Leishman Principles of Helicopter Aerodynamics, 2002
% kindOfFuselage = {lowDragFuselage} | averageDragFuselage | highDragFuselage

energyEstimations =  struct( ...
            'kappa',1.15,...
            'K',5,...
            'cd0',0.01,...
            'kindOfFuselage','lowDragFuselage',...
            'etaTra',0.07,...
            'etaTrp',0.12,...
            'eta_ra',0.06 ...
);



desreq = struct(...
         'class','desreq',...
         'id','emory',...
         'rand',rand,...
         'technologyFactors',technologyFactors,...
         'options',options,...
         'costFactors',costFactors,...
         'mission',mission,...
         'energyEstimations',energyEstimations,...
         'estimations',estimations ...
);



% From here we add crude estimations
desreq.estimations.Sbody=57.459;
