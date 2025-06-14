function stabilityState = getndHeLinearStabilityState(ndts,muWT,ndHe,varargin)
%getndHeLinearStabilityState gets a non dimensional linear stability state
%
%   ndSs = getndHeLinearStabilityState(ndTs,muWT,ndHe,options) gets a
%   nondimensional linear stability state, ndSs, for a given non
%   dimensional trim state, ndTs,nondimensional wind vector, muWT, and a 
%   nondimensional rigid helicopter ndHe. A non dimensional linear 
%   stability state, ndSs, is basically formed by:
%
%       -the nd trim state ndTs,
%       -the nd stability matrix, ndA,
%       -the nd control matrix, ndB,
%       -the nd stability derivatives,
%       -the nd control derivatives.
%       -the nd eigenvalues of ndA, ndsi
%       -the nd eigenvector matrix, of ndA ndW
%  
% Additional analysis of the longitudinal and lateral subproblems are
% performed so the stability matrixes ndALO and ndALA are calculared and
% the corresponding longitudinal and lateral eigen values and eigenvector
% matrixes are calculated.
%
% Also, both, the nd sability derivatives and nd control derivatives are
% calculated for each element of the aircraft.
%
% The units used for nondimensionalisation are
%
% time             : inverse of main rotor angular velocity 1/Omega
% angular velocity : main rotor angular velocity Omega.
% length           : main rotor radious R.
% velocity         : main rotor tip speed Omega*R.
% force            : characteristic thrust Tu.
% moment           : characteristic torque Qu.
%
% All values are calculated at the corresponding flight altitude and for
% the true flight angular velocity of the main rotor.
% 
% 
% The linear dynamic system is
%
%    dx/dt = Ax+Bu
%
% with x the state vector x = [u,w,oy,Th,v,ox,Ph,ox,Ps] ordered in longi-
% tudinal-lateral order and u = [t0,t1S,t1C,t0tr] the control vector orde-
% red in the same way
%
% The order of the nd stability matrix ndA therefore is:
%
%              u  |  w  |  oy  |  Th   ||  v  |  ox  |  Ph  |  ox  |  Ps  | 
%(du/dt) :F1 |    |     |      |       ||     |      |      |      |      | 
%(dw/dt) :F2 |                         ||
%(doy/dt):F3 |           ndALO         ||              ndA12
%(dTh/dt):F4 |                         ||
%--------------------------------------------------------------------------
%(dv/dt) :F5 |                         ||
%(dox/dt):F6 |                         ||
%(dPh/dt):F7 |            ndA21        ||               ndALA
%(doz/dt):F8 |                         ||
%(dPs/dt):F9 |                         ||
%
%
%The order of the nd stability matrix ndB therefore is:
%
%               t0  |  t1S  ||  t1C  |  t0tr  |  
%(du/dt) :F1 |              
%(dw/dt) :F2 |              ||
%(doy/dt):F3 |    ndBLO     ||     ndB12 
%(dTh/dt):F4 |              ||
%-----------------------------------------------
%(dv/dt) :F5 |              ||
%(dox/dt):F6 |              ||
%(dPh/dt):F7 |    ndB21     ||     ndBLA  
%(doz/dt):F8 |              ||
%(dPs/dt):F9 |              ||

%   matrix, ndA, is a [neq x ssv x sizeTs] matrix in which neq=9, is
%   the number f equations, ssv=9, is the length of the state vector, and
%   sizeTs is the dimension of the nd trim state from which the
%   linear stability state has been computed.
%  
%   The nondimensional control matrix, ndB, is a [neq x ssv x sizeTs] 
%   matrix in which scv=4, is the length of the control vector.
%
%   The eigenvalue problem is solved for ndA, ndALO and ndALA using
%   functions eig.m (c) and eigenshuffle.m (c). In the case of eig.m the
%   eigenvalues and eigenvectors can change its order for one nd trim
%   state case to another. In the case of eigenshuffle.m the order of the
%   eigenvalues and eigenvectors are tried to be keep for one case of nd
%   trim state to the next, so eigenvalues and eigenvector tracking can
%   be performed in a easier way.
%
%   The ordering of eigenvalues and eigenvector has been succesfully 
%   verified for different one dimensional nd trim states, for instance
%   when evaluating the evolution of eigenvalues for different values
%   of nd flight speed V/OR. However it has been verified that the order 
%   eigenvalues and eigenvectors can not be assured by eigenshuffle.m for
%   two (or more) dimension nd trim states, for instante when calculating
%   the evolution of eigenvalues for for different values of nd flight
%   speed V/OR and different climb angles, in this case the order of the
%   eigenvalues can be lost when passing from (VOR(end),gammaT(1)) to 
%   (VOR(1),gammaT(2)).
%   
%   Another difference between eig.m and eigenshuffle.m is that in the 
%   fisrt case a nd stability matrix ndA(9 9) is used (so including the
%   last colunm of 0 values which produced the s=0 eigen vector). In the
%   case of eigenshuffle.m good conditioning requires to work with 
%   ndA(8 8), both last row and column are eliminated and s=0 is not
%   produced.
%
%   The nondimensional stability state SS is a structure with the 
%   following fields:
%
%                   Ts: [1x1 struct]
%                   A: [9 9 nTs double]
%                   B: [9 4 nTs double]
%                 ALO: [4 4 nTs double]
%                 A12: [4 5 nTs double]
%                 A21: [5 4 nTs double]
%                 ALA: [5 5 nTs double]
%                 BLO: [9 2 nTs double]
%                 B12: [4 2 nTs double]
%                 B21: [5 2 nTs double]
%                 BLA: [5 2 nTs double]
%        staDerMatrix: [1x1 struct]
%        conDerMatrix: [1x1 struct]
%              staDer: [1x1 struct]
%              conDer: [1x1 struct]
%                eigW: [9 9 nTs double]
%              eigWLO: [4 4 nTs double]
%              eigWLA: [5 5 nTs double]
%                  si: [9 nTs double]
%                siLO: [4 nTs double]
%                siLA: [5 nTs double]
%            eigenVal: [1x1 struct]
%          eigenValLO: [1x1 struct]
%          eigenValLA: [1x1 struct]
%              eigWtr: [8 8 nTs double]
%            eigWLOtr: [4 4 nTs double]
%            eigWLAtr: [4 4 nTs double]
%                siTr: [8 nTs double]
%              siLOtr: [4 4 nTs double]
%              siLAtr: [4 4 nTs double]
%          eigenValTr: [1x1 struct]
%        eigenValLOtr: [1x1 struct]
%        eigenValLAtr: [1x1 struct]
%           charValTr: [1x1 struct]
%         charValLOTr: [1x1 struct]
%         charValLATr: [1x1 struct]
%
%
% Ts [1x1 struct]: is the dimensional trim state. see Also getNdHeTrimState
%
% staDerMatrix [1x1 struct]: is a structure whith the fields:
%
%              AllElements: [6 9 nTs double]
%       AllElementsFromSum: [6 9 nTs double]
%                mainRotor: [6 9 nTs double]
%                tailRotor: [6 9 nTs double]
%                 fuselage: [6 9 nTs double]
%              verticalFin: [6 9 nTs double]
%                  leftHTP: [6 9 nTs double]
%                 rightHTP: [6 9 nTs double]
% 
% corresponding to the matrixes of nd stability derivarives for the
% whole vechicle (AllElements and AllElementsFromSum) and by elements.
%
% The order of the nd stability derivative matrix is
%  
%    Fx_u | Fx_w| Fx_omy|Fx_The | Fx_v|Fx_omx | Fx_Phi | Fx_omz | Fx_Psi
%    Fz_u | Fz_w| Fz_omy|Fz_The | Fz_v|Fz_omx | Fz_Phi | Fz_omz | Fz_Psi
%    My_u | My_w| My_omy|My_The | My_v|My_omx | My_Phi | My_omz | My_Psi
%    Fy_u | Fy_w| Fy_omy|Fy_The | Fy_v|Fy_omx | Fy_Phi | Fy_omz | Fy_Psi
%    Mzx_u|Mzx_w|Mzx_omy|Mzx_The|Mzx_v|Mzx_omx| Mzx_Phi| Mzx_omz| Mx_Psi
%    Mxz_u|Mxz_w|Mxz_omy|Mxz_The|Mxz_v|Mxz_omx| Mxz_Phi| Mxz_omz| Mxz_Psi 
%
% conDerMatrix [1x1 struct]: is a structure whith the fields:
%
%              AllElements: [6 4 nTs double]
%       AllElementsFromSum: [6 4 nTs double]
%                mainRotor: [6 4 nTs double]
%                tailRotor: [6 4 nTs double]
%                 fuselage: [6 4 nTs double]
%              verticalFin: [6 4 nTs double]
%                  leftHTP: [6 4 nTs double]
%                 rightHTP: [6 4 nTs double]
% 
% corresponding to the matrixes of nd control derivarives for the
% whole vechicle (AllElements and AllElementsFromSum) and by elements.
%
% The order of the nd stability derivative matrix is
%  
%                  Fx_t0,  Fx_t1S,  Fx_t1C,  Fx_t0tr
%                  Fz_t0,  Fz_t1S,  Fz_t1C,  Fz_t0tr
%                  My_t0,  My_t1S,  My_t1C,  My_t0tr
%                  Fy_t0,  Fy_t1S,  Fy_t1C,  Fy_t0tr
%                  Mzx_t0, Mzx_t1S, Mzx_t1C, Mzx_t0tr
%                  Mxz_t0, Mxz_t1S, Mxz_t1C, Mxz_t0tr
%
%
%   Example of usage:
%   Obtain the nondimensional stability derivative Mw variation with 
%   forward speed for the three helicopters Bo105, Lynx and Puma as 
%   defined by [1]
%   atm                   = getISA;
%   myhe                  = {@rigidBo105,@rigidLynx,@rigidPuma};
%   ndV                   = linspace(.01, .3, 11);
%   n                     = length(ndV);
%   muWT                  = [0; 0; 0];
%   fCT      = zeros(6,n);
%   fCT(1,:) = ndV(:);
%   ss    = cell(length(myhe),1);
%   for i = 1:length(myhe)
%   he      = myhe{i}(atm);
%   ndHe    = rigidHe2ndHe(he,atm,0);
%   ts             = getTrimState(fCT,muWT,ndHe);
%   ss{i}             = getLinearStabilityState(ts,fCT,muWT,ndHe);
%   end
%
%   Now plot the stability derivative variation with  nondimensional 
%   forward speed
%   figure(1)
%   plot(ndV,ss{1}.Mw,'r-'); hold on;
%   plot(ndV,ss{2}.Mw,'b-.'); hold on;
%   plot(ndV,ss{3}.Mw,'m--'); hold on;
%   xlabel('V/(\Omega R) [-]'); ylabel('C''_{My,\mu_w} [-]')
%   legend({'Bo105','Lynx','Puma'},'Location','Best')
%
%   Note that this figure is the nondimensional equivalent plot of figure
%   2.226 page 44 of reference [1].
%
%   References
%
%   [1] G.D. Padfield Helicopter Flight Dynamics 1996
%
%   
%   See also getTrimState, plotStabilityDerivatives, plotControlDerivatives


% Setup options
options = parseOptions(varargin,@setHeroesRigidOptions);

if iscell(ndHe)
    % Dimensions of the output ndHe
    n              = numel(ndHe);
    s              = size(ndHe);
    stabilityState = cell(s);

    % Loop using linear indexing
    for i = 1:n
        stabilityState{i}    = getndHeLinearStabilityState_i(ndts{i},muWT,ndHe{i},options);
    end

else
    stabilityState    = getndHeLinearStabilityState_i(ndts,muWT,ndHe,options);
end

end

function stabilityState = getndHeLinearStabilityState_i(ndts,muWT,ndHe,varargin)
options   = parseOptions(varargin,@setHeroesRigidOptions);

% Define number of trim states
%n = size(flightConditionT,2);Old Nano

% Old Nano Assign trim state solution matrix
%x       = ts.x;

%==========================================================================
%NEW ALVARO TRIM STATE SOLUTION MATRIX
%Convert struct of solutions to cell. MOVE THIS TO A FUNCTION

if strcmp(ndts.class,'ndHeTrimState')
   % ts input is a full ndHeTrimState (included solution substructure)
   ndtssol = ndts.solution;
elseif strcmp(ndts.class,'GeneralNdHeTrimSolution')
   % ts input is the solution substructure of a ndHeTrimState
   ndtssol = ndts;
else
   error('getndHeLinearStabilityState: wrong data class input')
end
x          = struct2cell(ndtssol);
x          = x(2:end);


% 
xM2D = zeros(length(x),numel(x{1}));
 
for xi = 1:length(x);
     
    xM = x{xi};
     
    for m = 1:numel(xM)
     
    xM2D(xi,m) = xM(m);
     
    end
     
end

x = xM2D;

%n = size(x,2);


% Number of forces and moments
nfm = 6;

% Number of equations
neq  = 9;
% Size of state vector
ssv  = 9;
% Size of control vector
scv  = 4;


%==========================================================================
%Detemination of sizes of different results
%==========================================================================

% sizeTs = size(ts.solution.Theta);
sizeTs = size(ndtssol.Theta);

sizendA   = [neq ssv sizeTs];%New Alvaro
sizendALO = [4 4 sizeTs];%New Alvaro
sizendA12 = [4 5 sizeTs];%New Alvaro
sizendA21 = [5 4 sizeTs];%New Alvaro
sizendALA = [5 5 sizeTs];%New Alvaro

sizesi    = [ssv sizeTs];
sizesiLO  = [4 sizeTs];
sizesiLA  = [5 sizeTs];


sizendB   = [neq scv sizeTs];%New Alvaro
sizendBLO = [4 2 sizeTs];%New Alvaro
sizendB12 = [4 2 sizeTs];%New Alvaro
sizendB21 = [5 2 sizeTs];%New Alvaro
sizendBLA = [5 2 sizeTs];%New Alvaro

sizendSD  = [nfm ssv sizeTs];%New Alvaro
sizendCD  = [nfm scv sizeTs];%New Alvaro

%==========================================================================

%==========================================================================
% Allocate main output variables
%==========================================================================

%ndA  = zeros(neq,ssv,n);%Old Nano
%errA = zeros(neq,ssv,n);%Old Nano

ndA  = zeros(sizendA);%New Alvaro
errA = zeros(sizendA);%New Alvaro

% A    = zeros(neq,ssv,n);
%ndB    = zeros(neq,scv,n);%Old Nano
%errB = zeros(neq,scv,n);%Old Nano

ndB  = zeros(sizendB);%New Alvaro
errB = zeros(sizendB);%New Alvaro

ndSD  = zeros(sizendSD);%New Alvaro
errSD = zeros(sizendSD);%New Alvaro

ndSDmr   = zeros(sizendSD);%New Alvaro
ndSDtr   = zeros(sizendSD);%New Alvaro
ndSDf    = zeros(sizendSD);%New Alvaro
ndSDvf   = zeros(sizendSD);%New Alvaro
ndSDlHTP = zeros(sizendSD);%New Alvaro
ndSDrHTP = zeros(sizendSD);%New Alvaro
ndSDSum  = zeros(sizendSD);%New Alvaro

ndCD  = zeros(sizendCD);%New Alvaro
errCD = zeros(sizendCD);%New Alvaro

ndCDmr   = zeros(sizendCD);%New Alvaro
ndCDtr   = zeros(sizendCD);%New Alvaro
ndCDf    = zeros(sizendCD);%New Alvaro
ndCDvf   = zeros(sizendCD);%New Alvaro
ndCDlHTP = zeros(sizendCD);%New Alvaro
ndCDrHTP = zeros(sizendCD);%New Alvaro
ndCDSum  = zeros(sizendCD);%New Alvaro


ndALO = zeros(sizendALO);
ndA12 = zeros(sizendA12);
ndA21 = zeros(sizendA21);
ndALA = zeros(sizendALA);

ndBLO = zeros(sizendBLO);
ndB12 = zeros(sizendB12);
ndB21 = zeros(sizendB21);
ndBLA = zeros(sizendBLA);

eigW    = zeros(sizendA);
eigWLO  = zeros(sizendALO);
eigWLA  = zeros(sizendALA);

si      = zeros(sizesi);
siLO    = zeros(sizesiLO);
siLA    = zeros(sizesiLA);

s1 = zeros(sizeTs);
s2 = zeros(sizeTs);
s3 = zeros(sizeTs);
s4 = zeros(sizeTs);
s5 = zeros(sizeTs);
s6 = zeros(sizeTs);
s7 = zeros(sizeTs);
s8 = zeros(sizeTs);
s9 = zeros(sizeTs);

s1LO = zeros(sizeTs);
s2LO = zeros(sizeTs);
s3LO = zeros(sizeTs);
s4LO = zeros(sizeTs);

s1LA = zeros(sizeTs);
s2LA = zeros(sizeTs);
s3LA = zeros(sizeTs);
s4LA = zeros(sizeTs);
s5LA = zeros(sizeTs);


[SDnames,CDnames] = SCDnames;

for s = 1:length(SDnames);
   
        ndStaDer.(SDnames{s}) = zeros(sizeTs);
      ndStaDerMr.(SDnames{s}) = zeros(sizeTs);
      ndStaDerTr.(SDnames{s}) = zeros(sizeTs);
       ndStaDerF.(SDnames{s}) = zeros(sizeTs);
      ndStaDerVf.(SDnames{s}) = zeros(sizeTs);
    ndStaDerLHTP.(SDnames{s}) = zeros(sizeTs);
    ndStaDerRHTP.(SDnames{s}) = zeros(sizeTs);
    
     ndStaDerSum.(SDnames{s}) = zeros(sizeTs);
    
end

for c = 1:length(CDnames);
   
        ndConDer.(CDnames{c}) = zeros(sizeTs);
      ndConDerMr.(CDnames{c}) = zeros(sizeTs);
      ndConDerTr.(CDnames{c}) = zeros(sizeTs);
       ndConDerF.(CDnames{c}) = zeros(sizeTs);
      ndConDerVf.(CDnames{c}) = zeros(sizeTs);
    ndConDerLHTP.(CDnames{c}) = zeros(sizeTs);
    ndConDerRHTP.(CDnames{c}) = zeros(sizeTs);
    
     ndConDerSum.(CDnames{c}) = zeros(sizeTs);
    
end
%========================================================================== 


%==========================================================================
% Assign generalized trim control and state vectors
%==========================================================================

u_e      = x(3:6,:);%New ALVARO
x_e      = x(7:end,:);%New ALVARO

% Assign euler angles
% % % % % % % % % Psie      = ts.solution.Psi;%ALVARO
% % % % % % % % % Thetae    = ts.solution.Theta;%ALVARO
% % % % % % % % % Phie      = ts.solution.Phi;%ALVARO
% % % % % % % % % ueOR      = ts.solution.ueOR;%ALVARO
% % % % % % % % % veOR      = ts.solution.veOR;%ALVARO
% % % % % % % % % weOR      = ts.solution.weOR;%ALVARO
% % % % % % % % % omxade    = ts.solution.omxad;%ALVARO
% % % % % % % % % omyade    = ts.solution.omyad;%ALVARO
% % % % % % % % % omzade    = ts.solution.omzad;%ALVARO
% % % % % % % % % cse       = ts.solution.cs;%ALVARO
% % % % % % % % % 
% % % % % % % % % theta0e   = ts.solution.theta0;%ALVARO
% % % % % % % % % theta1Ce  = ts.solution.theta1C;%ALVARO
% % % % % % % % % theta1Se  = ts.solution.theta1S;%ALVARO
% % % % % % % % % theta0tre = ts.solution.theta0tr;%ALVARO
Psie      = ndtssol.Psi;%OSCAR
Thetae    = ndtssol.Theta;%OSCAR
Phie      = ndtssol.Phi;%OSCAR
ueOR      = ndtssol.ueOR;%OSCAR
veOR      = ndtssol.veOR;%OSCAR
weOR      = ndtssol.weOR;%OSCAR
omxade    = ndtssol.omxad;%OSCAR
omyade    = ndtssol.omyad;%OSCAR
omzade    = ndtssol.omzad;%OSCAR
cse       = ndtssol.cs;%OSCAR

theta0e   = ndtssol.theta0;%OSCAR
theta1Ce  = ndtssol.theta1C;%OSCAR
theta1Se  = ndtssol.theta1S;%OSCAR
theta0tre = ndtssol.theta0tr;%OSCAR


nFC = numel(Thetae);
%==========================================================================

%==========================================================================
% Main loop in flight conditions
%==========================================================================

disp('... Getting linear stability states ...')


for i = 1:nFC
    
    
    disp (['Solving Stability...  ',num2str(i),' of ',...
          num2str(numel(Thetae))]);
        
    
    %----------------------------------------------------------------------
    % Transformation of non-dimensional wind vector in the fuselage
    % reference system
    %----------------------------------------------------------------------
    MFT     = TFT(Psie(i),Thetae(i),Phie(i));
    muWV    = MFT*muWT;
    %----------------------------------------------------------------------

    
    %----------------------------------------------------------------------
    % Indexing of trim general state and control vectors
    %----------------------------------------------------------------------
    x_ei = x_e(:,i);
    %----------------------------------------------------------------------
    %ALVARO: We work with the control vector in the flight mechanic order
    %t0,t1S,t1C,t0tr so the control derivatives are obtained in the 
    %inside getStabilityEquations and getNdExternalActions we
    %change the main rotor control orders from the flight
    %mechanic order t0,t1S,t1C,t0tr to the aeromechanic order
    %t0,t1C,t1S,t0tr
    %----------------------------------------------------------------------
    u_ei = [u_e(1,i);u_e(3,i);u_e(2,i);u_e(4,i)];
    
    
    %----------------------------------------------------------------------
    % JACOBIAN VERSUS FLIGHT MECHANICS STATE VARIABLES
    %----------------------------------------------------------------------
    
    F = @(X)getStabilityEquations(0,X,u_ei,muWV,x_ei,ndHe,options);
        
    % Definition of flight mechanic trim state vector in LO-LA order
    X_e = [ueOR(i);weOR(i);omyade(i);Thetae(i);...
           veOR(i);omxade(i);Phie(i);omzade(i);Psie(i)]; 
        
    % Jacobian calculation   
    [ndOutSD(:,:),errOutSD(:,:)] = jacobianest(F,X_e);
        
    
    %----------------------------------------------------------------------
    % Extract nondimensional stability matrix ndA F(1:9)
    %----------------------------------------------------------------------
    
    ndA(:,:,i)   = ndOutSD((1:9),(1:9));
    errA(:,:,i)  = errOutSD((1:9),(1:9));
    
    ndALO(:,:,i) = ndOutSD((1:4),(1:4));
    ndALA(:,:,i) = ndOutSD((5:9),(5:9));
    
    ndA12(:,:,i) = ndOutSD((1:4),(5:9));
    ndA21(:,:,i) = ndOutSD((5:9),(1:4));
    
    % Stability matrix in linear order for eigenvalues tranking
    ndAtrack(:,:,i)   = ndOutSD((1:8),(1:8));
    ndALOtrack(:,:,i) = ndOutSD((1:4),(1:4));
    ndALAtrack(:,:,i) = ndOutSD((5:8),(5:8));

    %----------------------------------------------------------------------
    % Matrix of complete vehicle stability derivatives F(10:15)
    %----------------------------------------------------------------------

    ndSD(:,:,i)  = ndOutSD((10:15),(1:9));
    errSD(:,:,i) = errOutSD((10:15),(1:9));

    %----------------------------------------------------------------------
    % Matrix of main rotor contribution to stability derivatives F(16:21)
    %----------------------------------------------------------------------

    ndSDmr(:,:,i)  = ndOutSD((16:21),(1:9));
    errSDmr(:,:,i) = errOutSD((16:21),(1:9));

    %----------------------------------------------------------------------
    % Matrix of tail rotor contribution to stability derivatives F(22:27)
    %----------------------------------------------------------------------

    ndSDtr(:,:,i)  = ndOutSD((22:27),(1:9));
    errSDtr(:,:,i) = errOutSD((22:27),(1:9));
    
    
    %----------------------------------------------------------------------
    % Matrix of fuselage contribution to stability derivatives F(28:33)
    %----------------------------------------------------------------------

    ndSDf(:,:,i)  = ndOutSD((28:33),(1:9));
    errSDf(:,:,i) = errOutSD((28:33),(1:9));
    
    %----------------------------------------------------------------------
    % Matrix of vert. fin  contribution to stability derivatives F(34:39)
    %----------------------------------------------------------------------

    ndSDvf(:,:,i)  = ndOutSD((34:39),(1:9));
    errSDvf(:,:,i) = errOutSD((34:39),(1:9));
    
    %----------------------------------------------------------------------
    % Matrix of lHTP contribution to stability derivatives F(40:45)
    %----------------------------------------------------------------------

    ndSDlHTP(:,:,i)  = ndOutSD((40:45),(1:9));
    errSDlHTP(:,:,i) = errOutSD((40:45),(1:9));
        
    %----------------------------------------------------------------------
    % Matrix of rHTP contribution to stability derivatives F(46:51)
    %----------------------------------------------------------------------

    ndSDrHTP(:,:,i)  = ndOutSD((46:51),(1:9));
    errSDrHTP(:,:,i) = errOutSD((46:51),(1:9));
    
    %----------------------------------------------------------------------
    % Matrix of summed contributions to stability derivatives
    %----------------------------------------------------------------------
    
    ndSDSum(:,:,i) = ndSDmr(:,:,i)+ndSDtr(:,:,i)+ndSDf(:,:,i)+...
                     ndSDvf(:,:,i)+ndSDlHTP(:,:,i)+ndSDrHTP(:,:,i);
    
    %----------------------------------------------------------------------
    % JACOBIAN VERSUS CONTROL VARIABLES
    %----------------------------------------------------------------------
        
    F = @(U)getStabilityEquations(0,X_e,U,muWV,x_ei,ndHe,options);
                   
    % Definition of flight mechanic trim control vector in LO-LA order
    U_e = [theta0e(i);theta1Se(i);theta1Ce(i);theta0tre(i)];
    
    % Jacobian calculation 
    [ndOutCD(:,:),errOutCD(:,:)] = jacobianest(F,U_e);
    
    %----------------------------------------------------------------------
    % Extract nondimensional control matrix ndB F(1:9)
    %----------------------------------------------------------------------
    
    ndB(:,:,i) = ndOutCD((1:9),(1:4));
    errB(:,:,i) = errOutCD((1:9),(1:4));
    
    ndBLO(:,:,i) = ndOutCD((1:4),(1:2));
    ndBLA(:,:,i) = ndOutCD((5:9),(3:4));
    
    ndB12(:,:,i) = ndOutCD((1:4),(3:4));
    ndB21(:,:,i) = ndOutCD((5:9),(1:2));

    %----------------------------------------------------------------------
    % Matrix of complete vehicle control derivatives F(10:15)
    %----------------------------------------------------------------------

    ndCD(:,:,i)  = ndOutCD((10:15),(1:4));
    errCD(:,:,i) = errOutCD((10:15),(1:4));

    %----------------------------------------------------------------------
    % Matrix of main rotor contribution to control derivatives F(16:21)
    %----------------------------------------------------------------------

    ndCDmr(:,:,i)  = ndOutCD((16:21),(1:4));
    errCDmr(:,:,i) = errOutCD((16:21),(1:4));

    %----------------------------------------------------------------------
    % Matrix of tail rotor contribution to control derivatives F(22:27)
    %----------------------------------------------------------------------

    ndCDtr(:,:,i)  = ndOutCD((22:27),(1:4));
    errCDtr(:,:,i) = errOutCD((22:27),(1:4));
        
    %----------------------------------------------------------------------
    % Matrix of fuselage contribution to control derivatives F(28:33)
    %----------------------------------------------------------------------

    ndCDf(:,:,i)  = ndOutCD((28:33),(1:4));
    errCDf(:,:,i) = errOutCD((28:33),(1:4));
    
    %----------------------------------------------------------------------
    % Matrix of vert. fin  contribution to control derivatives F(34:39)
    %----------------------------------------------------------------------

    ndCDvf(:,:,i)  = ndOutCD((34:39),(1:4));
    errCDvf(:,:,i) = errOutCD((34:39),(1:4));
    
    %----------------------------------------------------------------------
    % Matrix of lHTP contribution to control derivatives F(40:45)
    %----------------------------------------------------------------------

    ndCDlHTP(:,:,i)  = ndOutCD((40:45),(1:4));
    errCDlHTP(:,:,i) = errOutCD((40:45),(1:4));
    
    %----------------------------------------------------------------------
    % Matrix of rHTP contribution to control derivatives F(46:51)
    %----------------------------------------------------------------------

    ndCDrHTP(:,:,i)  = ndOutCD((46:51),(1:4));
    errCDrHTP(:,:,i) = errOutCD((46:51),(1:4));
    
    %----------------------------------------------------------------------
    % Matrix of summed contributions to stability derivatives
    %----------------------------------------------------------------------
    
    ndCDSum(:,:,i) = ndCDmr(:,:,i)+ndCDtr(:,:,i)+ndCDf(:,:,i)+...
                     ndCDvf(:,:,i)+ndCDlHTP(:,:,i)+ndCDrHTP(:,:,i);
    
                    
    %----------------------------------------------------------------------
    % Eigen values and eigen vectors calulations
    %----------------------------------------------------------------------
     
    % Solution of the eigenvalues/eigen vector problem for the comple 
    % stability matrix A and the LO submatrix and LA submatrix
    [eigW(:,:,i),dM]     = eig(ndA(:,:,i));
    [eigWLO(:,:,i),dMLO] = eig(ndALO(:,:,i));
    [eigWLA(:,:,i),dMLA] = eig(ndALA(:,:,i));
    
     % eigenvalues indexing and structuring 
     si(:,i)   = diag(dM);
     siLO(:,i) = diag(dMLO);
     siLA(:,i) = diag(dMLA);
    
     s1(i) = si(1,i);
     s2(i) = si(2,i);
     s3(i) = si(3,i);
     s4(i) = si(4,i);
     s5(i) = si(5,i);
     s6(i) = si(6,i);
     s7(i) = si(7,i);
     s8(i) = si(8,i);
     s9(i) = si(9,i);
    
     s1LO(i) = siLO(1,i);
     s2LO(i) = siLO(2,i);
     s3LO(i) = siLO(3,i);
     s4LO(i) = siLO(4,i);
     
     s1LA(i) = siLA(1,i);
     s2LA(i) = siLA(2,i);
     s3LA(i) = siLA(3,i);
     s4LA(i) = siLA(4,i);
     s5LA(i) = siLA(5,i);
     
    %---------------------------------------------------------------------
          
    %---------------------------------------------------------------------- 
    % Generation of substruct ndStaDer with non dimensional stability
    % derivatives
    %----------------------------------------------------------------------
    
    for s = 1:length(SDnames);
   
        matrixSD = (ndSD(:,:,i))';
      matrixSDmr = (ndSDmr(:,:,i))';
      matrixSDtr = (ndSDtr(:,:,i))';
       matrixSDf = (ndSDf(:,:,i))';
      matrixSDvf = (ndSDvf(:,:,i))';
    matrixSDlHTP = (ndSDlHTP(:,:,i))';
    matrixSDrHTP = (ndSDrHTP(:,:,i))';
    matrixSDsum  = (ndSDSum(:,:,i))';    
    
    
        ndStaDer.(SDnames{s})(i) = matrixSD(s);
      ndStaDerMr.(SDnames{s})(i) = matrixSDmr(s);
      ndStaDerTr.(SDnames{s})(i) = matrixSDtr(s);
       ndStaDerF.(SDnames{s})(i) = matrixSDf(s);
      ndStaDerVf.(SDnames{s})(i) = matrixSDvf(s);
    ndStaDerLHTP.(SDnames{s})(i) = matrixSDlHTP(s);
    ndStaDerRHTP.(SDnames{s})(i) = matrixSDrHTP(s);
     ndStaDerSum.(SDnames{s})(i) = matrixSDsum(s);
       
    end 
    %----------------------------------------------------------------------
     
    %---------------------------------------------------------------------- 
    %Generation of substruct ndStaDer with non dimensional control
    %derivatives
    %---------------------------------------------------------------------- 
    
    for c = 1:length(CDnames);
   
        matrixCD = (ndCD(:,:,i))';
      matrixCDmr = (ndCDmr(:,:,i))';
      matrixCDtr = (ndCDtr(:,:,i))';
       matrixCDf = (ndCDf(:,:,i))';
      matrixCDvf = (ndCDvf(:,:,i))';
    matrixCDlHTP = (ndCDlHTP(:,:,i))';
    matrixCDrHTP = (ndCDrHTP(:,:,i))';   
     matrixCDsum = (ndCDSum(:,:,i))';    
    
      ndConDer.(CDnames{c})(i) = matrixCD(c);
    ndConDerMr.(CDnames{c})(i) = matrixCDmr(c);
    ndConDerTr.(CDnames{c})(i) = matrixCDtr(c);
     ndConDerF.(CDnames{c})(i) = matrixCDf(c);
    ndConDerVf.(CDnames{c})(i) = matrixCDvf(c);
  ndConDerLHTP.(CDnames{c})(i) = matrixCDlHTP(c);
  ndConDerRHTP.(CDnames{c})(i) = matrixCDrHTP(c);
   ndConDerSum.(CDnames{c})(i) = matrixCDsum(c);
    
    end
    
%----------------------------------------------------------------------
    
end

%==========================================================================
% Tracked eigen values and eigen vectors calulations
%==========================================================================

%--------------------------------------------------------------------------
% Solution of the tracked eigenvalues and eigenvector problem
%--------------------------------------------------------------------------
 [Wtrack,siTrack]     = eigenshuffle(ndAtrack);
 [WLOtrack,siLOTrack] = eigenshuffle(ndALOtrack);
 [WLAtrack,siLATrack] = eigenshuffle(ndALAtrack);
%--------------------------------------------------------------------------

%--------------------------------------------------------------------------
% Trakeg eigenvalues and eigenvectors allocation
%--------------------------------------------------------------------------
 eigWtr    = zeros([8 8 sizeTs]);
 eigWLOtr  = zeros([4 4 sizeTs]);
 eigWLAtr  = zeros([4 4 sizeTs]);
 
 siTr      = zeros([8 sizeTs]);
 siLOtr    = zeros([4 sizeTs]);
 siLAtr    = zeros([4 sizeTs]);
 
 s1Tr      = zeros(sizeTs);
 s2Tr      = zeros(sizeTs);
 s3Tr      = zeros(sizeTs);
 s4Tr      = zeros(sizeTs);
 s5Tr      = zeros(sizeTs);
 s6Tr      = zeros(sizeTs);
 s7Tr      = zeros(sizeTs);
 s8Tr      = zeros(sizeTs);
 s9Tr      = zeros(sizeTs);

 s1LOtr    = zeros(sizeTs);
 s2LOtr    = zeros(sizeTs);
 s3LOtr    = zeros(sizeTs);
 s4LOtr    = zeros(sizeTs);

 s1LAtr    = zeros(sizeTs);
 s2LAtr    = zeros(sizeTs);
 s3LAtr    = zeros(sizeTs);
 s4LAtr    = zeros(sizeTs);
 s5LAtr    = zeros(sizeTs);
 %-------------------------------------------------------------------------

 %=========================================================================
 % Main loop for tracked eigen values structuring
 %=========================================================================
 
for i = 1:nFC;
    
 siTr(:,i)   = siTrack(:,i);
 siLOtr(:,i) = siLOTrack(:,i);
 siLAtr(:,i) = siLATrack(:,i);
    
 s1Tr(i)     = siTrack(1,i);
 s2Tr(i)     = siTrack(2,i);
 s3Tr(i)     = siTrack(3,i);
 s4Tr(i)     = siTrack(4,i);
 s5Tr(i)     = siTrack(5,i);
 s6Tr(i)     = siTrack(6,i);
 s7Tr(i)     = siTrack(7,i);
 s8Tr(i)     = siTrack(8,i);
 s9Tr(i)     = 0;

 s1LOtr(i)   = siLOTrack(1,i);
 s2LOtr(i)   = siLOTrack(2,i);
 s3LOtr(i)   = siLOTrack(3,i);
 s4LOtr(i)   = siLOTrack(4,i);

 s1LAtr(i)   = siLATrack(1,i);
 s2LAtr(i)   = siLATrack(2,i);
 s3LAtr(i)   = siLATrack(3,i);
 s4LAtr(i)   = siLATrack(4,i);
 s5LAtr(i)   = 0;
    
 eigWtr(:,:,i)   = Wtrack(:,:,i);
 eigWLOtr(:,:,i) = WLOtrack(:,:,i);
 eigWLAtr(:,:,i) = WLAtrack(:,:,i);
 
end

%--------------------------------------------------------------------------
% Calculation of characteristic values associated to tracked eigen values
% FIXME: ALVARO, We must make something more consistent depending
% on the nature of the real and imag part of the eigenvalues
%--------------------------------------------------------------------------

 modsiTr    = abs(siTr);
 omegasiTr  = abs(imag(siTr));
 zetasiTr   = -real(siTr)./abs(imag(siTr));
 omega0siTr = omegasiTr./sqrt(1-zetasiTr.^2);
 invTausiTr = 1./real(siTr);
 t1_2siTr   = log(1/2)*(real(siTr)).^(-1);
 t2siTr     = log(2)*(real(siTr)).^(-1);
 
 modsiLOtr    = abs(siLOtr);
 omegasiLOtr  = abs(imag(siLOtr));
 zetasiLOtr   = -real(siLOtr)./abs(imag(siLOtr));
 omega0siLOtr = omegasiLOtr./sqrt(1-zetasiLOtr.^2);
 invTausiLOtr = 1./real(siLOtr);
 t1_2siLOtr   = log(1/2)*(real(siLOtr)).^(-1);
 t2siLOtr     = log(2)*(real(siLOtr)).^(-1);
 
 modsiLAtr    = abs(siLAtr);
 omegasiLAtr  = abs(imag(siLAtr));
 zetasiLAtr   = -real(siLAtr)./abs(imag(siLAtr));
 omega0siLAtr = omegasiLAtr./sqrt(1-zetasiLAtr.^2);
 invTausiLAtr = 1./real(siLAtr);
 t1_2siLAtr   = log(1/2)*(real(siLAtr)).^(-1);
 t2siLAtr     = log(2)*(real(siLAtr)).^(-1);

%==========================================================================

%==========================================================================
% Structuring the results
%==========================================================================
      
    
    
staDerMatrix = struct('AllElements',ndSD,'AllElementsFromSum',ndSDSum,...
                 'mainRotor',ndSDmr,'tailRotor',ndSDtr,...
                 'fuselage',ndSDf,'verticalFin',ndSDvf,...
                 'leftHTP',ndSDlHTP,'rightHTP',ndSDrHTP);
             
conDerMatrix = struct('AllElements',ndCD,'AllElementsFromSum',ndCDSum,...
                 'mainRotor',ndCDmr,'tailRotor',ndCDtr,...
                 'fuselage',ndCDf,'verticalFin',ndCDvf,...
                 'leftHTP',ndCDlHTP,'rightHTP',ndCDrHTP);             

staDer = struct('AllElements',ndStaDer,'AllElementsFromSum',ndStaDerSum,...
                 'mainRotor',ndStaDerMr,'tailRotor',ndStaDerTr,...
                 'fuselage',ndStaDerF,'verticalFin',ndStaDerVf,...
                 'leftHTP',ndStaDerLHTP,'rightHTP',ndStaDerRHTP);
             
conDer = struct('AllElements',ndConDer,'AllElementsFromSum',ndConDerSum,...
                 'mainRotor',ndConDerMr,'tailRotor',ndConDerTr,...
                 'fuselage',ndConDerF,'verticalFin',ndConDerVf,...
                 'leftHTP',ndConDerLHTP,'rightHTP',ndConDerRHTP);
             
eigenVal = struct('s1',s1,'s2',s2,'s3',s3,'s4',s4,'s5',s5,...
                   's6',s6,'s7',s7,'s8',s8,'s9',s9);

% In order to ease the plot of eigenvalues we have decided to make uniform
% fieldnames structures and each eigenvalue even for longitudinal or
% lateral uncoupled cases received the same name, that is si
eigenValLO = struct('s1LO',s1LO,'s2LO',s2LO,'s3LO',s3LO,'s4LO',s4LO);  
 
eigenValLA = struct('s1LA',s1LA,'s2LA',s2LA,'s3LA',s3LA,...
              's4LA',s4LA,'s5LA',s5LA);
          
           
eigenValTr = struct('s1',s1Tr,'s2',s2Tr,'s3',s3Tr,'s4',s4Tr,'s5',s5Tr,...
                   's6',s6Tr,'s7',s7Tr,'s8',s8Tr,'s9',s9Tr);
               
eigenValLOtr = struct('s1LO',s1LOtr,'s2LO',s2LOtr,...
                       's3LO',s3LOtr,'s4LO',s4LOtr);  
 
eigenValLAtr = struct('s1LA',s1LAtr,'s2LA',s2LAtr,...
                       's3LA',s3LAtr,'s4LA',s4LAtr,'s5LA',s5LAtr);
                   

charValsTr = struct('mod',modsiTr,'omega',omegasiTr,'zeta',zetasiTr,...
                  'omegaN',omega0siTr,'invTau',invTausiTr,...
                  't1_2',t1_2siTr,'t2',t2siTr);
              
charValsLOTr = struct('mod',modsiLOtr,'omega',omegasiLOtr,'zeta',zetasiLOtr,...
                  'omegaN',omega0siLOtr,'invTau',invTausiLOtr,...
                  't1_2',t1_2siLOtr,'t2',t2siLOtr);
              
charValsLATr = struct('mod',modsiLAtr,'omega',omegasiLAtr,'zeta',zetasiLAtr,...
                  'omegaN',omega0siLAtr,'invTau',invTausiLAtr,...
                  't1_2',t1_2siLAtr,'t2',t2siLAtr);
                   

stabilityState     =  struct('ndTs',ndts,...
                             'ndA',ndA, ...   
                             'ndB',ndB, ...
                             'ndALO',ndALO, ...
                             'ndA12',ndA12, ...
                             'ndA21',ndA21, ...
                             'ndALA',ndALA, ...
                             'ndBLO',ndBLO, ...
                             'ndB12',ndB12, ...
                             'ndB21',ndB21, ...
                             'ndBLA',ndBLA, ...
                             'staDerMatrix',staDerMatrix, ...
                             'conDerMatrix',conDerMatrix, ...
                             'staDer',staDer, ...
                             'conDer',conDer, ...
                             'eigW', eigW, ...
                             'eigWLO',eigWLO, ...
                             'eigWLA',eigWLA, ...
                             'si',si, ...
                             'siLO',siLO, ...
                             'siLA',siLA, ...
                             'eigenVal',eigenVal, ...
                             'eigenValLO',eigenValLO, ...
                             'eigenValLA',eigenValLA,...
                             'eigWtr', eigWtr, ...
                             'eigWLOtr',eigWLOtr, ...
                             'eigWLAtr',eigWLAtr, ...
                             'siTr',siTr, ...
                             'siLOtr',siLOtr, ...
                             'siLAtr',siLAtr, ...
                             'eigenValTr',eigenValTr, ...
                             'eigenValLOtr',eigenValLOtr, ...
                             'eigenValLAtr',eigenValLAtr,...
                             'charValTr',charValsTr,...
                             'charValLOTr',charValsLOTr,...
                             'charValLATr',charValsLATr ...
                             );


end

