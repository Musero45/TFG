function y = angle2pmpi(x)
%ANGLE2PMPI  Transforms angle to [-pi,pi] interval
%
%   B = ANGLE2PMPI(A) transforms the vector of angle
%   to [-pi,pi] interval.
%
%   Example of usage:
%   >> a = pi/180*linspace(-2*pi,2*pi,10);
%   >> b = angle2pmpi(a);
%
%   TO BE CHECKED: note that the actual algorithm could fail in case
%   the angle belongs to intervals [3*pi,NaN) or (-,NaN,-3*pi]
%
%   TO BE THOUGHT: maybe this function should be used at the airfoil
%   level instead of bem level.

y     = zeros(size(x));

r1    = x>-3*pi & x<=-pi;
pmpi  = x>=-pi & x<=pi;
r2    = x>pi & x<=3*pi;


y(r1)      = -x(r1)-2*pi;
y(pmpi)    = x(pmpi);
y(r2)      = x(r2)-2*pi;

