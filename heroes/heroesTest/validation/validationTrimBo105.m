function io = validationTrimBo105(mode)
%% Helicopter Trim and Stabillity Analysis
%
%   This function compares the Heroes result of the trim analysis with the
%   test fligth results from Padfield.
%
% Data taken from reference [1]
% Theta digitize from figure 4.6(a) page 198 of [1]
% theta1s digitize from figure 4.10(a) page 203 of [1]
% theta1c digitize from figure 4.10(b) page 203 of [1]
% theta0 digitize from figure 4.10(c) page 203 of [1]
% thetaotr digitize from figure 4.10(d) page 203 of [1]
% power digitize from figure 4.11 page 203 of [1]
%
% [1] G.D. Padfield Helicopter Flight Dynamics 1996
%
% TODO
% - Function name should include Bo105 to indicate the helicopter data
%

close all
clear all
setPlot;

atm           = getISA;
he            = PadfieldBo105(atm);


hsl           = 0;
ndHe          = rigidHe2ndHe(he,atm,hsl);

options       = setHeroesRigidOptions;

muWT          = [0; 0; 0];
ndV           = linspace(0.001,0.25,31);
FC            = {'VOR',ndV,...
                 'betaf0',0,...
                 'wTOR',0,...
                 'cs',0,...
                 'vTOR',0};
             
% To compute the nondimensional trim state just use the function 
% getNdHeTrimState.            
             
ndts          = getNdHeTrimState(ndHe,muWT,FC,options);

% To waste less time running this code it is useful the save and load
% functions
% % % save ndts
% % % load('ndts')

TrimState = ndts.solution;

% This function is used to get the power of the helicopter in order to
% comare it with the test fligt data from Padfield. 
ts   = ndHeTrimState2HeTrimState(ndts,he,atm,hsl,options);
TrimState.PMpower = ts.Pow.PM;

% Flight Test results from de code: getPadfieldFlightTest.m 
tsbo105_i = {ThetaBo105FlightTest,...
             theta0Bo105FlightTest,...
             theta1CBo105FlightTest,...
             theta1SBo105FlightTest,...
             theta0trBo105FlightTest,...
             PowerBo105FlightTest};

%%
zvarsTS     ={'Theta','theta0','theta1C','theta1S','theta0tr','PMpower'};

trimlabels  ={'$$\Theta$$ [$$^o$$]',...
              '$$\theta_{0}$$ [$$^o$$]',...
              '$$\theta_{1C}$$ [$$^o$$]',...
              '$$\theta_{1S}$$ [$$^o$$]',...
              '$$\theta_{0tr}$$ [$$^o$$]',...
              'Power [W]'};
scalefactor =[180/pi,180/pi,180/pi,180/pi,180/pi,10^(-3)];            

% This loop calls the corresponding function stored in tsbo105_i ,
% which contains the data on flight test from Padfield , and compares
% each variable from it with those obtained by Heroes.
% The comparison is done both by screen printing with a graph, as well 
% as with the function MycheckErro4s by comparing the relative error.

for i=1:length(zvarsTS); 
 
    tsbo105=tsbo105_i{i};
  
    xvar  = 'VOR';
    errTSi  = checkError4s(tsbo105,TrimState,xvar,'metric', 'mean',... 
                        'TOL', 1e-10,'zvars',zvarsTS{i});
    errTS.(zvarsTS{i}) = errTSi.(zvarsTS{i});                
    
    
    azdsTS  = getaxds({zvarsTS(i)},{trimlabels(i)},scalefactor(i));   

    x       = {TrimState,tsbo105};
    axds    = getaxds({'VOR'},{'V/(\Omega R) [-]'},1);
    plotNdTrimSolution(x,axds,{'Heroes','Padfield Flight Test'},...
                   'defaultVars',azdsTS,...
                   'plot2dMode','nFigures');
               
end
%%
MatErr=[errTS.Theta,errTS.theta0,errTS.theta1C,0;
        errTS.theta1S,errTS.theta0tr,0,0;
        0,0,0,0];
h=pcolor(MatErr);
rotate(h,[1,0,0],180);
colorbar
% colormap(hsv)

io = 1;
