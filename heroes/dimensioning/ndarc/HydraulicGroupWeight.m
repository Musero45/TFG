function y = HydraulicGroupWeight(input, flightControlsWeight)
%
% NDARC, NASA Design and Analysis of Rotorcraft (2009)
% Wayne Johnson
% HYDRAULIC GROUP (parametric method AFDD82) 19-9 (page 161)
%
% Input and output variables expressed in International System 
%
% Initial version: Emory et al
% International System Version 
%      11/03/2014 Ivan Marquez i.marquez@alumnos.upm.es
%

chifwhyd = input.technologyFactors.fixedWingHydraulics;
chirwhyd = input.technologyFactors.rotaryWingHydraulics;
ffwhyd = input.options.ffixedWingHydraulics;
frwhyd = input.options.frotaryWingHydraulics;
wfc   = flightControlsWeight.WflightControls;
Wfwmb = flightControlsWeight.WfixedWingBoostMechanisms;

kgf2N=9.81;
 
% Weights [N]->[Kg]
wfc = wfc/kgf2N;
Wfwmb = Wfwmb/kgf2N;

%pasamos a sistema imperial [Kg]->[lb]
wfc_ = wfc*2.205;
Wfwmb_ = Wfwmb*2.205;

%FIXED-WING FLIGHT CONTROLS
%Wfwmb=Flight-control boost mechanism weight
%ffwhyd=fixed wing hydraulics weight (fraction bost mechanism weight)

wfwhyd_ = ffwhyd*Wfwmb_;
Wfwhyd_ = chifwhyd*wfwhyd_;

%ROTARY-WING FLIGHT CONTROLS

wrwhyd_ = frwhyd*wfc_;
Wrwhyd_ = chirwhyd*wrwhyd_;

%pasamos a SI [lb]->[Kg]
Wfwhyd = Wfwhyd_*0.4536;
Wrwhyd = Wrwhyd_*0.4536;
 
% Weights [Kg]->[N]

Wfwhyd = Wfwhyd*kgf2N;
Wrwhyd = Wrwhyd*kgf2N;


y = struct(...
    'Wfwhyd', Wfwhyd,...
    'Wrwhyd', Wrwhyd ...
);
