function varargout = plotTrimState(X,leg,varargin)
%PLOTTRIMSTATE  Plots helicopter trim state
%
%   PLOTTRIMSTATE(X,LEG) plots the helicopter rigid state defined
%   by cell of structures, X, using the cell of legends, LEG. X should be 
%   a cell of helicopter trim output structures and LEG should be of the 
%   same length that X. In case that LEG is equal to '' or [] then 
%   the set of plots does not show any legend. PLOTTRIMSTATE plots 
%   every field of the structure X{i} according to the field type 
%   of the structure X{i}. Basically, PLOTTRIMSTATE produces three kind of
%   plots. The first set of plts is associated to the basic trim state
%   variables as defined by setTrimStateVars. The second set of plots are
%   the nondimensional actions, forces and moments, due to every active
%   element of the helicopter. The third set of plots are the trim control
%   variables.
%
%   PLOTTRIMSTATE(X,LEG,OPTIONS) plots as above with default options 
%   replaced by values set in OPTIONS. OPTIONS should be input in the form 
%   of sets of property value pairs. Default OPTIONS is a structure with 
%   the fields and values set by SETTRIMPLOTOPTIONS
%
%   AX = PLOTTRIMSTATE(X,LEG,OPTIONS) plots as above and returns AX 
%   a column vector of handles to the axis of the plots.
%
%   Examples of usage:
%   First load an atmosphere, then define a design requirement, and
%   get a non dimensional rigid helicopter, ndHe, providing the vertical
%   fin surface, Svt, and the horizontal tail plane chord, cHTP
%   atm        = getISA;
%   numEngines = 1;
%   engine     = Arriel2C1(atm,numEngines);
%   dr         = cesarDR;
%   stathe     = desreq2stathe(dr,engine);
%   Svt        = .805;
%   cHTP       = .4;
%   he         = stathe2rigidhe(stathe,atm,cHTP,Svt);
%   ndHe       = rigidHe2ndHe(he,atm,0);
%
%   Then define the flight condition by giving a vector of forward speeds
%   ndV                   = linspace(.2, .3, 4);
%   n                     = length(ndV);
%   muWT                  = [0; 0; 0];
%   flightConditionT      = zeros(6,n);
%   flightConditionT(1,:) = ndV(:);
%
%   Finally compute the trim state for every flight condition and plot 
%   the non dimensional trim states
%   trimState     = getTrimState(flightConditionT,muWT,ndHe);
%   plotTrimState(trimState,{'Bo-105'})
%
%   If prefix is set to a char, files with a name formed by 
%   prefix and the plotted variable name are saved as the formats
%   especified by the field format. If closePlot is set to 'yes' then
%   all the figures are closed. 
%
%   The following example plots the trim state computed above without
%   plotting actions by element nor control angles output using as legend 
%   the above value, save the plot as png and tiff formats using as prefix 
%   'test' and closes all the plots
%   plotTrimState(trimState,{'Bo-105'},...
%   'actionsByElements','no','controlAngles','no',...
%   'prefix','test','closePlot','yes','format',{'png','tiff'});
%
%   Please, note that in spite of the fact that the first set of windows were
%   open the new set of windows get a new figure handle which does not
%   interfere with the previous plots. However, all the figures are closed
%   when the option closePlot is set to 'yes'.
%
%   See also setTrimPlotOptions, getTrimState, plotActionsByElement, 
%   plotControlAngles

X  = output2cellOfStructures(X);
nX = length(X);
o  = parseOptions(varargin,@setTrimPlotOptions);

if isstruct(o.defaultVars)
  Zvars   = o.defaultVars;
elseif strcmp(o.defaultVars,'yes')==1
  Zvars   = setTrimStateVars;
end

ax  = plotCellOfStructures(X,Zvars,leg,o);


% Plot actions by elements
if strcmp(o.actionsByElements,'yes');
   for i = 1:nX
       plotActionsByElement(X{i},o);
   end
end

% plot control angles
if strcmp(o.controlAngles,'yes');
plotControlAngles(X,leg,o);
end

% FIXME set ax output depending on options 
if nargout == 1
   varargout{1} = ax;
end


