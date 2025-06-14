function Sinterf = fuselageInterf(xi,ndHe)

% heavysideFus Calculates the rotor-fuselage inflow interference. (1/0
% model)
%
%   interf = heavysideFus(xi,ndFus) computes the interference factor for a 
%   fuselage under a rotor inflow, given the skew angle (xi) and the
%   non dimensional fuselage (ndFus). It is a digital model, so it returns
%   1 if the fuselage is under the skew influence and 0 if it is not.
%

if abs(xi)<pi/2
    Sinterf = cos(xi);
else
    Sinterf = 0;
end

end