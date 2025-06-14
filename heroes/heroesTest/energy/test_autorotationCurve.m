function io = test_autorotationCurve(mode)

% This script is used to test autorrotation curve together with the
% computation of important points on this curve such as:
% * minimum gammaT for autorotation
% * minimum Vv for autorotation
% * minimum V for autorotation


close all
setPlot;
atm     = getISA;
he      = superPuma(atm);
he.mainRotor.kappa = 1.0;


GW      = 73550;
Mf      = 1600;
OmegaN  = he.mainRotor.Omega;
hsl     = 0.;



PAT     = 0.0;
nv      = 31;
VHi     = linspace(0,120,nv)';
pati    = PAT*ones(nv,1);

Omegai  = OmegaN*ones(nv,1);
GWi     = GW*ones(nv,1);
Mfi     = Mf*ones(nv,1);
Hi      = hsl*zeros(nv,1);


% Determine the autorotation curve
fcPi    = getFlightCondition(he,'Vh',VHi,'H',Hi,'GW',GWi,...
                             'Omega',Omegai,'Mf',Mfi,'P',pati);
pSP     = getEpowerState(he,fcPi,atm,'inducedVelocity',@Cuerva);


% Determine the minimum flight path angle for autorotation
fc1     = getFlightCondition(he,'Vh',NaN,'H',hsl,'GW',GW,...
                             'Omega',OmegaN,'Mf',Mf,'P',PAT);
[gammaT_mgT VV_mgT VH_mgT]    = gammaTminGammaT(he,fc1,atm,'inducedVelocity',@Cuerva);


% Determine the flight path angle for minimum vertical velocity in 
% autorotation
[gammaT_mVV VV_mVV VH_mVV]    = gammaTminVv(he,fc1,atm,'inducedVelocity',@Cuerva);

% Determine the flight path angle for minimum vertical velocity in 
% autorotation
[gammaT_mV VV_mV VH_mV]    = gammaTminV(he,fc1,atm,'inducedVelocity',@Cuerva);




% Now plot some points of the curve

% 1. Given vH=20 m/s and power=PAT compute Rate Of Climb vV. 
% Because we are imposing the power as a flight condition we must set the
% constrainedEnginePower heroes option to flightCondition. Moreover, we
% shouldn't forget to use Cuerva's induced velocity model because of the
% descend flight regime
Vh_a    = 20;
fc_a    = getFlightCondition(he,'Vh',Vh_a,'H',hsl,'GW',GW,...
                             'Omega',OmegaN,'Mf',Mf,'P',PAT);

roc_a   = vV4vHpower(he,fc_a,atm,...
          'inducedVelocity',@Cuerva,...
          'constrainedEnginePower','flightCondition');

% 2. Given rate Of Climb vV = -20 m/s and power=PAT compute vH
% Because we are imposing the power as a flight condition we must set the
% constrainedEnginePower heroes option to flightCondition. Moreover, we
% shouldn't forget to use Cuerva's induced velocity model because of the
% descend flight regime
roc_b   = -20;
fc_b    = getFlightCondition(he,'Vv',roc_b,'H',hsl,'GW',GW,...
                             'Omega',OmegaN,'Mf',Mf,'P',PAT);

Vh_b    = vH4vVpower(he,fc_b,atm,...
          'inducedVelocity',@Cuerva,...
          'constrainedEnginePower','flightCondition');

figure(1)
plot(VHi,pSP.Vv,'r-'); hold on;
plot(VH_mgT,VV_mgT,'b s'); hold on;
plot(VH_mVV,VV_mVV,'b o'); hold on;
plot(VH_mV,VV_mV,'b v'); hold on;
plot(Vh_a,roc_a,'k s'); hold on;
plot(Vh_b,roc_b,'k o'); hold on;



unsetPlot;
io = 1;


