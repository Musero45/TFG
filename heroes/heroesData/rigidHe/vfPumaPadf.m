function [Cl, Cd, Cm] = vfPumaPadf(alpha)
% TODO this function affects only to the horizontal tail plane so, it does
% not make sense that this function lives in rigidHe. Discuss about where 
% this kind of function should live

Cl = 3.5*(11.143*alpha^3-85.714*alpha^5);

if abs(Cl) > 2
    Cl = 2*sin(alpha)/abs(sin(alpha));
end

Cd = 0;

Cm = 0;
end