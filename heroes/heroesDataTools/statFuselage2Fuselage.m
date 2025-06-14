function Fuselage = statFuselage2Fuselage (stathelicopter,options)
% This function transforms the statiscal fuselage data coming from the
% statistical helicopter into the required fuselage data for rigid fuselage


options  = parseOptions(options,@statFuselage2FuselageOptions);

model    = options.model;
kf       = options.kf;

% Definitions
% Set the id of the fuselage
label = stathelicopter.id;

% Set the characteristic longitudinal length of fuselage
% Calculated by Rand statistical method.
lf    = stathelicopter.Dimensions.fuselageLength; 

% Set the characteristic width of the fuselage
% Calculated by Rand statistical method.
wf    = stathelicopter.Dimensions.widthOverLandingGear;

% Set the characteristic height of the fuselage
% Calculated by Rand statistical method.
hf    = stathelicopter.Dimensions.heightRotorHead;

% Set the characteristic lateral fuselage surface [m^2]
% Approximately width*Fuselage_length
Sp    = lf*wf; 

% Set the characteristic frontal fuselage surface [m^2]
% Approximately height*Fuselage_length.
Ss    = lf*hf;

Fuselage = struct(...
            'class','fuselage',...
            'id',label,...
            'active','yes',...
            'model',model,...@PadBo105Fus,...
            'lf',lf,... 
            'Sp',Sp,...  
            'Ss',Ss,... 
            'kf',kf ...  
            );



function options = statFuselage2FuselageOptions


options = struct(...
          'model',@generalFus,...
          'kf',1 ...
);
