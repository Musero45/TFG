function PFCNanotester(mode)

% trim tests

testList  = {...
             @AxialDerivativesTest, ...
             @airfoilTestppt, ...
             %@fuselageDerivativesTest, ...
             %@gravityCenterTest, ...
             %@gravityCenterTestppt, ...
             %@kbetaStabTest, ...
            };

runTestList(testList,mode);

