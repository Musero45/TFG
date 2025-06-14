function [kx,ky] = Pitt(xi,muxy)

if xi > pi/2
    kx = 15*pi/32/tan(xi/2); %Same modification as Coleman's for skew angles greater than pi/2
else
    kx = 15*pi/32*tan(xi/2);
end
ky = 0;

end