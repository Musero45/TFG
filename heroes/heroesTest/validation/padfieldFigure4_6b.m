function io = padfieldFigure4_6b(mode)
%% padfieldFigure4_6b 
% Pitch angle for different turn rate of Lynx helicopter (rad/s)
% Comparison between de results of Helisim and Heroes
% Flight speed: 80 kn
%
% Data taken from reference [1]
% Phi digitize from figure 4.6(b) page 200 of [1]
%
% [1] G.D. Padfield Helicopter Flight Dynamics 2007
%
% Author: Francisco J. Ruiz Fernandez
%

close all
clear all
setPlot;

atm           = getISA;
he            = rigidLynx(atm);
Om            = he.mainRotor.Omega;
Rmr           = he.mainRotor.R;

hsl           = 0;
ndHe          = rigidHe2ndHe(he,atm,hsl);

options       = setHeroesRigidOptions;

muWT          = [0; 0; 0];
gammaT        = [0; 0.1; 0.15];
omegaAdzT     = linspace(0.01,0.4,31)./Om;
VOR           = 80.*0.5144444./(Rmr*Om);
FC            = {'omegaAdzT',omegaAdzT,...
                 'betaf0',0,...
                 'gammaT',gammaT,...
                 'VOR',VOR,...
                 'vTOR',0};
             
% To compute the nondimensional trim state just use the function 
% getNdHeTrimState.                         
ndts          = getNdHeTrimState(ndHe,muWT,FC,options);

% To waste less time running this code it is useful the save and load
% functions
% % % save ndts4_6b
% % % load ('ndts4_6b')

%%
% This section plots the graph 4.6 b caculated with Heroes instead of
% Helisim. It is also plotted the bend radius(Rc) and the Phi angle, in
% order to analyze the if the conditions set by Padfield are the same as
% the ones we use in Heroes.

Rc=1./ndts.solution.cs;
ndts.solution.Rc=Rc;

azdsTS        = getaxds(...
                {'Theta','Phi','Rc',},...
                {'$$\Theta $$ [rad]','$$\Phi$$ [$$^o$$]','$$R_c$$ [m]'},...
                 [1,180/pi,Rmr]);             
axds          = getaxds({'omegaAdzT'},{'turn rate[rad/s]'},Om);
ayds          = getaxds({'gammaT'},'$$\gamma_T$$ [rad/s]',1);
plotNdTrimSolution(ndts.solution,axds,ayds,...
                   'defaultVars',azdsTS,...
                   'plot3dMode','parametric');               
              
%%               
% Finally, to compare better the results from Heroes and from Helisim, in
% this section are plotted both results in the same graphic.
% Figure 4, gammaT = 0
% Figure 5, gammaT = 0.1
% Figure 6, gammaT = 0.15
% Relative error its also obtained with MycheckError4s

azdsTS        = getaxds(...
                {'Theta'},...
                {'$$\Theta $$ [rad]'},...
                 1);
 title = {'$$\gammaT$$=0','$$\gammaT$$ = 0.1','$$\gammaT$$=0.15'};
 
 xvar   = 'omegaAdzT';
 zvars  = {'Theta'};
             
TO=padfieldFigure4_6b_data();

X1=struct('Theta',{},'omegaAdzT',{});
X2=struct('Theta',{},'omegaAdzT',{});
err=struct('Theta',{});
 
for i=1:3;
X1(i).Theta = ndts.solution.Theta(:,:,i);
X1(i).omegaAdzT = ndts.solution.omegaAdzT(:,:,i);

X2(i).Theta = TO.Theta(:,:,i);
X2(i).omegaAdzT = TO.omegaAdzT(:,:,i);
c={X1(i),X2(i)};
plotNdTrimSolution(c,axds,{'Heroes','Helisim'},...
                   'defaultVars',azdsTS,...
                   'plot2dMode','nFigures',...
                   'titleplot',title{i});

[err(i)] = checkError4s(X1(i),X2(i),xvar,'metric', 'mean',... 
                       'TOL', 1e-10,'zvars',zvars);

end

io = 1;
