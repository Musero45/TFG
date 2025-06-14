function Mfburnt = missionFuelMassConsumed(missState)
% missionMassFuelConsumed calculates the fuel mass consumed during the
% mission for gven mission state.
%
% The output of this function is Mfburnt:
%
%       Mfburnt: [1x1 double] fuel mass consumed during the mission [Kg]
%

for m = 1:length(missState.mSeg);
    
DMf(m) = missState.mSeg{m}.DMf;
    
end

Mfburnt = -sum(DMf);
