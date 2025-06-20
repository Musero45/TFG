function ndRotASol = getNdRotorAeromechSolution(ndRotor,theta,fC,GA,muWA,options,ndRotAIniCon)       

nlSolver            = options.nlSolver;
aeromechanicsSystem = options.aeromechanicModel;
system2solve = @(x)aeromechanicsSystem(x,theta,fC,...
                                    GA,muWA,ndRotor,...
                                    options);

[x,~,flag,OUTPUT] = nlSolver(system2solve,ndRotAIniCon,options);

beta0      = x(1);
beta1C     = x(2);
beta1S     = x(3);
lambda0    = x(4);
lambda1C   = x(5);
lambda1S   = x(6);
CT0        = x(7);
CT1C       = x(8);
CT1S       = x(9);

                    
ndRotASol  = struct('theta',theta,...
                    'fC',fC,...
                    'muWA',muWA,...
                    'GA',GA,...
                    'CT0',CT0,...
                    'CT1C',CT1C,...
                    'CT1S',CT1S,...
                    'beta0',beta0,...
                    'beta1C',beta1C,...
                    'beta1S',beta1S,...
                    'lambda0',lambda0,...
                    'lambda1C',lambda1C,...
                    'lambda1S',lambda1S,...
                    'flag',flag);
           
 end
