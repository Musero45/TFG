function [kx,ky] = Coleman(xi,muxy)

if xi > pi/2
    kx = 1/tan(xi/2); %Correction given in Padfield for skew angles greater than pi/2
else
    kx = tan(xi/2);
end

ky = 0;

end