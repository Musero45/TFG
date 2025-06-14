function [randHe] = getRandHe(randDr,atm)
%Provides a statistical estimation of main helicopter characteristics from Rand's database  
% 
%[randHe] = getRandHe(randDr) provides a statistical estimation of main
%helicopter characteristics from Rand helicopter database [1], [2].
%
%
% References
%
% [1]. Rand, O and Khromov, V. Helicopter Sizing by Statistics. Journal of The American Helicopter Society}, 2002, (49), 300-317.
%
% [2]. Rand, O and Khromov, V. Helicopter Sizing by Statistics. Oral presentation (slides) at the American Helicopter Society 58th Annual
% Forum, Montreal, Canada, June 11-13, 2002.
% 
% The input randHe is a structure with fields
% 
%         'MTOW': [N].   Maximum Take Off Weight at sea level (FE)
%            'b': [-].   Number of blades of the main rotor (FE)
%          'btr': [-].   Number of blades of the tail rotor (FE)
%         'Crew': [-].   Number of Crew members (FE)
%        'Range': [m].   Range with standard fuel at sea level  [1] (DM)
%           'Vm': [m/s]. Maximum speed at sea level (DM)
%  
%   Being:
%
%    DM = Desired Mission
%    FE = First Estimation
%
% The output randHe is a structure with fields
%
%       mainRotor: [1x1 struct]
%       tailRotor: [1x1 struct]
%      dimensions: [1x1 struct]
%    performances: [1x1 struct]
%         weights: [1x1 struct]
%    ndParameters: [1x1 struct]
% 
% mainRotor and tailRotor are structures with fields:
%
%           D: [m]. Estimated diameter of the rotor.
%           R: [m]. Estimated radious of the rotor.
%           c: [m]. Estimated chord of the rotor blades.
%          Vt: [m/s]. Estimated tip speed of the rotor blades. 
%    OmegaRPM: [rpm]. Estimated rotational speed of the rotor. 
%    OmegaRAD: [rad/s]. Estimated rotational speed of the rotor.
%           b: [-]. Number of blades of the rotor.
%       sigma: [-]. Estimated local solidity of the rotor.
%
% dimensions is a structure with fields:
%
%    horizontalTailSurfaceArm: [m]. Distance A-Eh along x-axis.   
%                         Sht: [m^2]. Surface of the horizontal tail. 
%                tailRotorArm: [m]. Distance AAa along x-axis. 
%      verticalTailSurfaceArm: [m]. Distance AEv along x-axis.
%              fuselageLength: [m]. Length of the fuselage.
%       airframeOverallLength: [m]. Length from tip to tip of main and tail
%                                   rotors.
%             heightRotorHead: [m]. Distance of point A above ground.
%        widthOverLandingGear: [m]. Distance between landing gears in the y
%                                   axis.
%                         cvt: [m]. Clearance fuselage-ground.
%
% performances is a structure with fields:
%
%                       neverEsceedSpeed: [m/s]. Never exeed speed. [3].
%                 longRangeSpeedSeaLevel: [m]. Long range speed at sea level.
%            maximumContinuousTotalPower: [W]. Maximum Continuous Power
%                                              (Pmc) at sea level
%    maximumContinuousTransmissionRating: [W]. Maximum continuous transmission power (Pmt).
%                      TakeOffTotalPower: [W]. Maximum takeoff power (Pdesp) at sea
%                                              level.
%                           VmaxSeaLevel: [m/s]. Maximum speed at sea level.
%                                  Range: [m]. Maximum range at sea level.
%              TakeOffTransmissionRating: [W]. Maximum take-off transmission power (Pmt).
%
% weights is a structure with fields:
%
%       emptyWeight: [N].     Empty Weight
%        usefulLoad: [N].     Useful Load. (Pay Load + Fuel Weight + Crew
%                                           Weight)
%         fuelValue: [N].     Fuel Weight
%              MTOW: [N].     Maximum Take-Off Weigth
%             Wcrew: [N].     Crew Weight.
%               Wpl: [N].     Pay Load.
%                Vf: [m^3].   Fuel Volume.
%       discLoading: [N/m^2]. Disc Loading
%
% ndParameters is a structure with fields:
%
%            muMax: [-]. mu value corresponding to maximum speed at sea level
%           CWMTOW: [-]. Weight coefficient corresponding to MTOW at sea level
%          MtipMax: [-]. Maximum tip Mach number (advancing blade with maximum speed at sea level) for main rotor
%          MtipMin: [-]. Minimum tip Mach number (retreating blade with maximum speed at sea level) for main rotor
%        MtipHover: [-]. Tip Mach number in hover for main rotor..
%        MtipTrMax: [-]. Maximum tip Mach number (advancing blade with maximum speed at sea level) for tail rotor
%        MtipTrMin: [-]. Minimum tip Mach number (retreating blade with maximum speed at sea level) for tail rotor
%      MtipTrHover: [-]. Tip Mach number in hover for tail rotor.
%          ReOR07c: [-]. Reynolds number for blade section 0.7r at hover for the tail rotor
%        ReORtr07c: [-]. Reynolds number for blade section 0.7r at hover for the tail rotor
%

desreq.rand = randDr;

mr    = getRandMainRotor(desreq);
tr    = getRandTailRotor(desreq);
dim   = getRandDimension(desreq,mr,tr);
pfs   = getRandPerformance(desreq);
wgt   = getRandWeight(desreq);

rho0  = atm.rho0;
mu0   = atm.mu0;
a0    = atm.a0;

MTOW    = wgt.MTOW;
Vmax    = pfs.VmaxSeaLevel;
Omega   = mr.OmegaRAD;
R       = mr.R;
c       = mr.c;
Omegatr = tr.OmegaRAD;
Rtr     = tr.R;
ctr     = tr.c;
OR      = Omega*R;
ORtr    = Omegatr*Rtr;

muMax       = Vmax/OR;
CWMTOW      = MTOW/(rho0*OR^2*pi*R^2); 
MtipMax     = (Vmax+OR)/a0;
MtipMin     = (-Vmax+OR)/a0;
MtipHover   = OR/a0;
MtipTrMax   = (Vmax+ORtr)/a0;
MtipTrMin   = (-Vmax+ORtr)/a0;
MtipTrHover = OR/a0;
ReOR07c     = rho0*0.7*OR*c/mu0;
ReORtr07c   = rho0*0.7*ORtr*ctr/mu0;




ndP = struct('muMax',muMax,...
             'CWMTOW',CWMTOW,...
             'MtipMax',MtipMax,...
             'MtipMin',MtipMin,...
             'MtipHover',MtipHover,...
             'MtipTrMax',MtipTrMax,...
             'MtipTrMin',MtipTrMin,...
             'MtipTrHover',MtipTrHover,...
             'ReOR07c',ReOR07c,...
             'ReORtr07c',ReORtr07c);


randHe = struct('mainRotor',mr,...
                'tailRotor',tr,...
                'dimensions',dim,...
                'performances',pfs,...
                'weights',wgt,...
                'ndParameters',ndP);


end

