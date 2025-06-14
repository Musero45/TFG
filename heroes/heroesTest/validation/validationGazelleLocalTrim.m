function io = validationGazelleLocalTrim(mode)
% clear all
close all
clear all
setPlot;


%% Atmosphere variables needed
atm     = getISA;

%% Constant definitions
lmr =linspace(0,1.0,31);% %linspace(0,1.0,13);
psimrvect = linspace(0,2*pi,180);
he     = rigidNLGazelle(atm,lmr,psimrvect);

FCi= {@gazelle_fc1Nasa88351,...
      @gazelle_fc2Nasa88351,...
      @gazelle_fc3Nasa88351};%,...
%       @FlightCondition4,...
%       @FlightCondition5,...
%       @FlightCondition6,...
%       @FlightCondition7};
  
DigitFC_i= {gazelle_fc1localNasa88351,...
            gazelle_fc2localNasa88351,...
            gazelle_fc3localNasa88351};
%         Theres no flight test information of conditions 4 to 7
%             DigitizeFC4,...
%             DigitizeFC5,...
%             DigitizeFC6,...
%             DigitizeFC7};
  
   r2d=180/pi;

%% Definition of trim state variables   

% titles used in the plotted graphics below
   titles     ={'$$r/R=0.75$$','$$r/R=0.88$$','$$r/R=0.97$$'}; %cL coef
% % % %    titlesM     ={'$$r/R=0.20$$','$$r/R=0.54$$','$$r/R=0.87$$'}; % Moment
  
% NAMES USED TO SAVE FIGURES:
% To save plotted local variables
% % % FCnames={'FC1','FC2','FC3','FC4','FC5','FC6','FC7'};
% % % varnames={'Log10Re','M','cl','cd'}; % varnames={'alpha'}; 

% To save plotted figures for the validation of cL and Ma 
% % cL
  names{1} ={'FC1cl_r75','FC1cl_r88','FC1cl_r97'};
  names{2} ={'FC2cl_r75','FC2cl_r88','FC2cl_r97'};
  names{3} ={'FC3cl_r75','FC3cl_r88','FC3cl_r97'};
% % % %  names{4} ={'FC4cl_r75','FC4cl_r88','FC4cl_r97'};
% % % %  names{5} ={'FC5cl_r75','FC5cl_r88','FC5cl_r97'};
% % % %  names{6} ={'FC6cl_r75','FC6cl_r88','FC6cl_r97'};
% % % %  names{7} ={'FC7cl_r75','FC7cl_r88','FC7cl_r97'};
   
% % Moment
% % % %    names{1} ={'FC1Ma_r20','FC1Ma_r54','FC1Ma_r87'};
% % % %    names{2} ={'FC2Ma_r20','FC2Ma_r54','FC2Ma_r87'};
% % % %    names{3} ={'FC3Ma_r20','FC3Ma_r54','FC3Ma_r87'};
% % % %    names{4} ={'FC4Ma_r20','FC4Ma_r54','FC4Ma_r87'};
% % % %    names{5} ={'FC5Ma_r20','FC5Ma_r54','FC5Ma_r87'};
% % % %    names{6} ={'FC6Ma_r20','FC6Ma_r54','FC6Ma_r87'};
% % % %    names{7} ={'FC7Ma_r20','FC7Ma_r54','FC7Ma_r87'};

 cl= cell(1,7);
 M_a=cell(1,7);

%% Definition of heroes trim state
% Compute

 for s = 1:length(FCi); %length(FCi) or 1:3 there is only Digitize data for the 3 first flight test

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

% Used to work only with one flight condition:
% % % % h       = 317;
% % % % ndHe            = rigidHe2ndHe(he,atm,h);
% % % % ndHe.ndRotor.aG = 0.;
% % % % ndRotor         = ndHe.mainRotor;
% % % % 
% % % % % wind velocity in ground reference system
% % % % muWT = [0; 0; 0];

tic
% % % nfc             = 5;
% % % FC = {'VOR',linspace(0.001,0.35,nfc),...
% % % 'betaf0',0,...
% % % 'gammaT',0,...
% % % 'vTOR',0,...
% % % 'cs',0 ...
% % % };
% % % 
% % %  
% % % ndTs = getNdHeTrimState(ndHe,muWT,FC,options);

% % % FC = {'VOR',0.14,...
% % %        'betaf0',0,...
% % %        'gammaT',0,...
% % %        'vTOR',0,...
% % %        'cs',0 ...
% % %        };

% % % ndTs              = getNdHeTrimState(ndHe,muWT,FC,options);
% % % options.IniTrimCon = ndTs.solution;

% Definition of the 7 flight conditions from nasa-tm-88351
[FC,muWT,h,he,mu]= FCi{s}(he);
 
ndHe            = rigidHe2ndHe(he,atm,h);
ndHe.ndRotor.aG = 0.;
ndRotor         = ndHe.mainRotor;   

ndTs              = getNdHeTrimState(ndHe,muWT,FC,options);
options.IniTrimCon = ndTs.solution;

toc

tic

options.aeromechanicModel = @aeromechanicsNL;
options.mrForces          = @completeFNL;
options.mrMoments         = @aerodynamicMNL;
options.trForces          = @completeFNL;
options.trMoments         = @aerodynamicMNL;

ndTsNL = getNdHeTrimState(ndHe,muWT,FC,options);

toc

% % sol{1} =  ndTs.solution;
% % sol{2} =  ndTsNL.solution;

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

%% Cl(Phi) and Cm(Phi) for 3 radial locations  
% In 'RigidNLGazelle' you have to introduce the following variables
%     the range of Phi for the main and tail rotor -> psimrvect = linspace(0,2*pi,180);                                                 
%     the radial locations are set as a input variable -> lmr = linspace(0,1.0,31);
%  In leg cell should be introduced the same radial coordinates than in the
%  nasa document. To do this you should set the linspace before to achieve
%  a good interpolation and then look for the most similar ones in the
%  matrix F.XD2 of the workspace(debugging).
% In this case with linspace(0,1.0,31), the 3 columns in the matrix are r=[23,27,30];


    psi     = he.mainRotor.nlRotor.psi2D{1,1}(:,1);
    cl{s}      = F.cl;
    cm{s}      = F.cm;
    
    rho = atm.density(h);
    gamma = atm.gama;
    R_g = atm.R_g;
    T = atm.temperature(h); 
    c0 = he.mainRotor.c0;
    M = F.M;
    M_a{s}     = 0.5.*rho.*(M.^2).*gamma.*R_g.*T.*c0.*cm{s};
    
%% Data obtained from digitize in nasa-tm-88351  

DigitFC = DigitFC_i{s};    
r=[23,27,30];   % Read section before

%% Plot of the cL and Ma validation
      for j=1:length(r) 
    
PsiDigitAv =  DigitFC{1,j}.PsiAverage;
PsiDigitUni =  DigitFC{1,j}.PsiUniform;

clDigitAv =  DigitFC{1,j}.clAverage;
clDigitUni =  DigitFC{1,j}.clUniform;    
        
  figure(j)
  plot(psi*r2d,cl{s}(:,r(j)),'r-');
hold on  
  plot(PsiDigitAv,clDigitAv,'k-');
  plot(PsiDigitUni,clDigitUni,'k-.');
hold off
    xlabel('$$\psi$$ [$$^o$$]');
    ylabel('$$c_L$$ [-]');
    title(titles{j});
    if s<=2;
    legend('HEROES','Data average','Uniform Inflow','Location','Best');
    else
    % In the third radial position there is not uniform inflow data    
    legend('HEROES','Data average','Location','Best');
    end
    
% % % % %   figure(j)
% % % % %   plot(Psi*r2d,cm{s}(:,j));
% % % % %     xlabel('$$\Psi$$ [$$^o$$]');
% % % % %     ylabel('$$c_m$$ [-]');
% % % % %     legend(leg{j});
% % % % %                 
% % % % % MDigitAv =  DigitFC{1,j}.MAverage;
% % % % % MDigitUni =  DigitFC{1,j}.MUniform;    
% % % % %         
% % % % %   figure(j)
% % % % %   plot(psi*r2d,M_a{s}(:,j),'r-');
% % % % % hold on
% % % % %   plot(PsiDigitAv,MDigitAv,'k-');
% % % % %   plot(PsiDigitUni,MDigitUni,'k-.');
% % % % % hold off
% % % % %   
% % % % %     xlabel('$$psi$$ [$$^o$$]');
% % % % %     ylabel('$$M_a$$ [Nm]');
% % % % %      title(titles{j});
% % % % %     legend('HEROES','Data average','Uniform inflow'); 
% % % % %             

%% Saving figures
% This saveas it is needed to keep the 3 figures of the 3 conditions.
% Without saving the figures only the condition 3 ones will be present at
% the end of the Run.
% Uncomment next line to save eps figures
%         saveas(figure(j),names{s}{j},'epsc')  

       end
   
%% More variables and possible plot options

% % % Fc{1} = F;
% % % Gc(1) = G; % Gc(i) = G;
% % % 
% % % axdsF  = getaxds({'x2D'},{'x [-]'},1);
% % % aydsF  = getaxds({'psi2D'},{'$$\psi$$ [rad]'},1);
% % % titlesF = gettitlesF;
% % % 
% % % showF = plotRotorStateF(F,axdsF,aydsF,...
% % %         'titleplot',titlesF,...
% % %         'polarPlot','yes',...
% % %         'plot3dMode','bidimensional',...
% % %         'plot3dMethod',@surf,...
% % %         'colormap','jet',...
% % %         'format','epsc'...
% % % );
% % % for j=1:length(varnames)    
% % % figure(length(varnames)*(s-1)+j)
% % % % view([0 90])
% % % shading interp
% % % end

% % % 
% % % showF = plotRotorStateF(F,axdsF,aydsF,...
% % %         'titleplot',titlesF,...
% % %         'polarPlot','yes',...
% % %         'plot3dMode','bidimensional',...
% % %         'plot3dMethod',@contour, ...
% % %         'labels','off',...
% % %         'nlevels',15, ...
% % %         'format','epsc'...
% % % );  


% Loop to save figures when using only one of the plots above 
% % %     for j=1:length(varnames)
% % % saveas(figure(length(varnames)*(s-1)+j),[FCnames{s},'surf',varnames{j}],'epsc');
% % %     end

% Use this to save just one variable printed   
% % % saveas(figure(2*s-1),[FCnames{s},'surf',varnames{1}],'epsc');
% % % saveas(figure(2*s),[FCnames{s},'contour',varnames{1}],'epsc');

% Loops to save both suf and contour plots above.
% It doesnt work only with one of the plots.
% % %       for j= (2*(s-1)*length(varnames)+1):(length(varnames)*(2*s-1));
% % % saveas(figure(j),[FCnames{s},'surf',varnames{j-8*(s-1)}],'epsc');
% % %       end
% % %       for j= (length(varnames)*(2*s-1)+1):(length(varnames)*2*s);
% % % saveas(figure(j),[FCnames{s},'contour',varnames{j-4*(2*s-1)}],'epsc');
% % %       end
      

% % axdsG  = getaxds({'psi1D'},{'$$\psi$$ [?]'},180/pi);
% % titlesG = gettitlesG;
% %  
% % showG = plotRotorStateG(G,axdsG,[],...
% %         'defaultVars','yes',...
% %         'titlePlot',titlesG,...
% %         'labels','off',...
% %         'plot3dMode','parametric'...
% % );    
    
   end 

% % sol{1} = ndTs.solution;
% % sol{2} = ndTsNL.solution;
% % 
% % axds           = getaxds({'VOR'},{'$$\mu_{x_A}$$ [-]'},1);
% % 
% % plotNdTrimSolution(sol,axds,{'Lineal','No lineal'});
% % 
% % io = 1;
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

 end
 

io = 1;
end




function titlesF = gettitlesF()

titlesF = {...
          'Numero de Reynolds',...
          'Numero de Mach',...
          'Coeficiente de sustentacion',...
          'Coeficiente de resistencia'};%...
%           'Velocidad tangencial',...
%           'Velocidad vertical',...
%           'Eficiencia aerodinamica',...
%           'Angulo de ataque'...
%           'Traccion inducida',...
%           'Traccion parasita',...
%           'Traccion',...
%           'Fuerza tangencial inducida',...
% 'Fuerza tangencial par?sita',...
% 'Fuerza tangencial'...
%           'Fuerza en $$x_{A1}%% inducida',...
% 'Fuerza en $$x_{A1}$$ par?sita',...
% 'Fuerza en $$x_{A1}$$',...
%           'Fuerza en $$y_{A1}$$ inducida',...
% 'Fuerza en $$y_{A1}$$ par?sita',...
% 'Fuerza en $$y_{A1}$$',...
%           'Fuerza en $$z_{A1}$$ inducida',...
% 'Fuerza en $$z_{A1}$$ par?sita',...
% 'Fuerza en $$z_{A1}$$',...
%           'Momento inducido en E seg?n $$x_{A1}$$',...
% 'Momento par?sito en E segun $$x_{A1}$$',...
% 'Momento en E seg?n $$x_{A1}$$',...
%           'Momento inducido en E seg?n $$y_{A1}$$',...
% 'Momento parasito en E segun $$y_{A1}$$',...
% 'Momento en E segun $$y_{A1}$$',...
%           'Momento inducido en E seg?n $$z_{A1}$$',...
% 'Momento parasito en E segun $$z_{A1}$$',...
% 'Momento en E seg?n $$z_{A1}$$',...
%           'Fuerza longitudinal inducida',...
% 'Fuerza longitudinal par?sita',...
% 'Fuerza longitudinal',...
%           'Fuerza lateral inducida',...
% 'Fuerza lateral par?sita',...
% 'Fuerza lateral',...
%           'Tracci?n inducida',...
% 'Tracci?n par?sita',...
% 'Tracci?n',...
%           'Momento inducido en E seg?n $$x_{A}$$',...
% 'Momento par?sito en E seg?n $$x_{A}$$',...
% 'Momento en E seg?n $$x_{A}$$',...
%           'Momento inducido en E seg?n $$y_{A}$$',...
% 'Momento par?sito en E seg?n $$y_{A}$$',...
% 'Momento en E seg?n $$y_{A}$$',...
%           'Momento inducido en E seg?n $$z_{A}$$',...
% 'Momento par?sito en E seg?n $$z_{A}$$',...
% 'Momento en E seg?n $$z_{A}$$',...
%           };
end
          
function titlesG = gettitlesG()

titlesG = {'Fuerza aerodin?mica inducida en $$x_{A1}$$','Fuerza aerodin?mica par?sita en $$x_{A1}$$','Fuerza aerodin?mica en $$x_{A1}$$',...
          'Fuerza aerodin?mica inducida en $$y_{A1}$$','Fuerza aerodin?mica par?sita en $$y_{A1}$$','Fuerza aerodin?mica en $$y_{A1}$$',...
          'Fuerza aerodin?mica inducida en $$z_{A1}$$','Fuerza aerodin?mica par?sita en $$z_{A1}$$','Fuerza aerodin?mica en $$z_{A1}$$',...
          'Momento aerodin?mico inducido en E en $$x_{A1}$$','Momento aerodin?mico par?sito en E en $$x_{A1}$$','Momento aerodin?mico en E en x_{A1}',...
          'Momento aerodin?mico inducido en E en $$y_{A1}$$','Momento aerodin?mico par?sito en E en $$y_{A1}$$','Momento aerodin?mico en E en y_{A1}',...
          'Momento aerodin?mico inducido en E en z_{A1}','Momento aerodin?mico par?sito en E en z_{A1}','Momento aerodin?mico en E en z_{A1}',...
          'Momento de la fuerza aerodin?mica inducida en E en $$x_{A1}$$','Momento de la fuerza aerodin?mica par?sita en E en $$x_{A1}$$','Momento de la fuerza aerodin?mica en E en $$x_{A1}$$',...
          'Momento de la fuerza aerodin?mica inducida en E en $$y_{A1}$$','Momento de la fuerza aerodin?mica par?sita en E en $$y_{A1}$$','Momento de la fuerza aerodin?mica en E en $$y_{A1}$$',...
          'Momento de la fuerza aerodin?mica inducida en E en $$z_{A1}$$','Momento de la fuerza aerodin?mica par?sita en E en $$z_{A1}$$','Momento de la fuerza aerodin?mica en E en $$z_{A1}$$',...
          'Momento aerodin?mico inducido en $$x_{A1}$$','Momento aerodin?mico par?sito en $$x_{A1}$$','Momento aerodin?mico en $$x_{A1}$$',...
          'Momento aerodin?mico inducido en $$y_{A1}$$','Momento aerodin?mico par?sito en $$y_{A1}$$','Momento aerodin?mico en $$y_{A1}$$',...
          'Momento aerodin?mico inducido en $$z_{A1}$$','Momento aerodin?mico par?sito en $$z_{A1}$$','Momento aerodin?mico en $$z_{A1}$$',...
          'Fuerza longitudinal inducida','Fuerza longitudinal par?sita','Fuerza longitudinal',...
          'Fuerza lateral inducida','Fuerza lateral par?sita','Fuerza lateral',...
          'Tracci?n inducida','Tracci?n par?sita','Tracci?n',...
          'Momento aerodin?mico inducido en $$x_{A}$$','Momento aerodin?mico par?sito en $$x_{A}$$','Momento aerodin?mico en $$x_{A}$$',...
          'Momento aerodin?mico inducido en $$y_{A}$$','Momento aerodin?mico par?sito en y_{A}','Momento aerodin?mico en $$y_{A}$$',...
          'Momento aerodin?mico inducido en $$z_{A}$$','Momento aerodin?mico par?sito en z_{A}','Momento aerodin?mico en $$z_{A}$$',...
          'Fuerza aerodin?mica en $$x_{A1}$$ (Fourier)','Fuerza aerodin?mica en $$y_{A1}$$ (Fourier)','Fuerza aerodin?mica en $$z_{A1}$$ (Fourier)',...
          'Momento aerodin?mico en $$x_{A1}$$ (Fourier)','Momento aerodin?mico en $$y_{A1}$$ (Fourier)','Momento aerodin?mico en $$z_{A1}$$ (Fourier)',...
          'Fuerza longitudinal (Fourier)','Fuerza lateral (Fourier)','Tracci?n (Fourier)',...
          'Momento aerodin?mico en $$x_{A}$$ (Fourier)','Momento aerodin?mico en y_{A} (Fourier)','Momento aerodin?mico en z_{A} (Fourier)',...
          'Momento de reacci?n en $$x_{A1}$$','Momento gravitatorio en $$x_{A1}$$','Derivada del momento cin?tico en $$x_{A1}$$','T?rmino correctivo en $$x_{A1}$$','IRG (Inercia + Reacci?n + Gravedad) en $$x_{A1}$$',...
          'Momento de reacci?n en $$y_{A1}$$','Momento gravitatorio en $$y_{A1}$$','Derivada del momento cin?tico en $$y_{A1}$$','T?rmino correctivo en $$y_{A1}$$','IRG (Inercia + Reacci?n + Gravedad) en $$y_{A1}$$',...
          'Momento de reacci?n en $$z_{A1}$$','Momento gravitatorio en $$z_{A1}$$','Derivada del momento cin?tico en $$z_{A1}$$','T?rmino correctivo en $$z_{A1}$$','IRG (Inercia + Reacci?n + Gravedad) en $$z_{A1}$$',...
          };
end
          
