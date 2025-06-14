clear all
close all

% % % % % % % % % % % % % % % % oslo: adding paths
% % % % % % % % % % % % % % % addpath(strcat(pwd,filesep,'Alvaro'));

% default optiosns are set
options        = setHeroesRigidOptions;
options.TolFun = 10^-12; 

%engineState
%options.engineState = @mainShaftBroken;

% uniformInflowModel options are updated with
% @Cuerva model for induced velocity
options.uniformInflowModel = @Cuerva;
options.armonicInflowModel = @none; % @none @Coleman

% engineState options are updated for the 
%options.engineState = @EngineOffTransmissionOn;

% mrForces options are updated for 
options.mrForces = @thrustF;

% trForces options are updated
options.trForces = @thrustF;

% Interference options are updated for
options.fInterf             = @noneInterf;
options.trInterf            = @noneInterf;
options.vfInterf            = @noneInterf;
options.lHTPInterf          = @noneInterf;
options.rHTPInterf          = @noneInterf;

% atmosphere variables needed
atm     = getISA;
rho0    = atm.rho0;
g       = atm.g;
H       = 200;

he              = rigidNLBo105(atm);
ndHe            = rigidHe2ndHe(he,atm,H);
ndHe.ndRotor.aG = 0.;
ndRotor         = ndHe.mainRotor;

% wind velocity in ground reference system
muWT = [0; 0; 0];

tic
nfc             = 5;
FC = {'VOR',linspace(0.001,0.35,nfc),...
'betaf0',0,...
'gammaT',0,...
'vTOR',0,...
'cs',0 ...
};

 
ndTs = getNdHeTrimState(ndHe,muWT,FC,options);

FC0 = {'VOR',0.001,...
       'betaf0',0,...
       'gammaT',0,...
       'vTOR',0,...
       'cs',0 ...
       };
   
ndTs0              = getNdHeTrimState(ndHe,muWT,FC0,options);
options.IniTrimCon = ndTs0.solution;

toc

tic

options.aeromechanicModel = @aeromechanicsNL;
options.mrForces          = @completeFNL;
options.mrMoments         = @aerodynamicMNL;
options.trForces          = @completeFNL;
options.trMoments         = @aerodynamicMNL;

ndTsNL = getNdHeTrimState(ndHe,muWT,FC,options);

toc

sol{1} =  ndTs.solution;
sol{2} =  ndTsNL.solution;

beta0  = ndTsNL.solution.beta0;
beta1C = ndTsNL.solution.beta1C;
beta1S = ndTsNL.solution.beta1S;
beta = [beta0,beta1C,beta1S];

theta0  = ndTsNL.solution.theta0;
theta1C = ndTsNL.solution.theta1C;
theta1S = ndTsNL.solution.theta1S;
theta = [theta0,theta1C,theta1S];

lambda0 = ndTsNL.solution.lambda0;
lambda1C = ndTsNL.solution.lambda1C;
lambda1S = ndTsNL.solution.lambda1S;
lambda = [lambda0,lambda1C,lambda1S];

muxA = ndTsNL.vel.A.airmux;
muyA = ndTsNL.vel.A.airmuy;
muzA = ndTsNL.vel.A.airmuz;
muA  = [muxA,muyA,muzA];

omegaadxA = ndTsNL.vel.A.omx;
omegaadyA = ndTsNL.vel.A.omy;
omegaadzA = ndTsNL.vel.A.omz;
omegaadA  = [omegaadxA,omegaadyA,omegaadzA];

muxWA = ndTsNL.vel.WA.airmuWx;
muyWA = ndTsNL.vel.WA.airmuWy;
muzWA = ndTsNL.vel.WA.airmuWz;
muWA  = [muxWA,muyWA,muzWA];

GxA = ndTsNL.actions.weight.fuselage.CFx;
GyA = ndTsNL.actions.weight.fuselage.CFy;
GzA = ndTsNL.actions.weight.fuselage.CFz;
GA  = [GxA,GyA,GzA];

for i = 1:length(beta0);
    
    Beta = beta(i,:);
    Theta = theta(i,:);
    Lambda = lambda(i,:);
    MuA = muA(i,:);
    OmegaadA = omegaadA(i,:);
    MuWA = muWA(i,:);
    GAi = GA(i,:);
%     
%     dirname = strcat(prefix,num2str(i));
%     cd(dirname);
    
    [F,G,M] = showNdRotorState(Beta,Theta,Lambda,MuA,OmegaadA,MuWA,GAi,ndRotor);
    

% Fc{1} = F;
% Gc(1) = G; % Gc(i) = G;
% 
% axdsF  = getaxds({'x2D'},{'x [-]'},1);
% aydsF  = getaxds({'psi2D'},{'\psi [rad]'},1);
% titlesF = gettitlesF;
% 
% 
% showF = plotRotorStateF(F,axdsF,aydsF,...
%         'closeplot','yes',...
%         'format',{'pdf','epsc'},...
%         'prefix','3Dsurf',...
%         'titleplot',titlesF,...
%         'polarPlot','yes',...
%         'plot3dMode','bidimensional',...
%         'plot3dMethod',@surf,...
%         'colormap','jet'...
% );
% 
%     
% showF = plotRotorStateF(F,axdsF,aydsF,...
%         'closeplot','yes',...
%         'format',{'pdf','epsc'},...
%         'prefix','3Dcontour',...
%         'titleplot',titlesF,...
%         'polarPlot','yes',...
%         'plot3dMode','bidimensional',...
%         'plot3dMethod',@contour, ...
%         'labels','off',...
%         'nlevels',10 ...
% );
%    
% 
% 
% axdsG  = getaxds({'psi1D'},{'\psi [?]'},180/pi);
% titlesG = gettitlesG;
% 
% showG = plotRotorStateG(G,axdsG,[],...
%         'closeplot','yes',...
%         'format',{'pdf','epsc'},...
%         'prefix','2D',...
%         'defaultVars','yes',...
%         'titlePlot',titlesG,...
%         'labels','off',...
%         'plot3dMode','parametric'...
% );    
% 
%  cd ..
end

sol{1} = ndTs.solution;
sol{2} = ndTsNL.solution;

axds           = getaxds({'VOR'},{'\mu_x_A [-]'},1);

plotNdTrimSolution2(sol,axds,{'Lineal','No lineal'});
% 
% 
% QmrHelisim       = load('QmrHelisim.dat');
% QmrReal          = load('QmrReal.dat');
% PmrHelisim       = load('PmrHelisim.dat');
% PmrReal          = load('PmrReal.dat');
% theta0Helisim    = load('theta0Helisim.dat');
% theta0Real       = load('theta0Real.dat');
% theta0trHelisim  = load('theta0trHelisim.dat');
% theta0trReal     = load('theta0trReal.dat');
% theta1CHelisim   = load('theta1CHelisim.dat');
% theta1CReal      = load('theta1CReal.dat');
% theta1SHelisim   = load('theta1SHelisim.dat');
% theta1SReal      = load('theta1SReal.dat');
% 
% 
% % Comparison with real and Helisim data ([km/h], [?], [kW] and [kN/m])
% 
% VORd = ndTsNL.solution.VOR*423.8*0.5144*3.6; %423.8 (44.4*4.91/0.5144)
% 
% 
% PowdLin = ndTs.ndPow.CPmr*961263.234984;
% Powd    = ndTsNL.ndPow.CPmr*961263.234984;
% 
% figure(1)
% grid on
% hold on
% plot(VORd,PowdLin,'k-.','LineWidth',2)
% plot(VORd,Powd,'k-','LineWidth',2)
% plot(PmrHelisim(:,1)*0.5144*3.6,PmrHelisim(:,2),'k--','LineWidth',2)
% plot(PmrReal(:,1)*0.5144*3.6,PmrReal(:,2),'ko','LineWidth',2)
% xlabel('V_{xA} [km/h]'); ylabel('Potencia [kW]');
% legend('Lineal','No lineal','Helisim','Bo-105');
% xlim([0,300]);
% savePlot(gcf,'power',{'pdf'});
% 
% 
% QdLin   = ndTs.ndPow.CQmr*21650.07286;
% Qd      = ndTsNL.ndPow.CQmr*21650.07286;
% 
% figure(2)
% grid on
% hold on
% plot(VORd,QdLin,'k-.','LineWidth',2)
% plot(VORd,Qd,'k-','LineWidth',2)
% plot(QmrHelisim(:,1)*0.5144*3.6,QmrHelisim(:,2),'k--','LineWidth',2)
% plot(QmrReal(:,1)*0.5144*3.6,QmrReal(:,2),'ko','LineWidth',2)
% xlabel('V_{xA} [km/h]'); ylabel('Par [kN/m]');
% legend('Lineal','No lineal','Helisim','Bo-105');
% xlim([0,300]);
% savePlot(gcf,'torque',{'pdf'});
% 
% r2d = 180/pi;
% 
% figure(3)
% grid on
% hold on
% plot(VORd,ndTs.solution.theta0*r2d,'k-.','LineWidth',2)
% plot(VORd,ndTsNL.solution.theta0*r2d,'k-','LineWidth',2)
% plot(theta0Helisim(:,1)*0.5144*3.6,theta0Helisim(:,2),'k--','LineWidth',2)
% plot(theta0Real(:,1)*0.5144*3.6,theta0Real(:,2),'ko','LineWidth',2)
% xlabel('V_{xA} [km/h]'); ylabel('\theta_0 [?]');
% legend('Lineal','No lineal','Helisim','Bo-105');
% xlim([0,300]);
% savePlot(gcf,'theta0',{'pdf'});
% 
% figure(4)
% grid on
% hold on
% plot(VORd,ndTs.solution.theta1C*r2d,'k-.','LineWidth',2)
% plot(VORd,ndTsNL.solution.theta1C*r2d,'k-','LineWidth',2)
% plot(theta1CHelisim(:,1)*0.5144*3.6,theta1CHelisim(:,2),'k--','LineWidth',2)
% plot(theta1CReal(:,1)*0.5144*3.6,theta1CReal(:,2),'ko','LineWidth',2)
% xlabel('V_{xA} [km/h]'); ylabel('\theta_1_C [?]');
% legend('Lineal','No lineal','Helisim','Bo-105');
% xlim([0,300]);
% savePlot(gcf,'theta1C',{'pdf'});
% 
% figure(5)
% grid on
% hold on
% plot(VORd,ndTs.solution.theta1S*r2d,'k-.','LineWidth',2)
% plot(VORd,ndTsNL.solution.theta1S*r2d,'k-','LineWidth',2)
% plot(theta1SHelisim(:,1)*0.5144*3.6,theta1SHelisim(:,2),'k--','LineWidth',2)
% plot(theta1SReal(:,1)*0.5144*3.6,theta1SReal(:,2),'ko','LineWidth',2)
% xlabel('V_{xA} [km/h]'); ylabel('\theta_1_S [?]');
% legend('Lineal','No lineal','Helisim','Bo-105');
% xlim([0,300]);
% savePlot(gcf,'theta1S',{'pdf'});
% 
% figure(6)
% grid on
% hold on
% plot(VORd,ndTs.solution.theta0*r2d,'k-.','LineWidth',2)
% plot(VORd,ndTsNL.solution.theta0tr*r2d,'k-','LineWidth',2)
% plot(theta0trHelisim(:,1)*0.5144*3.6,theta0trHelisim(:,2),'k--','LineWidth',2)
% plot(theta0trReal(:,1)*0.5144*3.6,theta0trReal(:,2),'ko','LineWidth',2)
% xlabel('V_{xA} [km/h]'); ylabel('\theta_0_t_r [?]');
% legend('Lineal','No lineal','Helisim','Bo-105');
% xlim([0,300]);
% savePlot(gcf,'theta0tr',{'pdf'});

%--------------------------------------------------------------------------


% Comparison with real and Helisim data (kn, [?], [kW] and [kN/m])

% VORd = ndTsNL.solution.VOR*423.8;
% 
% 
% PowdLin = ndTs.ndPow.CPmr*961263.234984;
% Powd    = ndTsNL.ndPow.CPmr*961263.234984;
% 
% figure(1)
% grid on
% hold on
% plot(VORd,PowdLin,'k-.','LineWidth',2)
% plot(VORd,Powd,'k-','LineWidth',2)
% plot(PmrHelisim(:,1),PmrHelisim(:,2),'k--','LineWidth',2)
% plot(PmrReal(:,1),PmrReal(:,2),'ko','LineWidth',2)
% xlabel('V_{xA} [kn]'); ylabel('Potencia [kW]');
% legend('Lineal','No lineal','Helisim','Bo-105');
% xlim([0,160]);
% savePlot(gcf,'power',{'pdf'});
% 
% 
% QdLin   = ndTs.ndPow.CQmr*21650.07286;
% Qd      = ndTsNL.ndPow.CQmr*21650.07286;
% 
% figure(2)
% grid on
% hold on
% plot(VORd,QdLin,'k-.','LineWidth',2)
% plot(VORd,Qd,'k-','LineWidth',2)
% plot(QmrHelisim(:,1),QmrHelisim(:,2),'k--','LineWidth',2)
% plot(QmrReal(:,1),QmrReal(:,2),'ko','LineWidth',2)
% xlabel('V_{xA} [kn]'); ylabel('Par [kN/m]');
% legend('Lineal','No lineal','Helisim','Bo-105');
% xlim([0,160]);
% savePlot(gcf,'torque',{'pdf'});
% 
% r2d = 180/pi;
% 
% figure(3)
% grid on
% hold on
% plot(VORd,ndTs.solution.theta0*r2d,'k-.','LineWidth',2)
% plot(VORd,ndTsNL.solution.theta0*r2d,'k-','LineWidth',2)
% plot(theta0Helisim(:,1),theta0Helisim(:,2),'k--','LineWidth',2)
% plot(theta0Real(:,1),theta0Real(:,2),'ko','LineWidth',2)
% xlabel('V_{xA} [kn]'); ylabel('\theta_0 [kN/m]');
% legend('Lineal','No lineal','Helisim','Bo-105');
% xlim([0,160]);
% savePlot(gcf,'theta0',{'pdf'});
% 
% figure(4)
% grid on
% hold on
% plot(VORd,ndTs.solution.theta1C*r2d,'k-.','LineWidth',2)
% plot(VORd,ndTsNL.solution.theta1C*r2d,'k-','LineWidth',2)
% plot(theta1CHelisim(:,1),theta1CHelisim(:,2),'k--','LineWidth',2)
% plot(theta1CReal(:,1),theta1CReal(:,2),'ko','LineWidth',2)
% xlabel('V_{xA} [kn]'); ylabel('\theta_1_C [?]');
% legend('Lineal','No lineal','Helisim','Bo-105');
% xlim([0,160]);
% savePlot(gcf,'theta1C',{'pdf'});
% 
% figure(5)
% grid on
% hold on
% plot(VORd,ndTs.solution.theta1S*r2d,'k-.','LineWidth',2)
% plot(VORd,ndTsNL.solution.theta1S*r2d,'k-','LineWidth',2)
% plot(theta1SHelisim(:,1),theta1SHelisim(:,2),'k--','LineWidth',2)
% plot(theta1SReal(:,1),theta1SReal(:,2),'ko','LineWidth',2)
% xlabel('V_{xA} [kn]'); ylabel('\theta_1_S [?]');
% legend('Lineal','No lineal','Helisim','Bo-105');
% xlim([0,160]);
% savePlot(gcf,'theta1S',{'pdf'});
% 
% figure(6)
% grid on
% hold on
% plot(VORd,ndTs.solution.theta0*r2d,'k-.','LineWidth',2)
% plot(VORd,ndTsNL.solution.theta0tr*r2d,'k-','LineWidth',2)
% plot(theta0trHelisim(:,1),theta0trHelisim(:,2),'k--','LineWidth',2)
% plot(theta0trReal(:,1),theta0trReal(:,2),'ko','LineWidth',2)
% xlabel('V_{xA} [kn]'); ylabel('\theta_0_t_r [?]');
% legend('Lineal','No lineal','Helisim','Bo-105');
% xlim([0,160]);
% savePlot(gcf,'theta0tr',{'pdf'});
