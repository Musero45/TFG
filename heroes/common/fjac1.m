function g=fjac1(f,x,varargin)
% FJAC1 Computes one-sided numerical Jacobian of a function
% USEAGE:
%   g=fjac1(f,x[, additional parameters])
% f is the string fname of a function
% x is a vector at which to evaluate the Jacobian of the function

% Copyright (c) 1996 by Paul L. Fackler

fx=feval(f,x,varargin{:});

n=size(fx,1);
d=size(x,1);

% Computation of stepsize (h)
h=sqrt(eps)*max(abs(x),1);
xh=x+h;
h=xh-x;                                     % increases precision

xx=x;
g=zeros(n,d);
for i=1:d
   xx(i)=xh(i);
   g(:,i)=(feval(f,xx,varargin{:})-fx)./h(i);
   xx(i)=x(i);
end 
