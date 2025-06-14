function [l,ma] = lmaZero(varargin);
% This function solves the equation of the forward inflow velocity that
% appears in the momemtum theory of forward flight using the Glauert's 
% simplification and it is:
%
% f(l,m,a)=l-m*tan(a) - 1/sqrt(l^2 + m^2)
%
% where:
% l = lambda/lambda_{i,0}
% m = mu//lambda_{i,0}
% a = alpha
%
% and lambda_{i,0} = sqrt(C_T/2)

if nargin == 2
   m        = varargin{1};
   a        = varargin{2};
   validity = 'on';
elseif nargin == 3
   m        = varargin{1};
   a        = varargin{2};
   validity = varargin{3};
end

l0  = 1.0;
l   = zeros(size(m,1),1);
if a >= 0

   for i=1:length(m)
       l(i)  = fzero(@(x) glauert_forward(x,m(i),a), l0);
   end
   ma  = m;
else
   if strcmp(validity,'on')==1
      % Compute 
      [lv,mv]  = getLMvalidity(a,l0);
      ma = linspace(mv,m(end),length(m))';
   else
      ma = m;
   end
   for i=1:length(m)
       l(i)  = fzero(@(x) glauert_forward(x,ma(i),a), l0);
   end

end


