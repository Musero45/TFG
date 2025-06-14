function Sinterf = rightHTPInterf(xi,ndHe)

geom    = ndHe.geometry;
hr      = geom.ndh;
lr      = geom.ndls;
ht      = geom.ndhrHTP;
lt      = geom.ndlrHTP;
c       = ndHe.rightHTP.ndc;

% DIRTY HACK to avoid the error (2). This error is due to the lack of 
% right HTP at Puma helicopter
% Error(1)
% ??? Error using ==> interp1 at 262
% The values of X should be distinct.
% 
% Error in ==> rightHTPInterf at 25
% Sinterf = interp1(skew,S,xi);
% 
% Error in ==> velocities at 144
%     Sinterf = rightHTPInterf(xi(i),ndHe);
% 
% Error in ==> helicopterTrim at 42
% vel = velocities(fCV,muWV,lambda,beta,ndHe,options);
% 
% Error in ==>
% getTrimState>@(x)helicopterTrim(x,flightConditionT(:,i),muWT,ndHe,options)
% at 41
%     @(x)
%     helicopterTrim(x,flightConditionT(:,i),muWT,ndHe,options);
%     
% Error in ==> fsolve at 254
%             fuser = feval(funfcn{3},x,varargin{:});
% 
% Error in ==> getTrimState at 44
%     x(:,i) = nlSolver(system2solve,initialCondition,options);
% 

if c == 0
   % It means there is no rightHTP
   % I do not know what I am doing setting Sinterf equal to zero
   % I guess that Sinterf is the surface fraction with interference with
   % the main rotor wake but who knows!!!!
   Sinterf = 0;
   return
end

deltaZ  = ht+hr;

l1 = (lr-1)-lt-c/4;
l2 = (lr-1)-lt+3*c/4;
l3 = (lr+1)-lt-c/4;
l4 = (lr+1)-lt+3*c/4;

% oscar: dirty hack to avoid the following error when computing Sinterf
% ??? Error using ==> interp1 at 262
% The values of X should be distinct.
%
% The problem appears when ht and hr are equal to zero. This condition
% can happen when a canonical or simplified helicopter is considered. 
% Then, the problem it is that xi1 and xi2 are equal and xi3 and xi4 are
% also equal leading to a square-pulse-like function for S(skew). To
% quickly fix this problem we define an infinitesimal, i.e we add plus
% minux epsilon, to the equal abcisas xi1-eps, xi2+eps, xi3-eps, xi4+eps,
% and this does not have problem using interp1

xi1 = atan(l1/deltaZ) - eps;
xi2 = atan(l2/deltaZ) + eps;
xi3 = atan(l3/deltaZ) - eps;
xi4 = atan(l4/deltaZ) + eps;

skew = [-pi; xi1; xi2; xi3; xi4; pi];
S    = [0; 0; 1; 1; 0; 0];

Sinterf = interp1(skew,S,xi);

end