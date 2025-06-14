function interf = cosInterf(Sinterf)

% cosInterf Calculates the inflow interference. (cosine model)
% 
%   interf = linearInterf(Sinterf) calculates the inflow interference, assuming
%   that its first derivative is zero at the beginning and the end, having
%   the cosine shape. 

interf =0.5.*(1-cos(pi.*Sinterf));

end