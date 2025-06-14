% 
% This script reproduces the following figures of Nano's PFC [1]
% Figure 4.13 (a) and (b) page 60
% Figure 4.14 (a) page 61
% Figure 4.15 (a) and (b) page 62
%
% There is a heavily modified copy of this test at heroesTest/trim which is
% called trimPFCnano
%
% [1] Mariano Rubio, Simulacion de la mecanica de vuelo de un 
%     helicoptero convencional, 2011. Proyecto Fin de Carrera, ETSIA,
%     Madrid
% 
clear all
close all
clc

opt1       = {'armonicInflowModel',@none,'mrForces',@completeF,'mrMoments',@aerodynamicM};
options{1} = parseOptions(opt1,@setHeroesRigidOptions);

opt2       = {'armonicInflowModel',@Coleman,'mrForces',@completeF,'mrMoments',@aerodynamicM};
options{2} = parseOptions(opt2,@setHeroesRigidOptions);

opt3       = {'armonicInflowModel',@Coleman,'mrForces',@completeF,'mrMoments',@aerodynamicM,'fInterf',@noneInterf,'lHTPInterf',@linearInterf,'rHTPInterf',@linearInterf};
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
ndV = linspace(0.0,.25,26);
n = length(ndV);

fCT = zeros(6,n);
d2r = pi/180;

m = length(options);

trimState = cell(1,m);

tic;
initialCondition = [0.05; -0.05; .25; 0; 0; .25; 0; 0; 0; -sqrt(CW/2); 0; 0; CW; 0; 0;0; 0; 0; -sqrt(CW/20); 0; 0; CW/10; 0; 0; 0];
x = zeros(25,n);
fCT(1,:) = ndV(:);

for j = 1:m
opt       = options{j};    
nlSolver  = opt.nlSolver;
eps       = opt.TolX;
    for i = 1:n
        disp (['Solving trim...  ', num2str(i+n*(j-1)), ' of ', num2str(m*n)]);
        if(norm(fCT(:,i))<eps || atan2(fCT(3,i),fCT(1,i))>86*d2r && atan2(fCT(3,i),fCT(1,i))<104*d2r)
            system2solve = @(x) helicopterTrimAxial(x,fCT(:,i),muWT,ndHe,opt);
            x(1:24,i) = nlSolver(system2solve,initialCondition(1:24),opt);
            x(25,i) = 0;
        else
            system2solve = @(x) helicopterTrim(x,fCT(:,i),muWT,ndHe,opt);
            x(:,i) = nlSolver(system2solve,initialCondition,opt);
        end
        for k = 1:25
            if abs(x(k,i))<eps
                x(k,i) = 0;
            end
        end
        initialCondition = x(:,i);
    end
trimState{j} = getHeTrimState(x,fCT,muWT,ndHe,opt);
% plotActionsByElement(trimState{j},j);
end
toc

% pairs = {'format' {'pdf'} 'prefix' '1' 'closePlot' 'no'};
% legend = {'b?sico' '\lambda_{1C} \lambda_{1S}' 'interferencia'};
% plotSimplifiedTS(trimState,legend,pairs);

trimState{4} = getPadfieldFlightTest();
mark   = {'k-','r-','b-','ko','k-o','k-^',...
          'k-d','k:.','k-*','k-+',...
          'k-v','k->','k-<'};
      
legend2 = {'b?sico' '\lambda_{1C} \lambda_{1S}' 'interferencia' 'ensayos'};
pairs = {'format' {'pdf'} 'prefix' '1' 'closePlot' 'no' 'mark' mark};
plotControlAngles(trimState,legend2,pairs)

