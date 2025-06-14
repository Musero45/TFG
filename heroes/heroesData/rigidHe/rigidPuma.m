function he = rigidPuma(atmosphere)

% FIXME Growing structure. Some definitions will be added. To be documented

% Helicopter definition
label = 'practPuma'; % FIXME oscar: why is this label practPuma?

% main rotor definition
mainRotor = struct(...
            'class','rigidRotor',...
            'active','yes',...
            'id',label,...
            'R',7.5,...% 
            'e',0.,....64,...%
            'b',4,...%
            'theta1',-.14,...
            'cldata',[5.73 0],...% Padfield [6.113 0]
            'cddata',[0.008 0.00961 0.29395],... [0.29395 0.00961 0.0049],... %Padfield [38.66? ? .0074]
            'profile',@cl1cd2,...
            'Omega',27,... % 
            'c0',0.5401,... %
            'c1',0,... % 
            'IBeta',1280,...%
            'ITheta',30,...%
            'IZeta',1310,...% IBeta+ITheta 100000,...% My own
            'xGB',3.75,...%3.22 
            'bm',65.2,...%
            'kBeta',48149,... %
            'k',0 ...
            );

%%% Non corresponding values from now on to. Not used by this moment, but
%%% necce but neccesary to properly performance. Will be update when needed.

% tail rotor definition
tailRotor = struct(...
            'class','rigidRotor',...
            'id',label,...
            'active','yes',...
            'R',1.56,...%
            'b',5,...% 
            'e',0.,...%
            'theta1',0,...
            'cldata',[5.73 0],...% Padfield [5.7 0]
            'cddata',[0.008 0.00961 0.29395],...% Padfield [9.5? ? 0.008]
            'profile',@cl1cd2,...
            'Omega',27*4.82,... % 
            'c0',0.1176, ... %
            'c1',0, ... %
            'IBeta',2.395,...% bm/3*R^2
            'ITheta',0.014,...% bm/3*c^2
            'IZeta',2.409,...%
            'xGB',.78,...% R/2
            'bm',2.95,...% my own
            'kBeta',1e100,... %
            'k',0 ...
            );

% fuselage definition
fuselage = struct(...
            'class','fuselage',...
            'id',label,...
            'active','yes',...
            'model',@generalFus,...
            'lf',14.06,...
            'Sp',24.6,...
            'Ss',30.6,...
            'kf',1 ...
            );
        
% vertical fin definition
verticalFin = struct(...
            'class','stabilizer',...
            'id',label,...
            'active','yes',...
            'airfoil',@vfPumaPadf,...@naca0012,...
            'type',@get2DStabilizerActions,...
            'c',.635,...
            'S',1.395,...
            'theta',0.0175,...
            'ks',1 ...
            );
        
% horizontal tail definition
%left
leftHTP = struct(...
            'class','stabilizer',...
            'id',label,...
            'active','yes',...
            'airfoil',@naca0012,...@HTPPumaPadf,...
            'type',@get2DStabilizerActions,...
            'c',0.635,...
            'S',0,...
            'theta',0,...
            'ks',0 ...
            );

%right
rightHTP = struct(...
            'class','stabilizer',...
            'id',label,...
            'active','yes',...
            'airfoil',@naca0012,...@HTPPumaPadf,...
            'type',@get2DStabilizerActions,...
            'c',.635,...
            'S',1.34,...
            'theta',-0.0262,...
            'ks',1 ...
            );
        
        
% transmission        

  

transmission = struct(...
                'transmissionType',@standardTransmission,...
                'etaTmr',0.12,...
                'etaTtr',0.07 ...
             );
% grometry definition

geometry = struct(...
            'class','geometry',...
            'id',label,...
            'xcg',0.0375,...
            'ycg',0,...
            'zcg',0,...
            'epsilonx',0,...
            'epsilony',-0.0873,...
            'ls',0,...
            'ds',0,...
            'h',2.157,...
            'thetatr',0,...
            'ltr',-9,...
            'dtr',0.,...
            'htr',-1.587,...
            'lvf',-9,...
            'dvf',0,...
            'hvf',-0.79,...-1.587,...
            'Gammavf',pi/2,...
            'llHTP',-0,...
            'dlHTP',-0.,...
            'hlHTP',0,...
            'GammalHTP',0,...
            'lrHTP',-9,...
            'drHTP',1.055,...0,...
            'hrHTP',-1.587,...
            'GammarHTP',0 ...
            );
        
inertia = struct(...
          'class','inertia',...
          'id',label,...
          'W',5805*9.8,...
          'Ix',9638,...
          'Iy',33240,...
          'Iz',25889,...
          'Ixy',0,...
          'Ixz',2226,...
          'Iyz',0 ...
          );
        
% helicopter definition
he  = struct(...
      'class','rigidHe', ...
      'id',label,...
      'mainRotor',mainRotor,...
      'tailRotor',tailRotor,...
      'fuselage',fuselage,...
      'verticalFin',verticalFin,...
      'leftHTP',leftHTP,...
      'rightHTP',rightHTP,...
      'transmission',transmission,...
      'geometry',geometry,...
      'inertia',inertia ...
);



% atmosphere seems not very clear that it is convenient to be input FIXME
he      = addCharacteristic2he(he,atmosphere);
