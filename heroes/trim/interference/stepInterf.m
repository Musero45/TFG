function interf = stepInterf(Sinterf)

% stepInterf Calculates the rotor-element inflow interference. (1/0
% model)
%
%   interf = stepInterf(Sinterf) computes the interference factor for an 
%   element under a rotor inflow, given the surface affected by the skew.
%   It is a digital model, so it returns 1 if the element is under the skew
%   influence and 0 if it is not. 
%

interf = zeros(size(Sinterf));

for i = 1:length(Sinterf)
    if Sinterf(i) > 0
        interf(i) = 1;
    else
        interf(i) = 0;
    end
end
end