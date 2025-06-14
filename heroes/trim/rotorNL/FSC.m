function [a0,ai,bi,ys] = FSC(x,y,n)
%FSC Calculates Fourier series coefficients 
%   Calculates Fourier series coefficients up to an n order for an imput
%   pair data (x,y) using 'trapz' integration. Output consists on three
%   vectors containing a0, a_i and b_i respectively, and the approximation
%   function 'ys'.

a0 = (1/pi)*trapz(x,y);

nx = x*(1:n);

ys = a0/2;

for ind = 1:n
    
ai(ind) = (1/pi)*trapz(x,y.*cos(nx(:,ind)));
bi(ind) = (1/pi)*trapz(x,y.*sin(nx(:,ind)));

ai = ai';
bi = bi';

ys = ys + ai(ind)*cos(nx(:,ind)) + bi(ind)*sin(nx(:,ind));

end

end

