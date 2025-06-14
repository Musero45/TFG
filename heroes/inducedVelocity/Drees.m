function [kx,ky] = Drees(xi,muxy)

if xi > pi/2
    kx = 4/3*(1-1.8*muxy^2)/tan(xi/2); %Also corrected in the same way than before
else
    kx = 4/3*(1-1.8*muxy^2)*tan(xi/2);
end

ky = -2*muxy;

end