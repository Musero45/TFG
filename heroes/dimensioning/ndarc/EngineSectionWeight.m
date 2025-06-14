function y = EngineSectionWeight(input,engine)
%
% NDARC, NASA Design and Analysis of Rotorcraft (2009)
% Wayne Johnson
%  
% ENGINE SECTION OR NACELLE GROUP AND AIR INDUCTION GROUP
%
% Input and output variables expressed in International System 
%
% Initial version: Emory et al
% International System Version 
%      23/01/2014 Alvaro Moreno Sacristan alvaro.msacristan@alumnos.upm.es
%



MTOW = input.rand.MTOW;
Snac = engine.Snac;
Neng = engine.numEngines;
Weng = engine.weight;
chisupt   = input.technologyFactors.engineSupportStructure;
chicowl   = input.technologyFactors.engineCowling;
chipylon  = input.technologyFactors.pylonSupportStructure;
chiairind = input.technologyFactors.airInductionGroup;
fairind = input.options.fairInductionGroup;
fpylon  = input.options.pylonSupportStructure;


%Factores de conversi?n 
Kgf2N = 9.81;
Kg_lb = 2.2046;
m_ft = 3.2808;

%Pasamos a Sistema Imperial
MTOW_ = MTOW*Kg_lb/Kgf2N;
Weng_ = Weng*Kg_lb/Kgf2N;
Snac_ = Snac*(m_ft)^2;

%ENGINE SUPPORT STRUCTURE
%Weng=Weight all main engines
%Neng=Number of Main Engines
wsupt_ = 0.0412*(1-fairind)*((Weng_/Neng)^1.1433)*(Neng^1.3762);
Wsupt_= chisupt*wsupt_;


%ENGINE COWLING
%Snac=wetted area of nacelles and pylon (less spinner)
wcowl_ = 0.2315*Snac_^1.3476;
Wcowl_ = chicowl*wcowl_;



%PYLON SUPPORT STRUCTURE
%MTOW= maximun takeoff weight
%fpylon=pylon support structure weight (fraction MTOW)
wpylon_= fpylon*MTOW_;
Wpylon_= chipylon*wpylon_;


%AIR INDUCTION GROUP WEIGHT
%Weng=Weight all main engines
%Neng=Number of Main Engines
wairind_ = 0.0412*fairind*((Weng_/Neng)^1.1433)*(Neng^1.3762);
Wairind_ = chiairind*wairind_;

%Pasamos a SI
Wsupt = Wsupt_*Kgf2N/Kg_lb;
Wairind = Wairind_*Kgf2N/Kg_lb;
Wpylon = Wpylon_*Kgf2N/Kg_lb;
Wcowl = Wcowl_*Kgf2N/Kg_lb;

y = struct (...
    'WengineSupportStructure', Wsupt,...
    'WengineCowling', Wcowl,...
    'WpylonSupportStructure', Wpylon,...
    'WairInductionGroup', Wairind ...
);
