function vel = velocities(flightConditionV,muWV,lambda,beta,ndHe,options)
% velocities  returns a structure with the aerodynamic velocity vector
% relative to the characteristic point of each element expressed in the
% local reference system local to each element.
%
% In the case of the main rotor and the tail rotor the air velocities
% due to the displacement of the He center of mass (flight velocity) and
% the the ones due to the angular velocity of the fuselage are calculated
% separatelly from the air velocities due to the atmospheric wind
%
% In the case of the fuselage, vertical fin and horizontal left and right
% tail planes the three types of air valocites are included in the
% corresponding flight conditions.
%
%
%                  main rotor: A
%                  tail rotor: Atr
%                    fuselage: F
%                vertical fin: vf
%  left horizontal tail plane: lHTP
% right horizontal tail plane: lHTP
%            wake skew angle : xi
%
% vel is a structure with the fields
%
%              'A': fCA,    [6xn double]
%             'WA': muWA,   [3xn double]
%            'Atr': fCAtr,  [6xn double]
%           'WAtr': muWAtr, [3xn double]
%              'F': fCF,    [6xn double]
%             'vf': fCvf,   [6xn double]
%           'lHTP': fClHTP, [6xn double]
%           'rHTP': fCrHTP, [6xn double]
%             'xi': xi;     [1xn double]
%
% where n is n = S(2) being S = size(flightConditionV):
% 
% fCA is the vector [muxA,muyA,muzA,omAdxA,omAdyA,omAdzA].The first 3
% components are the non dimensional air velocities relative to
% the reference point of the main rotor A due to:
% 
%   - the linear displacement of the helicopter center of He mass.
%   - the angular velocity of the fuselage arroud the He center of mass.
%
% The last 3 components are the non dimensional angular velocity 
% componentes of the MAIN ROTOR (A) reference system (coincident with
% the fuselage angular velocities). The variables are made nondimensional
% with Omega*R and Omega. fCA is expressed % in the MAIN ROTOR (A)
% reference system.
%-------------------------------------------------------------------------
% muWA is the nondimensional atmospheric wind vector expressed in the 
% MAIN ROTOR reference system. The variables are made nondimensional
% with Omega*R.
%-------------------------------------------------------------------------
% fCAtr is the vector [muxAtr,muyAtr,muzAtr,omAtrAdxAtr,..
% omAtrAdyAtr,omAtrAdzAtr]. The first 3 components are the 
% non dimensional air velocities relative to the reference point of the 
% tail rotor, Atr, due to:
%
%   - the linear displacement of the helicopter center of He mass.
%   - the angular velocity of the fuselage arroud the He center of mass.
%
% The last 3 components are the  non dimensional angular 
% velocity componentes of the TAIL ROTOR (Atr) reference system 
% (coincident with the fuselage angular velocities). The variables
% are made nondimensional with Omegatr*Rtr and Omegatr. fCAtr is expressed
% in the TAIL ROTOR (Atr) reference system.
%-------------------------------------------------------------------------
% muWAtr is the nondimensional atmospheric wind vector expressed in the 
% TAIL ROTOR reference system. The variables are made nondimensional
% with Omegatr*Rtr.
%-------------------------------------------------------------------------
% fCF is the vector [muxF,muyF,muzF,omAdx,omAdy,omAdz]. The first
% 3 components are the non dimensional air velocities relative to
% the reference point of the fuselage Of due to:
%
%   - the linear displacement of the helicopter center of He mass.
%   - the angular velocity of the fuselage arroud the He center of mass.
%   - the atmospheric wind.
%
% The last 3 components are the  non dimensional angular 
% velocity componentes of the FUSELAGE reference system (coincident with
% the fuselage angular velocities). The variables are made nondimensional
% with Omega*R and Omega. fCf is expressed In the FUSELAGE (F) 
% reference system.
%-------------------------------------------------------------------------
% fCvf is the vector [muxF,muyF,muzF,omAdx,omAdy,omAdz]. The first
% 3 components are the non dimensional air velocities relative to
% the reference point of the vertical fin Vf due to:
%
%   - the linear displacement of the helicopter center of He mass.
%   - the angular velocity of the fuselage arroud the He center of mass.
%   - the atmospheric wind.
%
% The last 3 components are the  non dimensional angular 
% velocity componentes of the VERTICAL FIN reference system (coincident
% with the fuselage angular velocity). The variables
% are made nondimensional with Omega*R and Omega. fCvf is expressed
% in the VERTICAL FIN (vf) reference system.
%-------------------------------------------------------------------------
% fClHTP is the vector [muxlHTP,muylHTP,muzlHTP,omAdlHTPx,omAdlHTPy,...
% omAdlHTPz]. The first 3 components are the non dimensional air velocities
% relative to the reference point of the left horizontal tail plane lHTP
% due to:
%
%   - the linear displacement of the helicopter center of He mass.
%   - the angular velocity of the fuselage arroud the He center of mass.
%   - the atmospheric wind.
%
% The last 3 components are the  non dimensional angular 
% velocity componentes of the LEFT HORIZONTAL TAIL PLANE reference system
% (coincident with the fuselage angular velocity). The variables
% are made nondimensional with Omega*R and Omega. fClHTP is expressed
% in the LEFT HORIZONTAL TAIL PLANE (lHTP) reference system.
%-------------------------------------------------------------------------
% fCrHTP is the vector [muxrHTP,muyrHTP,muzrHTP,omAdrHTPx,omAdrHTPy,...
% omAdrHTPz]. The first 3 components are the non dimensional air velocities
% relative to the reference point of the left horizontal tail plane lHTP
% due to:
%
%   - the linear displacement of the helicopter center of He mass.
%   - the angular velocity of the fuselage arroud the He center of mass.
%   - the atmospheric wind.
%
% The last 3 components are the  non dimensional angular 
% velocity componentes of the RIGHT HORIZONTAL TAIL PLANE reference system
% (coincident with the fuselage angular velocity). The variables
% are made nondimensional with Omega*R and Omega. fCrHTP is expressed
% in the RIGHT HORIZONTAL TAIL PLANE (rHTP) reference system.
%-------------------------------------------------------------------------
% xi: wake skew angle. FIXME this should be made two dimensional to take
% into account the lateral skew of the wake.
%
%
n = size(flightConditionV,2);

muV      = flightConditionV(1:3,:);% This is in the body reference system
omegaAd  = flightConditionV(4:6,:);% This is in the body reference system
lambdaP  = [zeros(1,n);zeros(1,n);lambda(1,:)];

geom = ndHe.geometry;

epsx = geom.epsilonx;
epsy = geom.epsilony;
MAF = TAF(epsx,epsy);
MPF  = zeros(3,3,n);

OfO = [geom.Xcg;geom.Ycg;geom.Zcg];% This is in the body reference system
OfA = [geom.ndls;geom.ndds;0];% This is in the body reference system
OfA  = OfA+MAF\[0;0;geom.ndh];% MAF\[0;0;geom.ndh] is equivalent to 
%inv(MAF)*[0;0;geom.ndh]=MFA*[0;0;geom.ndh].  
OA = -OfO+OfA;% This is in the body reference system

interf = zeros(3,n);

fCA  = zeros(6,n);
muWA = zeros(3,n);
mu   = zeros(3,n);

xi   = zeros(1,n);

for i = 1:n

%==========================================================================
% main rotor hub (A) velocities. Linear velocities are air velocities,
% and angular velocities are the absolute angular velocity of the
% A reference system. In both cases main rotor Omega and R are used for
% making the variables non dimensional.
%--------------------------------------------------------------------------

    MPA = TPA(beta(:,i));
    MPF(:,:,i) = MPA*MAF;
    
%   interf(:,i)  = MPF(:,:,i)\lambdaP(:,i);
    interf(:,i)  = -lambdaP(:,i);

    % hub velocities (They are flight+atmosferic wind,
    % air velocities expressed in A reference system
    muOmega    = -cross(omegaAd(:,i),OA);
    fCA(1:3,i) = MAF*(-muV(:,i) + muOmega);
    fCA(4:6,i) = MAF*omegaAd(:,i);
    muWA(:,i)  = MAF*muWV;
    
    %-----------------------------------------------------------------
    %     mu(1:3,i) = fCA(1:3,i) + muWA(i) + MPA\lambdaP(:,i);% ALVARO:
    %WHY NOT?
    %-----------------------------------------------------------------
    mu(1:3,i) = fCA(1:3,i) + muWA(i) + lambdaP(:,i);
    % FIXME (ALVARO): WHY IS NANO ADDING 
    %fCA and muWA in A reference system and lambdaP is tip plane reference
    %system???
    %INTERFERENCE GEOMETRY MUST BE IMPROVED!!!!. No geometric analysis
    %of the interference has been programed. Indeed, for instance,
    %Sinterf = tailRotorInterf(xi(i),ndHe) provides always Sinterf = 1.
    %So, always, the default option for
    % model   = options.trInterf=@NoInterf, is used.
    
    muxy      = mu(1,i);
    lam       = mu(3,i);
    xi(i)     = atan2(muxy,-lam);
    
end

%==========================================================================

%==========================================================================
% tail rotor hub velocities. Linear velocities are air velocities,
% and angular velocities are the absolute angular velocity of the
% Atr reference system. In both cases tail rotor Omegatr and Rtr are used
% for making the variables non dimensional.
%--------------------------------------------------------------------------

thetatr   = geom.thetatr;
rVel      = ndHe.rVel;
rAngVel   = ndHe.rAngVel;

OfAtr = [geom.ndltr;geom.nddtr;geom.ndhtr];%In fuselage axis
OAtr = -OfO+OfAtr;%In fuselage axis

MAtrF = TAtrF(thetatr);

ktr     = ndHe.tailRotor.k;
model   = options.trInterf;

fCAtr  = zeros(6,n);
muWAtr = zeros(3,n);

for i = 1:n
    
    Sinterf = tailRotorInterf(xi(i),ndHe);
    factor  = model(Sinterf);
    ktr     = ktr*factor;
    
    %muOmega      = [0;-OAtr(1)*omegaAd(3,i);+OAtr(1)*omegaAd(2,i)];%WHY
    %IS NOT USING NANO HERE A CROSS PRODUCT?
    muOmega    = -cross(omegaAd(:,i),OAtr);%Introduced by ALVARO 2014/12/26
    fCAtr(1:3,i) = MAtrF*(-muV(:,i) + muOmega + ktr.*interf(:,i));
    fCAtr(1:3,i) = fCAtr(1:3,i)./rVel;%For further calculations the
    %tr air velocities must be relative to its own Omega and R. Good for
    %Nano
    fCAtr(4:6,i) = MAtrF*omegaAd(:,i);
    fCAtr(4:6,i) = fCAtr(4:6,i)./rAngVel;%For further calculations the
    %tr air velocities must be relative to its own Omega and R. Good for
    %Nano
    muWAtr(:,i)  = (MAtrF*muWV)./rVel;%For further calculations the
    %tr air velocities must be relative to its own Omega and R. Good for
    %Nano
    
end

%==========================================================================

%==========================================================================
% fuselage velocities.  Linear velocities are air velocities,
% and angular velocities are the absolute angular velocity of the
% f reference system. In both cases main rotor Omega and R are used
% for making the variables non dimensional.
%--------------------------------------------------------------------------

kf      = ndHe.fuselage.kf;
model   = options.fInterf;

fCF = zeros(6,n);

for i = 1:n
    
    Sinterf    = fuselageInterf(xi(i),ndHe);
    factor     = model(Sinterf);
    kf         = kf*factor;
    
    fCF(1:3,i) = -muV(:,i) + muWV + kf.*interf(:,i);%ALVARO: PAY ATTENTION
    %IN fCF muWV is included but it is not in main rotor and tail rotor
    fCF(4:6,i) = omegaAd(:,i);
    
end

%==========================================================================
% vertical fin velocities.  Linear velocities are air velocities,
% and angular velocities are the absolute angular velocity of the
% vf reference system. In both cases main rotor Omega and R are used
% for making the variables non dimensional.
%--------------------------------------------------------------------------

Gamma = geom.Gammavf;% ALVARO: Gammavf is a positive rotation angle
% of the vertical fin arround x fuselage axis, this is declared in
% this way (diferent compared to Teoria de los Helicópteros, where
% a specific treatment of the vertical fin and horizontal tail planes
% are introduced. In Heroes a vf is a stabilizer with Gamma = pi/2.
% To make this approcach as comparable as possible with Teoria de los
% Helicopteros, Gamma mus be set Gamma = -pi/2, so xvf = x, yvf = -z 
% and zvf = y. A vf fin pitch angle thetavf>0 points the leading edge
% towards fuselage y negative.
% -pi/2 if we want the axis  This posibility allows to

OfVf  = [geom.ndlvf;geom.nddvf;geom.ndhvf];
OVf   = -OfO+OfVf;

MFS = TFS(Gamma);

kv      = ndHe.verticalFin.ks;
model   = options.vfInterf;

fCvf = zeros(6,n);

for i = 1:n
    
    Sinterf = verticalFinInterf(xi(i),ndHe);
    factor  = model(Sinterf);
    kv      = kv*factor;
    
    %muOmega     = [0;-OVf(1)*omegaAd(3,i);0];%Old nano why not a cross product?
    muOmega      = -cross(omegaAd(:,i),OVf);%New Alvaro 2015_03
    fCvf(1:3,i) = MFS\(-muV(:,i) + muWV + muOmega + kv.*interf(:,i));
    fCvf(4:6,i) = MFS\omegaAd(:,i);
    
end

%====================================================================

%====================================================================
% horizontal tail velocities.  Linear velocities are air velocities,
% and angular velocities are the absolute angular velocity of the
% HTP reference system. In both cases main rotor Omega and R are used
% for making the variables non dimensional.
%--------------------------------------------------------------------

% left

Gamma  = geom.GammalHTP;
OflHTP = [geom.ndllHTP;geom.nddlHTP;geom.ndhlHTP];
OlHTP  = -OfO+OflHTP;

MFS = TFS(Gamma);

klh     = ndHe.leftHTP.ks;
model   = options.lHTPInterf;

fClHTP = zeros(6,n);

for i = 1:n
    Sinterf = leftHTPInterf(xi(i),ndHe);
    factor  = model(Sinterf);
    klh     = klh*factor;
    
    muOmega       = [0;0;OlHTP(1)*omegaAd(2,i)];
    fClHTP(1:3,i) = MFS\(-muV(:,i) + muWV + muOmega + klh.*interf(:,i));
    fClHTP(4:6,i) = MFS\omegaAd(:,i);
end

% right

Gamma  = geom.GammarHTP;
OfrHTP = [geom.ndlrHTP;geom.nddrHTP;geom.ndhrHTP];
OrHTP  = -OfO+OfrHTP;

MFS = TFS(Gamma);

krh     = ndHe.rightHTP.ks;
model   = options.rHTPInterf;

fCrHTP = zeros(6,n);

for i = 1:n
    
    Sinterf = rightHTPInterf(xi(i),ndHe);
    factor  = model(Sinterf);
    krh     = krh*factor;
    
    muOmega       = [0;0;OrHTP(1)*omegaAd(2,i)];
    fCrHTP(1:3,i) = MFS\(-muV(:,i) + muWV + muOmega + krh.*interf(:,i));
    fCrHTP(4:6,i) = MFS\omegaAd(:,i);
    
end

% velocities struct

vel = struct('A',fCA, ...
             'WA',muWA,...
             'Atr',fCAtr,...
             'WAtr',muWAtr,...
             'F',fCF,...
             'vf',fCvf,...
             'lHTP',fClHTP,...
             'rHTP',fCrHTP,...
             'xi',xi ... 
             );

