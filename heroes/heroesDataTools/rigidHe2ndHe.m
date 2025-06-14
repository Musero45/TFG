function pOut = rigidHe2ndHe(he,atm,H)
%RIGIDHE2NDHE  Transforms a dimensional rigid helicopter into a 
%         nondimensional one
%
%   P = RIGIDHE2NDHE(HE,ATM,H) computes a nondimensional rigid helicopter at
%   density RHO and gravity G. If HE is a cell of N helicopters
%   RIGIDHE2NDHE returns a cell of N nondimensional helicopters, P.
%
%   TODO
%   * vectorize each element: rigidRotor2ndRotor, etc
%
% Dirty hack to avoid vector evaluation of density rho
% FIXME? Oscar is not sure if this is the correct way of doing, and I do
% not really like it at all

% % % % % % g          = atm.g;
density    = atm.density;
rho        = density(H);

n     = length(he);
p     = cell(n,1);

% If there is one helicopter structure it should be redefined to a cell
if n == 1
   he = {he};
end


for i=1:n

% Main rotor
mr    = he{i}.mainRotor;

% Dimensional variables
Omega = mr.Omega;
R     = mr.R;
area  = pi*R^2;
OR    = Omega*R;
Tu    = rho*area*OR.^2;
W     = he{i}.inertia.W;

% Weight coefficient
CW           = W./Tu;
inertia      = he{i}.inertia;
ndInertia    = inertia2ndInertia(inertia,R,rho);
ndInertia.CW = CW;

% nondimensionalMainRotor
ndMainRotor    = rigidRotor2ndRotor(mr,atm,H);
ndMainRotor.CW = CW;

% nondimensionalTailRotor
tr          = he{i}.tailRotor;
Omegatr     = tr.Omega;
Rtr         = tr.R;
ndTailRotor = rigidRotor2ndRotor(tr,atm,H);

rAngVel  = Omegatr/Omega;
rVel     = (Omegatr*Rtr)/(Omega*R);
rForces  = rVel^2*Rtr^2/R^2;%((Omegatr*Rtr)^2*Rtr^2)/((Omega*R)^2*R^2);
rMoments = rVel^2*Rtr^3/R^3;%((Omegatr*Rtr)^2*Rtr^3)/((Omega*R)^2*R^3);

% nondimensionalFuselage
model      = he{i}.fuselage.model;
lf         = he{i}.fuselage.lf;
Sp         = he{i}.fuselage.Sp;
Ss         = he{i}.fuselage.Ss;
kf         = he{i}.fuselage.kf;
activef    = he{i}.fuselage.active;
ndFuselage = struct(...
                    'active',activef,...
                    'model',model, ...
                    'ndlf',lf/R, ...
                    'ndSp',Sp/area, ...
                    'ndSs',Ss/area, ...
                    'kf',kf);

% nondimensionalVerticalFin
vf            = he{i}.verticalFin;
ndVerticalFin = stabilizer2ndStabilizer(vf,R);

% nondimensionalLeftHTP
lHTP      = he{i}.leftHTP;
ndLeftHTP = stabilizer2ndStabilizer(lHTP,R);

% nondimensionalLeftHTP
rHTP      = he{i}.rightHTP;
ndRightHTP = stabilizer2ndStabilizer(rHTP,R);

% nondimensionalGeometry
geom       = he{i}.geometry;
ndGeometry = geometry2ndGeometry(geom,R);
ndGeometry.BFtr = 1-0.75*he{i}.verticalFin.S/(pi*he{i}.tailRotor.R^2);

% Define the nondimensional helicopter
p{i}     = struct(...
         'class','ndRigidHe',...
         'id',he{i}.id,....
         'mainRotor',ndMainRotor,...
         'tailRotor',ndTailRotor,...
         'fuselage',ndFuselage,...
         'verticalFin',ndVerticalFin,...
         'leftHTP',ndLeftHTP,...
         'rightHTP',ndRightHTP,...
         'geometry',ndGeometry,...
         'transmission',he{i}.transmission,...
         'inertia',ndInertia,...
         'Tu',Tu,...
         'Pu',Tu*OR,...
         'rAngVel',rAngVel,...
         'rVel',rVel,...
         'rForces',rForces,...
         'rMoments',rMoments,...
         'rho',rho...
);


end

if n == 1
   pOut = p{1};
else
   pOut = p;
end