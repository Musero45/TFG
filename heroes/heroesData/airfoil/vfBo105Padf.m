function [Cl, Cd, Cm] = vfBo105Padf(alpha)

Cl = 2.704*alpha;

for i = 1:length(alpha)
    if abs(Cl(i)) > 2
        Cl(i) = 2*sin(alpha(i))/abs(sin(alpha(i)));
    end
end

Cd = zeros(size(alpha));

Cm = zeros(size(alpha));
end