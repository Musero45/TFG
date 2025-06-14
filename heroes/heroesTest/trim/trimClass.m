clear all
close all


opt1       = {'armonicInflowModel',@none};
options{1} = parseOptions(opt1,@setHeroesRigidOptions);

opt2       = {'armonicInflowModel',@Coleman};
options{2} = parseOptions(opt2,@setHeroesRigidOptions);

opt3       = {'armonicInflowModel',@Coleman,'fInterf',@linearInterf,'lHTPInterf',@linearInterf,'rHTPInterf',@linearInterf};
options{3} = parseOptions(opt3,@setHeroesRigidOptions);
%atmosphere variables needed
atm     = getISA;
rho0    = atm.rho0;
g       = atm.g;

%helicopter model selection
he      = rigidBo105(atm);

% helicopter 2 non-dimensional helicopter
ndHe = rigidHe2ndHe(he,rho0,g);

CW = ndHe.inertia.CW;

muWT = [0; 0; 0];
ndV = linspace(0.0001,.299,31);
n = length(ndV);

flightConditionT = zeros(6,n);

m = length(options);

trimState = cell(1,m);

tic;
initialCondition = [0.05; -0.05; .25; 0; 0; .25; 0; 0; 0; -sqrt(CW/2); 0; 0; CW; 0; 0;0; 0; 0; -sqrt(CW/20); 0; 0; CW/10; 0; 0; 0];
x = zeros(25,n);
flightConditionT(1,:) = ndV(:);

for j = 1:m
nlSolver  = options{j}.nlSolver;
    for i = 1:n
        disp (['Solving trim...  ', num2str(i+n*(j-1)), ' of ', num2str(m*n)]);
        system2solve = @(x) helicopterTrim(x,flightConditionT(:,i),muWT,ndHe,options{j});
        x(:,i) = nlSolver(system2solve,initialCondition,options{j});
        for k = 1:25
            if abs(x(k,i))<options{j}.TolX
                x(k,i) = 0;
            end
        end
        initialCondition = x(:,i);
    end
trimState{j} = getHeTrimState(x,flightConditionT,muWT,ndHe,options{j});
plotActionsByElement(trimState{j},j);
end
toc

pairs = {};
%%%% Uncomment following line in order to generate output files
pairs = {'format' {'pdf'} 'prefix' '1' 'closePlot' 'no'};
% legend1 = {'Bo105'};
% ts{1} = trimState{1,1};
% plotSimplifiedTS(ts,legend1,pairs);
% pause
% 
% close all
% legend2 = {'Bo105' 'inflow'};
% ts{2} = trimState{1,2};
% plotSimplifiedTS(ts,legend2,pairs);
% pause
% 
% close all
legend3 = {'Bo105' 'inflow' 'interference'};
plotSimplifiedTS(trimState,legend3,pairs);

close all
%plotActionsByElement(trimState{1});