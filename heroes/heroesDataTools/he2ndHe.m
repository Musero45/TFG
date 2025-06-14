function p = he2ndHe(he)
%HE2NDHE  Transforms a dimensional helicopter into a 
%         nondimensional one
%
%
%   NDHE = HE2NDHE(HE) transforms a dimensional helicopter HE, into 
%   a nondimensional one, NDHE.
%
%
%   -- TO BE REMOVED --
%   NDHE = HE2NDHE(HE,RHO,OMEGA,GW) transforms a dimensional helicopter HE, 
%   into a nondimensional one, NDHE, at a given density RHO, with rotor
%   speed OMEGA and gross weight GW. The size of density, rotor speed and
%   gross weight should be the same, let us say N and HE2NDHE  
%
% TOTHINKABOUT
% function p = he2ndHe(he,fc)
% function p = he2ndHe(he)
%
%
% Dirty hack to avoid vector evaluation of density rho
% FIXME? Oscar is not sure if this is the correct way of doing, and I do
% not really like it at all
% if numel(rho) ~= numel(Omega) || ...
%    numel(rho) ~= numel(GW)
%    disp('he2ndHe: wrong dimensions of input arguments')
% end
% 
% if length(he) ~= 1
%    disp('he2ndhe: dimensional input helicopter should be of length 1')
% end


if iscell(he)
    % Dimensions of the output ndHe
    n         = numel(he);
    s         = size(he);

    p         = cell(s);

    % Loop using linear indexing
    for i = 1:n
        p{i}    = hei2ndHei(he{i});
    end

else
    p    = hei2ndHei(he);
end



function p = hei2ndHei(he)



% Get main rotor data
mr          = he.mainRotor;

% Get tail rotor data
tr          = he.tailRotor;

% nondimensionalMainRotor
ndMainRotor = rotor2ndRotor(mr);

% nondimensionalTailRotor
ndTailRotor = rotor2ndRotor(tr);

% Dimensional variables 
% (constant values because helicopter is just one element)
R           = mr.R;
area        = pi*R^2;


% nondimensionalFuselage definition
f           = he.fuselage.f;
fuselage    = struct('fS',f/area);

% nondimensional transmission definition
transmission.etaMra = he.transmission.etaMra;
transmission.etaMrp = he.transmission.etaMrp;
transmission.etaTra = he.transmission.etaTra;
transmission.etaTrp = he.transmission.etaTrp;
transmission.etaM   = he.transmission.etaM;

% Define the nondimensional helicopter
p     = struct(...
        'class','ndHe',...
        'id',he.id,....
        'mainRotor',ndMainRotor,...
        'tailRotor',ndTailRotor,...
        'fuselage',fuselage,...
        'transmission',transmission ...
);


