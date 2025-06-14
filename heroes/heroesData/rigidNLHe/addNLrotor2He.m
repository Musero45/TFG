function heNA = addNLrotor2He(he,nAsetUp)


heNA = he;

%-------------------------------------------------------------------------
% main rotor parameters from analytic definition
%-------------------------------------------------------------------------

e      = he.mainRotor.e;
R      = he.mainRotor.R;
c0     = he.mainRotor.c0;
c1     = he.mainRotor.c1;
theta1 = he.mainRotor.theta1;


psimr1D       = nAsetUp.psimr1D;
lmrcell       = nAsetUp.lmrRegions;
airfoilmrcell = nAsetUp.airfoilmr;

psi2Dall    = [];
r2Dall      = [];
c2Dall      = [];
thetaG2Dall = [];

for nli = 1:length(lmrcell);
    
    r      = e+(R-e)*lmrcell{nli};
    c      = c0+(c1/R)*r;
    thetaG = (theta1/R)*r;
    
    [psimr2D{nli},rmr2D{nli}] = ndgrid(psimr1D,r);
    cmr2D{nli}                = repmat(c,length(psimr1D),1);
    thetaGmr2D{nli}           = repmat(thetaG,length(psimr1D),1);
    
    profile                   = airfoilmrcell{nli};
    airfoilmr{nli}            = profile();
    
    psi2Dall    = [psi2Dall psimr2D{nli}];
    r2Dall      = [r2Dall rmr2D{nli}];
    c2Dall      = [c2Dall cmr2D{nli}];
    thetaG2Dall = [thetaG2Dall thetaGmr2D{nli}];

end
    
    nlRotor = struct('r2D',{rmr2D},'psi2D',{psimr2D},...
                     'c2D',{cmr2D},'thetaG2D',{thetaGmr2D},...
                     'airfoil',{airfoilmr},...
                     'r2Dall',{r2Dall},'psi2Dall',{psi2Dall},...
                     'c2Dall',{c2Dall},'thetaG2Dall',{thetaG2Dall});
                     
    heNA.mainRotor.('nlRotor') =  nlRotor;  

 
    
%-------------------------------------------------------------------------
% tail rotor parameters from analytic definition
%-------------------------------------------------------------------------

e      = he.tailRotor.e;
R      = he.tailRotor.R;
c0     = he.tailRotor.c0;
c1     = he.tailRotor.c1;
theta1 = he.mainRotor.theta1;


psitr1D       = nAsetUp.psitr1D;
ltrcell       = nAsetUp.ltrRegions;
airfoiltrcell = nAsetUp.airfoiltr;

psi2Dall    = [];
r2Dall      = [];
c2Dall      = [];
thetaG2Dall = [];


for nli = 1:length(ltrcell);
    
    r      = e+(R-e)*ltrcell{nli};
    c      = c0+(c1/R)*r;
    thetaG = (theta1/R)*r;
    
    [psitr2D{nli},rtr2D{nli}] = ndgrid(psitr1D,r);
    ctr2D{nli}              = repmat(c,length(psitr1D),1);
    thetaGtr2D{nli}         = repmat(thetaG,length(psitr1D),1);
    
    profile                 = airfoiltrcell{nli};
    airfoiltr{nli}          = profile();
    
    psi2Dall    = [psi2Dall psitr2D{nli}];
    r2Dall      = [r2Dall rtr2D{nli}];
    c2Dall      = [c2Dall ctr2D{nli}];
    thetaG2Dall = [thetaG2Dall thetaGtr2D{nli}];


end
    
    nlRotor = struct('r2D',{rtr2D},'psi2D',{psitr2D},...
                     'c2D',{ctr2D},'thetaG2D',{thetaGtr2D},...
                     'airfoil',{airfoiltr},...
                     'r2Dall',{r2Dall},'psi2Dall',{psi2Dall},...
                     'c2Dall',{c2Dall},'thetaG2Dall',{thetaG2Dall});
                     
    heNA.tailRotor.('nlRotor') =  nlRotor;  

end

