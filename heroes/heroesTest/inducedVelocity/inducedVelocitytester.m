function inducedVelocitytester(mode)

% induced velocity tests
% TODO tests that do not work (oslo: March, 7th)
% inflowTest doesn't work Error using wakeEqs Too many input arguments 

 
testList  = {...
             @localMTTest...
             %@inflowTest, ...
             %@inflowFrameTest  ...
            };

runTestList(testList,mode);

% for i=1:length(test),
%     io = test{i}();
%     runCheckTest(io,func2str(test{i}));
%     close all
% end
