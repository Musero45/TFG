function flightDynamicstester(mode)

% flightDynamic tests
testList  = {...
             @flightDynamics3DVisualizationTest,...
             @flightDynamicsTest, ...
             @polePlacementSASTest ...
            };

runTestList(testList,mode);
