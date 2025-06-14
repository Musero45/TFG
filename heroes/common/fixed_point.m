function [Xn,fn] = fixed_point(F,X0,varargin)
%FIXED_POINT solves systems of nonlinear equations with fixed-point iteration
%  
%   FIXED_POINT attempts to solve equations of the form:
%               
%   F(X)=0    where F and X may be vectors or matrices.   
%  
%   X=FIXED_POINT(FUN,X0) starts at the matrix X0 and tries to solve the 
%   equations in FUN.  FUN accepts input X and returns a vector (matrix) of 
%   equation values F evaluated at X. 
%  
%   X=FIXED_POINT(FUN,X0,OPTIONS) solves the equations with the
%   default optimization parameters replaced by values in the structure
%   OPTIONS, an argument created with the OPTIMSET function.
%   See OPTIMSET for details.  Used options are TolFun and MaxIter.
%

if nargin < 3
   options   = optimset('fsolve');
else
   options   = varargin{1};
end

iter   = 0;
Xn     = X0;
xErr   = 1.0;

while (abs(xErr) > options.TolFun) && (iter < options.MaxIter)
     Xn1    = Xn;
     iter   = iter+1;
     Xn     = Xn1 - F(Xn1);
     xErr   = norm(Xn-Xn1)/norm(Xn1);
end

if iter == options.MaxIter
   disp(strcat('Maximum number of iterations reached. Tol= ',num2str(xErr)));
end

