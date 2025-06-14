function Structure = getContinuous(address)
%GETCONINUOUS Organizes the structure to be according with a continious
%generation


Structure = struct('functionQFD',@continuousSensibility,'address',address);

end

