function [io,info] = istrimconverged(trimdata)
% istrimconverged  True for converged trim states
%
%   istrimconverged(B) returns 1 if B is a converged nondimensional trim 
%   state structure. istrimconverged works not only for trim
%   nondimensional blade states but also for trim nondimensional performance
%   maps and more generally for any structure with field named flags
%   containing the output information flags of MATLAB fsolve function. the
%   converged logical check considers as converged solutions the values of
%   flags > 0.
%
%   [IO,INFO] = istrimconverged(B) returns the logical variable IO and the
%   structure INFO with information about the nonconverged trim states. The
%   INFO structure has the following fields:
%         nonConvergedStates: INTEGER
%    nonConvergedStatesRatio: FLOAT
%      nonConvergedStatesIND: INTEGER VECTOR
%
%   The nonConvergedStates fields gives the number of non converged states.
%   The nonConvergedStatesRatio is the ration between the number of non
%   converged states and the total number of states. The 
%   nonConvergedStatesIND is the linear indexing vector of the non 
%   converged trim states and nonConvergedStatesSUB is the subscripts vector
%   of non converged trim states. This vector is of size 3 corresponding to
%   the subscripts of the nondimensional position, operation parameter and
%   pitch control angle vectors, respectively.
%
%   See also fsolve.


io   = min(min(min(trimdata.flags))) > 0;

if nargout == 2
   % In case two output arguments are required we output an info structure
   % with information about the nonconverged trim states
   nonConvergedStates       = nnz(trimdata.flags < 0);
   nonConvergedStatesRatio  = nnz(trimdata.flags < 0)/numel(trimdata.flags);
   nonConvergedStatesIND    = find(trimdata.flags < 0);

   trimDataSize              = size(trimdata.flags);
   [xSUB,lSUB,tSUB]         = ind2sub(trimDataSize,nonConvergedStatesIND);
   nonConvergedStatesSUB    = [xSUB,lSUB,tSUB];
% % % % % % % % % % % % % %    % older code 
% % % % % % [nx_nc,nl_nc,nt_nc]= ind2sub(...
% % % % % %     [trimDataSize(1),trimDataSize(2),trimDataSize(3)], ...
% % % % % %      info.nonConvergedStatesIDX);


   % Define output structure
   info   = struct(...
   'nonConvergedStates',nonConvergedStates,...
   'nonConvergedStatesRatio',nonConvergedStatesRatio,...
   'nonConvergedStatesIND',nonConvergedStatesIND, ...
   'nonConvergedStatesSUB',nonConvergedStatesSUB ...
   );
end    

