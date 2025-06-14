function options = setHeroesEnergyOptions
%  SETHEROESOPTIONS Defines the default options of HEROES
%     
%  OPTIONS = SETHEROESOPTIONS returns the default options
%  structure of HEROES, OPTIONS. The default structure is:
% 
%                        igeModel: @kGoge
%                     excessPower: 'no'
%      forwardFlightApproximation: 'none'
%     fuselageVelocityCalculation: 'none'
%          constrainedEnginePower: 'yes'
%                  powerEngineMap: 'mc'
%                          hGuess: [0 12000]
%                          vGuess: 600
%                    tailrotor2cp: 'eta'
%                 inducedVelocity: @Glauert
%                 externalPLinPLR:'yes'
%
%  igeModel - IGE function [ {@kGoge} | @kGlefortHamann |  @kGknightHefner|
%             @kGcheesemanBennet]
%     This function handle specifies the function used to compute
%     the in ground effet
%
%  excessPower - assumption to control the excess power [ {'no'} | 'yes' ]
%     This string controls if the excess power assumption is used at the 
%     computation of climb velocity.
%
%  forwardFlightApproximation - Forward flight approximation [{'none'} |
%                               'highSpeed' | 'slowSpeed']
%
%  fuselageVelocityCalculation
%
%  tailrotor2cp - Tail rotor power model [{'eta'}]
%      This string especifies the way tail rotor power is computed. Only
%      the model which determines the tail rotor as a percentege of the 
%      power of the main rotor based on the transmission data of power
%      losses.
%
%  constrainedEnginePower -  engine power  [ 'no' | {'yes'} ]
%       This string sets the available power map used to compute power%       This string sets the engine power map used to compute power
%       dependent performances like ceiling, maximum forward velocity,
%       maximum rate of climb etc. For the moment being there is no
%       implementation of this option for range, endurance etc. The
%       following valid strings for powerEngineMap are interpreted as
%         'mc' stands for maximum continuum power
%         'de' stands for maximum take off power
%         'mu' stands for maximum urgency power
%
%       dependent performances (vMaxROC, vMaxMaxROC, ceilingHover, 
%       vGivenPower etc.). When constrainedEnginePower is set to 'no' 
%       it means that the available power is not constrained by
%       maximum transmission power. If constrainedEnginePower is set to
%       'yes' (default) it means that available power takes into account 
%       the limitation due maximum power transmission by defining a
%       piecewise function for the available power.
%
%  powerEngineMap - Engine power map [{'mc'} | 'de' | 'mu']
%       This string sets the engine power map used to compute power
%       dependent performances like ceiling, maximum forward velocity,
%       maximum rate of climb etc. For the moment being there is no
%       implementation of this option for range, endurance etc. The
%       following valid strings for powerEngineMap are interpreted as
%         'mc' stands for maximum continuum power
%         'de' stands for maximum take off power
%         'mu' stands for maximum urgency power
%
%  hFzero - altitude initial guess [{[0,12000]} | vector float number]
%
%  vFzero - forward speed initial guess [{600} | vector float number]
%
%  inducedVelocity - Induced Velocity Model used [ {@Cuerva}  |
%                                                  '@Glauert' | 
%                                                  '@Rand']
%  externalPLinPLR - Define if it's possible to calculate PLR diagram with
%       external load (no limit of MPL in the helicopter, only strauctural limit
%       by MTOW)





options  = struct(...
           'igeModel',@kGoge,... % kGoge | kGlefortHamann | @kGknightHefner| @kGcheesemanBennet 
           'excessPower','no', ... % 'yes' | 'no'
           'forwardFlightApproximation','none', ... % highSpeed | lowSpeed | none
           'fuselageVelocityCalculation','none',... % none | yes
           'constrainedEnginePower','yes', ... % 'yes' | 'no'
           'powerEngineMap','mc', ... % 'mc' | 'de' | 'mu' 
           'hFzero',[0,12000],...
           'vFzero',600,...
           'tailrotor2cp','eta', ... % float | bramwell | q2ct | no | eta
           'inducedVelocity',@Glauert,... % @Cuerva | @Glauert | @Rand
           'externalPLinPLR','yes'... % 'yes' | 'no'
       );
