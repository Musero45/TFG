function  io = validationGazelleTrim(mode)
close all
clear all
setPlot;
%% Setting up environment

atm           = getISA;
%% Constant definitions

he_lin        = rigidGazelle(atm);
lmr = linspace(0,1.0,11);
psimrvect = linspace(-pi,pi,180);
he_nln     = rigidNLGazelle(atm,lmr,psimrvect);
options       = setHeroesRigidOptions;
muWT          = [0; 0; 0];
W2hp          = 0.00134102;

%% Definition of trim state variables 
% Set variables dependent upon reported trim variables 
% (5 trim state variables)
zvarsTS     ={'Theta','theta0','theta1C','theta1S','PMpower'};       
trimlabels  ={'$$\Theta$$ [$$^o$$]',...
              '$$\theta_{0}$$ [$$^o$$]',...
              '$$\theta_{1C}$$ [$$^o$$]',...
              '$$\theta_{1S}$$ [$$^o$$]',...
              '$$P_M$$ [$$hp$$]' ...
};
scalefactor =[180/pi,180/pi,180/pi,180/pi,W2hp];  
nvar        = length(zvarsTS);

% This statements loads all the flight tests because each of the cell
% variables is a known function with data from digitize.
tsfigure = {...
ThetaGazelleNasa88351,...
Theta0GazelleNasa88351,...
Theta1CGazelleNasa88351,...
Theta1SGazelleNasa88351,...
PowerGazelleNasa88351 ...
};



%% Definition of flight test parameters
% Set variables dependent upon reported flight conditions 
% (7 flight conditions)
fc_leg      = {'FC1','FC2','FC3','FC4','FC5','FC6','FC7'};
fc_mark     = {'<','d','v','>','o','s','^'};
nfc         = length(fc_leg);

% Define set of flight conditions according to reported flight tests
FC          = getFC_nasa_88351(tsfigure{1});
H           = [317,1521,235,320,336,308,292];
W           = atm.g*[1985,1934,1951,1979,1973,1967,1961];

%% Definition of heroes trim state
% Compute
opt   = cell(nfc,1);
for i = 1:nfc
    opt{i}  = options;
end

[ts_lin,ndtssol] = he2flightState(he_lin,atm,H,W,muWT,FC,opt,zvarsTS);

opt_nln  = cell(nfc,1);
for i = 1:nfc
    opt_nln{i}                   = opt{i};
    opt_nln{i}.IniTrimCon        = ndtssol{i};
    opt_nln{i}.mrForces          = @completeFNL;
    opt_nln{i}.mrMoments         = @aerodynamicMNL;
    opt_nln{i}.aeromechanicModel = @aeromechanicsNL;
    opt_nln{i}.trForces          = @completeFNL;
    opt_nln{i}.trMoments         = @aerodynamicMNL;
end

ts_nln = he2flightState(he_nln,atm,H,W,muWT,FC,opt_nln,zvarsTS);


%% Definition of analyses
% Joint together flight test data and heroe's computations
ft          = {tsfigure,ts_lin,ts_nln};
ft_color    = {'w','k','r'};

%% Plot section
nana        = length(ft);

for i=1:nvar
    figure(i);
    for k=1:nana
    ts  = ft{k};
    for j=1:nfc
        X2 = ts{i}.VOR(j,1);  
        Y2 = ts{i}.(zvarsTS{i})(j,1)*scalefactor(i);
        p = plot(X2,Y2,...
                'LineStyle','none',...
                'Marker',fc_mark{j},...
                'MarkerEdgeColor','k',...
                'MarkerFaceColor',ft_color{k},...
                'MarkerSize',8); hold on;
     end
     end
     xlabel('$$V/(\Omega R)$$ [--]');
     ylabel(trimlabels{i}); 
     legend(fc_leg,'FontSize',13,'Location','Best');
     
end

    
%% saving figures

% for i=1:5 ;
%    saveas(figure(i),['FC',zvarsTS{i},'NL'],'png');    
% end   

io = 1;

end

function FC          = getFC_nasa_88351(tsfigure)

nfc           = length(tsfigure.VOR);
FC            = cell(nfc,1);
for i = 1:nfc

    FC{i}   = {'VOR',tsfigure.VOR(i),...
               'betaf0',0,...
               'wTOR',0,...
               'cs',0,...
               'vTOR',0};
end

end




function [ft,ndtssol]   = he2flightState(he,atm,H,W,muWT,FC,options,zvars)

nfc          = length(H);
% nv           = length(zvars);
ndtssol      = cell(nfc,1);

Theta        = cell(nfc,1);
theta0       = cell(nfc,1);
theta1C      = cell(nfc,1);
theta1S      = cell(nfc,1);
Power        = cell(nfc,1);

for j = 1:nfc
    he.inertia.W = W(j);
    ndHe         = rigidHe2ndHe(he,atm,H(j));
    fc           = FC{j};
    ndts         = getNdHeTrimState(ndHe,muWT,fc,options{j});
    ndtssol{j}   = ndts.solution;
    ts           = ndHeTrimState2HeTrimState(ndts,he,atm,H(j),options{j});
    Theta{j}     = struct('VOR',fc{2},(zvars{1}),ndts.solution.Theta);
    theta0{j}    = struct('VOR',fc{2},(zvars{2}),ndts.solution.theta0);
    theta1C{j}   = struct('VOR',fc{2},(zvars{3}),ndts.solution.theta1C);
    theta1S{j}   = struct('VOR',fc{2},(zvars{4}),ndts.solution.theta1S);
    Power{j}     = struct('VOR',fc{2},(zvars{5}),ts.Pow.PM);
    
end


sTheta    = coswsf2swmf(Theta);
stheta0   = coswsf2swmf(theta0);
stheta1C  = coswsf2swmf(theta1C);
stheta1S  = coswsf2swmf(theta1S);
sPower    = coswsf2swmf(Power);

ft        = {sTheta,stheta0,stheta1C,stheta1S,sPower};

end


 