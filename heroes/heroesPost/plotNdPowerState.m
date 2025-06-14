function varargout = plotNdPowerState(X,AXDS,AYDS,varargin)
%PLOTNDPOWERSTATE  Plots a nondimensional Energy power state
%
%   PLOTNDPOWERSTATE(X,LEG) plots nondimensional Energy power state defined
%   by cell of structures, X, using the cell of legends, LEG. X should be a cell
%   of wt output structures and LEG should be of the same
%   length that X. In case that LEG is equal to '' or [] then 
%   the set of plots does not show any legend. PLOTNDEPOWERSTATE plots 
%   every field of the structure X{i} according to the field type 
%   of the structure X{i}.
%
%   PLOTNDPOWERSTATE(X,LEG,OPTIONS) plots as above with default options 
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
%   AX = PLOTNDEPOWERSTATE(X,LEG,OPTIONS) plots as above and returns AX 
%   a column vector of handles to the axis of the plots.
%
%   Examples of usage: -description- that is
%   a        = getISA;
%   he       = superPuma(a);
%   ndhe     = he2ndHe(he);
%   nv       = 9;
%   vspan    = linspace(0,85,nv);
%   nh       = 11;
%   hspan    = linspace(0,2000,nh);  
%   [V,H]    = ndgrid(vspan,hspan);
%   fchv     = getFlightCondition(he,'V',V,'H',H);
%   ndfchv   = fc2ndFC(fchv,he,a);
%   ndpehv   = getNdEpowerState(ndhe,ndfchv);
%   plotNdPowerState(ndpehv,'plot3dMode','parametric');
%   plotNdPowerState(ndpehv);
%   plotNdPowerState(ndpev,'plot2dMode','nFigures');
%   plotNdPowerState(ndpehv,'plot3dMethod',@contour,'labels','on','colormap','autumn','nlevels',5);
%   plotNdPowerState(ndpehv,'plot3dMethod',@surfc,'colormap','copper')
%   plotNdPowerState(ndpehv,'plot3dMethod',@surf,'colormap','bone')
%   plotNdPowerState(ndpehv,'plot3dMethod',@meshc,'colormap','winter')
%
%   To change the default behavior of plotNdPowerState a axes data 
%   structure should be input. For instance, let us say we want to plot
%   power coefficient, nondimensional induced velocity as functions of
%   nondimensional horizontal forward velocity the next axes data 
%   structure is input
%   axs = struct('xvar',{{'VhOR'}},'xunit',1,'xlab',{{'$V/(\Omega R)$'}},...
%                'yvars',{{'CP','lambdaI'}},'yunits',[1,1],'ylabs',{{'$C_P$','$\lambda_I$'}});
%
%   plotNdPowerState(ndpev,...
%                     'Power curve of SuperPuma at sea level',...
%                     'defaultVars',axs);
%
%   Second, plot several ndEpowerStates, by defining a cell of
%   ndEpowerStates, because, for instance the flight height has changed
%   hspan   = linspace(0,1000,5);
%   for i=1:5
%       rho     = a.density(hspan(i));
%       b       = he2ndHe(he);
%       q{i}    = getNdEpowerState(b,c);
%       leg{i}  = strcat('h=',num2str(hspan(i)));
%   end
%   plotNdPowerState(q,leg)
%
%   See also setHeroesPlotOptions, 
%
%

options  = parseOptions(varargin,@setHeroesPlotOptions);

% if ~isstruct(X)
%    error('X: First input argument should be a single structure')
% end

if strcmp(options.defaultVars,'yes')==1
  zvars   = setNdPowerStateVars;
else
  zvars   = options.defaultVars;
end

ax = plotStructureNdMatrix(X,AXDS,AYDS,zvars,options);
if nargout == 1
   varargout{1} = ax;
end


