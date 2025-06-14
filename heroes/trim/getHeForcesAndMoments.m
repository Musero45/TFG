function [CFW,...
          CFmr,CMmr,CMFmr,...
          CFtr,CMtr,CMFtr,...
          CFf,CMf,CMFf,...
          CFvf,CMvf,CMFvf,...
          CFlHTP,CMlHTP,CMFlHTP,...
          CFrHTP,CMrHTP,CMFrHTP...
          ] =  getHeForcesAndMoments(x,vel,ndHe,options)
%getHeForcesAndMoments  Gets helicopter actions by components
%
%   getHeForcesAndMoments(FC,V,ndHE,options) gets the non dimensional 
%   helicopter forces and moments by components using the array 
%   of flight conditions FC, velocity structure.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  2014/12/04 Big modification, Yaw angle psi is introduced on this
%  function and matrix MFT(0,Theta,Phi) is transformed to MFT(Psi,Theta,Phi)
%
%  An additional big modification is including flight CW = CWrated*omega^(-2);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%


CFW                     = getGravityForces(x,ndHe,options);


if strcmp(ndHe.mainRotor.active,'yes')
   [CFmr,CMmr,CMFmr]       = getMR_ForcesAndMoments(x,vel,ndHe,options);
else
   n   = size(x,2);
   CFmr  = zeros(3,n);
   CMmr  = zeros(3,n);
   CMFmr = zeros(3,n);
end

if strcmp(ndHe.tailRotor.active,'yes')
   [CFtr,CMtr,CMFtr]       = getTR_ForcesAndMoments(x,vel,ndHe,options);
else
   n   = size(x,2);
   CFtr  = zeros(3,n);
   CMtr  = zeros(3,n);
   CMFtr = zeros(3,n);
end

if strcmp(ndHe.fuselage.active,'yes')
   [CFf,CMf,CMFf]          = getF_ForcesAndMoments(x,vel,ndHe,options);
else
   n   = size(x,2);
   CFf   = zeros(3,n);
   CMf   = zeros(3,n);
   CMFf  = zeros(3,n);
end

if strcmp(ndHe.verticalFin.active,'yes')
   [CFvf,CMvf,CMFvf]       = getVF_ForcesAndMoments(x,vel,ndHe,options);
else
   n   = size(x,2);
   CFvf  = zeros(3,n);
   CMvf  = zeros(3,n);
   CMFvf = zeros(3,n);
end

if strcmp(ndHe.leftHTP.active,'yes')
   [CFlHTP,CMlHTP,CMFlHTP] = getLHTP_ForcesAndMoments(x,vel,ndHe,options);
else
   n   = size(x,2);
   CFlHTP  = zeros(3,n);
   CMlHTP  = zeros(3,n);
   CMFlHTP = zeros(3,n);
end

if strcmp(ndHe.rightHTP.active,'yes')
   [CFrHTP,CMrHTP,CMFrHTP] = getRHTP_ForcesAndMoments(x,vel,ndHe,options);
else
   n   = size(x,2);
   CFrHTP  = zeros(3,n);
   CMrHTP  = zeros(3,n);
   CMFrHTP = zeros(3,n);
end



end


function [CF,CM,CMF] = getMR_ForcesAndMoments(x,vel,ndHe,options)

% This was in the loop and it shouldn't be FIXME?
geom = ndHe.geometry;
OfO = [geom.Xcg;geom.Ycg;geom.Zcg];


n   = size(x,2);
CF  = zeros(3,n);
CM  = zeros(3,n);
CMF = zeros(3,n);

mrF = options.mrForces;
mrM = options.mrMoments;
GT  = options.GT;
kIn = options.inertialFM;

for i=1:n

    Psi      = x(26,i);%Alvaro including yaw Psi after generalising the trim problem
    Theta    = x(1,i);
    Phi      = x(2,i);
    theta    = [x(3,i); x(4,i); x(5,i)];
    beta     = [x(7,i); x(8,i); x(9,i)];
    lambda   = [x(10,i); x(11,i); x(12,i)];

    MFT = TFT(Psi,Theta,Phi);%Alvaro includign yaw Psi after generalising the trim problem


    ndMR = ndHe.mainRotor;
    fCA  = vel.A(:,i);
    muWA = vel.WA;
    epsx = geom.epsilonx;
    epsy = geom.epsilony;
    
    OfA = [geom.ndls;geom.ndds;0];

    MAF = TAF(epsx,epsy);
    MFA = MAF';

    OfA  = OfA+MFA*[0;0;geom.ndh];
    OA   = -OfO+OfA;
    
    GA = MAF*MFT*[0;0;GT];

    [CFai, CFa0, CFi, CFg] = mrF(beta,theta,lambda,fCA,muWA,GA,ndMR);
    [CMFai, CMFa0, CMaEi, CMaE0, CMFi, CMiE, CMgE, CMel] = mrM(beta,theta,lambda,fCA,muWA,GA,ndMR);
    CFA = CFai(1:3) + CFa0(1:3)+ kIn.*CFi + CFg;
    CMA = CMFai+ CMaEi+ CMFa0 + CMaE0 +  kIn.*CMFi +  kIn.*CMiE + CMgE + CMel;
%     Padfield's
%     CMA(1) = CMel(1);
%     CMA(2) = CMel(2);

    CF(:,i)  = MFA*CFA;
    CM(:,i)  = MFA*CMA;
    CMF(:,i) = cross(OA,CF(:,i));
end

end


function [CF,CM,CMF] = getTR_ForcesAndMoments(x,vel,ndHe,options)

% This was in the loop and it shouldn't be. FIXME?
geom = ndHe.geometry;
OfO = [geom.Xcg;geom.Ycg;geom.Zcg];

n   = size(x,2);
CF  = zeros(3,n);
CM  = zeros(3,n);
CMF = zeros(3,n);

trF = options.trForces;
trM = options.trMoments;
GT  = options.GT;
kIn = options.inertialFM;


for i = 1:n

    Psi      = x(26,i);%Alvaro includign yaw Psi after generalising the trim problem
    Theta    = x(1,i);
    Phi      = x(2,i);
    thetatr  = [x(6,i);0;0];
    betatr   = [x(16,i);x(17,i);x(18,i)];
    lambdatr = [x(19,i);x(20,i);x(21,i)];
    MFT      = TFT(Psi,Theta,Phi);%Alvaro includign yaw Psi after generalising the trim problem


    ndTR     = ndHe.tailRotor;
    muWAtr   = vel.WAtr;
    rForces  = ndHe.rForces;
    rMoments = ndHe.rMoments;
    epstr    = geom.thetatr;

    OfAtr = [geom.ndltr;geom.nddtr;geom.ndhtr];
    OAtr = -OfO+OfAtr;

    MAtrF = TAtrF(epstr);
    MFAtr = MAtrF';

    fCAtr    = vel.Atr(:,i);
    GAtr = MAtrF*MFT*[0;0;GT];

    [CFai, CFa0, CFi, CFg] = trF(betatr,thetatr,lambdatr,fCAtr,muWAtr,GAtr,ndTR);
    [CMFai, CMFa0, CMaEi, CMaE0, CMFi, CMiE, CMgE, CMel] = trM(betatr,thetatr,lambdatr,fCAtr,muWAtr,GAtr,ndTR);
    CFAtr = CFai(1:3) + CFa0(1:3)+ kIn.*CFi + CFg;... ;
%     CFAtr = geom.BFtr.*CFAtr;
    CMAtr = CMFai+ CMaEi+ CMFa0 + CMaE0 +  kIn.*CMFi +  kIn.*CMiE + CMgE + CMel;
% %     Considering only z forces and moments
%     CFAtr = [0; 0; CFai(3)];
%     CMAtr = [0; 0; 0];...CMFai(3)+ CMaEi(3)+ CMFa0(3) + CMaE0(3)];...
    
    CF(:,i)  = rForces.*(MFAtr*CFAtr);
    CM(:,i)  = rMoments.*(MFAtr*CMAtr);
    CMF(:,i) = cross(OAtr,CF(:,i));


end

end


function [CF,CM,CMF] = getF_ForcesAndMoments(x,vel,ndHe,options)

% This was in the loop and it shouldn't be FIXME?
geom = ndHe.geometry;
OfO = [geom.Xcg;geom.Ycg;geom.Zcg];


n   = size(x,2);
CF  = zeros(3,n);
CM  = zeros(3,n);
CMF = zeros(3,n);

for i=1:n

    ndFus = ndHe.fuselage;
    flightConditionF = vel.F(:,i);

    [CF(:,i), CM(:,i)] = getFuselageActions(flightConditionF,ndFus);
    
%     CFf(2,i) = 0;
%     CMf(1,i) = 0;
%     CMf(3,i) = 0;
    
    OOf = -OfO;
%     OOf = [0; 0; 0]; %Padfield's fuselages

    CMF(:,i) = cross(OOf,CF(:,i));


end

end



function [CF,CM,CMF] = getVF_ForcesAndMoments(x,vel,ndHe,options)

% This was in the loop and it shouldn't be FIXME?
geom = ndHe.geometry;
OfO = [geom.Xcg;geom.Ycg;geom.Zcg];


n   = size(x,2);
CF  = zeros(3,n);
CM  = zeros(3,n);
CMF = zeros(3,n);

ndVF    = ndHe.verticalFin;
Gamma   = geom.Gammavf;
actions = ndVF.type;

MFS = TFS(Gamma);

OfVf = [geom.ndlvf;geom.nddvf;geom.ndhvf];
OVf = -OfO+OfVf;

for i = 1:n

    flightConditionvf = vel.vf(:,i);

    [CF(:,i), CM(:,i)] = actions(flightConditionvf,ndVF);%ALVARO after Sergio Nadal, 2015/01/09

    CF(:,i)  = MFS*CF(:,i);%ALVARO after Sergio Nadal, 2015/01/09
    CM(:,i)  = MFS*CM(:,i);%ALVARO after Sergio Nadal, 2015/01/09
    CMF(:,i) = cross(OVf,CF(:,i));


end

end


function [CF,CM,CMF] = getLHTP_ForcesAndMoments(x,vel,ndHe,options)

% This was in the loop and it shouldn't be FIXME?
geom = ndHe.geometry;
OfO = [geom.Xcg;geom.Ycg;geom.Zcg];

n   = size(x,2);
CF  = zeros(3,n);
CM  = zeros(3,n);
CMF = zeros(3,n);

ndlHTP  = ndHe.leftHTP;
Gamma   = geom.GammalHTP;
actions = ndlHTP.type;

MFS = TFS(Gamma);

OflHTP = [geom.ndllHTP;geom.nddlHTP;geom.ndhlHTP];
OlHTP = -OfO+OflHTP;

for i=1:n


    flightConditionlHTP = vel.lHTP(:,i);

    [CF(:,i), CM(:,i)] = actions(flightConditionlHTP,ndlHTP);%ALVARO after Sergio Nadal, 2015/01/09

    CF(:,i)  = MFS*CF(:,i);%ALVARO after Sergio Nadal, 2015/01/09
    CM(:,i)  = MFS*CM(:,i);%ALVARO after Sergio Nadal, 2015/01/09
    CMF(:,i) = cross(OlHTP,CF(:,i));


end


end

function [CF,CM,CMF] = getRHTP_ForcesAndMoments(x,vel,ndHe,options)

% This was in the loop and it shouldn't be FIXME?
geom = ndHe.geometry;
OfO = [geom.Xcg;geom.Ycg;geom.Zcg];

n   = size(x,2);

CF  = zeros(3,n);
CM  = zeros(3,n);
CMF = zeros(3,n);

ndrHTP  = ndHe.rightHTP;
Gamma   = geom.GammarHTP;
actions = ndrHTP.type;

MFS = TFS(Gamma);

OfrHTP = [geom.ndlrHTP;geom.nddrHTP;geom.ndhrHTP];
OrHTP = -OfO+OfrHTP;

for i=1:n

    flightConditionrHTP = vel.rHTP(:,i);    

    [CF(:,i), CM(:,i)] = actions(flightConditionrHTP,ndrHTP);

    CF(:,i)  = MFS*CF(:,i);%ALVARO after Sergio Nadal, 2015/01/09
    CM(:,i)  = MFS*CM(:,i);%ALVARO after Sergio Nadal, 2015/01/09
    CMF(:,i) = cross(OrHTP,CF(:,i));%ALVARO after Sergio Nadal, 2015/01/09

end


end



function CF = getGravityForces(x,ndHe,options)

n   = size(x,2);
CF  = zeros(3,n);

for i = 1:n
    
    Psi      = x(26,i);%Alvaro including yaw Psi after generalising the trim problem
    Theta    = x(1,i);
    Phi      = x(2,i);
    
    MFT = TFT(Psi,Theta,Phi);%Alvaro including yaw Psi after generalising the trim problem

    CWrated = ndHe.inertia.CW;
    %CW = x(43);
    CF(:,i) = MFT*[0;0;CWrated*(x(25,i)^-2)];%Alvaro including flight x(43) = CW = CWrated*omega^(-2);
    %CF(:,i) = MFT*[0;0;x(43)];% WIthout any aparent reason this works but
    %the previous way it does not.
    
end


end