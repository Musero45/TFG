function energytester(mode)

% energy method tests

testList  = {...
             @test_flightEnvelope, ...
             @test_checkFlightEnvelope, ...
             @test_flightEnvelopeEngine, ...
             @test_hoverCeiling, ...
             @energy01, ...
             @energy02, ...
             @test_autorotationCurve,...
             @test_poweredStates,...
             @test_plotNdPowerState ...
            };

runTestList(testList,mode);

% for i=1:length(test),
%     io = test{i}();
%     runCheckTest(io,func2str(test{i}));
%     close all
% end
