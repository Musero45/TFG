function y = DriveSystemWeight(desreq,performances, rotorGroupWeight, dimensions,mainRotor,engine)
%
% NDARC, NASA Design and Analysis of Rotorcraft (2009)
% Wayne Johnson
% Propulsion Group 
% DRIVE SYSTEM 19-7.4 (pages 158-159)
%
% Input and output variables expressed in International System 
%
% Initial version: Emory et al
% International System Version 
%      26/01/2014 Hector Fernandez Dotu hector.f.dotu@gmail.com
%


xhub = dimensions.verticalTailSurfaceArm;
chigb = desreq.technologyFactors.gearBoxes;
chirs = desreq.technologyFactors.rotorShaft;
chids = desreq.technologyFactors.driveShaft;
chirb = desreq.technologyFactors.rotorBrake;
frs = desreq.options.frotorShaft;
Nds = desreq.estimations.Nds;

Omegaeng = engine.OmegaRPM;
Tto = performances.TakeOffTransmissionRating;
Wblade = rotorGroupWeight.WbladeMainRotor;
Vt = mainRotor.Vt;
OmegaRPM = mainRotor.OmegaRPM;
Pmc = performances.maximumContinuousTotalPower;

%change [W] to [kW] as it was the original input
Tto = Tto/1000;
Pmc = Pmc/1000;

%change [N] to [kg] as it was stated that all weights were expressed
%in [N] (originally they were in [kg])
kg2N = 9.81;
N2kg = 1/9.81;
Wblade = Wblade*N2kg;

%pasamos a sistema imperial
Tto_ = Tto/0.7457;
xhub_ = xhub/0.3048;
Wblade_ = Wblade*2.205;
Vt_ = Vt/0.3048;
Pmc_=Pmc*1.341;

%GEAR BOX AND ROTOR SHAFT (AFDD00 model)
%Tto=drive system rated power
%omega=main rotor rotatio speed
%omegaeng=engine output speed
N = 1;%Number of Main rotors
wgbrs_ = 95.7634*(N^0.38553)*(Pmc_^0.78137)*(((Omegaeng)^0.09899)/((OmegaRPM)^0.80686));
Wgb_ = chigb*(1-frs)*wgbrs_;
Wrs_ = chirs*frs*wgbrs_;

%DRIVE SHAFT AND ROTOR BRAKE (AFDD82 model)
%Tto=drive system rated power
%omega=main rotor rotatio speed
%xhub= lenght of drive shaft between rotors
%Nds=Number of intermediate drive shafts
%Wblade=weight blade
%Vt=main rotor tip speed
fp = 0.15;%second (main or tail) rotor and rater power (fraction of total drive system rated power)
Qmc_ = Tto_/OmegaRPM;
wds_ = 1.166*(Qmc_^0.3828)*(xhub_^1.0455)*(Nds^0.3909)*((0.01*fp)^0.2693);
wrb_ = 0.000871*Wblade_*((0.01*Vt_)^2);
Wds_ = chids*wds_;
Wrb_ = chirb*wrb_;

%pasamos a SI
Wgb = Wgb_*0.4536;
Wrs = Wrs_*0.4536;
Wds = Wds_*0.4536;
Wrb = Wrb_*0.4536;

%change output weights from [kg] to [N]
Wgb = Wgb*kg2N;
Wrs = Wrs*kg2N;
Wds = Wds*kg2N;
Wrb = Wrb*kg2N;

y = struct (...
    'WgearBox', Wgb,...
    'WrotorShaft', Wrs,...
    'WdriveShaft', Wds,...
    'WrotorBrake', Wrb ...
);









