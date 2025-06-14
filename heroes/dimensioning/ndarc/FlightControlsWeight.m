function y = FlightControlsWeight(input, mainRotor,dimensions)
%
% NDARC, NASA Design and Analysis of Rotorcraft (2009)
% Wayne Johnson
% Flight Control Group
% Parametric method AFDD82 19-8 page 159-161
%
% Input and output variables expressed in International System 
%
% Initial version: Emory et al
% International System Version 
%      23/01/2014 Cristobal Francisco Serrano fco.serrano.guzman@alumnos.upm.es
%



MTOW = input.rand.MTOW;
b    = input.rand.b;
c    = mainRotor.c;
Vt   = mainRotor.Vt;
Sht  = dimensions.Sht;
chifwnb = input.technologyFactors.fixedWingNonBoosted;
chifwmb = input.technologyFactors.fixedWingBoostMechanisms;
chirwnb = input.technologyFactors.rotaryWingNonBoosted;
chirwmb = input.technologyFactors.rotaryWingBoostMechanisms;
chirwb  = input.technologyFactors.rotaryWingBoosted;
ffwnb  = input.options.ffixedWingNonBoosted;%fixed wing non-boosted weight (fraction total fixed wing flight control weight)
frwhyd = input.options.frotaryWingHydraulics;%rotary wing hydraulics weight (fraction hydraulics plus boost mechanisms weight)
frwred = input.options.frotaryWingHydraulicsSistemRedundancy;%flight control hydraulic system redundancy factor


%pasamos a sistema imperial 
MTOW_ = MTOW*2.205/9.81;
c_ = c/0.3048;
Vt_ = Vt/0.3048;
Sht_ = Sht/(0.3048^2);

%WING-FLIGHT CONTROLS (NON-BOOSTED FLGHT CONTROLS/FLIGHT-CONTROL BOOST MECHANISMS)
%MTOW= maximun takeoff weight
w_ = 0.01735*(MTOW_^0.64345)*(Sht_^0.40952);
w_ = 0;
wfwnb_ = ffwnb*w_;
wfwmb_ = (1-ffwnb)*w_;
Wfwnb_ = chifwnb*wfwnb_;
Wfwmb_ = chifwmb*wfwmb_;

%ROTARY-FLIGHT CONTROLS (NON-BOOSTED FLGHT CONTROLS/FLIGHT-CONTROL BOOST MECHANISMS/BOOSTED FLIGHT CONTROLS)
%MTOW= maximun takeoff weight
%b=number of blades per rotor
%c=rotor mean blade chord
%Vt=rotor hover tip velocity
N = 1;%Number of main rotors 
if input.options.fnbsv == true
    fnbsv = 1.0;%for otherwise
else
    fnbsv = 1.8984;%for ballistically survivable (UTTAS/AAH level)
end
if input.options.fmbsv == true
    fmbsv = 1.0;%for otherwise
else
    fmbsv = 1.3029;%for ballistically survivable (UTTAS/AAH level)
end
if input.options.fbsv == true
    fbsv = 1.0;%for otherwise
else
    fbsv = 1.1171;%for ballistically survivable (UTTAS/AAH level)
end
wfc_ = 0.2873*fmbsv*((N*b)^0.6257)*(c_^1.3286)*((0.01*Vt_)^2.1129)*frwred^0.8942;
wrwnb_ = 2.1785*fnbsv*(MTOW_^0.3999)*(N^1.3855);
wrwmb_ = (1-frwhyd)*wfc_;
wrwb_ = 0.02324*fbsv*((N*b)^1.0042)*(N^0.1155)*(c_^2.2296)*((0.01*Vt_)^3.1877);
Wrwnb_ = chirwnb*wrwnb_;
Wrwmb_ = chirwmb*wrwmb_;
Wrwb_ = chirwb*wrwb_;

%pasamos a SI
Wfwnb = Wfwnb_*0.4536*9.81;
Wfwmb = Wfwmb_*0.4536*9.81;
Wrwnb = Wrwnb_*0.4536*9.81;
Wrwmb = Wrwmb_*0.4536*9.81;
Wrwb = Wrwb_*0.4536*9.81;
Wfc=Wfwnb+Wfwnb+Wrwnb+Wrwmb+Wrwb;

y = struct (...
    'WfixedWingNonBoosted', Wfwnb,...
    'WfixedWingBoostMechanisms', Wfwmb,...
    'WrotaryWingNonBoosted', Wrwnb,...
    'WrotaryWingBoostMechanisms', Wrwmb,...
    'WrotaryWingBoosted', Wrwb,...
    'WflightControls',Wfc ...
);






