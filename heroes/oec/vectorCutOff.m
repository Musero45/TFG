function vectRankHows = vectorCutOff(Order,nMasterVariables)
%VECTCUTOFF Selects the number of main Hows used for the OEC helicopter
%generation
%   This funtion cuts the Order QFD vector of master variables in order to
%   select the number of variables desired nMasterVariables

disp(['OEC number of master variables selected: ', int2str(nMasterVariables)]); 

n = size(Order,2);
if nMasterVariables<=n
    vectRankHows    = zeros(1,nMasterVariables);
    vectRankHows(:) = Order(1:nMasterVariables);
else
    vectRankHows = 0;
    disp('vectorCutOff error: number of master variables required more than input vector');
end


end

