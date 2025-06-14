function he = rigidEC135(atmosphere)
%RIGIDEC135  Builds up a rigid Eurocopter EC-135 helicopter
%
% Most of the information written down here comes from [7].
%
% History
%
% To substitute the BO105 after 20 years in duty, the BO108 was developed 
% and flown for the first time on Oct. 15th, 1988. In late 1992, the design 
% was modified to provide accommodation for more passengers and cargo, 
% also an Aerospatiale developed Fenestron Anti Torque system was adapted.
% The EC 135 - as it looks today - took shape and certification by the 
% German (LBA) and the American Airworthiness Authorities (FAA) was 
% completed 1996.
%
% General description
%
% The EC 135 is approved in the Small Rotorcraft Airworthiness Category, 
% under JAR 27 first issue ? 06 September 1993, JAR 27 Appendix C for 
% Category A Operation, and JAR 27 Appendix B for operation under IFR. 
%
% The Eurocopter (now Airbus Helicopters) EC135 is a twin-engine civil 
% helicopter produced by Eurocopter, widely used amongst police and ambulance 
% services and for executive transport. It is capable of flight under 
% instrument flight rules (IFR) and is outfitted with digital flight 
% controls. It entered service in 1996; over a thousand aircraft have been 
% produced to date, see [1] for further information.
%
% 
% Main Rotor Blades
% 
% The main rotor blades are manufactured with fiber composite materials. 
% A blade root (Flex Beam) with low bending and torsion stiffness enables the
% same functions like flap- and lead-lag hinges as well as the function of
% blade pitch bearings.
% 
% A pitch control cuff around the flex beam is integrated in the blade 
% structure to provide a rigid connection with the airfoil section of the 
% blade. The pitch angle of the main rotor blade is changed through a 
% pitch horn on the pitch control cuff. The pitch control cuff is kept 
% centred around the blade root by a bearing support and a spherical bearing.
% 
% Two elastomeric lead-lag dampers provide sufficient in-plane damping of 
% the main rotor blade to prevent ground and air resonance. 
% 
% The airfoil section has a rectangular blade geometry with a parabolic 
% swept-back tip and a negative 2^o twist per meter. 
%
% EC135 rotor blade airfoil at the root is DFVLR DM-H3 and at the tip DFVLR DM-H4, 
% see [3] and [4]. This airfoil corresponds to the third generation of
% advanced rotor blade airfoils, look for [5] because it is likely to found
% there the aerodynamic data, but a comparison of aerodynamic properties
% with other airfoils can be found at [6].
%
% The blade airfoil consists of:
% - a homogenous section comprising the DM--H4 airfoil up to R = 4500 mm
% - a transition area between R = 4500 and R = 4800 mm with DM--H4 and 
% DM--H3 airfoil 
% - the blade tip between R = 4800 and R = 5100 mm comprising the DM--H3 
% airfoil. 
% 
% Each blade is equipped with a blade tip mass, static discharger, 
% trim tabs and balance washers.The blades are protected against leading 
% edge erosion and lightning. 
% 
%
% References
%
% [1] http://es.wikipedia.org/wiki/Eurocopter_EC135
% [2] Eurocopter EC135 Technical Data (135.05.101.01E)
% [3] Brocklehurst and Barakos, A review of helicopter rotor blade tip 
%     shapes, Progress in Aerospace Sciences, (56) 35-74, 2013.
% [4] http://aerospace.illinois.edu/m-selig/ads/aircraft.html
% [5] Polz G., Schimke D. New aerodynamic rotor blade design at MBB,
%     Paper No 2.19, 13th European Rotorcraft Forum, 1987.
% [6] Wojcieh, K. and Wienczyslaw, S. Development of new generation main 
%     and tail rotors blade airfoils, ICAS 2000 Congress
% [7] EASA European Aviation Safety Agency, Eurocopter Family. Operational
%     Evaluation Board Report. 2012
% [8] Kampa, K, Enenkl, B, Polz, G, Roth, G, Aeromechanic aspects in the 
%     design of the EC135, JOURNAL OF THE AMERICAN HELICOPTER SOCIETY, 
%     44:(2), 83-93, 1999, 23rd European Rotorcraft Forum, Dresden, Germany
%
%
%
% ACRONYMS
%   TBD     To Be Defined
%
% TODO
%
%

% Degrees to radians factor conversion
d2r   = pi/180;

% Helicopter label definition
label = 'rigidEC135';


% Radius, drawing at page 23 of [7]
radius = 5.1;

% Twist, page 13 of [7]
twist  = -2*d2r*radius;

% Tip speed, page 84 of [8]
OR     = 211;
Omega  = OR/radius;

% Chord, page 84 of [8]
chord  = 0.288;

% main rotor structure definition
mainRotor = struct(...
            'class','rigidRotor',...
            'id',label,...
            'active','yes',...
            'R',radius,... 
            'e',[],...% FIXME
            'b',4,...% page 84 of [8]
            'theta1',twist,...
            'cldata',[],...% FIXME
            'cddata',[],... % FIXME
            'profile',[],...% FIXME
            'Omega',Omega,...
            'c0',chord,... 
            'c1',0,...  
            'IBeta',[],...% FIXME
            'ITheta',[],...% FIXME
            'IZeta',[],...% FIXME
            'xGB',[],...% FIXME
            'bm',[],...% FIXME
            'kBeta',[],... % FIXME
            'k',[] ...% FIXME
            );

% tail rotor structure definition
% Tail rotor (TR) radius, drawing at page 23 of [7]
radius_tr = 1.0;

% TR tip speed, page 84 of [8]
OR_tr     = 188;
Omega_tr  = OR_tr/radius_tr;

% TR number of blades, page 84 of [8]
b_tr      = 10;

% TR chord, page 84 of [8]
chord_tr  = 0.05;

tailRotor = struct(...
            'class','fenestron',...% FIXME TBD
            'id',label,...
            'active','yes',...
            'R',radius_tr,...
            'b',b_tr,...
            'e',[],... % FIXME
            'theta1',[],... % FIXME
            'cldata',[],... % FIXME
            'cddata',[],... % FIXME
            'profile',[],... % FIXME
            'Omega',Omega_tr,... 
            'c0',chord_tr, ... 
            'c1',0, ...  
            'kBeta',[],...  % FIXME
            'k',[] ... % FIXME
            );


alpha_tp0
tailRotor = massBlade_mr2inertiaBlade_tr(mainRotor,tailRotor);

% fuselage structure definition
fuselage = struct(...
            'class','fuselage',...
            'id',label,...
            'active','yes',...
            'model',@generalFus,...
            'lf',[],...% FIXME
            'Sp',[],...% FIXME
            'Ss',[],...% FIXME
            'kf',[]...% FIXME
            );
        
% vertical fin structure definition
% tip chord c_t = 0.98 m
% root chord c_r = 1.19 (wing taper ratio \lambda = c_t /c_r = 0.82)
% semi span b/2 = 0.9 m
% sweep angle \Lambda = 34 degrees
%
% Using the aerodynamic definitions of a trapezoidal sweep wing the
% following data has been computed:
% equivalent chord c=1.088 m
% wing surface S = 1.953 m^2
verticalFin = struct(...
            'class','stabilizer',...
            'id',label,...
            'active','yes',...
            'airfoil',@naca0012,... % FIXME
            'type',@get2DStabilizerActions,... % FIXME
            'c',1.088,...% From computing and measuring of drawing at page 23 of [7]
            'S',1.953,...% From computing and measuring of drawing at page 23 of [7]
            'theta',0,...% Drawing at page 23 of [7]
            'ks',1 ...
            );
        
% horizontal tail definition
% left (pilot's left hand) tail plane
% From the drawings both left and right horizontal tail planes are
% rectangular wings.
% The horizontal tail plane is equipped with inverted NASA GA(W)-1
% airfoils as stated in Kampa et. al. [8]. ?For example to minimize the 
% necessary horizontal stabilizer area, it is fitted with the inverted 
% NASA GA(W)-1 airfoil and additional Gurney flaps (Fig 21) to achieve 
% a high lift curve slope".
% NASA GA(W)-1 stands for General Aviation (Whitcomb) -number one airfoil 
% and was developed by NASA for light airplanes in the earlier 70's, 
% see NASA TN D-7428 for aerodynamic characteristics.
% Horizontal tail plane
c_HT   = 0.52;

% Wing span
b_HT   = 2.65;

% Semi-wing surface
S_HT   = c_HT*b_HT/2;

leftHTP = struct(...
            'class','stabilizer',...
            'id',label,...
            'active','yes',...
            'airfoil',@naca0012,... % FIXME
            'type',@get2DStabilizerActions,... % FIXME
            'c',c_HT,...% From computing and measuring of drawing at page 23 of [7]
            'S',S_HT,...% From computing and measuring of drawing at page 23 of [7]
            'theta',0,...% Drawing at page 23 of [7]
            'ks', 1 ...
            );

% right (pilot's right hand) tail plane
rightHTP = struct(...
            'class','stabilizer',...
            'id',label,...
            'active','yes',...
            'airfoil',@naca0012,... % FIXME
            'type',@get2DStabilizerActions,... % FIXME
            'c',c_HT,...% From computing and measuring of drawing at page 23 of [7]
            'S',S_HT,...% From computing and measuring of drawing at page 23 of [7]
            'theta',0,...% Drawing at page 23 of [7]
            'ks', 1 ...
            );
        
 % transmission        
 
transmission = struct(...
                'transmissionType',@standardTransmission,...
                'etaTmr',0.12,...
                'etaTtr',0.07 ...
             );
        
% geometry structure definition

geometry = struct(...
            'class','geometry',...
            'id',label,...
            'xcg',0,...% FIXME
            'ycg',0,...% FIXME
            'zcg',0,...% FIXME
            'epsilonx',0,...% Drawing at page 23 of [7]
            'epsilony',-5*d2r,... % Drawing at page 23 of [7]
            'ls',0,...% FIXME
            'ds',0,...% FIXME
            'h',0,...% FIXME
            'thetatr',0,...% Drawing at page 23 of [7]
            'ltr',9.17,...% From measuring of drawing at page 23 of [7]
            'dtr',0,...% From measuring of drawing at page 23 of [7]
            'htr',-0.56,...% From computing and measuring of drawing at page 23 of [7]
            'lvf',-9.2,...% From computing and measuring of drawing at page 23 of [7]
            'dvf',0.0,...% Drawing at page 23 of [7]
            'hvf',-0.43,...% From computing and measuring of drawing at page 23 of [7]
            'Gammavf',0.0,...% Drawing at page 23 of [7]
            'llHTP',-7.83,...% From computing and measuring of drawing at page 23 of [7]
            'dlHTP',-1.325,...% From computing and measuring of drawing at page 23 of [7]
            'hlHTP',-0.43, ...% From computing and measuring of drawing at page 23 of [7]
            'GammalHTP',0,...% From measuring of drawing at page 23 of [7]
            'lrHTP',-7.83,...% From computing and measuring of drawing at page 23 of [7]
            'drHTP',1.325,...% From computing and measuring of drawing at page 23 of [7]
            'hrHTP',-0.43,...% From computing and measuring of drawing at page 23 of [7]
            'GammarHTP',0 ...% From measuring of drawing at page 23 of [7]
            );
        
inertia = struct(...
          'class','inertia',...
          'id',label,...
          'W',4500*atmosphere.g,...%FIXME, current data from Bo105
          'Ix',2700,...%FIXME, current data from Bo105
          'Iy',14000,...%FIXME, current data from Bo105
          'Iz',12000,...%FIXME, current data from Bo105
          'Ixy',0,...%FIXME, current data from Bo105
          'Ixz',2000,...%FIXME, current data from Bo105
          'Iyz',0 ...%FIXME, current data from Bo105
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
