function Structure = getDiscrete(address,vector)
%GETDISCRETE Organizes the structure to be according with a discrete
%generation

Structure = struct('functionQFD',@discreteSensibility,...
    'address',address,'values',vector);

end

