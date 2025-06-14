function stabilityMap = getStabilityMap(stabilityState,Omega,Radius)
%GETSTABILITYMAP  Gets a stability map
%
%   SM = getStabilityState(SS,Omega,R) gets a stability map, SM, for a 
%   given ...
%
%   Example of usage:

% Get non dimensional matrix A
ndA           = stabilityState.ndA;

% Define number of trim states
[neq,ssv,n]   = size(ndA);

% Allocate dimensional A matrix
A             = zeros(neq,ssv,n);

% allocate eigenvectors and eigenvalues
eigW          = zeros(neq,ssv,n);
si            = zeros(neq,n);
% Solve the eigenvalue problem for the n trim states
for i = 1:n
    % Transform nondimensional A matrix to dimensional A matrix
    A(:,:,i) = ndA2A (ndA(:,:,i), Omega, Radius);

    % Solve the eigenvalue problem associated to A matrix
    [eigW(:,:,i),dM] = eig(A(:,:,i));
    si(:,i) = diag(dM);
end


% Poor assignment of flight condition data FIXME
mux            = stabilityState.mux;
V              = mux.*Omega.*Radius;

stabilityMap   = struct(...
'mux',mux,...
'V',V,...
'eigW',eigW,...
'si',si ...
);

% Add characteristic time to damp initial perturbation and frequency of
% autovectors
stabilityMap     = si2si_reim(stabilityMap,si);

% Add longitudinal and lateral norms of auto vectors
stabilityMap     = eigW2longlat(stabilityMap,eigW);




function stabilityMapOut = si2si_reim(stabilityMapIn,si)
% FIXME update help
% This local function is a strong candidate to be moved to
% plotStabilityDerivatives and plotControlDerivatives because the goal of
% this function is to give to stabilityState the format required by
% plotCellOfStructures to ease the plot of both stability and control
% derivatives

%
stabilityMapOut  = stabilityMapIn;

re_si    = real(si);
im_si    = imag(si);
md_si    = abs(si);
ph_si    = angle(si);
ssv      = size(si,1);

% the assignment is splitted in two loops because of the aesthetics of
% building the structure in such a way that t12 and omega fields are
% displayed ordered
for i = 1:ssv
    var_re = strcat('t12_',num2str(i));
    stabilityMapOut.(var_re) = log(2)./re_si(i,:);
end

for i = 1:ssv
    var_im = strcat('omega_',num2str(i));
    stabilityMapOut.(var_im) = im_si(i,:);
end

for i = 1:ssv
    var_md = strcat('abs_',num2str(i));
    stabilityMapOut.(var_md) = md_si(i,:);
end

for i = 1:ssv
    var_ph = strcat('phi_',num2str(i));
    stabilityMapOut.(var_ph) = ph_si(i,:);
end

for i = 1:ssv
    var_zt = strcat('zeta_',num2str(i));
    stabilityMapOut.(var_zt) = -re_si(i,:)./im_si(i,:);
end


function stabilityMapOut     = eigW2longlat(stabilityMapIn,eigW)

stabilityMapOut  = stabilityMapIn;

[neq,ssv,n]      = size(eigW);

% Allocate longitudinal and lateral norms of eigen vectors
longitudinalEig  = zeros(neq,n);
lateralEig       = zeros(neq,n);


% Compute longitudinal and lateral norms of eigen vectors
for k = 1:ssv
for j = 1:n
        longitudinalEig(k,j)       = norm(eigW(1:4,k,j),2);
        lateralEig(k,j)            = norm(eigW(5:9,k,j),2);
end
end


% Assign longitudinal and lateral norms of eigen vectors
for k = 1:ssv
        var_long                   = strcat('eigW_long',num2str(k));
        var_lat                    = strcat('eigW_lat',num2str(k));
        stabilityMapOut.(var_long) = longitudinalEig(k,:);
        stabilityMapOut.(var_lat)  = lateralEig(k,:);
end
