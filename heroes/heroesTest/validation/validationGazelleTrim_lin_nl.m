function io = validationGazelleTrim_lin_nl(mode)
clear all
close all


%% Setup atmosphere and computation options
%
% First, we setup heroes environment by defining and ISA+0 atmosphere, 
% the analysis altitude is sea level, hsl=0 and wind velocity in ground
% reference system is set to zero. Default options are defined by 
% setHeroesRigidOptions.
atm       = getISA;
hsl       = 0;
muWT      = [0; 0; 0];
options   = setHeroesRigidOptions;


he_ln     = rigidGazelle(atm);
lmr = linspace(0,1.0,11);
psimrvect = linspace(0,2*pi,180);
he_nl     = rigidNLGazelle(atm,lmr,psimrvect);
ndHe_ln   = rigidHe2ndHe(he_ln,atm,hsl);
ndHe_nl   = rigidHe2ndHe(he_nl,atm,hsl);


% Define flight condition for initial trim computation
vor_ini   = 0.01;

FCini     = {'VOR',vor_ini,...
             'betaf0',0,...
             'wTOR',0,...
             'cs',0,...
             'vTOR',0};
ndTSini = getNdHeTrimState(ndHe_ln,muWT,FCini,options);  
sol_ini = ndTSini.solution;
options.IniTrimCon = sol_ini;

%
%
vor_end = 0.35;
FC      = {'VOR',linspace(vor_ini,vor_end,31),...
           'betaf0',0,...
           'wTOR',0,...
           'cs',0,...
           'vTOR',0};
ndTS_ln = getNdHeTrimState(ndHe_ln,muWT,FC,options);  

%
%
options.mrForces          = @completeFNL;
options.mrMoments         = @aerodynamicMNL;
options.aeromechanicModel = @aeromechanicsNL;
options.trForces          = @completeFNL;
options.trMoments         = @aerodynamicMNL;

%
ndTS_nl        = getNdHeTrimState(ndHe_nl,muWT,FC,options);


%% Postprocessing
ndtsSol    = {ndTS_ln.solution,ndTS_nl.solution};


axds       = getaxds({'VOR'},{'$$V/(\Omega R)$$ [--]'},1);


var        = {...
'Theta',...
'Phi',...
'theta0',...
'theta1C',...
'theta1S',...
'theta0tr' ...
};

lab        = {...
'$$\Theta$$ [$$^o$$]',...
'$$\Phi$$ [$$^o$$]',...
'$$\theta_0$$ [$$^o$$]',...
'$$\theta_{1C}$$ [$$^o$$]',...
'$$\theta_{1S}$$ [$$^o$$]',...
'$$\theta_{0,tr}$$ [$$^o$$]',...
};

r2d       = 180/pi;
unit      = [r2d r2d r2d r2d r2d r2d ];
azds      = getaxds(var,lab,unit);
axATa     = plotNdTrimSolution(...
            ndtsSol,axds,{'Lineal','No lineal'},...
           'defaultVars',azds,'grid','off' ...
);               
%% saving fugures
% for i=1:6 ;
%    saveas(figure(i),['NL',var{i}],'epsc');    
% end    

io = 1;
