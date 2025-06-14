%% HEROES TOOLBOX
%% Getting Started Guide
% 
%% Heroes toolbox description
%
%  Heroes toolbox is a matlab toolbox developed to simulate the flight
%  mechanics of conventional helicopters and it has been developed by
%  profesors and students of Escuela Tecnica Superior de Ingeniera
%  Aeronautica y del Espacio from Universidad Politecnica de Madrid. 
%
%  The key features of heroes are the following ones
%
% 
% * Construct helicopter models
% * Analyse performance, missions, trim and stability of helicopters
% * Computer aid to design of helicopters
%
%% Using the documentation
% 
%% Defining helicopters
%
% You can use heroes toolbox to define helicopter models based on two
% theoretical formulations. The following sort of helicopters can be
% defined:
%
% * energy-based helicopters
% * actions-based helicopters
%
% Constructing an energy-based helicopter
% To define an energy-based helicopter, ehe, it is neccessary to define
% each of the subcomponents of helicopter, that is, main and tail rotors,
% fuselage, transmission and power plant. 
%
% Enter the following data to define the main rotor of an energy-based
% helicopter.


R     = 5.6;
Omega = 42.0;
chord = 0.35;
b     = 2;
cd0   = 0.009;
kappa = 1.1;
K     = 4.5;

%%
% where R is the rotor radius, Omega is the rotor angular speed, chord, the
% chord of the blade, b the number of blades, cd0 is an average drag 
% coefficient, kappa the induced correction factor and K the profile and
% parasite correction factor. To construct the main rotor it should be used
% the eRotor function:

mr    = eRotor(b,cd0,chord,Omega,R,K,kappa);

%%
% To define a tail rotor it is enough to define the percentage of the main
% rotor power consumption that is required by the tail rotor. Then defining
% 

eta = 0.07;

%%
% where eta is the percentage of the main rotor power consumption that 
% is required by the tail rotor. To construct the tail rotor we use again
% eRotor function as follows

tr    = eRotor(eta);


%%
% Now to define the helicopter fuselage the flat plate equivalent area
% shold be input, that is

f     = 1.2;

%%
% To construct the energy-based fuselage we need to use the function
% eFuselage:

flg   = eFuselage(f);


%%
% To define the power plant and because the performance of the power plant
% is dependent on the flight altitude we need to define before a ISA
% atmosphere. To setup a international standard atmosphere we use the
% function getISA as follows

atm   = getISA;

%%
% and atm is an ISA atmosphere variable. The energy-based power plant
% should especify the following data

PTOsl     = 375e3;
PMCsl     = 360e3;
PSFC      = 0.11e-6;
npower    = 0.8;
nEngines  = 1;

%%
% where

pp = ePowerPlant(PTOsl,PMCsl,PSFC,npower,nEngines,atm);


%%
% The last component to be defined is the helicopter transmission. 

PMT       = 310e3;
etaTmr    = 0.95;
etaTtr    = 0.94;
trn       = eTransmission(PMT,etaTmr,etaTtr);

%%
% The Operating Empty Weight OEW, maximum take-off weight, MTOW, maximum
% pay load, MPL, and maximum fuel weight, MFW, should be especified by using 
% the eWeight constructor. For instance, consider the following helicopter
% weights

MTOW      = 20000;
OEW       = 10500;
MPL       = 4000;
MFW       = 5000;

%%
% and using the eWeight constructor an energy-based structure is setup

we        = eWeight(MTOW,OEW,MPL,MFW);

%%
% Finally to construct the energy-based helicopter we use the ehe
% constructor function.


gshe      = ehe(mr,tr,flg,pp,trn,atm,we,'heroes-gs');


%
%% Analysing helicopter using the energy method
%
%
%
% In this section, you learn how to analyze the performance of energy-based 
% helicopter models using the energy method of determining performances. 
%
% Before you can perform the analysis, you must have already built in 
% energy-based helicopter models in the MATLAB workspace. For information 
% on how to create a model, see ??hypperlink required??.
%
% In what follows, some energy-based functions are going to be presented in
% a study-case fashion. For a more detailed information about energy-based
% functions see ??hypperlink required??
%
% Among others, one of the basic information the energy method can provide 
% is the determination of the required power as a function of the 
% forward speed and the flight altitude. Before using the energy-based
% functions an energy_based helicopter a flight conditions should be
% defined. Section ??hyperlink required?? presents how to construct
% energy-based helicopters. Flight conditions can be established using the
% corresponding constructors and depending on the kind of flight condition
% several constructors are used. 
%
% From a mathematical point of view the energy method deals with 
% two basic problems:
% * power is unknown (powered flight conditions). This case corresponds to
% the basic energy problem. Performances based on this kind of problem are
% ceiling, velocity for maximum endurance, velocity for maximum range, etc.
% * power is known (powered flight condition). This case implies that power
% is imposed and other variable can be determined instead of power. Typical
% helicopter performances for given power are maximum velocity for given
% power, maximum rate of climb, autorotation performances such as flight 
% path angle for minimum vertical velocity.
%
%% Computing helicopter performance from non-powered flight conditions
%
%
% 
% To compute the required power in watts of the helicopter previously
% defined as gshe at sea level with a forward speed between 50 km/h upto 
% 200 km/h and gammaT equal to zero (level cruise flight condition) we can 
% use the getEpowerState function. 
%
% Once atmosphere and helicopter are established, see previous section, 
% flight condition should be defined. To define a flight condition the
% following operating variables should be especified:
%
% * helicopter speed modulus V
% * altitude, H.
% * helicopter gross weight, W.
% * angular speed of rotor, Omega.
% * Fuel mass, Mf.
% * Height above ground, Z.
% * Helicopter required power, P.
% * gammaT.
%
%
% To define a level flight condition, gammaT=0, corresponding to a sea level
% altitude, H=0, with a gross weight of 10400 N, fuel mass of 400 kg, and
% rotor speed corresponding to nominal rotor speed, Omega=Omega_N, and
% 31 forward speeds between 5 km/h upto 200 km/h we can use the
% getFlightCondition constructor function as follows: first we define
% scalar values of the flight condition parameters to be used latter, and
% then we build up a vector of flight conditions using the flightCondition
% constructor by input vector values. Therefore, we define the scalar values of
% the flight condition

GW      = 10400;
Mf      = 400;
hsl     = 0.0;
OmegaN  = gshe.mainRotor.Omega;


%% 
% then we define the input vector for the flight condition and finally we
% use the getFlightCondition function.
nv      = 31;
v_i     = linspace(5,200,nv)'/3.6;
hsl_i   = hsl*ones(nv,1);
GW_i    = GW*ones(nv,1);
Mf_i    = Mf*ones(nv,1);
Omega_i = OmegaN*ones(nv,1);
fc_i    = getFlightCondition(gshe,...
          'V',v_i,'H',hsl_i,'GW',GW_i,...
          'Omega',Omega_i,'Mf',Mf_i);


%%
% The next example shows how to compute and plot the power curve of the helicopter
% for the previously defined flight condition. To get the power curve of
% the helicopter the function getEpowerState is used. As every energy
% function the sequence of input arguments is always helicopter, flight
% condition, atmosphere and possibly some options. The function
% getEpowerState transforms helicopter, flight condition and atmosphere
% into a power state data structure. 
%
ps_i    = getEpowerState(gshe,fc_i,atm);


fc1     = getFlightCondition(gshe,...
          'V',NaN,'H',hsl,'GW',GW,...
          'Omega',Omega,'Mf',Mf);
VA      = vMaxRange(gshe,fc1,atm);
fcA     = getFlightCondition(gshe,...
          'V',VA,'H',hsl,'GW',GW,...
          'Omega',Omega,'Mf',Mf);
psA     = getEpowerState(gshe,fcA,atm);

VB      = vMaxEndurance(gshe,fc1,atm);
fcB     = getFlightCondition(gshe,...
          'V',VB,'H',hsl,'GW',GW,...
          'Omega',Omega,'Mf',Mf);
psB     = getEpowerState(gshe,fcB,atm);



%%
% Heroes toolbox provides the function plotPowerState to plot power state 
% data.
axds    = getaxds('Vh','$V_H$ [km/h]',3.6);
azds    = getaxds({'P'},{'$P$ [kW]'},1e-3);

axps    = plotPowerState(ps_i,axds,[],'defaultVars',azds); hold on;


plotPowerState({ps_i,psA,psB},axds, ...
{'power curve','max range','max endurance'}, ...
'defaultVars',azds,...
'mark',{'k-','r s','b o'} ...
);

%% Computing powered power states


%% Analysing helicopter using the actions method


