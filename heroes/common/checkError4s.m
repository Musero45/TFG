function err = checkError4s(X,Y,xvar,varargin)
%CHECKERROR Check error for two cell of structures
%     What the function does is to obtain the diference between the zvars 
%   of the structures introduced (X,Y) for different values of another 
%   variable(xvar);that are going to be the axis x variables, while the zvars 
%   the z axis variables and the ones compared. 
%     Then different methods are used to calculate an estimation of that
%   error or difference(standard desviation, the mean, or the root mean square)
%
%   Examples of usage:
%   >> io = checkError4s(x,y); 
%   >> io = checkError4s(x,y,'metric','std');   standard desviation
%   >> io = checkError4s(x,y,'metric','mean');  mean
%   >> io = checkError4s(x,y,'metric','rms');   root mean square
%   >> io = checkError4s(x,y,'measure',@norm);
%   >> io = checkError4s(x,y,'vars',{'W'});
%   >> io = checkError4s(x,y,'vars',{'W','t','h'});
%
%   Code example:
%   X -> X.V                    Y -> Y.V
%        X.Fx_u                      Y.Fx_u
%        X.Fx_w                      Y.Fx_w
%        ...                         ...
%        X.My_w                      Y.My_w
%
%   xvar   = {'V'};
%   zvars  = {'Fx_u','Fx_w','Fz_u','Fz_w','My_u','My_w'};
%   [err] = MycheckError4s (X,Y,xvar,'metric', 'mean',... 
%                             'TOL', 1e-10,'zvars',zvars);
%
%     To obtain the diference it is needed to interpol the variables of Y 
%   in order to get them refered to the same x axis as the X variables.
%     The firs variable (X) is the one that is going to be the reference 
%   to get the points using interp1 of the Y variable, according to the X  
%   variable values of xvar(axis x)
%
%   For example:
%       we want to compare 2 strctures of ____ by the speed(axis x).
%       'X.V' is the vector of speeds reference
%       'Y' values will be interpolled to obtain it for the speeds
%       of 'X.V' vector values.
%       This implies that the variable 'Y' values after the interpolation
%       will be set in a vector of the same lenght as X.V 
%
%

if length(X) ~= 1 || length(Y) ~= 1
   error('CHECKERROR4S:the input cell of structures to compute the error should be of lenght one ')
end

X  = output2structure(X);
Y  = output2structure(Y);

options   = getCheckErrorOptions;
if nargin >= 3
   options  = parse_pv_pairs(options,varargin);
end

% Select variables to check
if strcmp(options.zvars,'all')
    Zvars     = selectPostVars(X);
    zvars     = Zvars.yvars;
    
elseif iscell(options.zvars)
    zvars = options.zvars;
else
    zvars = {options.zvars};
end

[x,y]     = extractVars(X,Y,zvars);

% Parsing with xvar what to do
Lvar      = length(zvars);

if ~isempty(xvar)
    xVARX     = X.(xvar);
    xVARY     = Y.(xvar); 
    Lx        = length(xVARX);
    yq        = zeros(Lvar,Lx);

    for k=1:Lvar

        yq(k,:) = interp1(xVARY,y(k,:),xVARX,'linear','extrap');

    end 

else 
    % if xvar is empty it means that we want just to compare vectorwise the
    % components of the fields
    yq        = y;

end   


% Compute error according to measure
errEnd = abs(x-yq);

% Impose metric to determine the error
if strcmp(options.metric,'std') 
   errXY = std(errEnd,0,2);     
elseif strcmp(options.metric,'mean') 
   errXY = mean(errEnd,2);
elseif strcmp(options.metric,'rms')  
   errXY = rms(errEnd,2);
end

 for j=1:Lvar
% Create the structure that will be output of the function     
err.(zvars{j})= errXY(j);       

% Check error
if strcmp(options.inequalitySign,'little')
   io   = errXY(j) < options.TOL;
elseif strcmp(options.inequalitySign,'greater')
   io   = errXY(j) > options.TOL;
end
    
% Create the structure that will be output of the function    
%     if io
%       err.([zvars{j},'_passed'])=errXY(j);
%     else
%       err.([zvars{j},'_failed'])=errXY(j);
%     end  
    
if io
  disp(strcat(zvars{j},':',options.label,'_passed'));
else
  disp(strcat(zvars{j},':',options.label,'_failed'));
end  
%   disp(strcat('Relative Error of?',zvars{j},'?:',num2str(errXY(j))));

end

function opts = getCheckErrorOptions

opts  = struct( ...
'inequalitySign','little',...
'label','Test',...
'zvars','all',...% 'all' | {cell of variables} 
'metric','mean',...  % 'std' | 'mean' | 'rms' ...
'measure',@norm,... % @norm
'TOL',1e-3 );

function [x,y] = extractVars(X,Y,vars)
nx   = length(X.(vars{1}));
ny   = length(Y.(vars{1}));
nv   = length(vars);
x    = zeros(nv,nx);
y    = zeros(nv,ny);
for i=1:nv
   x(i,:) = X.(vars{i});
   y(i,:) = Y.(vars{i});
end
