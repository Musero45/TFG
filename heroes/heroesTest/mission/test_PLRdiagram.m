function io = test_PLRdiagram(mode)
% TEST_PLRDIAGRAM Tests PLR methodology.
%
%   This function obtains the PL-R diagram of the helicopter obtained with
%   dimensioning (using cesarDR). 2 PLR are calculated: stathe of
%   dimensioning and the same stathe but with the real weights of Bo105. 
%   Also it's included the real PLR diagram of Bo105 using getDataPLRBo105.

close all

%% Input helicopter

% Atmosphere
atm = getISA;

% DR
numEngines = 2;
engine     = Allison250C28C(atm,numEngines);
desreq     = cesarDR;

% Dimensioning
stathe     = desreq2stathe(desreq,engine);

% Dimensioning 2 energy helicopter
ehe = stathe2ehe(atm,stathe);

% We recompute available power
Pmt                    = 620e3;
fPmt                   = @(h) Pmt*ones(size(h));
he.transmission.fPmt   = fPmt;
he.transmission.Pmt    = Pmt;
availablePower = engine_transmission2availablePower(ehe.engine,he.transmission);
ehe.availablePower = availablePower;

%% PL-R

% PL-R diagram obtained using dim-->energy
[ PL{1}, R{1} ] = getPLRdiagram(ehe,atm,'externalPLinPLR','yes');
sty{1} = 'bo-';
leg{1} = 'PL-R stathe';

% Bo105 Example helicopter real Weights (to verify that this method works)
ehe.weights.MPL  = 837*atm.g;
ehe.weights.OEW  = 1507*atm.g;
ehe.weights.MTOW = 2600*atm.g;
ehe.weights.MFW  = 456*atm.g;

% PL-R diagram manual calculation by previous introducing weights
[ PL{2}, R{2} ] = getPLRdiagram(ehe,atm,'externalPLinPLR','yes');
sty{2} = 'ro-';
leg{2} = 'stathe with Bo105 Real Weights';

% PL-R real from Bo105
[ PL{3}, R{3} ] = getDataPLRBo105;
sty{3} = 'ko-';
leg{3} = 'Bo105';

%% Plot results

plotPLRdiagram(1,PL,R,sty,leg);

%%
io = 1;

