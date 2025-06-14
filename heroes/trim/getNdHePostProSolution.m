function trimState = getNdHePostProSolution(x,r,f,muWT,ndHe,options)
%GETHETRIMSTATE  Gets an helicopter trim state
%
%   ts = getNdHePostProSolution(X,mu_w,ndHe) gets an helicopter trim state, ts,
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
%
%

% Define number of degrees of freedom
%ndof  = length(struct2cell(x))-1;

% Define the number of trim state solutions
%n = size(x,2);

% Define the dimension of each trimSolution variable
s = size(x.Theta);

% Define the number of trimSolutions (elements in each solution)
n = numel(x.Theta);


%  Assign trim state solution to meaningful variables
PsiM       = x.Psi;
ThetaM     = x.Theta;
PhiM       = x.Phi;

%beta   = [x(7,:); x(8,:); x(9,:)];

beta0M     = x.beta0;                 
beta1CM    = x.beta1C;                 
beta1SM    = x.beta1S;

%lambda     = [x(10,:); x(11,:); x(12,:)];

lambda0M   = x.lambda0;             
lambda1CM  = x.lambda1C;            
lambda1SM  = x.lambda1S;

%uTORM      = x.uTOR;
%vTORM      = x.vTOR;
%wTORM      = x.wTOR;

omegaM     = x.omega;

ueORM      = x.ueOR;
veORM      = x.veOR;
weORM      = x.weOR;

omxadM     = x.omxad;
omyadM     = x.omyad;
omzadM     = x.omzad;


trimState.class = 'ndHeTrimState';
trimState.('solution') = x;
trimState.('residuals') = r;
trimState.('flags') = f;


%Convert struct of solutions to cell
x = struct2cell(x);
x = x(2:end);

 xM2D = zeros(length(x),numel(x{1}));

for xi = 1:length(x);
    
    xM = x{xi};
    
    for m = 1:numel(xM)
    
    xM2D(xi,m) = xM(m);
    
    end
    
end


%=====================================================================
% Inicialisation of variables

% Define actions by elements
elements = {'weight' ...
            'mainRotor' 'tailRotor' 'fuselage' ...
            'verticalFin' 'leftHTP' 'rightHTP'};
        
       
forces   = {'CFx' 'CFy' 'CFz'};
moments  = {'CMx' 'CMy' 'CMz'};
moments2 = {'CMFx' 'CMFy' 'CMFz'};
moments3 = {'CMtx' 'CMty' 'CMtz'};


for ei = 1:7
     
    for cj = 1:3
        
        trimState.('actions').(elements{ei}).('fuselage').(forces{cj})   = zeros(s);
        trimState.('actions').(elements{ei}).('fuselage').(moments{cj})  = zeros(s);
        trimState.('actions').(elements{ei}).('fuselage').(moments2{cj}) = zeros(s);
        trimState.('actions').(elements{ei}).('fuselage').(moments3{cj}) = zeros(s);
        
        trimState.('actions').(elements{ei}).('ground').(forces{cj})   = zeros(s);
        trimState.('actions').(elements{ei}).('ground').(moments{cj})  = zeros(s);
        trimState.('actions').(elements{ei}).('ground').(moments2{cj}) = zeros(s);
        trimState.('actions').(elements{ei}).('ground').(moments3{cj}) = zeros(s);
        
     end
end

actions          = zeros(3,7*3);
actionsT         = zeros(3,7*3);

%fCV  = zeros(6,1);


% Initialization of velelocity elements

velElements = {'A' 'Atr' 'F' 'vf' 'lHTP' 'rHTP'};
fCcomp = {'airmux' 'airmuy' 'airmuz' 'omx' 'omy' 'omz'};

windElements = {'WA' 'WAtr'}; 
fCWindcomp = {'airmuWx' 'airmuWy' 'airmuWz'};

for velEi = 1:length(velElements)
    
    for cj = 1:length(fCcomp)
        
        trimState.('vel').(velElements{velEi}).(fCcomp{cj}) = zeros(s);
        
    end
    
end

for windEi = 1:length(windElements) 
    
      for wj = 1:length(fCWindcomp)
        
        trimState.('vel').(windElements{windEi}).(fCWindcomp{wj}) = zeros(s);
        
      end
    
end

        trimState.('vel').('xi') = zeros(s);
     
  % Initialization of ndPower Elements
       
     trimState.('ndPow').('CQmr') = zeros(s);
     trimState.('ndPow').('CQtr') = zeros(s);
     trimState.('ndPow').('CPmr') = zeros(s);
     trimState.('ndPow').('CPtr') = zeros(s);
trimState.('ndPow').('CPtLossmr') = zeros(s);
trimState.('ndPow').('CPtLosstr') = zeros(s);
  trimState.('ndPow').('CPtrans') = zeros(s); 
       trimState.('ndPow').('CP') = zeros(s);  
      trimState.('ndPow').('CPM') = zeros(s);
   trimState.('ndPow').('etaTmr') = zeros(s);
   trimState.('ndPow').('etaTtr') = zeros(s);
    trimState.('ndPow').('etaTr') = zeros(s);
     trimState.('ndPow').('etaM') = zeros(s);




% FIXME: this should be handled at dimensional transformation


%==========================================================================
% MAIN LOOP
%--------------------------------------------------------------------------

for i = 1:n
    
    MFT      = TFT(PsiM(i),ThetaM(i),PhiM(i));
    %fCV(1:3) = MFT*[uTORM(i);vTORM(i);wTORM(i)];
    %fCV(4:6) = [omxadM(i);omyadM(i);omzadM(i)];
       
    fCV      = [ueORM(i);veORM(i);weORM(i);omxadM(i);...
                omyadM(i);omzadM(i)];
    muWV     = MFT*muWT;
    lambda   = [lambda0M(i);lambda1CM(i);lambda1SM(i)];
    beta     = [beta0M(i);beta1CM(i);beta1SM(i)];

    % Compute velocities at different components
    vel = velocities(fCV,muWV,lambda,beta,ndHe,options);
    
    x = xM2D(:,i);
    
    % Get forces and moments
    % AQUI HAY UNA DIFICULTAD PORQUE X EN getHeForcesAndMoments DEBERIA SER
    % EL VECTOR DE X
 
 [CFW,...
 CFmr,CMmr,CMFmr,...
 CFtr,CMtr,CMFtr,...
 CFf,CMf,CMFf,...
 CFvf,CMvf,CMFvf,...
 CFlHTP,CMlHTP,CMFlHTP,...
 CFrHTP,CMrHTP,CMFrHTP] =  getHeForcesAndMoments(x,vel,ndHe,options);

  
% Define actions 2D matrix in fuselage frame and ground frame

actionsCell =  {CFW,zeros(3,1),zeros(3,1),CFmr,CMmr,CMFmr,CFtr,CMtr,CMFtr,...
                CFf,CMf,CMFf,CFvf,CMvf,CMFvf,CFlHTP,CMlHTP,CMFlHTP,...
                CFrHTP,CMrHTP,CMFrHTP};
 
            for aci = 1:length(actionsCell)
                
                actions(:,aci)  = actionsCell{aci};
                actionsT(:,aci) = MFT\actionsCell{aci};

            end
             
 
 for ei = 1:length(elements)
     
    for cj = 1:3
        
        trimState.('actions').(elements{ei}).('fuselage').(forces{cj})(i)   = actions (cj,3*(ei-1)+1);
        trimState.('actions').(elements{ei}).('fuselage').(moments{cj})(i)  = actions (cj,3*(ei-1)+2);
        trimState.('actions').(elements{ei}).('fuselage').(moments2{cj})(i) = actions (cj,3*(ei-1)+3);
        trimState.('actions').(elements{ei}).('fuselage').(moments3{cj})(i) = actions (cj,3*(ei-1)+2) + actions (cj,3*(ei-1)+3);
        
        trimState.('actions').(elements{ei}).('ground').(forces{cj})(i)     = actionsT (cj,3*(ei-1)+1);
        trimState.('actions').(elements{ei}).('ground').(moments{cj})(i)    = actionsT (cj,3*(ei-1)+2);
        trimState.('actions').(elements{ei}).('ground').(moments2{cj})(i)   = actionsT (cj,3*(ei-1)+3);
        trimState.('actions').(elements{ei}).('ground').(moments3{cj})(i)   = actionsT (cj,3*(ei-1)+2) + actions (cj,3*(ei-1)+3);
        
    end
    
 end
  
 % treatment of the velocities

 
 for velEi = 1:length(velElements)
    
    for cj = 1:length(fCcomp)
        
        trimState.('vel').(velElements{velEi}).(fCcomp{cj})(i)   = vel.(velElements{velEi})(cj);
        
    end
    
 end
 
 for windEi = 1:length(windElements) 
    
      for wj = 1:length(fCWindcomp)
        
        trimState.('vel').(windElements{windEi}).(fCWindcomp{wj})(i) = vel.(windElements{windEi})(wj);
        
      end
    
end
 
 trimState.('vel').('xi')(i) = vel.xi;
 
end


tS = trimState;

%=========================================================================
% ndPowerCaculations
%-------------------------------------------------------------------------

Wmr_tr   = ndHe.rAngVel;
transmission = ndHe.transmission;% ALVARO
transmissionType = transmission.transmissionType;% ALVARO

GT       = options.GT;
mrM      = options.mrMoments;
trM      = options.trMoments;


for i = 1:n
    
Pu       = ndHe.Pu*omegaM(i)^(-3);
    
fCA      = [tS.vel.A.airmux(i);...
            tS.vel.A.airmuy(i);...
            tS.vel.A.airmuz(i);...
            tS.vel.A.omx(i);...
            tS.vel.A.omy(i);...
            tS.vel.A.omz(i)];


fCAtr    = [tS.vel.Atr.airmux(i);...
            tS.vel.Atr.airmuy(i);...
            tS.vel.Atr.airmuz(i);...
            tS.vel.Atr.omx(i);...
            tS.vel.Atr.omy(i);...
            tS.vel.Atr.omz(i)];
        
% Get the number of trim state solutions
%nts      = size(fCA,2);
%zeroes   = zeros(1,nts);

muWA     = [tS.vel.WA.airmuWx(i);...
            tS.vel.WA.airmuWy(i);...
            tS.vel.WA.airmuWz(i)];
      
muWAtr   = [tS.vel.WAtr.airmuWx(i);...
            tS.vel.WAtr.airmuWy(i);...
            tS.vel.WAtr.airmuWz(i)];

beta     = [tS.solution.beta0(i);tS.solution.beta1C(i);tS.solution.beta1S(i)];
theta    = [tS.solution.theta0(i);tS.solution.theta1C(i);tS.solution.theta1S(i)];
lambda   = [tS.solution.lambda0(i);tS.solution.lambda1C(i);tS.solution.lambda1S(i)];

betatr   = [tS.solution.beta0tr(i);tS.solution.beta1Ctr(i);tS.solution.beta1Str(i)];
thetatr  = [tS.solution.theta0tr(i);0;0];
lambdatr = [tS.solution.lambda0tr(i);tS.solution.lambda1Ctr(i);tS.solution.lambda1Str(i)];

epsx     = ndHe.geometry.epsilonx;
epsy     = ndHe.geometry.epsilony;


% Initialise transformation matrices
MAF      = TAF(epsx,epsy);
MAtrF    = TAtrF(ndHe.geometry.thetatr);

% Main loop


MFT      = TFT(tS.solution.Psi(i),tS.solution.Theta(i),tS.solution.Phi(i));


% Transforms vectors
GA       = MAF*MFT*[0;0;GT];
GAtr     = MAtrF*MFT*[0;0;GT];


[CMFai, CMFa0, CMaEi, CMaE0, CMFi, CMiE, CMgE, CMel] = ...
mrM(beta,theta,lambda,fCA,muWA,GA,ndHe.mainRotor);%ALVARO BUG detected, it
% was written trM()...it would not affect the results to much but it was
% insensitive to changes in trM options calculations
%

CMA = CMFai+ CMaEi+ CMFa0 + CMaE0 + CMFi + CMiE + CMgE + CMel;

[CMFaitr, CMFa0tr, CMaEitr, CMaE0tr, CMFitr, CMiEtr, CMgEtr, CMeltr] = ...
trM(betatr,thetatr,lambdatr,fCAtr,muWAtr,GAtr,ndHe.tailRotor);

CMAtr = CMFaitr+ CMaEitr+ CMFa0tr + CMaE0tr + CMFitr + CMiEtr + CMgEtr + CMeltr;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% ALVARO: I have introduced the following change, since we refer all
%%% quantities to OR and S in the main rotor, we have that CQmr = CPmr but
%%% in the case of the tail rotor is CQtr=rMoments*KMAtr(3) and
%%% CPtr=ratVel*CQtr.
%%%
%%% I have also introduced some changes in the sings to make them coherent,
%%% i.e previously it was written CQmr(i)  = CMA(3); 
%%% CQtr(i)  = ndHe.rMoments*CMAtr(3), and P = -CQ*Pu now it is written 
%%%
%%% CQmr(i)  = -CMA(3); 
%%% CQtr(i)  = ndHe.rMoments*CMAtr(3),
%%% CP(i) = CQmr+rVel*CQtr(i) 
%%% and P = CP*Pu
%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% power(i)   = -Pu*CMA(3) - Pu*Wmr_tr*ndHe.rMoments*CMAtr(3);
CQmr = -CMA(3);
CPmr = CQmr;
CQtr = -ndHe.rMoments*CMAtr(3);
CPtr = Wmr_tr*CQtr;
CP   = CQmr + Wmr_tr*CQtr;

[CPtransmission,...
 CPtLossmr,...
 CPtLosstr] = ...
    transmissionType(CQmr,CQtr,Wmr_tr,transmission);%ALVARO

etaTmr = CPtLossmr/abs(CPmr);
etaTtr = CPtLosstr/abs(CPtr);
etaTr  = CPtr/CPmr;
etaM   = 1/(1-etaTmr)+etaTr/(1-etaTtr);

CPM    = CP+CPtransmission; 


     trimState.('ndPow').('CQmr')(i) = CQmr;
     trimState.('ndPow').('CQtr')(i) = CQtr;
     trimState.('ndPow').('CPmr')(i) = CPmr;
     trimState.('ndPow').('CPtr')(i) = CPtr;
trimState.('ndPow').('CPtLossmr')(i) = CPtLossmr;
trimState.('ndPow').('CPtLosstr')(i) = CPtLosstr;
  trimState.('ndPow').('CPtrans')(i) = CPtransmission;
       trimState.('ndPow').('CP')(i) = CP;
      trimState.('ndPow').('CPM')(i) = CPM;
   trimState.('ndPow').('etaTmr')(i) = etaTmr;
   trimState.('ndPow').('etaTtr')(i) = etaTtr;
    trimState.('ndPow').('etaTr')(i) = etaTr;
     trimState.('ndPow').('etaM')(i) = etaM;
     
     %=========================================================================  
  
end

end
