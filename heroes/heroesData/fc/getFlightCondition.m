function fc = getFlightCondition(he,varargin)
%getFlightCondition  Construct energy flight conditions
%
%   FC = getFlightCondition(HE) constructs a hover flight condition for
%   the energy-based helicopter HE. The hover flight condition is defined
%   by the following structure data
%              V: 0
%         gammaT: 0
%             Vh: []
%             Vv: []
%              H: 0
%             GW: MTOW
%          Omega: OmegaN
%             Mf: MFW/g
%              P: NaN
%              Z: NaN
%
%   where V is the modulus velocity, gammaT, Vh the horizontal velocity, Vv
%   the vertical velocity, H the altitude, the gross weight GW is set to
%   the MTOW, the rotor speed Omega is also set to the nominal rotor speed,
%   the fuel mass is set to the maximum fuel mass, MFW/g, and power plant 
%   rating, P, and height above ground, Z, are set to not-a-numbers, NaN.
%
%   FC = getFlightCondition(HE,'V',V) constructs a flight condition for
%   the energy-based helicopter HE which consists on level flight gammaT=0 
%   with forward velocity V, at sea level H=0, helicopter gross weight
%   equals to MTOW and fuel mass the maximum fuel mass and nominal rotor 
%   speed . 
%
%   FC = getFlightCondition(HE,OPTIONS) constructs as above with 
%   default options replaced by values set in OPTIONS. OPTIONS should 
%   be input in the form of sets of property value pairs. Default OPTIONS 
%   is a structure defined by the function setFCdefaults. SETFCDEFAULTS
%   is a structure with the same fields as flight condition and with field
%   values corresponding to the hover condition of the previous example.
%   The valid properties strings are the fieldnames of the flight condtion
%   that is the following examples are valid ones:
%         fc0 = getFlightCondition(he);
%         fc1 = getFlightCondition(he,'V',V);
%         fc2 = getFlightCondition(he,'V',V,'gammaT',gt);
%         fc3 = getFlightCondition(he,'V',V,'H',H,'GW',gw);
% 
% 
% 
% 
% 
%   Examples of usage
% a   = getISA;
% he  = superPuma(a);1f
% V   = linspace(0,100,11);
% H   = 1000*ones(1,11);
% fc0 = getFlightCondition(he);
% fc1 = getFlightCondition(he,'V',V);
% fc2 = getFlightCondition(he,'V',V');
% fc3 = getFlightCondition(he,'V',V,'H',H);
% 
%
%
%
%

% if nargin < 3 || isempty(varargin)
%    disp('getFlightcondition: wrong number of input variables')
% end


% Fix the dimensions of the flight condition fields
% According to the third input argument we set the dimensions of the flight
% condition
if isempty(varargin)
nf      = [1 1];
else
nf      = size(varargin{2});
end

% Setup the default values of flight conditions fields
defaultFC = setFCdefaults(he,nf);
parsedFC  = parse_pv_pairs(defaultFC,varargin);

% Dirty fix derived variables like Vh and Vv
if isempty(parsedFC.Vh)
   % This implies that default variable is set and input arguments
   % does not contain any input of horizontal Vh
   parsedFC.Vh   = parsedFC.V.*cos(parsedFC.gammaT);
end
if isempty(parsedFC.Vv)
   % This implies that default variable is set and input arguments
   % does not contain any input of vertical VV
   parsedFC.Vv   = parsedFC.V.*sin(parsedFC.gammaT);
end

fc        = parsedFC;

function defaults = setFCdefaults(he,n)

GW        = he.weights.MTOW*ones(n);
MFM       = he.weights.MFW/9.8*ones(n); % FIXME
OmegaN    = he.mainRotor.Omega*ones(n);

defaults  = struct(...
     'V',zeros(n), ...
     'gammaT',zeros(n), ...
     'Vh',[], ...
     'Vv',[],...
     'H',zeros(n), ...
     'GW',GW,...
     'Omega',OmegaN,...
     'Mf',MFM,...
     'P',NaN(n),...
     'Z',NaN(n) ...
       );
