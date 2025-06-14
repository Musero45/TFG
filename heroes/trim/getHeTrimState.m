function trimState = getHeTrimState(x,flightConditionT,muWT,ndHe,options)
%GETHETRIMSTATE  Gets an helicopter trim state
%
%   ts = getHeTrimState(X,FC,mu_w,ndHe) gets an helicopter trim state, ts,
%   for a given trim state solution, x, flight condition FC, nondimensional
%   wind speed, mu_w, a nondimensional helicopter, ndHe. The trim state
%   solution, X, is a ndof x nfc matrix, being ndof=24 the number of
%   degrees of freedom of the helicopter model and nfc the number of 
%   flight conditions for which the trim state solution matrix was obtained. 
%
%   ts = getHeTrimState(X,FC,mu_w,ndHe,OPTIONNS) computes as above with 
%   default options replaced by values set in OPTIONS. OPTIONS should be 
%   input in the form of sets of property value pairs. Default OPTIONS 
%   is a structure with the following fields and values:
% 
%               niSolver: @qtrapz
%               umSolver: @fminsearch
%               nlSolver: @fsolve
%              odeSolver: @ode45
%          newmarkParams: [1x2 double]
%                 TolFun: 1.000000000000000e-12
%                   TolX: 1.000000000000000e-12
%                Display: 'off'
%                MaxIter: 400
%           linearInflow: @wakeEqs
%     uniformInflowModel: @Cuerva
%     armonicInflowModel: @Coleman
%               mrForces: @thrustF
%               trForces: @thrustF
%              mrMoments: @elasticM
%              trMoments: @aerodynamicM
%                fInterf: @noneInterf
%               trInterf: @noneInterf
%               vfInterf: @noneInterf
%             lHTPInterf: @noneInterf
%             rHTPInterf: @noneInterf
%                     GT: 1
%             inertialFM: 1
%
%   See also setHeroesRigidOptions and setHeroesOptions
%
%   Examples of usage:
%
%   TODO
%
%   function name should be changed to something more meaningful like
%   trimStateSolution2trimState. There are a lot of uses of getHeTrimState
%   at heroesTest/PFCNano and at this moment it stays like it is.

% Define number of degrees of freedom
%  (for the moment being, it should be 24 which is fixed) 
ndof  = size(x,1);
% Define the number of trim state solutions
n = size(flightConditionT,2);

%  Assign trim state solution to meaningful variables
Theta(1,:) = x(1,:);
Phi(1,:)   = x(2,:);
beta       = [x(7,:); x(8,:); x(9,:)];
lambda     = [x(10,:); x(11,:); x(12,:)];



fCV  = zeros(6,n);
for i = 1:n
    MFT        = TFT(0,Theta(i),Phi(i));
    fCV(1:3,i) = MFT*flightConditionT(1:3,i);
    fCV(4:6,i) = flightConditionT(4:6,i);
    muWV       = MFT*muWT;
end


% Compute velocities at different components
vel = velocities(fCV,muWV,lambda,beta,ndHe,options);


% Get forces and moments
[CFW,...
 CFmr,CMmr,CMFmr,...
 CFtr,CMtr,CMFtr,...
 CFf,CMf,CMFf,...
 CFvf,CMvf,CMFvf,...
 CFlHTP,CMlHTP,CMFlHTP,...
 CFrHTP,CMrHTP,CMFrHTP] =  getHeForcesAndMoments(x,vel,ndHe,options);

% Allocate actions matrix
actions         = zeros(3,n,7*3);

% Define actions 3D matrix
actions(:,:,1)  = CFW;
actions(:,:,2)  = zeros(3,n);
actions(:,:,3)  = zeros(3,n);
actions(:,:,4)  = CFmr;
actions(:,:,5)  = CMmr;
actions(:,:,6)  = CMFmr;
actions(:,:,7)  = CFtr;
actions(:,:,8)  = CMtr;
actions(:,:,9)  = CMFtr;
actions(:,:,10) = CFf;
actions(:,:,11) = CMf;
actions(:,:,12) = CMFf;
actions(:,:,13) = CFvf;
actions(:,:,14) = CMvf;
actions(:,:,15) = CMFvf;
actions(:,:,16) = CFlHTP;
actions(:,:,17) = CMlHTP;
actions(:,:,18) = CMFlHTP;
actions(:,:,19) = CFrHTP;
actions(:,:,20) = CMrHTP;
actions(:,:,21) = CMFrHTP;


% Define labels of trim state solution
incogs = {'Theta' 'Phi' ...
          'theta0' 'theta1C' 'theta1S' ...
          'theta0tr' ...
          'beta0' 'beta1C' 'beta1S' ...
          'lambda0' 'lambda1C' 'lambda1S' ...
          'CT0' 'CT1C' 'CT1S' ...
          'beta0tr' 'beta1Ctr' 'beta1Str' ...
          'lambda0tr' 'lambda1Ctr' 'lambda1Str' ...
          'CT0tr' 'CT1Ctr' 'CT1Str' ...
          };

for i = 1:ndof
    trimState.(incogs{i}) = x(i,:);
end


% Duplicate trim state data with trim state solution x 
% in order to ease the postprocess and stability and control treatment
trimState.x = x;


% Define actions by elements
elements = {'weight' ...
            'mainRotor' 'tailRotor' 'fuselage' ...
            'verticalFin' 'leftHTP' 'rightHTP'};
forces   = {'CFx' 'CFy' 'CFz'};
moments  = {'CMx' 'CMy' 'CMz'};
moments2 = {'CMFx' 'CMFy' 'CMFz'};
moments3 = {'CMtx' 'CMty' 'CMtz'};

for i = 1:7
    for j = 1:3
        trimState.(elements{i}).(forces{j})   = actions (j,:,3*(i-1)+1);
        trimState.(elements{i}).(moments{j})  = actions (j,:,3*(i-1)+2);
        trimState.(elements{i}).(moments2{j}) = actions (j,:,3*(i-1)+3);
        trimState.(elements{i}).(moments3{j}) = actions (j,:,3*(i-1)+2) + actions (j,:,3*(i-1)+3);
    end
end

% Flight condition
trimState.mux        = flightConditionT(1,:);
trimState.muy        = flightConditionT(2,:);
trimState.muz        = flightConditionT(3,:);

% Velocities Struct
trimState.vel        = vel;

% Compute power
% This add-on is debatable because up to the next line getHeTrimState
% computes non dimensional variables and due to the next line computes 
% a dimensional variable like power. This is embarrasing but until we do 
% not define a dimensional trim state and because we need the power to 
% compare with HA2 practical projects and compare power computation 
% from energy model we decided to go this non consistent route
cq                   = getCQndHe(ndHe,trimState,options);
trimState.CQmr       = cq.CQmr;
trimState.CQtr       = cq.CQtr;
trimState.CQ         = cq.CQ;
trimState.power      = cq.power;

end




function CQ = getCQndHe(ndHe,ts,options)



% List of assignments
Pu       = ndHe.Pu;
Wmr_tr   = ndHe.rAngVel;

GT       = options.GT;
trM      = options.trMoments;


fCA      = ts.vel.A;
fCAtr    = ts.vel.Atr;
% Get the number of trim state solutions
nts      = size(fCA,2);
zeroes   = zeros(1,nts);

muWA     = ts.vel.WA;
muWAtr   = ts.vel.WAtr;

beta     = [ts.beta0;ts.beta1C;ts.beta1S];
theta    = [ts.theta0;ts.theta1C;ts.theta1S];
lambda   = [ts.lambda0;ts.lambda1C;ts.lambda1S];

betatr   = [ts.beta0tr;ts.beta1Ctr;ts.beta1Str];
thetatr  = [ts.theta0tr;zeroes;zeroes];
lambdatr = [ts.lambda0tr;ts.lambda1Ctr;ts.lambda1Str];

epsx     = ndHe.geometry.epsilonx;
epsy     = ndHe.geometry.epsilony;


% Initialise transformation matrices
MAF      = TAF(epsx,epsy);
MAtrF    = TAtrF(ndHe.geometry.thetatr);

% Main loop
CQmr     = zeros(1,nts);
CQtr     = zeros(1,nts);
CQ       = zeros(1,nts);
power    = zeros(1,nts);

for i = 1:nts
MFT      = TFT(0,ts.Theta(i),ts.Phi(i));


% Transforms vectors
GA       = MAF*MFT*[0;0;GT];
GAtr     = MAtrF*MFT*[0;0;GT];


[CMFai, CMFa0, CMaEi, CMaE0, CMFi, CMiE, CMgE, CMel] = ...
trM(beta(:,i),theta(:,i),lambda(:,i),fCA(:,i),muWA(:,i),GA,ndHe.mainRotor);

CMA = CMFai+ CMaEi+ CMFa0 + CMaE0 + CMFi + CMiE + CMgE + CMel;

[CMFaitr, CMFa0tr, CMaEitr, CMaE0tr, CMFitr, CMiEtr, CMgEtr, CMeltr] = ...
trM(betatr(:,i),thetatr(:,i),lambdatr(:,i),fCAtr(:,i),muWAtr(:,i),GAtr,ndHe.tailRotor);

CMAtr = CMFaitr+ CMaEitr+ CMFa0tr + CMaE0tr + CMFitr + CMiEtr + CMgEtr + CMeltr;

% power(i)   = -Pu*CMA(3) - Pu*Wmr_tr*ndHe.rMoments*CMAtr(3);
CQmr(i)  = CMA(3);
CQtr(i)  = Wmr_tr*ndHe.rMoments*CMAtr(3);
CQ(i)    = CQmr(i) + CQtr(i);
power(i) = -CQ(i)*Pu; % FIXME: this should be handled at dimensional transformation

end

CQ    = struct(...
'CQmr',CQmr,...
'CQtr',CQtr,...
'CQ',CQ,...
'power',power ...
);

end
