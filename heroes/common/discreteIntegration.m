function   I = discreteIntegration(xi,Fi,niSolver)
%DISCRETEINTEGRATION  Integrates a discrete function
%
%   I = DISCRETEINTEGRATION(XI,YI,F) integrates the discrete function 
%   YI=Y(XI) using the numerical integrator function handle F. The function
%   handle F can be one of the following list:
%      @quad
%      @quadl
%      @qtrapz
%   
%   Example of usage
%   Integrate sin(x) at the interval [0,2*pi]:
%   >> xi=linspace(0,2*pi,61);
%   >> yi=sin(xi);
%   >> I1=discreteIntegration(xi,yi,@quad)
% 
%   I1 =
%
%     -6.6613e-16
%
%   >> I2=discreteIntegration(xi,yi,@quadl)
% 
%   I2 =
%
%      3.9909e-16
%
%   >> I3=discreteIntegration(xi,yi,@qtrapz)
% 
%   I3 =
%
%     -5.5511e-17
%
%

nf=size(Fi,1);
I =zeros(nf,1);
a       = xi(1);
b       = xi(end);
if a~=b
    for i=1:nf
        fi      = Fi(i,:);
        f       = @(x) interp1(xi,fi,x);
        I(i,1)  = niSolver(f,a,b);
    end
end
