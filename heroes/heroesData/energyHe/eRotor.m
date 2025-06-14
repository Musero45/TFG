function rotor = eRotor(varargin)
% Have a look at heroes_gs.m to see some examples of usage of this function
if nargin == 1
    id     = 'tailRotor';
    b      = [];
    cd0    = [];
    chord  = [];
    Omega  = [];
    R      = [];
    eta    = varargin{1};
    K      = [];
    kappa  = [];
    cldata = [];
    cddata = [];

elseif nargin > 4 && nargin < 10

    id     = 'mainRotor';
    b      = varargin{1};
    cd0    = varargin{2};
    chord  = varargin{3};
    Omega  = varargin{4};
    R      = varargin{5};

    if nargin == 5
       eta    = 1.0;
       K      = 3.0;
       kappa  = 1.0;
       cldata = [];
       cddata = [];
    elseif nargin == 6
       eta    = varargin{6};
       K      = 3.0;
       kappa  = 1.0;
       cldata = [];
       cddata = [];
    elseif nargin == 7
       eta    = varargin{6};
       K      = varargin{7};
       kappa  = 1.0;
       cldata = [];
       cddata = [];
    elseif nargin == 8
       eta    = varargin{6};
       K      = varargin{7};
       kappa  = varargin{8};
       cldata = [];
       cddata = [];
    elseif nargin == 9
       eta    = varargin{6};
       K      = varargin{7};
       kappa  = varargin{8};
       cldata = varargin{9};
       cddata = [];
    elseif nargin == 10
       eta    = varargin{6};
       K      = varargin{7};
       kappa  = varargin{8};
       cldata = varargin{9};
       cddata = varargin{10};
    end

else

    disp('eRotor: wrong number of inputs')

end


% rotor definition
rotor = struct(...
            'class','eRotor',...
            'id',id,...
            'b',b,...
            'cd0',cd0, ...
            'c',chord, ... 
            'Omega',Omega,... 
            'R',R,... 
            'eta',eta, ...
            'K',K,...
            'kappa',kappa,... 
            'cldata',cldata,...
            'cddata',cddata ...
);





