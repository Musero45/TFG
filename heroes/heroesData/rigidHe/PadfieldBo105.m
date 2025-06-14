function he = PadfieldBo105(atmosphere)

% This helicopter is a modification of rigidBo105 

he = rigidBo105(atmosphere);
        
% vertical fin modification
he.verticalFin.airfoil = @vfBo105Padf;
he.verticalFin.type    = @get1DStabilizerActions;

% left horizontal tail modification
he.leftHTP.airfoil     = @HTPBo105Padf;
he.leftHTP.type        = @get1DStabilizerActions;


% right horizontal tail modification
he.rightHTP.airfoil    = @HTPBo105Padf;
he.rightHTP.type       = @get1DStabilizerActions;


