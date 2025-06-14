function options = setHeroesMissionOptions
%  SETHEROESOPTIONS Defines the default options of HEROES
%     
%  OPTIONS = SETHEROESOPTIONS returns the default options
%  structure of HEROES, OPTIONS. The default structure is:
%
%                        missionType: civilTimeSurvey
%                   reserveFuelModel: @percentMF
%
%  missionType -  [{civilTimeSurvey}|civilRangeSurvey|civilRangeTransport|
%                   civilMedical|civilSurveillance|civilFirefighting|
%                   milASWDippingSonar|milMEDEVAC|milRecon|milScort
%                   milTroopTransport|milCommand]
%  reserveFuelModel - @PercentMf | @VarandFixedRF



options  = struct(...
  'missionType','civilTimeSurvey',... % civilTimeSurvey|civilRangeSurvey|civilRangeTransport|civilMedical|civilSurveillance|civilFirefighting|milASWDippingSonar|milMEDEVAC|milRecon|milScort|milTroopTransport|milCommand
  'reserveFuelModel',@VarandFixedRF... % @percentMF | @VarandFixedRF    
           );