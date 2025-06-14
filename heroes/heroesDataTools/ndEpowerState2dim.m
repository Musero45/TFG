function ePowerState = ndEpowerState2dim(ndEPowerState,he,H,tailrotorOpt)




if iscell(he)
    % Dimensions of the output ndHe
    n            = numel(he);
    s            = size(he);
    ePowerState  = cell(s);

    % Loop using linear indexing
    for i = 1:n
        ePowerState{i}    = ndEpowerStatei2dimi(ndEPowerState{i},he{i},H,tailrotorOpt);
    end

else
    ePowerState    = ndEpowerStatei2dimi(ndEPowerState,he,H,tailrotorOpt);
end



function ePowerState = ndEpowerStatei2dimi(ndEPowerState,he,H,tailrotorOpt)

% Assignments of structure fields
% nondimensional power state fields
lambdaI   = ndEPowerState.lambdaI;
CPi       = ndEPowerState.CPi;
CPf       = ndEPowerState.CPf;
CPcd0     = ndEPowerState.CPcd0;
CPg       = ndEPowerState.CPg;
CPrmr     = ndEPowerState.CPrmr;
CPrtr     = ndEPowerState.CPrtr;
CPmr      = ndEPowerState.CPmr;
CPtr      = ndEPowerState.CPtr;
CP        = ndEPowerState.CP;

% nondimensional flight conditions
mu        = ndEPowerState.VOR;
Z_nd      = ndEPowerState.Z_nd;
gammaT    = ndEPowerState.gammaT;

% characteristic dimensions
R         = he.mainRotor.R;
OR        = he.characteristic.OR;
Pu        = he.characteristic.Pu(H);

% Definition of dimensional variables
vi        = lambdaI.*OR;
Pi        = CPi.*Pu;
Pf        = CPf.*Pu;
Pcd0      = CPcd0.*Pu;
Pg        = CPg.*Pu;
Prmr      = CPrmr.*Pu;
Prtr      = CPrtr.*Pu;
Pmr       = CPmr.*Pu;
P         = CP.*Pu;

% Definition of the dimensional variables of tail rotor

if strcmp(tailrotorOpt,'eta')
   Ptr       = CPtr.*Pu;
elseif strcmp(tailrotorOpt,'rotor')
   Pu_tr     = he.characteristic.Pu_tr(H);
   Ptr       = CPtr.*Pu_tr;
end

% % % % % % % Required power of the complete helicopter
% % % % % % % FIXME at this point some transmission function should be used
% % % % % % etaTrp    = he.transmission.etaTrp;
% % % % % % etaTra    = he.transmission.etaTra;
% % % % % % Prmr      = Pmr/(1-etaTrp);
% % % % % % Prtr      = Ptr/(1-etaTra);
% % % % % % P         = Prmr + Prtr;

% Dimensional flight condition variables. The following dimensional
% variables of flight condition are missing 
%      'H'
%      'GW'
%      'Omega'
%      'Mf'
% 
% FIXME this part of code shold be moved to a function ndFC2fc

V         = mu.*OR;
Z         = Z_nd.*R;
Vh        = V.*cos(gammaT);
Vv        = V.*sin(gammaT);

% Define output
ePowerState = struct(...
              'class','PowerState', ...
              'V',V,...
              'Vv',Vv,...
              'Vh',Vh,...
              'gammaT',gammaT,...
              'H',H,...
              'Z',Z,...
              'vi',vi,...
              'Pi',Pi,...
              'Pf',Pf,...
              'Pcd0',Pcd0,...
              'Pg',Pg,...
              'Pmr',Pmr,...
              'Ptr',Ptr,...
              'Prmr',Prmr,...
              'Prtr',Prtr,...
              'P',P...
);

