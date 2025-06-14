function stabilitytester(mode)

% stability tests
% TODO tests that do not work (oslo: March, 7th)
% * numjacTest doesn't work Attempt to reference field of non-structure 
% array. Error in helicopterTrim (line 116) CWrated = ndHe.inertia.CW;
% * Bo105DerivativesNumjacTest outdated
% * PumaDerivativesTest outdated
% * test_controlResponse outdated

testList  = {...
             @stabilityTest, ...
             @stability01, ...
             @stability02, ...
             @test_gravityCenter2stabilityMap,...
             @Bo105DerivativesTest ...
            };

runTestList(testList,mode);

% for i=1:length(test),
%     io = test{i}();
%     runCheckTest(io,func2str(test{i}));
%     close all
% end
