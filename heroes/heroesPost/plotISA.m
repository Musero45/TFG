function varargout = plotISA(X,leg,varargin)
%PLOTISA  Plots a International Standard Atmosphere
%
%   PLOTISA(X,LEG) plots ISA defined by cell of structures, X, using the 
%   cell of legends, LEG. X should be a cell of ISA structures and LEG 
%   should be of the same length that X. In case that LEG is equal to '' 
%   or [] then the set of plots does not show any legend. PLOTISA plots 
%   every field of the structure X{i} according to the field type 
%   of the structure X{i}.
%
%   PLOTISA(X,LEG,OPTIONS) plots as above with default options 
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
%   See also setHeroesPlotOptions, setISAPlotOptions
%
%   AX = PLOTISA(X,LEG,OPTIONS) plots as above and returns AX 
%   a column vector of handles to the axis of the plots.
%
%   Examples of usage: 
%   Define three different ISA, i.e. ISA-10 C, ISa and ISA+20 C
%   a  = getISA;
%   b  = getISA(-10);
%   c  = getISA(20);
%   plotISA({a,b,c},{'ISA','ISA-10','ISA+20'});
%

X          = output2cellOfStructures(X);
nx         = length(X);

o          = parseOptions(varargin,@setISAPlotOptions);

Y          = cell(1,nx);
axds       = getaxds({'hspan'},{'$z$ [m]'},1);

hspan = o.hspan;
for i = 1: nx
   s.hspan              = hspan;
   s.density            = X{i}.density(hspan);
   s.pressure           = X{i}.pressure(hspan);
   if strcmp(o.temperatureUnit,'Celsius')
      s.temperature        = X{i}.temperature(hspan) - 273;
   elseif strcmp(o.temperatureUnit,'Kelvin')
      s.temperature        = X{i}.temperature(hspan);
   else
      error('plotISA: wrong temperarature unit string');
   end
   s.soundSpeed         = X{i}.soundSpeed(hspan);
   s.sigma              = X{i}.sigma(hspan);
   s.delta              = X{i}.delta(hspan);
   s.theta              = X{i}.theta(hspan);
   s.d_densiti          = X{i}.d_density(hspan);
   s.d_pressure         = X{i}.d_pressure(hspan);
   s.d_temperature      = X{i}.d_temperature(hspan);
   s.d_soundSpeed       = X{i}.d_soundSpeed(hspan);
   s.d2_density         = X{i}.d2_density(hspan);
   s.d2_pressure        = X{i}.d2_pressure(hspan);
   s.d2_temperature     = X{i}.d2_temperature(hspan);
   s.d2_soundSpeed      = X{i}.d2_soundSpeed(hspan);
   s.dynamicViscosity   = X{i}.dynamicViscosity(hspan);
   s.kinematicViscosity = X{i}.kinematicViscosity(hspan);
   Y{i}     = s;
end


if isstruct(o.defaultVars)
  Zvars   = o.defaultVars;
elseif strcmp(o.defaultVars,'yes')==1
  Zvars   = setISAplotVariables;
end

ax  = plotCellOfStructures(Y,axds,Zvars,leg,o);

if nargout == 1
   varargout{1} = ax;
end


function A = setISAplotVariables

var = {'density','pressure','temperature','soundSpeed',...
       'sigma','delta','theta' ...
        };
lab = {'$$\rho$ [kg m $$^{-3}$]','$$p$$ [Pa]','$$T$$ [$$K$$]','$$a$$ [m/s]' ...
       '$$\sigma_{ISA}(h)$$ [-]','$$\delta_{ISA}$$ [-]','$$\theta$$ [-]' ...
        };
unit= [1,1,1,1,...
       1,1,1   ...
       ];

% var = {'rho','p','T','a',...
%        'sigma','delta','theta',...
%        'd_rho','d_p','d_T','d_a',...
%        'd2_rho','d2_p','d2_T','d2_a' ...
%         };
% lab = {'$\rho(h)$ [kg m $^{-3}$]','$p(h)$ [Pa]','$T(h)$ [$^o$]','$a$ [m/s]' ...
%          '$\sigma_{ISA}(h)$ [-]','$\delta_{ISA}$ [-]','$\theta(h)$ [-]',...
%          '$d\rho/dH$','$dp/dH$','$dT/dH$','$da/dH$', ...
%          '$d^2\rho/dH^2$','$d^2p/dH^2$','$d^2T/dH^2$','$d^2a/dH^2$', ...
%         };
% unit= [1,1,1,1,...
%          1,1,1,  ...
%          1,1,1,1,...
%          1,1,1,1 ...
%         ];

A = getaxds(var,lab,unit);


