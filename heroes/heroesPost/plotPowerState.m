function varargout = plotPowerState(X,AXDS,AYDS,varargin)
%PLOTPOWERSTATE  Plots a dimensional Energy power state
%   --FIXME DOCS--
%   PLOTPOWERSTATE(X,LEG) plots a dimensional power state defined
%   by cell of structures, X, using the cell of legends, LEG. X should be
%   a cell of energy power state output structures and LEG should be 
%   of the same length that X. In case that LEG is equal to '' or [] 
%   then the set of plots does not show any legend. PLOTEPOWERSTATE 
%   plots every field of the structure X{i} according to the field type 
%   of the structure X{i}.
%
%   PLOTEPOWERSTATE(X,LEG,OPTIONS) plots as above with default options 
%   replaced by values set in OPTIONS. OPTIONS should be input in the form 
%   of sets of property value pairs. Default OPTIONS is a structure with 
%   the following fields and values:
% 
%          mode: 'thick'
%          mark: {'r-'  'b-.'  'k:' [until 13 markers] 'r-<'}
%        prefix: 'no'
%     closePlot: 'no'
%     titleplot: []
%
%   See also setHeroesPlotOptions
%
%   AX = PLOTEPOWERSTATE(X,LEG,OPTIONS) plots as above and returns AX 
%   a column vector of handles to the axis of the plots.
%
%   Examples of usage: First, generate a nondimensional Energy power state
%   by first creating a nondimensional helicopter and nondimensional flight
%   condition. Then, create a nondimensional energy power state
%   corresponding to a horizontal forward flight, that is
%   a     = getISA;
%   he    = superPuma(a);
%   vspan = linspace(0,70,31);
%   fc    = getLevelFC(vspan,zeros(1,31));
%   p     = getEpowerState(he,fc,a);
%   plotPowerState(p,{''})
%
%   Second, plot several ndEpowerStates, by defining a cell of
%   ndEpowerStates, because, for instance the flight height has changed
%   hspan   = linspace(0,1000,5);
%   for i=1:5
%       fc      = getLevelFC(vspan,hspan(i)*ones(1,31));
%       q{i}    = getEpowerState(he,fc,a);
%       leg{i}  = strcat('h=',num2str(hspan(i)));
%   end
%   plotPowerState(q,leg)

options  = parseOptions(varargin,@setHeroesPlotOptions);

% if ~isstruct(X)
%    error('X: First input argument should be a single structure')
% end

if strcmp(options.defaultVars,'yes')==1
  zvars   = setPowerStateVars;
else
  zvars   = options.defaultVars;
end

ax = plotStructureNdMatrix(X,AXDS,AYDS,zvars,options);
if nargout == 1
   varargout{1} = ax;
end

function A = setPowerStateVars


var = {'P','Pi','Pf','Pcd0','Pg',...
        'Vv'...
        };
lab = {'$P$ [W]','$P_i$ [W]','$P_f$ [W]','$P_{cd0}$ [W]','$P_g$ [W]' ...
         '$V_v$ [m/s]'...
        };
unit=[1,1,1,1,1,...
        1 ...
       ];

A = getaxds(var,lab,unit);
% A  = struct('var',{var},'lab',{lab},'unit',unit);
