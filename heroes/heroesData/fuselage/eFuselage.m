function fuselage = eFuselage(f,varargin)


if nargin == 2
   label = varargin{1};
else
   label = 'eFuselage';
end

% fuselage definition
% f is the equivalent flat plate area [m^2] S*Cd
fuselage   = struct(...
            'class','fuselage',...
            'id',label,...
             'f',f ...
);


