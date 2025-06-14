function oectester(mode)

% qfd tests

testList  = {...
             @oec01 ...
            };

runTestList(testList,mode);

% for i=1:length(test),
%     io = test{i}();
%     runCheckTest(io,func2str(test{i}));
%     close all
% end
