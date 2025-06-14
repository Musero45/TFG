function io = test_flightEnvelopeEngine(mode)
% This test differs from test_checkFlightEnvelope i
close all

% Get ISA atmosphere
atm        = getISA;


% Define engine variable vector
numEngines = [1,2];
nEngine    = length(numEngines);
mark       = {'r-','b-','r--','b--'};
for i = 1:nEngine
    mycase = strcat('cesar',num2str(numEngines(i)));
    he = selectTestingEhe(mycase,atm);

    % Define longitudinal flight path angle
    gammaT  = 0;
    fc      = getFlightCondition(he);
    [v1,h1] = getFlightEnvelope(he,fc,atm);
    [v2,h2] = getFlightEnvelope(he,fc,atm,'constrainedEnginePower','no');

    figure(1)
    plot(v1*3.6,h1,mark{2*(i-1) + 1}); hold on;
    plot(v2*3.6,h2,mark{2*(i-1) + 2}); hold on;


end


xlabel('V [Km]'); ylabel('h [m]')



io = 1;
