function hedim = stathe2rigidhe (stathelicopter,atmosphere,cht,Svt,...
                                 varargin)


%--------------------------------------------------------------------------
% Definitions
label = stathelicopter.id;


% Try better because the next lines are quite hardcoded for this particular
% function and we have set the parseOptions mechanism to avoid this kind of
% of mechanism to set the options. The next lines should be avoided and a
% parseOption mechanism should be established.
if nargin == 4
   options = struct([]);
elseif nargin == 5
   options = varargin{1};
else
   error('Error in ==> stathe2rigidhe: incorrect number of input arguments')
end

%--------------------------------------------------------------------------
% Transform statistical rotors to dimensional rotors
% Main Rotor
statMainRotor = stathelicopter.MainRotor;
optionsMr     = parseNestedOptions(options,'mainRotor');
MainRotor     = statRotor2Rotor (stathelicopter,statMainRotor,optionsMr);

% Tail Rotor
statTailRotor = stathelicopter.TailRotor;
optionsTr     = parseNestedOptions(options,'tailRotor');
TailRotor     = statRotor2Rotor (stathelicopter,statTailRotor,optionsTr);

%--------------------------------------------------------------------------
% Transform statistical fuselage to dimensional fuselage
optionsF      = parseNestedOptions(options,'fuselage');
Fuselage      = statFuselage2Fuselage (stathelicopter,optionsF);

%--------------------------------------------------------------------------
% Transform vertical estabilizer statistical rotors to dimensional rotors
% Vertical fin
% Vertical fin chord calculated by Rand statistical method.
cvt         = stathelicopter.Dimensions.cvt;

optionsVf     = parseNestedOptions(options,'verticalFin');
VerticalFin = statEstabilizer2Estabilizer(Svt,cvt,label,optionsVf);

%--------------------------------------------------------------------------
% Horizontal tail plane surface calculated by Rand statistical method.
Sht         = stathelicopter.Dimensions.Sht;

% Now, the left and right horizontal tail planes are supposed to be equal
% and the surface of each tail plane is the half of the total one
% calculated by Rand statistical method. 
% FIXME: IKER it is not clear to me if the Sht provided by Rand takes into
% account only one estabilizer or two. From figure 3 it seems to me that it
% represents the surface of only the left estabilizer
Sht2        = Sht/2;

% Left horizontal tail plane
optionsLHTP   = parseNestedOptions(options,'leftHTP');
LeftHTP       = statEstabilizer2Estabilizer(Sht2,cht,label,optionsLHTP);

% Right horizontal tail plane
optionsRHTP   = parseNestedOptions(options,'rightHTP');
RightHTP      = statEstabilizer2Estabilizer(Sht2,cht,label,optionsRHTP);

%--------------------------------------------------------------------------
% Transform statistical geometry to dimensional geometry
optionsGeom   = parseNestedOptions(options,'geometry');
Geometry      = statGeometry2Geometry(stathelicopter,Svt,cht,label,optionsGeom);

%--------------------------------------------------------------------------
% Inertia transformation does not require an option cell
W  = stathelicopter.Weights.MTOW;
FW = stathelicopter.Weights.fuelValue;
statInertiaTensor = stathelicopter.inertiaMoments;

Inertia = struct(...
          'class','inertia',...
          'id',label,...
          'W',W,... 
          'FW',FW,...
          'Ix',statInertiaTensor.Ix,...  
          'Iy',statInertiaTensor.Iy,...  
          'Iz',statInertiaTensor.Iz,...  
          'Ixy',statInertiaTensor.Ixy,...  
          'Ixz',statInertiaTensor.Ixz,...
          'Iyz',statInertiaTensor.Iyz ...  
          );

%--------------------------------------------------------------------------      
% Weights included in inertia. They don't require an option cell
Inertia.MTOW = stathelicopter.Weights.MTOW;
Inertia.OEW  = stathelicopter.Weights.emptyWeight;
Inertia.MPL  = stathelicopter.Weights.Wpl;
Inertia.MFW  = stathelicopter.Weights.fuelValue;
Inertia.usefulLoad  = stathelicopter.Weights.usefulLoad;
Inertia.Wcrew  = stathelicopter.Weights.Wcrew;
Inertia.Vf  = stathelicopter.Weights.Vf;
Inertia.DL  = stathelicopter.Weights.discLoading;

%--------------------------------------------------------------------------      
% Engine field directly taken from stat helicopter.
Engine = stathelicopter.Engine;

%--------------------------------------------------------------------------      
% Dimensioning performances field directly taken from stat helicopter.
dimPerformances = stathelicopter.Performances;

%--------------------------------------------------------------------------      
% Energy estimations field directly taken from stat helicopter.
eneEstimations = stathelicopter.energyEstimations;

%--------------------------------------------------------------------------      
% Transmission estimations struct.
Transmission = struct(...
    'transmissionType',eneEstimations.transmissionType,...
    'etaTmr',eneEstimations.etaTrp,...
    'etaTtr',eneEstimations.etaTra...
 );

hedim  = struct(...
      'class','rigidHe', ...
      'id',label,...
      'mainRotor',MainRotor,...
      'tailRotor',TailRotor,...
      'fuselage',Fuselage,...
      'verticalFin',VerticalFin,...
      'leftHTP',LeftHTP,...
      'rightHTP',RightHTP,...
      'geometry',Geometry,...
      'transmission',Transmission,...
      'inertia',Inertia,...
      'engine',Engine,...
      'dimensioningPerformances',dimPerformances,...
      'energyEstimations',eneEstimations...
);


% atmosphere seems not very clear that it is convenient to be input FIXME
hedim      = addCharacteristic2he(hedim,atmosphere);



function optionsOut = parseNestedOptions(options,fieldname)

if isfield(options,fieldname)
   if isempty(options.(fieldname))
      optionsOut    = options.(fieldname);
   else
      optionsOut     = {options.(fieldname)};
   end
else
   optionsOut     = [];
end
