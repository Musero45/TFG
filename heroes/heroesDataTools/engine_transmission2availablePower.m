function availablePower = engine_transmission2availablePower(engine,transmission)

% Define maximun altitude. This seems safe because no helicopter has flown
% above Everest altitude
hMax    = 20000; % FIXME
h       = linspace(0,hMax,2001);

% Engine power maps
fPde    = engine.fPde;
fPmc    = engine.fPmc;
fPmu    = engine.fPmu;

% Transmission maximun power
% fPmt    = transmission.fPmt;
Pmt     = transmission.Pmt;

[fPa_de,Hde] = pieceWiseAvailablePower(fPde,Pmt,h);
[fPa_mc,Hmc] = pieceWiseAvailablePower(fPmc,Pmt,h);
[fPa_mu,Hmu] = pieceWiseAvailablePower(fPmu,Pmt,h);

availablePower = struct(...
                 'fPa_de',fPa_de,...
                 'fPa_mc',fPa_mc,...
                 'fPa_mu',fPa_mu,...
                 'Hde',Hde,...
                 'Hmc',Hmc,...
                 'Hmu',Hmu ...
);


function [fPa,Hlim] = pieceWiseAvailablePower(fEngineMap,Pmt,h)

hMax = max(h);
% Define equations to determine altitude at which transmission power is
% limitating
% This is a dirty hack because the addition of function handles does not
% work out of the box. The dirty hack is to directly input the transmission 
% maximum power taking advantage that does not depend on altitute or other
% parameters

myf0    = @(h) fEngineMap(h) - Pmt;

% Computation of altitude at which transmission power is limitating
Hlim    = fzero(myf0,hMax);


% Define available power as a piecewise function
% Allocate available power data
Pa   = zeros(size(h));

% Define logical regions
r1   = h <  Hlim;
r2   = h >= Hlim;
Pa(r1) = Pmt*ones(size(h(r1)));
Pa(r2) = fEngineMap(h(r2));

% Define available power function handle
fPa    = @(H)interp1(h,Pa,H);







% f0Pmd    = @(h) fPde(h) - Pmt;
% f0Pmc    = @(h) fPmc(h) - Pmt;
% f0Pmu    = @(h) fPmu(h) - Pmt;

% % Computation of altitude at which transmission power is limitating
% Hmd     = fzero(f0Pmd,hMax);
% Hmc     = fzero(f0Pmc,hMax);
% Hmu     = fzero(f0Pmu,hMax);





% % % % % engine definition
% % % % Pmt     = stathe.Performances.TakeOffTransmissionRating*stathe.Engine.numEngines;% m?x en la transmision
% % % % Pde     = stathe.Engine.PowerTakeOff*stathe.Engine.numEngines;% despegue
% % % % Pmc     = stathe.Engine.PowerMaximumContinuous*stathe.Engine.numEngines;% max continua
% % % % % urgencia, suponemos un 10% de incremento al no disponer la base de datos de este dato.
% % % % Pmu     = Pde*1.1*stathe.Engine.numEngines;
% % % % 
% % % % 
% % % % P0      = Pmc;
% % % % n       = 0.85;
% % % % cE      = stathe.Engine.SPC/1000;%kg/W/s;
% % % % 
% % % % density = atmosphere.density;
% % % % fPower  = @(h) engPower(h,P0,n,density);
% % % % 
% % % % fPmt    = @(h) Pmt*ones(size(h));
% % % % fPde    = @(h) engPower(h,Pde,n,density);
% % % % fPmc    = @(h) engPower(h,Pmc,n,density);
% % % % fPmu    = @(h) engPower(h,Pmu,n,density);
% % % % 
% % % % % f0Pmd    = @(h) engPower(h,Pde,n,density) - Pmt;
% % % % % f0Pmc    = @(h) engPower(h,Pmc,n,density) - Pmt;
% % % % % f0Pmu    = @(h) engPower(h,Pmu,n,density) - Pmt;
% % % % 
% % % % % Hmd     = fzero(f0Pmd,10000);%limitaciones de transmisi?n despegue
% % % % % Hmc     = fzero(f0Pmc,10000);%limitaciones de transmisi?n continua
% % % % % Hmu     = fzero(f0Pmu,10000);%limitaciones de transmisi?n urgencia
% % % % 
% % % % engine = struct(...
% % % %          'class','engine',...
% % % %          'id',label,...
% % % %          'fPmt',fPmt,...
% % % %          'fPde',fPde,...
% % % %          'fPmc',fPmc,...
% % % %          'fPmu',fPmu,...
% % % %          'Pmt',Pmt, ...
% % % %          'Pde',Pde, ...
% % % %          'Pmc',Pmc, ...
% % % %          'Pmu',Pmu, ...
% % % %          'n',n, ...
% % % %          'cE',cE ...
% % % % );
% % % %

