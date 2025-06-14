function ehe = selectTestingEhe(energytestcase,atm)
%
% This is an auxiliary function to help defining the set of engine and
% design requirements together with a direct input of an energy helicopter
% and to cover a wide set of energy helicopter cases to test energy
% performance computations.

switch energytestcase
case 'cesar1'
    % Define engine
    numEngines = 1;
    engine     = Arriel2C1(atm,numEngines);
    % Get design requirements
    dr         = cesarDR;
    % Transform design requirements to statistical helicopter
    heli       = desreq2stathe(dr,engine);
    % Transform statistical helicopter to energy helicopter
    ehe        = stathe2ehe(atm,heli);
    % Set maximum transmission power to have enough available power
    Pmt                     = 6.2e5;
    fPmt                    = @(h) Pmt*ones(size(h));
    ehe.transmission.fPmt   = fPmt;
    ehe.transmission.Pmt    = Pmt;
    availablePower = engine_transmission2availablePower(ehe.engine,ehe.transmission);
    ehe.availablePower = availablePower;

case 'cesar2'
    % Define engine
    numEngines = 2;
    engine     = Allison250C28C(atm,numEngines);
    % Get design requirements
    dr         = cesarDR;
    % Transform design requirements to statistical helicopter
    heli       = desreq2stathe(dr,engine);
    % Transform statistical helicopter to energy helicopter
    ehe        = stathe2ehe(atm,heli);
    % Set maximum transmission power to have enough available power
    Pmt                     = 6.2e5;
    fPmt                    = @(h) Pmt*ones(size(h));
    ehe.transmission.fPmt   = fPmt;
    ehe.transmission.Pmt    = Pmt;
    availablePower = engine_transmission2availablePower(ehe.engine,ehe.transmission);
    ehe.availablePower = availablePower;

case '4500kg'
    % Define engine
    numEngines = 2;
    engine     = Arriel2C2(atm,numEngines);
    % Get design requirements
    dr         = kg4500DR;
    % Transform design requirements to statistical helicopter
    heli       = desreq2stathe(dr,engine);
    % Transform statistical helicopter to energy helicopter
    ehe        = stathe2ehe(atm,heli);
    % Set maximum transmission power to have enough available power
    Pmt                     = 1.1e6;
    fPmt                    = @(h) Pmt*ones(size(h));
    ehe.transmission.fPmt   = fPmt;
    ehe.transmission.Pmt    = Pmt;
    availablePower          = engine_transmission2availablePower(ehe.engine,ehe.transmission);
    ehe.availablePower      = availablePower;

case '6000kg'
    % Define engine
    numEngines = 2;
    engine     = CT58_140(atm,numEngines);
    % Get design requirements
    dr         = kg6000DR;
    % Transform design requirements to statistical helicopter
    heli       = desreq2stathe(dr,engine);
    % Transform statistical helicopter to energy helicopter
    ehe        = stathe2ehe(atm,heli);

case '9000kg'
    % Define engine
    numEngines = 2;
    engine     = CT7_8A(atm,numEngines);
    % Get design requirements
    dr         = kg9000DR;
    % Transform design requirements to statistical helicopter
    heli       = desreq2stathe(dr,engine);
    % Transform statistical helicopter to energy helicopter
    ehe        = stathe2ehe(atm,heli);

case 'ehe'
    ehe        = superPuma(atm);

otherwise
    disp('Unknown Energy Test Case.')

end