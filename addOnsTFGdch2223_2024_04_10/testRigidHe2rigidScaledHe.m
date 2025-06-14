%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%

%%% Test of generation of a scaled helicoper and modification of inertia
%%% values after adding a internal payload with known inertial properties

clear all
close all

set(0,'defaulttextinterpreter','tex')
set(0,'DefaultTextFontSize',26)
set(0,'DefaultAxesFontSize',26)
set(0,'DefaultTextFontName','Times')
set(0,'DefaultAxesFontName','Times') 
set(0,'defaultlinelinewidth', 2)
% set(0,'defaultlinemarkersize',4);


%%% We load an atmophere
atm = getISA;

%%% We load a helicopter that will be used a a seed
he = rigidBo105(atm);



%%% We defined the flight altitude
H     = 0;

ndHe = rigidHe2ndHe(he,atm,H);

%%% We define the goal characteristics of the scaled helicopter
b     = 2;         % number of blades of the main rotor 
R     = 1.9;       % [m]. radius of the main rotor
W     = 250*atm.g; % [N]. Weight of the helicopter
btr   = 2;         % Number of blades of the tail rotor
Omega = 1000*(2*pi)/60;        % [rad/s]. 

%%% The drone he is obtained from seed he
newHe             = rigidHe2rigidScaledHe(he,b,R,Omega,W,btr,atm,H,'newHe');

ndNewHe = rigidHe2ndHe(newHe,atm,H);

%save('SAnTAR2223.mat', '-struct', 'SAnTAR');




                                          