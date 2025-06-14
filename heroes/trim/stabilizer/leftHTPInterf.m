function Sinterf = leftHTPInterf(xi,ndHe)

geom    = ndHe.geometry;
hr      = geom.ndh;
lr      = geom.ndls;
ht      = geom.ndhlHTP;
lt      = geom.ndllHTP;
c       = ndHe.leftHTP.ndc;

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