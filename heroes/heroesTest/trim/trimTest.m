function io = trimTest(mode)

close all

% default optiosns are set
options = setHeroesRigidOptions;

%engineState
%options.engineState = @mainShaftBroken;

% uniformInflowModel options are updated with
% @Cuerva model for induced velocity
options.uniformInflowModel = @Cuerva;
options.armonicInflowModel = @none;

% engineState options are updated for the 
%options.engineState = @EngineOffTransmissionOn;

% mrForces options are updated for 
%options.mrForces = @completeF;
options.mrForces =@thrustF;

% trForces options are updated
options.trForces = @completeF;


% atmosphere variables needed
atm     = getISA;

% helicopter model selection
he      = rigidCanonical(atm);

% helicopter 2 non-dimensional helicopter
H       = 0;
ndHe    = rigidHe2ndHe(he,atm,H);

% wind velocity in ground reference system
muWT = [0; 0; 0];

tic

FC = {'VOR',linspace(0.05,0.35,10),...
      'betaf0',[0 5*pi/180],...
      'wTOR',0,...
      'cs',0,...
      'vTOR',0};

ndTrimState = getNdHeTrimState(ndHe,muWT,FC,options);


toc

axds           = getaxds({'VOR'},{'VOR [-]'},1);
ayds           = getaxds('betaf0','betaf0 [o]',180/pi);

axATa          = plotNdTrimSolution(ndTrimState.solution,...
                 axds,ayds,'defaultVars','yes',...
                 'plot3dMode','parametric');               

% FIXME: check the plot3dMethod option
% axATa          = plotNdTrimSolution(ndTrimState.solution,axds,ayds,'defaultVars','yes',...
%                  'plot3dMethod',@contour);               

ts             = ndHeTrimState2HeTrimState(ndTrimState,he,atm,H,options);

io             = 1;

end