close all
clear all

atm      = getISA;
he       = rigidBo105(atm);
rho0     = atm.rho0;
g        = atm.g;
ndHe     = rigidHe2ndHe(he,rho0,g);

options      = setHeroesRigidOptions;
options.armonicInflowModel = @Coleman;
nlSolver     = options.nlSolver;
linearInflow = options.linearInflow;

CT   = [ndHe.inertia.CW; 0; 0];
beta = [0; 0; 0];
muW  = [0; 0; 0];

alpha    = 0;
sideslip = [0; -30; -90; -180;]*pi/180;
v        = 0.15;
flightCondition = zeros(length(sideslip),6);

psi      = 0:pi/40:2*pi;
r        = 0:.0125:1;

lambda  = zeros(length(sideslip),3);

flightCondition(:,3) = v*sin(alpha); 
flightCondition(:,2) = v*cos(alpha).*sin(sideslip(:));
flightCondition(:,1) = v*cos(alpha).*cos(sideslip(:));

initialCondition = [-sqrt(CT(1)/2);0;0];

for j=1:length(sideslip)
    system2solve = @(lambda) linearInflow(lambda,CT,flightCondition(j,:),muW,beta,options);
    lambda(j,:)  = nlSolver(system2solve,initialCondition,options);
    initialCondition = lambda(j,:);
end

xA   = r'*cos(psi);
yA   = r'*sin(psi);
indV = zeros(length(r),length(psi));

setPlot

for k =1:length(sideslip)
    for i = 1:length(r)
         for j = 1:length(psi)
             indV(i,j)= lambda(k,1)+r(i)*(lambda(k,2)*cos(psi(j))+lambda(k,3)*sin(psi(j)));
         end
    end
    figure(k)
    [C,h] = contour(xA,yA,indV,'LineWidth',2);
    clabel(C,h);
    grid on
    axis equal
    xlabel('x_A [-]'); 
    ylabel('y_A [-]');
    name = strcat(int2str(k),'_cont');
    savePlot(gcf,name,{'pdf'});
end

unsetPlot

