% HELICOPTER MISSIONS
%
% Helicopter mission state and fuel mass optimization toolbox
%
% Segment Builders
%   <a href="matlab:help segmentBuilders">Segment Builders</a> >> help segmentBuilders
%
% Segments Solvers
%   <a href="matlab:help segmentSolvers">Segment Solvers</a> >> help segmentSolvers
%
%
% Mission solver:
%
%   missionIni                - Computes the initial hover segment 
%                               common to all missions.
%   getMissionState           - Computes the state of a helicopter 
%                               mission for a given initial fuel mass, 
%                               reserve of fuel, initial payload and 
%                               given mission segments, adding the 
%                               initial mission segment to them.
%   missionFuelMassConsumed   - Computes the fuel mass consumed during
%                               the mission with a given mission state.
%
%
% Mission optimization:
%
%   getOptimumFuelMass        - Computes the optimum fuel mass needed
%                               to complete the mission with final fuel
%                               mass equal to zero.