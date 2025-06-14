%   Available energy method performance functions
%
%   Performance computation:
%     getEndurance         - Computes the endurance of an helicopter for a 
%                            given fuel mass.
%     getRange             - Computes the range of an helicopter for a given
%                            fuel mass.
%     ceilingHoverEnergy   - Computes the ceiling of a hovering helicopter.
%     ceilingEnergy        - Computes the ceiling of an helicopter.
%     getFlightEnvelope    - Computes the flight envelope of an helicopter.
%     vGivenPower          - Computes the horizontal forward speed for a  
%                            given rotor available power.
%     vMaxRange            - Computes the horizontal forward velocity which 
%                            maximizes the helicopter range.
%     vMaxEndurance        - Computes the horizontal forward velocity which 
%                            maximizes the helicopter endurance 
%     vV4vHpower           - Computes the vertical velocity for given 
%                            horizontal forward velocity and available power
%     vH4maxVv             - Computes the horizontal forward velocity which 
%                            maximizes the vertical velocity for a given 
%                            available power
%
%   Available "In Ground Effect" IGE models:
%
%     kGoge                - kG parameter for Out of Ground Effect (OGE)
%     kGlefortHamann       - kG parameter according to Lefort & Hamann
%     kGknightHefner       - kG parameter according to Knight & Hefner
%     kGcheesemanBennet    - kG parameter according to Cheeseman & Bennet
%
%
%   Available plot functions related to power state classes
%   
%     plotNdPowerState     - Plots a nondimensional power state
%     plotPowerState       - Plots a dimensional power state
%
%
%   Basic performance computation:
%     getNdEpowerState     - Gets a nondimensional engine-on power state of 
%                            an helicopter
%     getNdApowerState     - Gets a nondimensional engine-off power state of 
%                            an helicopter
%     getEpowerState       - Gets the dimensional energy power state of 
%                            an helicopter (TO BE RENAMED TO getPowerState)
%
%     ndEpowerState2dim    - TO BE DOCUMENTED
%
%
% LIST OF ACTIONS TO BE DONE
% --------------------------
% [works=y/n ; help=y/n ; comment={TBR/TBDoc/TBD/TBF} ]
% TBR: To Be Removed
% TBDoc: To Be Documented
% TBD: To Be Done
% TBF: To Be Fixed (indicates that some error in the computations appear)
% NTD: Nothing To Do
%
%
% V2gammaTautorrotation.m [comment=REMOVED no instances found of using this function]
% angleOfAttack4autorotation.m [works=y ; help=y ; comment=TBDoc]
% ceilingEnergy.m [works=y ; help=y ; comment=NTD]
% ceilingHoverEnergy.m [works=y ; help=y ; comment=NTD]
% energyEquations.m [works=y ; help=n ; comment=TBDoc]
% energyTermsCalculation.m [works=y ; help=n ; comment=TBDoc]
% gammaT2Vautorrotation.m [works=y ; help=n ; comment=TBDoc]
% gammaT2autorrotation.m [works=y ; help=n ; comment=TBDoc]
% gammaTminGammaT.m [works=y ; help=n ; comment=TBDoc]
% gammaTminV.m [works=y ; help=n ; comment=TBDoc]
% gammaTminVv.m [works=y ; help=n ; comment=TBDoc]
% getEndurance.m [works=y ; help=y ; comment=NTD]
% getEpowerState.m [works=y ; help=y ; comment=NTD]
% getExcessPower.m [works=? ; help=n ; comment=TBDoc]
% getFlightEnvelope.m [works=y ; help=y ; comment=NTD]
% getNdApowerState.m [works=y ; help=y ; comment=NTD]
% getNdEpowerState.m [works=y ; help=y ; comment=NTD]
% getP.m [works=? ; help=? ; comment=?]
% getRange.m [works=y ; help=y ; comment=NTD]
% kGcheesemanBennet.m [works=y ; help=y ; comment=TBDoc]
% kGknightHefner.m [works=y ; help=y ; comment=TBDoc]
% kGlefortHamann.m [works=y ; help=y ; comment=TBDoc]
% kGoge.m [works=y ; help=y ; comment=TBDoc]
% theta2axialAutorotation.m [works=? ; help=? ; comment=?]
% vGivenPower.m [works=y ; help=y ; comment=NTD]
% vH4maxVv [works=y ; help=y ; comment=TBDoc]
% vMaxEndurance.m [works=y ; help=y ; comment=NTD]
% vMaxMaxROC.m [comment=REMOVED ; deprecated and superseded by vH4maxVv]
% vMaxROC.m [comment=REMOVED ; deprecated and superseded by vV4vHpower]
% vMaxRange.m [works=y ; help=y ; comment=NTD]
% vV4vHpower.m [works=y ; help=n ; comment=TBDoc]
% vH4vVpower.m [works=y ; help=n ; comment=TBDoc]
% 
%
%
%