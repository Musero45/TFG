function dimensioningtester(mode)

% energy method tests

testList  = {...
             @dimensioning01, ...
             @dimensioning02, ...
             @dimensioning03, ...
             @dimensioning04, ...
             @dimensioning05, ...
             @dimensioning06, ...
             @dimensioning07 ...
            };

runTestList(testList,mode);

% for i=1:length(test),
%     io = test{i}();
%     runCheckTest(io,func2str(test{i}));
%     close all
% end
