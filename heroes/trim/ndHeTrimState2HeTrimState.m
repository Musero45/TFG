function Ts = ndHeTrimState2HeTrimState(ndTs,he,atm,H,varargin)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

options = parseOptions(varargin,@setHeroesRigidOptions);

ndTrimVars = {'Theta','Phi','theta0','theta1C','theta1S',...       
'theta0tr','beta0','beta1C','beta1S','lambda0',...          
'lambda1C','lambda1S','CT0','CT1C','CT1S',...                  
'beta0tr','beta1Ctr','beta1Str','lambda0tr',...
'lambda1Ctr','lambda1Str','CT0tr','CT1Ctr',...
'CT1Str','omega','Psi','uTOR','vTOR',...
'wTOR','ueOR','veOR','weOR','omxad',...
'omyad','omzad','omegaAdzT','VOR',...
'gammaT','betaT','betaf0','alphaf0','cs'};

TrimVars = {'Theta','Phi',...
            'theta0','theta1C','theta1S','theta0tr',...
            'beta0','beta1C','beta1S',...
            'ORlambda0','ORlambda1C','ORlambda1S',...
            'T0','T1C','T1S',...                  
            'beta0tr','beta1Ctr','beta1Str',...
            'ORlambda0tr','ORlambda1Ctr','ORlambda1Str',...
            'T0tr','T1Ctr','T1Str',...
            'Omega',...
            'Psi',...
            'uT','vT','wT',...
            'ue','ve','we',...
            'omx','omy','omz',...
            'omegazT',...
            'V',...
            'gammaT','betaT','betaf0','alphaf0',...
            'invRg'};


%==========================================================================
% Units generation
%==========================================================================

OmegaRated   = he.mainRotor.Omega;
OmegaRatedtr = he.tailRotor.Omega;

R            = he.mainRotor.R;
Rtr          = he.tailRotor.R;

ORrated      = OmegaRated*R;
ORratedtr    = OmegaRatedtr*Rtr;

rho          = atm.density(H);

OR           = ORrated*ndTs.solution.omega;

one          = ones(size(OR));
Orated       = OmegaRated*one;

Om           = OmegaRated*ndTs.solution.omega;
Omtr         = Om*(OmegaRatedtr/OmegaRated);

ORtr   = OR*(ORratedtr/ORrated);

Tu     = rho*pi*R^2*OR.^2;
Tutr   = rho*pi*Rtr^2*ORtr.^2;

Qu     = rho*pi*R^2*OR.^2*R;

Pu     = Qu.*Om;

invR   = (1/R)*one;


CTE = {one,one,...
       one,one,one,one,...
       one,one,one,...
       OR,OR,OR,...
       Tu,Tu,Tu,...                  
       one,one,one,...
       ORtr,ORtr,ORtr,...
       Tutr,Tutr,Tutr,...
       Orated,...
       one,...
       OR,OR,OR,...
       OR,OR,OR,...
       Om,Om,Om,...
       Om,...
       OR,...
       one,one,one,one,...
       invR};
       
       

Ts.class = 'HeTrimState';
Ts.solution.class = 'GeneralHeTrimSolution';

%--------------------------------------------------------------------------
% Giving dimensions to the solution struct
%--------------------------------------------------------------------------
for s = 1:length(TrimVars);
    
    Ts.solution.(TrimVars{s}) = ndTs.solution.(ndTrimVars{s}).*CTE{s}; 

end
%--------------------------------------------------------------------------

%--------------------------------------------------------------------------
% Adding residuals and flags to the Ts structure
%--------------------------------------------------------------------------
   Ts.residuals = ndTs.residuals;
   Ts.flags     = ndTs.flags;
%--------------------------------------------------------------------------

%--------------------------------------------------------------------------
% Adding dimensions to actions
%--------------------------------------------------------------------------
   ele   = fieldnames(ndTs.actions);
   ndAc  = fieldnames(ndTs.actions.weight.fuselage);
   
   CTE1 = {Tu,Qu,Qu,Qu,...
           Tu,Qu,Qu,Qu,...
           Tu,Qu,Qu,Qu};
   
   act = {'Fx' 'Mx' 'MFx' 'Mtx' ...
              'Fy' 'My' 'MFy' 'Mty' ...
              'Fz' 'Mz' 'MFz' 'Mtz'};
  
   for ei = 1:length(ele);
       
       for ai = 1:length(act);
       
           Ts.actions.(ele{ei}).fuselage.(act{ai}) =...
               ndTs.actions.(ele{ei}).fuselage.(ndAc{ai}).*CTE1{ai};
           
           Ts.actions.(ele{ei}).ground.(act{ai}) =...
               ndTs.actions.(ele{ei}).ground.(ndAc{ai}).*CTE1{ai}; 
   
       end
       
   end
   
   %-----------------------------------------------------------------------
   
   %-----------------------------------------------------------------------
   % Adding dimensions to velocities
   %-----------------------------------------------------------------------
   
   com  = fieldnames(ndTs.vel.A);
  
   CTE3  = {OR,OR,OR,Om,Om,Om};
   CTEtr = {ORtr,ORtr,ORtr,Omtr,Omtr,Omtr};
   
   for ci = 1:length(com)
       
       Ts.vel.A.(com{ci})    = ndTs.vel.A.(com{ci}).*CTE3{ci};
       Ts.vel.Atr.(com{ci})  = ndTs.vel.Atr.(com{ci}).*CTEtr{ci}; 
       Ts.vel.F.(com{ci})    = ndTs.vel.F.(com{ci}).*CTE3{ci}; 
       Ts.vel.vf.(com{ci})   = ndTs.vel.vf.(com{ci}).*CTE3{ci}; 
       Ts.vel.lHTP.(com{ci}) = ndTs.vel.lHTP.(com{ci}).*CTE3{ci};
       Ts.vel.rHTP.(com{ci}) = ndTs.vel.rHTP.(com{ci}).*CTE3{ci}; 
         
   end

   aircom = fieldnames(ndTs.vel.WA);
   
   for aci = 1:length(aircom);

       Ts.vel.WA.(aircom{aci})   = ndTs.vel.WA.(aircom{aci}).*CTE3{aci};
       Ts.vel.WAtr.(aircom{aci}) = ndTs.vel.WAtr.(aircom{aci}).*CTEtr{aci};
       
   end
   
      Ts.vel.xi = ndTs.vel.xi;
    
   %-----------------------------------------------------------------------   

   %-----------------------------------------------------------------------
   % Adding dimensions to nd power struct
   %-----------------------------------------------------------------------   
      
       Ts.Pow.Qmr      = ndTs.ndPow.CQmr.*Qu;
       Ts.Pow.Qtr      = ndTs.ndPow.CQtr.*Qu;
       Ts.Pow.Pmr      = ndTs.ndPow.CPmr.*Pu;
       Ts.Pow.Ptr      = ndTs.ndPow.CPtr.*Pu;
       Ts.Pow.PtLossmr = ndTs.ndPow.CPtLossmr.*Pu;
       Ts.Pow.PtLosstr = ndTs.ndPow.CPtLosstr.*Pu;
       Ts.Pow.Ptrans   = ndTs.ndPow.CPtrans.*Pu;
       Ts.Pow.P        = ndTs.ndPow.CP.*Pu;
       Ts.Pow.PM       = ndTs.ndPow.CPM.*Pu;
       Ts.Pow.etaTmr   = ndTs.ndPow.etaTmr;
       Ts.Pow.etaTtr   = ndTs.ndPow.etaTtr;
       Ts.Pow.etaTr    = ndTs.ndPow.etaTr;
       Ts.Pow.etaM     = ndTs.ndPow.etaM;
   
end


   
   
