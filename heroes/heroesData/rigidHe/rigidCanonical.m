function he = myRigidCanonical(atmosphere)
% 


% Helicopter definition
label = 'MYrigidCanonical';

% main rotor definition
mainRotor = struct(...
            'class','rigidRotor',...
            'id',label,...
            'active','yes',...
            'R',6.0,...% 
            'e',0,...%
            'b',4,...%
            'theta1',0,...% no twist
            'cldata',[5.7 0],...% Padfield [5.7 0]
            'cddata',[0.008 0.00961 0.29395],...
            'profile',@cl1cd2,...
            'Omega',35.33,... %
            'Pin',1,...% Pin = +1 counter clockwise (British) Pin = -1, clocwise (French/Russian) 
            'c0',0.37,... %
            'c1',0,... % 
            'IBeta',680,...%
            'ITheta',15,...%
            'IZeta',695,...% IBeta+ITheta 100000,...% My own
            'xGB',2.5,...% 
            'bm',60,...%
            'kBeta',0,... %
            'k',0 ...
            );

%%% Non corresponding values from now on to. Not used by this moment, but
%%% necce but neccesary to properly performance. Will be update when needed.

% tail rotor definition
tailRotor = struct(...
            'class','rigidRotor',...
            'id',label,...
            'active','yes',...
            'R',1.2,...%
            'b',2,...% 
            'e',0.,...%
            'theta1',0,...
            'cldata',[5.7 0],...% Padfield [5.7 0]
            'cddata',[0.008 0.00961 0.29395],...
            'profile',@cl1cd2,...
            'Omega',175.73,... %
            'Pin',1,...% Pin = +1 counter clockwise (British) Pin = -1, clocwise (French/Russian) 
            'c0',0.18, ... %
            'c1',0, ... %
            'kBeta',1e16,... 
            'k',0 ...
            );

tailRotor = massBlade_mr2inertiaBlade_tr(mainRotor,tailRotor);

% fuselage definition
fuselage = struct(...
            'class','fuselage',...
            'id',label,...
            'active','no',...
            'model',@generalFus,...
            'lf',11.51,...
            'Sp',10,...
            'Ss',12,...
            'kf',0 ...
            );
        
% vertical fin definition
verticalFin = struct(...
            'class','stabilizer',...
            'id',label,...
            'active','no',...
            'airfoil',@naca0012,...
            'type',@get2DStabilizerActions,...
            'c',.748,...
            'S',1.4,...
            'theta',0.08116,...
            'ks',0 ...
            );
        
% horizontal tail definition
%left
leftHTP = struct(...
            'class','stabilizer',...
            'id',label,...
            'active','no',...
            'airfoil',@naca0012,...
            'type',@get2DStabilizerActions,...
            'c',.47,...
            'S',0.615,...
            'theta',0.0698,...
            'ks',0 ...
            );

%right
rightHTP = struct(...
            'class','stabilizer',...
            'id',label,...
            'active','no',...
            'airfoil',@naca0012,...
            'type',@get2DStabilizerActions,...
            'c',.47,...
            'S',0.615,...
            'theta',0.0698,...
            'ks',0 ...
            );
        
% transmission        

  

transmission = struct(...
                'transmissionType',@standardTransmission,...
                'etaTmr',0.0,...
                'etaTtr',0.0 ...
             );
        
% grometry definition

geometry = struct(...
            'class','geometry',...
            'id',label,...
            'xcg',0,...
            'ycg',0,...
            'zcg',0,...
            'epsilonx',0,...
            'epsilony',0,...
            'ls',0,...
            'ds',0,...
            'h',0,...
            'thetatr',0,...
            'ltr',-7,...
            'dtr',0.0,...
            'htr',0,...%-1.5,...
            'lvf',0,...
            'dvf',0,...
            'hvf',0,...
            'Gammavf',0,...
            'llHTP',0,...
            'dlHTP',0,...
            'hlHTP',0,...
            'GammalHTP',0,...
            'lrHTP',0,...
            'drHTP',0,...
            'hrHTP',0,...
            'GammarHTP',0 ...
            );
        
inertia = struct(...
          'class','inertia',...
          'id',label,...
          'W',4500*atmosphere.g,...
          'Ix',2700,...
          'Iy',14000,...
          'Iz',12000,...
          'Ixy',0,...
          'Ixz',2000,...
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
