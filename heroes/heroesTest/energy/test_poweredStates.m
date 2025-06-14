function io = test_poweredStates(mode)

% This script is used to test powered performances, that is, performances
% of helicopter when power is imposed as fixed flight condition and the
% unknown to be computed is the vertical velocity. For this practical
% situation we have two interesting flight conditions
% * climbing
% * autorotation (descend flight)

close all
setPlot;
atm     = getISA;
he      = superPuma(atm);
he.mainRotor.kappa = 1.0;


GW      = 73550;
Mf      = 1600;
OmegaN  = he.mainRotor.Omega;
hsl     = 0.;

% Climbing performance at sea level
nv      = 31;
Vi      = linspace(0,250,nv)';

Omegai  = OmegaN*ones(nv,1);
GWi     = GW*ones(nv,1);
Mfi     = Mf*ones(nv,1);
Hi      = hsl*zeros(nv,1);

% Get power states for horizontal level flight 
fc0i  = getFlightCondition(he,'V',Vi,'H',Hi,'GW',GWi,...
                             'Omega',Omegai,'Mf',Mfi);
ps0   = getEpowerState(he,fc0i,atm);

% Get power state for minimum gammaT for autorotation
% First, get gammaT minimum for autorotation
fc0    = getFlightCondition(he,'H',hsl,'GW',GW,...
                             'Omega',OmegaN,'Mf',Mf);
gTmin  = gammaT2autorrotation(he,fc0,atm,'inducedVelocity',@Cuerva);

% Second, define flight condition for gTmin and 
gTmini    = gTmin*ones(nv,1);
fCgTmini  = getFlightCondition(he,'gammaT',gTmini,'V',Vi,'H',Hi,'GW',GWi,...
                               'Omega',Omegai,'Mf',Mfi);

pSgTmin  = getEpowerState(he,fCgTmini,atm,...
                           'inducedVelocity',@Cuerva);

% Plot power states: ps0 and pSgTmin as function of velocity modulus and
% horizontal velocity
axV     = getaxds('V','$V$ [m/s]',1);
axVH    = getaxds('Vh','$V_h$ [m/s]',1);
azP     = getaxds({'P'},{'$P$ [W]'},1);
l1      = '$\gamma_T = 0$';
l2      = '$\gamma_T = (\gamma_T)_{AT,min}$';
leg     = {l1,l2};
axpv    = plotPowerState({ps0,pSgTmin},...
          axV,leg,'defaultVars',azP); hold on;
axph    = plotPowerState({ps0,pSgTmin},...
          axVH,leg,'defaultVars',azP); hold on;


% Now let us impose several flight condition power ratings. The following
% power ratings are considered
%
patj    = [1.20  1.10 1.001 -0.90 -0.0].*ps0.P(1);
% patj    = [1.001 -0.0].*ps0.P(1);
np      = length(patj);
VHi     = linspace(0,120,nv);

[VHij,PATij] = ndgrid(VHi,patj);

Omegaij = OmegaN*ones(nv,np);
GWij    = GW*ones(nv,np);
Mfij    = Mf*ones(nv,np);
Hij     = hsl*zeros(nv,np);

fcPij   = getFlightCondition(he,'Vh',VHij,'H',Hij,'GW',GWij,...
                             'Omega',Omegaij,'Mf',Mfij,'P',PATij);
pSP     = getEpowerState(he,fcPij,atm,'inducedVelocity',@Cuerva);
azVV    = getaxds({'Vv'},{'$V_v$ [m/s]'},1);
axpP    = plotPowerState(pSP,axVH,[],...
          'defaultVars',azVV,...
          'plot3dMode','parametric' ...
); hold on;

ayVV    = getaxds({'Vv'},{'$V_v$ [m/s]'},1);
azAT    = getaxds('P','$P$ [W]',1);
axpP    = plotPowerState(pSP,axVH,azAT,...
          'defaultVars',ayVV...
); hold on;


io = 1;



% %==========================================================================
% fc      = getFlightCondition(he,'Vh',VH,'H',H,'GW',W,...
%                              'Omega',Omega,'Mf',Mf,'P',PAT);
% ndfc    = fc2ndFC(fc,he,atm);
% 
% ps      = getNdApowerState(ndhe,ndfc);
% 
% axds    = getaxds('VhOR','$V_h/\Omega R$ [-]',1);
% ayds    = getaxds('CP','$C_P$ [-]',1);
% azds    = getaxds({'VvOR'},{'$Vv/(\Omega R)$ [-]'},1);
% 
% plotNdPowerState(ps,axds,ayds,...
%                  'defaultVars',azds,...
%                  'plot3dMode','parametric')
% 
% io = 1;

% % Define the flight condition of autorotation
% nv      = 31;
% np      = 3;
% % Omega at steday autorotation
% omega   = 1.06;
% OmegaN  = he.mainRotor.Omega;
% Omega   = omega*OmegaN*ones(nv,np);
% GW      = 73550;
% W       = GW*ones(nv,np);
% Mf      = 1600*ones(nv,np);
% hsl     = 0;
% H       = hsl*zeros(nv,np);
% VH      = repmat(linspace(0,100,nv)',1,np);
% pat     = [2e-3*he.characteristic.Pu(hsl),0,-2e-4*he.characteristic.Pu(hsl)];
% PAT     = repmat(pat,nv,1);
% 
% fc      = getFlightCondition(he,'Vh',VH,'H',H,'GW',W,...
%                              'Omega',Omega,'Mf',Mf,'P',PAT);
% 
% 
% ndhe    = he2ndHe(he);
% 
% ndfc    = fc2ndFC(fc,he,atm);
% 
% ps      = getNdApowerState(ndhe,ndfc);
% 
% % Plot power state
% % Define x and y axis data of the problem.
% % For this example they are x:=VhOR and y:=CP
% % Get an axis data structure for independent variables
% axds    = getaxds('VhOR','$V_h/\Omega R$ [-]',1);
% ayds    = getaxds('CP','$C_P$ [-]',1);
% azds    = getaxds({'VvOR'},{'$Vv/(\Omega R)$ [-]'},1);
% 
% % Now plot the power state structure data as function of the axis data
% % structure defined above
% plotNdPowerState(ps,axds,ayds,...
%                  'defaultVars',azds,...
%                  'plot3dMode','parametric')
% 
% 
% plotNdPowerState(ps,axds,ayds,'plot3dMode','bidimensional');
% 
% 
% % Cange the default behaviour of plotNdEpowerState by defining as depedent
% % variables just only lambdaI. For this first create 
% azds    = getaxds('lambdaI','lambda_I [-]',1);
% 
% plotNdPowerState(ps,axds,ayds,'plot3dMode','bidimensional','defaultVars',azds);
% 
% 
% unsetPlot;
% io = 1;

