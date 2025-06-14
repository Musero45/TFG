function [V,nu] = getHtg_gf1ma(alpha)


% t1   = 3*sin(alpha)./2;
% kH   = t1 + sqrt(t1.^2 + 1);

kH   = sin(alpha);
t2   = 1 - 2*sin(alpha).*kH + kH.^2;
nu   = (1./t2).^(1/4);
V    = kH.*nu;