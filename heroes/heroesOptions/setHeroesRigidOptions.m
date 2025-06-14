function options = setHeroesRigidOptions
%  SETHEROESRIGIDOPTIONS Defines the default options of HEROES trim, flight
%  mechanics and estability problems
%     
%  OPTIONS = SETHEROESRIGIDOPTIONS returns the default options
%  structure of RIGIDHEROES, OPTIONS. The default structure is:
%
%           linearInflow: @wakeEqs
%     uniformInflowModel: @Cuerva
%     armonicInflowModel: @Coleman
%               mrForces: @thrustF
%               trForces: @thrustF
%              mrMoments: @elasticM
%              trMoments: @aerodynamicM
%                fInterf: @noneInterf
%               trInterf: @noneInterf
%               vfInterf: @noneInterf
%             lHTPInterf: @noneInterf
%             rHTPInterf: @noneInterf
%                     GT: 1
%             inertialFM: 1
%      aeromechanicModel: @aeromechanicsLin
%              [+options: setHeroesOptions]
%
%   See also setHeoresOptions and setHeroesPlotOptions
% 
%  linearInflow - model used to calculate the rotor inflow [  {@wakeEqs} |
%             @LMTCuerva | @LMTGlauert ]
%     This function handle determines the model used to compute
%     the induced velocity field.
%
%  uniformInflowModel - model used to calculate the uniform inflow (wake) [  {@Cuerva} |
%             @Rand | @Glauert ]
%     This function handle specifies the model used to compute
%     the uniform induced velocity if the wake way is selected. This option
%     does not have any effect if the induced velocity is calculed by using 
%     the Momentum Theory.
%  
%  armonicInflowModel - model used to calculate the lambda1C and lambda1S inflow (wake) [ {@none} | @Coleman |
%             @Drees | @Payne | @White | @Pitt | @Howlett]
%     This function handle specifies the model used to compute the armonic part of
%     the induced velocity field if the rigid wake is considered. This option does not have any effect if
%     the induced velocity is calculed by using the Momentum Theory.
%
%  rotorForcesComputation - assumption to calculate aerodynamic forces in 
%     of a rotor. [ {@completeF} | {@thrustF}.%
%
%  rotorMomentsComputation - assumption to calculate simplifyed yA1 momentum [ {'aerodynamic'} | 'elastic' ]
%     This string controls if the kbeta*beta simplification is active. 
% 
%  fInterf - model used to estimate the inflow interference factor [ @noneInterf | @unitInterf| @stepInterf | {@linearInterf}] 
%     This function handle specifies the model used to compute the amount
%     of induced velocity which modifies the fuselage velocities.
% 
%  trInterf - model used to estimate the inflow interference factor [ @noneInterf | @unitInterf| @stepInterf | {@linearInterf}] 
%     This function handle specifies the model used to compute the amount
%     of induced velocity which modifies the tail rotor velocities.
% 
%  vfInterf - model used to estimate the inflow interference factor [ @noneInterf | @unitInterf| @stepInterf | {@linearInterf}] 
%     This function handle specifies the model used to compute the amount
%     of induced velocity which modifies the vertical fin velocities.
% 
%  lHTPInterf - model used to estimate the inflow interference factor [ @noneInterf | @unitInterf| @stepInterf | {@linearInterf}] 
%     This function handle specifies the model used to compute the amount
%     of induced velocity which modifies the lefthorizontal tail velocities.
% 
%  rHTPInterf - model used to estimate the inflow interference factor [ @noneInterf | @unitInterf| @stepInterf | {@linearInterf}] 
%     This function handle specifies the model used to compute the amount
%     of induced velocity which modifies the right horizontal tail velocities.
%
%  engineState - function handle defining the operation of the engine. [
%  {@EngineOn} | @EngineOffTransmissionOn |  @mainShaftBroken ]. engineState = @EngineOn represents the normal operation of the engine (constant rpm
%  equal to the rated value. engineState = @EngineOffTransmissionOn
%  represents an autorotation state where the engine is off but the
%  trasmission is operating. engineState = @mainShaftBroken represents the
%  fligth condition when the main rotor shaft is broken and no net power
%  is being consumed at the main rotor
%
% TODO: The following fields are not documented. These fields should be
% described in this help
% GT:
% inertialFM
%
%  aeromechanicModel - model used to describe rotor aeromechanics [ {@aeromechanicsLin}  | @aeromechanicsNL] 
%     This function handle specifies the model used to compute the amount
%     of induced velocity which modifies the right horizontal tail velocities.

% These are the options set by default
options  = setHeroesOptions;

% Adding other fields
options.linearInflow        = @wakeEqs; % @wakeEqs | @LMTGlauert | @LMTCuerva
options.uniformInflowModel  = @Cuerva; % @Cuerva | @Rand | @Glauert
options.armonicInflowModel  = @Coleman; % @none | @Coleman | @Drees | @Payne | @White | @Pitt | @Howlett
options.mrForces            = @thrustF; % @completeF | @thrustF
options.trForces            = @thrustF; % @completeF | @thrustF
options.mrMoments           = @elasticM; % @elasticM | @aerodynamicM
options.trMoments           = @aerodynamicM; % @elasticM | @aerodynamicM
options.fInterf             = @noneInterf; % @noneInterf | @unitInterf | @stepInterf | @linearInterf
options.trInterf            = @noneInterf; % @noneInterf | @unitInterf | @stepInterf | @linearInterf
options.vfInterf            = @noneInterf; % @noneInterf | @unitInterf | @stepInterf | @linearInterf
options.lHTPInterf          = @noneInterf; % @noneInterf | @unitInterf | @stepInterf | @linearInterf
options.rHTPInterf          = @noneInterf; % @noneInterf | @unitInterf | @stepInterf | @linearInterf
options.GT                  = 1; % 1 | 0
options.inertialFM          = 1;
options.aeromechanicModel   = @aeromechanicsLin; % @aeromechanicsLin  | @aeromechanicsNL
options.engineState         = @EngineOn; % @EngineOn | @EngineOffTransmissionOn | @mainShaftBroken
options.IniTrimCon          = [];%UserSuplied

end
