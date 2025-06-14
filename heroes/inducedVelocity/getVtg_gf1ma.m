function [V,nu] = getVtg_gf1ma(alpha)

alphaM    = asin(sqrt(8/9));

regionA   = alpha < alphaM;
regionB   = alpha >= alphaM & alpha <= pi/2;

if ~isempty(alpha(regionA))
   kHp(regionA)   = NaN*zeros(size(alpha(regionA)));
   kHm(regionA)   = NaN*zeros(size(alpha(regionA)));
end


if ~isempty(alpha(regionB))
   t1   = 3*sin(alpha(regionB))./2;
   kHp(regionB)   = t1 + sqrt(t1.^2 - 2);
   kHm(regionB)   = t1 - sqrt(t1.^2 - 2);
end


t2p   = 1 - 2*sin(alpha).*kHp + kHp.^2;
t2m   = 1 - 2*sin(alpha).*kHm + kHm.^2;

nup   = (1./t2p).^(1/4);
Vp    = kHp.*nup;

num   = (1./t2m).^(1/4);
Vm    = kHm.*num;

V     = [Vm;Vp];
nu    = [num;nup];