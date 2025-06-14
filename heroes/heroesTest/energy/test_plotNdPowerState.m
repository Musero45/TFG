function io = test_plotNdPowerState(mode)



%==========================================================================
% SETUP ENVIRONMENT
a       = getISA;
he      = superPuma(a);
% ndhe    = he2ndHe(he,a.rho0,he.mainRotor.Omega,he.weights.MTOW);
ndhe    = he2ndHe(he);

%==========================================================================
% VECTOR FUNCTIONALITY
% Plot the power coefficient variation with level nondimensional 
% forward velocity from 50 km/h upto 250 km/h, at sea level

% Get the power state object
nv      = 31;
vspan   = linspace(50,250,nv)./3.6;
H       = zeros(1,nv);
fcv     = getFlightCondition(he,'V',vspan,'H',H);
ndfcv   = fc2ndFC(fcv,he,a);
ndpsv   = getNdEpowerState(ndhe,ndfcv);

% There exists the function plotNdPowerState that plots power
% state objects and by default plots as follows

% Then, build up the axis data structure
% Get an axis data structure for independent variables
axds    = getaxds('VhOR','$V_h/\Omega R$ [-]',1);

% The input axes data to plotNdPowerState
plotNdPowerState(ndpsv,axds,[]);
plotNdPowerState(ndpsv,axds,[],'plot2dMode','nFigures');

%==========================================================================
% MATRIX FUNCTIONALITY
% Plot nondimensional power state variation with forward speed and 
% altitude. Consider an interval of forward speed between 50 and 180 km/h,
% altitude between sea level and 2000 m.
nv       = 21;
vspan    = linspace(50,250,nv)./3.6;
nh       = 11;
hspan    = linspace(0,2000,nh);  
[V,H]    = ndgrid(vspan,hspan);
fchv     = getFlightCondition(he,'V',V,'H',H);
ndfchv   = fc2ndFC(fchv,he,a);
ndpshv   = getNdEpowerState(ndhe,ndfchv);

% Then, build up the axis data structure
% Get an axis data structure for independent variables
axds    = getaxds('VhOR','$V_h/\Omega R$ [-]',1);
ayds    = getaxds('CW','$C_W$ [-]',1);

% Then input axes data to plotNdPowerState
plotNdPowerState(ndpshv,axds,ayds);
plotNdPowerState(ndpshv,axds,ayds,'plot3dMode','parametric');


io = 1;