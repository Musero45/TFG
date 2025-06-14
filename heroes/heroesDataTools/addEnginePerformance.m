function engine = addEnginePerformance(engIn,atmosphere)

engine            = engIn;
numEngines        = engIn.numEngines;
label             = engIn.model;

% % Pmt     = stathe.Performances.TakeOffTransmissionRating*stathe.Engine.numEngines;% m?x en la transmision
% % fPmt    = @(h) Pmt*ones(size(h));
% % engine.Pmt    = Pmt;

% power function handle engine definition
Pde     = engine.PowerTakeOff*numEngines;% takeoff power
Pmc     = engine.PowerMaximumContinuous*numEngines; % continuous maximum

% urgency, it is supposed an increment of 10%
% al no disponer la base de datos de este dato.
Pmu     = Pde*1.1; % FIXME

n       = engine.powerExponent;

density = atmosphere.density;
% fPower  = @(h) engPower(h,Pmc,n,density);

fPde    = @(h) engPower(h,Pde,n,density);
fPmc    = @(h) engPower(h,Pmc,n,density);
fPmu    = @(h) engPower(h,Pmu,n,density);


engine.class  = 'engine';
engine.id     = label;
engine.fPde   = fPde;
engine.fPmc   = fPmc;
engine.fPmu   = fPmu;
engine.Pde    = Pde;
engine.Pmc    = Pmc;
engine.Pmu    = Pmu;

