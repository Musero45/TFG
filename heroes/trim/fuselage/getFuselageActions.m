function [CF,CM] = getFuselageActions(flightConditionFus,ndFus)
%getFuselageActions  returns the vector coefficients of forces and moments
%arround the center of mass of the helicopter, O due to aerodynamic actions
%on the fuselaje.
%
%   getFuselageActions(ndfCF,ndFus) returns the coefficients of forces for
%   a flight condition  ndfCF and a non dimensional fuselaje, ndFus.  
%
%   [CF,CM] = getFuselageActions(ndfCF,ndFus) returns the 
%   coefficients of forces, CF, and moments, CM, arround the center
%   of mass of the helicopter, O  for a flight condition  ndfCF and a
%   non dimensional fuselaje, ndFus.
%
%   Both vectors coefficients are expressed in the body reference system
%   of the helicopter [x,y,z], and they are obtained by making the
%   aerodynamic forces and moments nondimensional with the characteristic
%   thrust Tu and the characteristic torque Qu. 
%
%   nfCF is a colunm vector 
%                         
%   For example, PLOT(X,Y,'c+:') plots a cyan dotted line with a plus 
%   at each data point; PLOT(X,Y,'bd') plots blue diamond at each data 
%   point but does not draw any line.
%
%   PLOT(X1,Y1,S1,X2,Y2,S2,X3,Y3,S3,...) combines the plots defined by
%   the (X,Y,S) triples, where the X's and Y's are vectors or matrices 
%   and the S's are strings.  
%
%   For example, PLOT(X,Y,'y-',X,Y,'go') plots the data twice, with a
%   solid yellow line interpolating green circles at the data points.
%
%   The PLOT command, if no color is specified, makes automatic use of
%   the colors specified by the axes ColorOrder property.  By default,
%   PLOT cycles through the colors in the ColorOrder property.  For
%   monochrome systems, PLOT cycles over the axes LineStyleOrder property.
%
%   Note that RGB colors in the ColorOrder property may differ from
%   similarly-named colors in the (X,Y,S) triples.  For example, the 
%   second axes ColorOrder property is medium green with RGB [0 .5 0],
%   while PLOT(X,Y,'g') plots a green line with RGB [0 1 0].
%
%   If you do not specify a marker type, PLOT uses no marker. 
%   If you do not specify a line style, PLOT uses a solid line.
%
%   PLOT(AX,...) plots into the axes with handle AX.
%
%   PLOT returns a column vector of handles to lineseries objects, one
%   handle per plotted line. 
%
%   The X,Y pairs, or X,Y,S triples, can be followed by 
%   parameter/value pairs to specify additional properties 
%   of the lines. For example, PLOT(X,Y,'LineWidth',2,'Color',[.6 0 0]) 
%   will create a plot with a dark red line width of 2 points.
%
%   Example
%      x = -pi:pi/10:pi;
%      y = tan(sin(x)) - sin(tan(x));
%      plot(x,y,'--rs','LineWidth',2,...
%                      'MarkerEdgeColor','k',...
%                      'MarkerFaceColor','g',...
%                      'MarkerSize',10)
%
%   See also PLOTTOOLS, SEMILOGX, SEMILOGY, LOGLOG, PLOTYY, PLOT3, GRID,
%   TITLE, XLABEL, YLABEL, AXIS, AXES, HOLD, LEGEND, SUBPLOT, SCATTER.

%   If the NextPlot axes property is "replace" (HOLD is off), PLOT resets 
%   all axes properties, except Position, to their default values,
%   deletes all axes children (line, patch, text, surface, and
%   image objects), and sets the View property to [0 90].

%   Copyright 1984-2009 The MathWorks, Inc. 
%   $Revision: 5.19.4.10 $  $Date: 2009/05/18 20:48:24 $
%   Built-in function.

Re = 1e6;

muxf  = flightConditionFus(1);
muyf  = flightConditionFus(2);
muzf  = flightConditionFus(3);

ndSp   = ndFus.ndSp;
ndSs   = ndFus.ndSs;
ndlf   = ndFus.ndlf;
model  = ndFus.model;

ndVf2 = muxf^2+muyf^2+muzf^2;

alphaF = atan2(-muzf,-muxf);
if ndVf2 ~= 0
    betaF  = asin(-muyf/sqrt(ndVf2));
else
    betaF = 0;
end

K = model(alphaF,betaF,Re);

CFx = 0.5*ndSp*ndVf2*K(1);
CFy = 0.5*ndSs*ndVf2*K(2);
CFz = 0.5*ndSp*ndVf2*K(3);

CMx = 0.5*ndSs*ndlf*ndVf2*K(4);
CMy = 0.5*ndSp*ndlf*ndVf2*K(5);
CMz = 0.5*ndSs*ndlf*ndVf2*K(6);

CF = [CFx; CFy; CFz];
CM = [CMx; CMy; CMz];
end