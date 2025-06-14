function io = dimensioning02(mode)
close all

% This is the basic template of input data containing 
% the helicopter design requirements (desreq)
% this case corresponds to Emory's design specifications
% this data is usually obtained from a RFP (Request For Proposal)
% see aiaa-rfp-2011-2012.pdf to get a grasp of what a RFP is.

% Old line (not needed anymore)
% load input;
% The actual one (emory's project)
dr = cesarDR;


% there are two ways to select an engine 
% 1.- Get the most suitable engine from the engine database 
% using the function engineSelection. This is the old one and 
% the function engineSelection is too much clever for Oscar's taste
% this part of the code is deprecated
% list_engine = getEngine_db;
% Get performance
% pfmc  = getRandPerformance(dr);
% engine      = engineSelection(list_engine,pfmc);


% 2.- just selecting one of the engines of the database
% For the time being, it does not work because engineSelection adds the
% field of numEngines using performance to compute it and the number
% of engines should be added by hand
atm               = getISA;
numEngines        = 2;
engine            = Allison250C28C(atm,numEngines);

% the funcion desreq2hedim inputs helicopter design requirement
% specification and engine data type to transform it into a 
% dimensioning helicopter using Rand and Jonhson estimations 
% which is a variable called heli
heli = desreq2stathe(dr,engine);


% The following code takes care of producing a valid energy helicopter 
% to be used in heroes and compute the helicopter performance using
% the energy method. The energy helicopter is a variable called he
atm  = getISA; 

he   = stathe2ehe(atm,heli);

io = 1;