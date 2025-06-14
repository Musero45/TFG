function [kx,ky] = Payne(xi,muxy)

if xi > pi/2
    kx = -4/3*tan(xi)/(1.2-tan(xi)); %Modified tan(xi)=>-tan(xi)
else
    kx = 4/3*tan(xi)/(1.2+tan(xi));
end

ky = 0;

end