clear all
close all

plotOptions = setHeroesPlotOptions;
mark  = plotOptions.lines;
setPlot

atm     = getISA;
he      = rigidBo105(atm);
rho0    = atm.rho0;
g       = atm.g;
ndHe    = rigidHe2ndHe(he,rho0,g);

options      = setHeroesRigidOptions;
nlSolver     = options.nlSolver;

CT   = [ndHe.inertia.CW; 0; 0];
beta = [0; 0; 0];
muW  = [0; 0; 0];

alpha = [-60,-30,0,20,50,70]*pi/180;
mu    = linspace(0,.2,31);
model = {@Coleman @Payne @White @Pitt @Howlett};
unif  = {@Cuerva @Rand};

n1 = length(mu);
n2 = length(alpha);
n3 = length(model);
n4 = length(unif);

fC     = zeros(length(mu),6);
lambda = zeros(n1,3,n3+2);

for i = 1:n2
    fC(:,3) = mu(:).*sin(alpha(i)); 
    fC(:,1) = mu(:).*cos(alpha(i));
    for k = 1:n3
        options.uniformInflowModel = @Glauert;
        options.armonicInflowModel = model{k};
        initialCondition = [-sqrt(CT(1)/2);0;0];
        for j = 1:n1
            f = @(x) wakeEqs(x,CT,fC(j,:),muW,beta,options);
            lambda(j,:,k)  = nlSolver(f,initialCondition,options);
            initialCondition = lambda(j,:,k);
        end
    end
    
    for k = 1:n4
        options.uniformInflowModel = unif{k};
        options.armonicInflowModel = @none;
        initialCondition = [-sqrt(CT(1)/2);0;0];
        for j = 1:n1
            f = @(x) wakeEqs(x,CT,fC(j,:),muW,beta,options);
            lambda(j,:,n3+k)  = nlSolver(f,initialCondition,options);
            initialCondition = lambda(j,:,n3+k);
        end
    end
    
    figure(i)
    plot(mu,lambda(:,1,1),mark{1})
    hold on
    grid on
    for k = 1:n3
        plot(mu,lambda(:,2,k),mark{k+1});
    end
    leg = {'Glauert (\lambda_0)' 'Coleman' 'Payne' 'White' 'Pitt' 'Howlett'};
    legend(leg,'location','B')
    xlabel('V/(\Omega R) [-]');
    ylabel('\lambda_{1C} [-]');
    name = strcat('skew',num2str(alpha(i)*180/pi));
    savePlot(gcf,name,{'pdf'});
    
%     %Red book figure 3.13 Page 112
    figure(n2+1)
    hold on
    for k = 1:n4
        plot(mu,lambda(:,1,n3+k),mark{k})
    end
    hold off
end

 figure(n2+1)
 grid on
 xlabel('V/(\Omega R) [-]');
 ylabel('\lambda_{0} [-]');
 saveplot(gcf,'l0',{'pdf'});

unsetPlot