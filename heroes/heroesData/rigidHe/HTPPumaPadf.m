function [Cl, Cd, Cm] = HTPPumaPadf(alpha)
% TODO this function affects only to the horizontal tail plane so, it does
% not make sense that this function lives in rigidHe. Discuss about where 
% this kind of function should live
Cl = 3.7*(alpha-3.92*alpha^3);

if abs(Cl) > 2
    Cl = 2*sin(alpha)/abs(sin(alpha));
end

Cd = 0;

Cm = 0;

end