function [Xn,fn] = newton_raphson(F,X0,varargin)
%NEWTON_RAPHSON solves systems of nonlinear equations using NR*
%  
%   NEWTON_RAPHSON attempts to solve equations of the form:
%               
%   F(X)=0    where F and X may be vectors or matrices.   
%  
%   X=NEWTON_RAPHSON(FUN,X0) starts at the matrix X0 and tries to solve the 
%   equations in FUN.  FUN accepts input X and returns a vector (matrix) of 
%   equation values F evaluated at X. 
%  
%   X=NEWTON_RAPHSON(FUN,X0,OPTIONS) solves the equations with the
%   default optimization parameters replaced by values in the structure
%   OPTIONS, an argument created with the OPTIMSET function.
%   See OPTIMSET for details.  Used options are TolFun, Jacobian, and
%   MaxIter.
%
%   * NR stands for Newton-Raphson

if nargin < 3
   options   = optimset('fsolve');
else
   options   = varargin{1};
end

iter   = 0;
Xn     = X0;
funErr = 1.0;
if isempty(options.Jacobian) || ...
   strcmp(options.Jacobian,'off')   
  fn = F(Xn);
  jn = fjac1(F,Xn);
elseif strcmp(options.Jacobian,'on')
  [fn,jn] = F(Xn);
end

while (abs(funErr) > options.TolFun) && (iter < options.MaxIter)
     Xn1    = Xn;
     f      = fn;
     j      = jn;
     Xn     = Xn1 - j\f;
     iter   = iter+1;
     if isempty(options.Jacobian)
       fn = F(Xn);
       jn = fjac1(F,Xn);
     elseif strcmp(options.Jacobian,'on')
       [fn,jn] = F(Xn);
     end
     funErr = norm(fn);
end

if iter == options.MaxIter
   disp(strcat('Maximum number of iterations reached. Tol= ',num2str(funErr)));
end

