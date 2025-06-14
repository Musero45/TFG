function y = getRandDimension(input, mainRotor, TailRotor)
%
% Rand - Dimensions, lengths and surfaces
% Page 306-308
%
% Input and output variables expressed in International System 
%
% Initial version: Emory et al
% International System Version 
%      20/01/2014 Maria Santos mariass0@alumnos.upm.es
%

MTOW = input.rand.MTOW;
D = mainRotor.D;
Dtr=TailRotor.D;

%Factor de conversi?n peso a masa.
g=9.81;
k=inv(g);

% HORIZONTAL TAIL SURFACE ARM
aht=0.4247*((MTOW*k)^0.327); % equation 22
%Dimensions.horizontalTailSurfaceArm = aht;

% HORIZONTAL TAIL SURFACE AREA
Sht=0.0021*((MTOW*k)^0.758); % equation 23
%Dimensions.horizontalTailSurfaceArea = Sht;

% TAIL ROTOR ARM
amt=0.5107*(D^1.061); % equation 18
%Dimensions.tailRotorArm = amt;

% VERTICAL TAIL SURFACE ARM
avt=0.5914*(D^0.995); % equation 24
%Dimensions.verticalTailSurfaceArm = avt;

% FUSELAGE LENGTH
Fl=0.824*(D^1.056); % equation 26a
%Dimensions.fuselageLength = Fl;

% AIRFRAME OVERALL LENGTH
Lrt=1.09*(D^1.03); % equation 26b
%Dimensions.airframeOverallLength = Lrt;

% HEIGHT TO ROTOR HEAD
Fh=0.642*(D^0.677); % equation 26c
%Dimensions.heightToRotorHead = Fh;

% WIDTH OVER THE LANDING GEAR
Fw=0.436*(D^0.697); % equation 26d
%Dimensions.widthOverTheLandingGear = Fw;

% VERTICAL TAIL AVERAGE CHORD
 if Dtr < 3.5 
     cvt=0.1605*(Dtr^1.745); % equation 25b, if Dtr < 3.5 m
 else
     cvt=0.297*(Dtr^1.06); % equation 25c, if Dtr > 3.5 m
 end

y = struct(...
    'horizontalTailSurfaceArm', aht,...
    'Sht', Sht,...
    'tailRotorArm', amt,...
    'verticalTailSurfaceArm', avt,...
    'fuselageLength', Fl,...
    'airframeOverallLength', Lrt,...
    'heightRotorHead', Fh,...
    'widthOverLandingGear', Fw,...
    'cvt',cvt ...
);

