function stabilityState = getLinearStabilityState(ts,flightConditionT,muWT,ndHe,varargin)
%GETLINEARSTABILITYSTATE  Gets a non dimensional linear stability state
%
%   SS = getLinearStabilityState(TS,FC,mu_w,ndHe) gets a nondimensional 
%   linear stability state, SS, for a given non dimensional trim state, TS, 
%   flight condition FC, nondimensional wind vector, mu_w, and a 
%   nondimensional rigid helicopter. A linear stability state, SS, is
%   basically formed by the nondimensional stability matrix, ndA, and the
%   nondimensional control matrix, ndB. The nondimensional stability 
%   matrix, ndA, is a [neq x ssv x nts double] matrix in which neq=9, is
%   the number f equations, ssv=9, is the length of the state vector, and
%   nts is a variable denoting the number of trim states from which the
%   linear stability state has been computed. The nondimensional control
%   matrix, ndB, is a [neq x ssv x nts double] matrix in which scv=4, is 
%   the length of the control vector.
%
%   The nondimensional stability state SS is a structure with the 
%   following fields:
%
%      mux: [1 x nts double]
%      ndA: [neq x ssv x nts double]
%      ndB: [neq x scv x nts double]
%       Xu: [1 x nts double]
%       Xw: [1 x nts double]
%       Xq: [1 x nts double]
%       Xv: [1 x nts double]
%       Xp: [1 x nts double]
%       Xr: [1 x nts double]
%      Xt0: [1 x nts double]
%     Xt1C: [1 x nts double]
%     Xt1S: [1 x nts double]
%     Xt0T: [1 x nts double]
%       Zu: [1 x nts double]
%       Zw: [1 x nts double]
%       Zq: [1 x nts double]
%       Zv: [1 x nts double]
%       Zp: [1 x nts double]
%       Zr: [1 x nts double]
%      Zt0: [1 x nts double]
%     Zt1C: [1 x nts double]
%     Zt1S: [1 x nts double]
%     Zt0T: [1 x nts double]
%       Mu: [1 x nts double]
%       Mw: [1 x nts double]
%       Mq: [1 x nts double]
%       Mv: [1 x nts double]
%       Mp: [1 x nts double]
%       Mr: [1 x nts double]
%      Mt0: [1 x nts double]
%     Mt1C: [1 x nts double]
%     Mt1S: [1 x nts double]
%     Mt0T: [1 x nts double]
%       Yu: [1 x nts double]
%       Yw: [1 x nts double]
%       Yq: [1 x nts double]
%       Yv: [1 x nts double]
%       Yp: [1 x nts double]
%       Yr: [1 x nts double]
%      Yt0: [1 x nts double]
%     Yt1C: [1 x nts double]
%     Yt1S: [1 x nts double]
%     Yt0T: [1 x nts double]
%       Lu: [1 x nts double]
%       Lw: [1 x nts double]
%       Lq: [1 x nts double]
%       Lv: [1 x nts double]
%       Lp: [1 x nts double]
%       Lr: [1 x nts double]
%      Lt0: [1 x nts double]
%     Lt1C: [1 x nts double]
%     Lt1S: [1 x nts double]
%     Lt0T: [1 x nts double]
%       Nu: [1 x nts double]
%       Nw: [1 x nts double]
%       Nq: [1 x nts double]
%       Nv: [1 x nts double]
%       Np: [1 x nts double]
%       Nr: [1 x nts double]
%      Nt0: [1 x nts double]
%     Nt1C: [1 x nts double]
%     Nt1S: [1 x nts double]
%     Nt0T: [1 x nts double]
%
%   where the following notation has been used to especify the field names:
%   * stability derivatives are denoted by 
%      [X | Y | Z | L | M | N ] +
%      [u | v | w | p | q | r ]
%     which produces 36 stability derivatives.
%
%   * control derivatives are denoted by 
%      [X | Y  | Z  | L | M | N ] +
%      [0 | 1C | 1S | 0T ]
%     which produces 24 control derivatives.
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

options   = parseOptions(varargin,@setHeroesRigidOptions);

% Define number of trim states
n = size(flightConditionT,2);

% Assign trim state solution matrix
x       = ts.x;

% Number of equations
neq  = 9;
% Size of state vector
ssv  = 9;
% Size of control vector
scv  = 4;

% Allocate main output variables
ndA  = zeros(neq,ssv,n);
errA = zeros(neq,ssv,n);
% A    = zeros(neq,ssv,n);
ndB    = zeros(neq,scv,n);
errB = zeros(neq,scv,n);

% Assign trim control vector
u_e      = x(3:6,:);
% Assign state vector
x_e      = x(7:end,:);

% Assign euler angles
Psi      = x(1,:);
Phi      = x(2,:);


disp('... Getting linear stability states ...')

for i = 1:n
    % Transform ????
    MFT     = TFT(0,Psi(i),Phi(i));
    muV     = MFT*flightConditionT(1:3,i);
    muWV    = MFT*muWT;

    % Define function handle to point to stability equation with
    % state vector as dummy variable
    x_ei = x_e(:,i);
    u_ei = u_e(:,i);
    F    = @(X) getStabilityEquations(0,X,u_ei,muWV,x_ei,ndHe,options);

    % Define global trim state vector in longitudinal and lateral order
    X_e = [muV(1);muV(3);0;x(1,i);muV(2);0;x(2,i);0;0];

    % Compute nondimensional stability derivative matrix ndA
    [ndA(:,:,i),errA(:,:,i)] = jacobianest(F,X_e);
%     % FIXME: BUG? fifth element shouldn't be lateral velocity muV(2)?
%     X_e = [muV(1);muV(3);0;y(1,i);muV(2);0;y(2,i);0;0];
    F = @(U) getStabilityEquations(0,X_e,U,muWV,x_ei,ndHe,options);
    U_e = [x(3,i);x(4,i);x(5,i);x(6,i)];
    [ndB(:,:,i),errB(:,:,i)] = jacobianest(F,U_e);
end


% Define non dimensional linear stability state
stabilityState     = struct(...
                     'mux',flightConditionT(1,:), ...
                     'ndA',ndA,...
                     'ndB',ndB ...
);

% Add stability and control derivative matrices
stabilityState     = abMatrix2stabiliytState(stabilityState,ndA,ndB);


function stabilityStateOut = abMatrix2stabiliytState(stabilityStateIn,A,B)
% This local function is a strong candidate to be moved to
% plotStabilityDerivatives and plotControlDerivatives because the goal of
% this function is to give to stabilityState the format required by
% plotCellOfStructures to ease the plot of both stability and control
% derivatives
stabilityStateOut  = stabilityStateIn;

index = [1; 2; 3; 5; 6; 8];


Avars = {'Xu' 'Xw' 'Xq' 'Xv' 'Xp' 'Xr' ...
         'Zu' 'Zw' 'Zq' 'Zv' 'Zp' 'Zr' ...
         'Mu' 'Mw' 'Mq' 'Mv' 'Mp' 'Mr' ...
         'Yu' 'Yw' 'Yq' 'Yv' 'Yp' 'Yr' ...
         'Lu' 'Lw' 'Lq' 'Lv' 'Lp' 'Lr' ...
         'Nu' 'Nw' 'Nq' 'Nv' 'Np' 'Nr' ...
        }; 
    
Bvars = {'Xt0' 'Xt1C' 'Xt1S' 'Xt0T'...
         'Zt0' 'Zt1C' 'Zt1S' 'Zt0T'...
         'Mt0' 'Mt1C' 'Mt1S' 'Mt0T'...
         'Yt0' 'Yt1C' 'Yt1S' 'Yt0T'...
         'Lt0' 'Lt1C' 'Lt1S' 'Lt0T'...
         'Nt0' 'Nt1C' 'Nt1S' 'Nt0T'...
        };
    

for i = 1:6
    for j = 1:6
        Aa(1,:) = A(index(i),index(j),:);
        stabilityStateOut.(Avars{6*(i-1)+j}) = Aa;
    end
    for j = 1:4
        Bb(1,:) = B(index(i),j,:);
        stabilityStateOut.(Bvars{4*(i-1)+j}) = Bb;
    end
end

