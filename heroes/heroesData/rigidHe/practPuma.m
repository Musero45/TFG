function he = practPuma(atmosphere)

% FIXME Growing structure. Some definitions will be added. To be documented

% Helicopter definition
label = 'practPuma';

% main rotor definition
mainRotor = struct(...
            'class','rigidRotor',...
            'id',label,...
            'active','yes',...
            'R',7.5,...% 
            'e',0.64,...%
            'b',4,...%
            'theta1',-0.1,...
            'cldata',[5.73 0],...% Padfield [6.113 0]
            'cddata',[0.012 0 0],... [0.29395 0.00961 0.0049],... %Padfield [38.66? ? .0074]
            'profile',@cl1cd2,...
            'Omega',27,... % 
            'c0',0.5401,... %
            'c1',0,... % 
            'IBeta',1280,...%
            'ITheta',30,...%
            'IZeta',1310,...% IBeta+ITheta 100000,...% My own
            'xGB',3.22,...% 
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
            'cldata',[5.7 0],...% Padfield [5.7 0] | old one [5.8109 0]
            'cddata',[0.01 0.0 0.0],...% Padfield | old one [0.29395 0.00961 0.00492]
            'profile',@cl1cd2,...
            'Omega',129.8,... % 
            'c0',0.186, ... %
            'c1',0, ... %
            'kBeta',1e100,... % rigid
            'k',1 ...
            );

tailRotor = massBlade_mr2inertiaBlade_tr(mainRotor,tailRotor);

% fuselage definition
fuselage = struct(...
            'class','fuselage',...
            'id',label,...
            'active','no',...
            'model',@generalFus,...
            'lf',8.56,...
            'Sp',10,...
            'Ss',12,...
            'kf',1 ...
            );
        
% vertical fin definition
verticalFin = struct(...
            'class','stabilizer',...
            'id',label,...
            'active','no',...
            'airfoil',@naca0012,...
            'type',@get2DStabilizerActions,...
            'c',.3,...
            'S',.805,...
            'theta',0.08116,...
            'ks',1 ...
            );
        
% horizontal tail definition
%left
leftHTP = struct(...
            'class','stabilizer',...
            'id',label,...
            'active','no',...
            'airfoil',@naca0012,...
            'type',@get2DStabilizerActions,...
            'c',.3,...
            'S',.4015,...
            'theta',0.0698,...
            'ks',1 ...
            );

%right
rightHTP = struct(...
            'class','stabilizer',...
            'id',label,...
            'active','no',...
            'airfoil',@naca0012,...
            'type',@get2DStabilizerActions,...
            'c',.3,...
            'S',.4015,...
            'theta',0.0698,...
            'ks',1 ...
            );
        
% transmission        

  

transmission = struct(...
                'transmissionType',@standardTransmission,...
                'etaTmr',0.12,...
                'etaTtr',0.07 ...
             );
        
% geometry definition

geometry = struct(...
            'class','geometry',...
            'id',label,...
            'xcg',0.0375,...
            'ycg',0,...
            'zcg',0,...
            'epsilonx',0,...
            'epsilony',-4*pi/180,...
            'ls',0,...
            'ds',0,...
            'h',2.157,...
            'thetatr',0,...
            'ltr',-9,...
            'dtr',0.0,...
            'htr',1.587,...
            'lvf',-5.416,...
            'dvf',0,...
            'hvf',-2.04,...
            'Gammavf',pi/2,...
            'llHTP',-4.56,...
            'dlHTP',-.969,...
            'hlHTP',0,...
            'GammalHTP',0,...
            'lrHTP',-4.56,...
            'drHTP',.969,...
            'hrHTP',0,...
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


% inertia = struct(...
%           'class','inertia',...
%           'id',label,...
%           'W',5805*9.8,...
%           'Ix',0,...
%           'Iy',0,...
%           'Iz',0,...
%           'Ixy',0,...
%           'Ixz',0,...
%           'Iyz',0 ...
%           );
        
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
