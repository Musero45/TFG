function missiontester(mode)

% mission tests

testList  = {...
             @mission01,...
             @test_PLRdiagram...
            };

runTestList(testList,mode);

% for i=1:length(test),
%     io = test{i}();
%     runCheckTest(io,func2str(test{i}));
%     close all
% end
