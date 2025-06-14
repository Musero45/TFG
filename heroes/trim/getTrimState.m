function trimState = getTrimState(flightConditionT,muWT,ndHe,varargin)
%GETTRIMSTATE  Gets a trim state
%
%   TS = getTrimState(FC,mu_w,ndHe) gets an nondimensional trim state, ts,
%   by solving the trim condition for a given flight condition FC, 
%   nondimensional wind speed, mu_w, a nondimensional helicopter, ndHe.
%   The trim state TS is a structure with flight condition vectorized
%   fields, that is, fields which are computed for a vector of flight
%   conditions.
%
%   Example of usage:
%   atm      = getISA;
%   he       = PadfieldBo105(atm);
%   ndHe     = rigidHe2ndHe(he,atm,0);
%   muWT     = [0; 0; 0];
%   ndV      = linspace(.2, .3, 4);
%   n        = length(ndV);
%   fCT      = zeros(6,n);
%   fCT(1,:) = ndV(:);
%   ts       = getTrimState(fCT,muWT,ndHe);
%   plotTrimState(ts,{'Bo-105'});
%
%
%   See also: getHeTrimState, plotTrimState
%
%   TODO
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 23 april 2014: THIS WAS THE OLD CODE IMPLEMENTED BY NANO
% there is an if statement to treat axil trim differently to forward
% trim and I do not understand why this is required because trim02 and the
% test of HA2 does not use this if statement.
% d2r       = pi/180;
% %==========================================================================
% % Main trim loop
% for i = 1:n
%     disp (['Solving trim...  ', num2str(i), ' of ', num2str(n)]);
%     if(norm(flightConditionT(:,i))<eps || ...
%        atan2(flightConditionT(3,i),flightConditionT(1,i))>86*d2r && ...
%        atan2(flightConditionT(3,i),flightConditionT(1,i))<104*d2r)
%        system2solve = @(x) helicopterTrimAxial(x,flightConditionT(:,i),muWT,ndHe,options);
%         x(1:ndof,i) = nlSolver(system2solve,initialCondition(1:ndof),options);
% % % FIXME The next line was the culprit of the following warning:
% % % Warning: Trust-region-dogleg algorithm of FSOLVE cannot handle
% % % non-square systems; using Levenberg-Marquardt algorithm
% % % 
% % % because we were asking for solving a system of 24 equations supplying a
% % % vector of initial guess of unknowns of 25 variables. In order to avoid
% % % the warning the next line is commented and everything seems to work lioke
% % % a charm. However, I am not sure when and why this thing was supposed to
% % % appear and if at Nano's time this was at this state. 
% %             x(25,i) = 0;
%     else
%         system2solve = @(x) helicopterTrim(x,flightConditionT(:,i),muWT,ndHe,options);
%         x(:,i) = nlSolver(system2solve,initialCondition,options);
%     end
%     for k = 1:ndof
%         if abs(x(k,i))<eps
%             x(k,i) = 0;
%         end
%     end
%     initialCondition = x(:,i);
% end
% trimState = getHeTrimState(x,flightConditionT,muWT,ndHe,options);
% %==========================================================================


options   = parseOptions(varargin,@setHeroesRigidOptions);

nlSolver  = options.nlSolver;
eps       = options.TolX;

d2r       = pi/180;

% Get weight coefficient just to define initial guess
CW      = ndHe.inertia.CW;

% Set basic trim state initial guess
% This initial guess to solve the system of ndof algebraic non linear
% equations is as follows:
initialCondition = [...
    0.05; ... % Theta
   -0.05; ...% Phi
    0.25; 0; 0; ...% theta0 theta1C theta1S 
    0.25; ...% theta0tr
    0; 0; 0; ... % beta0 beta1C beta1S
   -sqrt(CW/2); 0; 0; ...% lambda0 lambda1C lambda1S
    CW; 0; 0; ...% CT0 CT1C CT1S
    0; 0; 0; ... % beta0tr beta1Ctr beta1Str
   -sqrt(CW/20); 0; 0; ... % lambda0tr lambda1Ctr lambda1Str
    CW/10; 0; 0; ... % CT0tr CT1Ctr CT1Str
];

% Allocate main variables
% Define number of degrees of freedom of the trim state
ndof      = 24;

% Define number of trim states to be computed
n = size(flightConditionT,2);

% Define basic trim state matrix. 
x         = zeros(ndof,n);

disp('... Getting trim states ...')
for i = 1:n
%     if(norm(flightConditionT(:,i))<eps || ...
%        atan2(flightConditionT(3,i),flightConditionT(1,i))>86*d2r && ...
%        atan2(flightConditionT(3,i),flightConditionT(1,i))<104*d2r)
% 
%        system2solve = @(x) helicopterTrimAxial(x,flightConditionT(:,i),muWT,ndHe,options);
%        x(:,i) = nlSolver(system2solve,initialCondition(1:ndof),options);
% 
%     else
       % Define the system of equations to be solved
       system2solve = ...
       @(x) helicopterTrim(x,flightConditionT(:,i),muWT,ndHe,options);

       % Solve the actual problem and get the trim state solution
       x(:,i) = nlSolver(system2solve,initialCondition,options);
%     end
    for k = 1:ndof
       if abs(x(k,i))<eps
           x(k,i) = 0;
       end
    end
    % Use the trim state solution as initial guess of the next trim state
    % solution
    initialCondition = x(:,i);
end

% Get an actual trim state from the trim state solution
trimState = getHeTrimState(x,flightConditionT,muWT,ndHe,options);
%==========================================================================









