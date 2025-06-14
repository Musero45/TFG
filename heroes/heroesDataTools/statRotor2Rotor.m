function Rotor = statRotor2Rotor (stathelicopter,Rotor,options)
% Fichero que dimensiona el rotor statrotor2rotor
% Definitions

options  = parseOptions(options,@statRotor2RotorOptions);

e      = options.e;
theta1 = options.theta1;
cldata = options.cldata;
cddata = options.cddata;
kBeta  = options.kBeta;


label = stathelicopter.id;
% Calculated by Rand statistical method.
R = Rotor.R;
RMr = stathelicopter.MainRotor.R;
cMr = stathelicopter.MainRotor.c;

% Desing request, input.
b = Rotor.b; 
bMr = stathelicopter.MainRotor.b;

% Calculated by Rand statistical method.
Omega = Rotor.OmegaRAD; 

% rectangular plate.
c0 = Rotor.c; 
% It is supposed that the blade is of uniform chord
c1 = c0;

% Get blade mass
N2kg   = 1/9.8;
wblade = stathelicopter.AFDD.RotorGroupWeight.WbladeMainRotor*N2kg;

% Unique blade lengthwise weight.
bm = wblade*(1/(RMr*bMr));
Bm = bm*(R-e)*(R*c0/(RMr*cMr));

% Teoria de helicopteros page 218
% rectangular and thin plate hypothesis
xGB = (R-e)*0.5;
IBeta = 1/3*bm*(R-e)^3;
ITheta = 1/12*bm*(R-e)*c0^2; 
IZeta = IBeta+ITheta;

Rotor = struct(...
            'class','rigidRotor',... 
            'active','yes',...
            'id',label,...
            'R',R,...
            'e',e,...
            'b',b,...
            'theta1',theta1,... % Input.
            'cldata',cldata,... % Input.
            'cddata',cddata,... % Input. 
            'profile',@cl1cd2,... 
            'Omega',Omega,...  
            'c0',c0,... 
            'c1',c1,... % rectangular plate.
            'bm',Bm,...
            'xGB',xGB,...
            'IBeta',IBeta,...
            'ITheta',ITheta,...
            'IZeta',IZeta,...
            'kBeta',kBeta,... % Input.
            'k',0 ... 
            );



function options = statRotor2RotorOptions


options = struct(...
          'e',0,...
          'theta1',0,...
          'cldata',[2*pi 0],...
          'cddata',[0.01 0 0],...
          'kBeta', 0 ...
);
