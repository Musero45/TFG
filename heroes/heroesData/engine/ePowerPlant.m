function powerplant = ePowerPlant(varargin)

if nargin ~= 6

    disp('eRotor: wrong number of inputs')

end

PTOsl      = varargin{1};
PMCsl      = varargin{2};
PSFC       = varargin{3};
exponent   = varargin{4};
nEngines   = varargin{5};
atmosphere = varargin{6};

powerplant = struct(...
            'model','ePowerPlant',...
            'PowerTakeOff',PTOsl,...
            'PowerMaximumContinuous',PMCsl,...
            'powerExponent',exponent,...
            'numEngines',nEngines,...
            'PSFC',PSFC ...
);







powerplant  = addEnginePerformance(powerplant,atmosphere);
