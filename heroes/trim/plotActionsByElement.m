function varargout = plotActionsByElement(ndtsActions,AXDS,xvalues,varargin)
%plotActionsByElement  Plots nondimensional trim state actions
%
%   plotActionsByElement(A,AXDS,XSPAN) plots nondimensional trim state
%   actions
% 
%   Examples of usage: -description- that is
%   1. Scalar helicopter together with a vector of fligh conditions
%
%   options = setHeroesRigidOptions;
%   atm     = getISA;
% % % % % % % % %   rho0    = atm.rho0;
% % % % % % % % %   g       = atm.g;
%   he      = rigidBo105(atm);
%   ndHe    = rigidHe2ndHe(he,atm,0);
%   muWT    = [0; 0; 0];
%   VOR     = linspace(0.001,0.2,5);
%   FC      = {'VOR',VOR,...
%              'betaf0',0,...
%              'wTOR',0,...
%              'cs',0,...
%              'vTOR',0};
%   ndts        = myGetNdHeTrimState(ndHe,muWT,FC,options);
%   axds        = getaxds({'VOR'},{'$V/(\Omega R)$ [-]'},1);
%   plotActionsByElement(ndts.actions,axds,VOR);              
%   azds        = getaxds({'CFx' 'CMty' 'CFz'},...
%                         {'C_{Fx} [-]' 'C_{My}^{sum} [-]' 'C_{Fz} [-]'}, ...
%                          [1 1 1]);
%   plotActionsByElement(ndts.actions,axds,VOR,'defaultVars',azds);              
%   plotActionsByElement(ndts.actions,axds,VOR,...
%                       'elements',{'mainRotor','tailRotor','weight'},...
%                       'elementsLabels',{'mr','tr','W'},...
%                       'defaultVars',azds);               
%
%
%   2. Cell vector of helicopter together with a scalar fligh condition (hover)
%   FC0     = {'VOR',0.00001,...
%              'betaf0',0,...
%              'wTOR',0,...
%              'cs',0,...
%              'vTOR',0};
%   ndpstr      = 'geometry.Xcg';
%   np          = 5;
%   ndpspan     = ndHe.geometry.Xcg*linspace(0.9,1.1,np);
%   ndhei       = getParametricCellHe(ndHe,ndpstr,ndpspan);
%   ndts        = myGetNdHeTrimState(ndhei,muWT,FC0,options);
%   ndtact      = cosws2coswmf(ndts,'actions');
%   axds        = getaxds({'Xcg'},{'$x_{cg}/R$ [-]'},1);
%   azds        = getaxds({'CFx' 'CFy' 'CFz' ...
%                          'CMtx' 'CMty' 'CMtz' },...
%                         {'C_{Fx} [-]' 'C_{Fy} [-]' 'C_{Fz} [-]' ...
%                          'C_{Mx}^{sum} [-]' 'C_{My}^{sum} [-]' 'C_{Mz}^{sum} [-]'}, ...
%                          [1 1 1 ...
%                           1 1 1]);
%   plotActionsByElement(ndtact,axds,ndpspan,...
%                       'defaultVars',azds);               
%   
%   plotActionsByElement(ndtact,axds,ndpspan,...
%                       'elements',{'fuselage','verticalFin','leftHTP','rightHTP'},...
%                       'elementsLabels',{'f','vf','lht','rht'},...
%                       'defaultVars',azds);               
%
%   3. How to plot single components of actions. using the above example
%   number 2 we can select the actions of an arbitrary component, let us
%   say tail rotor, in the fuselage coordinate system as follows:
%   ndttr       = cosws2coswmf(ndts,'actions.tailRotor.fuselage');
%   ndttr       = coswmf_cos2swmf(ndttr,ndhei,ndpstr);
%   plotActionsByElement(ndttr,axds,{'tr'},...
%                       'defaultVars',azds);               
%
%   
%
% TODO
% - rename function to plotTrimStateActions
%
% NOTES
% - This function initially (Nano's time) was called as follows:
%   function plotActionsByElement(trimStateActions)
%   function plotActionsByElement(trimStateActions,j) 
% 
%   depending on the place in which was called. 
%
%   We have found that sometimes was called with one input argument other 
%   times was called with two input arguments without any varargin mechanism 
%   implementation. This behaviour should be fixed.
%
%   Now, the function has been rewritten to consider that the second argument 
%   is intended to be a cell of pairs parameter value


options  = parseOptions(varargin,@setActionsByElementsPlotOptions);



% if ~isstruct(X)
%    error('X: First input argument should be a single structure')
% end

if strcmp(options.defaultVars,'yes')==1
  zvars   = setNdTrimActionsVars;
else
  zvars   = options.defaultVars;
end

frame          = options.frame;
elements       = options.elements;
elementsLabels = options.elementsLabels;


n = length(elements);

fS = cell(n,1);


if iscell(ndtsActions)
    % this means a scalar of flight conditions (hover) together
    % with a cell vector ndHe (parameter variation)
    na    = length(ndtsActions);
    for k = 1:length(zvars.var)
        for i = 1:n
            for j = 1:na
                v(j) =ndtsActions{j}.(elements{i}).(frame).(zvars.var{k});
            end
            fS{i}.(zvars.var{k})   = v;
            fS{i}.(char(AXDS.var)) = xvalues;
        end
    end
elseif isstruct(ndtsActions)
    pureActions = false;
    % check the kind of structure 
    % (a) pure ndtsActions structure-> fields: weight, mainRotor, ...
    % rightHTP
    % (b) action components structure-> fields: CFx, CMx, CMFx, CMtx
    flnm = fieldnames(ndtsActions);
    for i = 1:length(flnm)
        if strcmp(elements{1},flnm{i});
           pureActions = true;
        end
    end
    if pureActions
        % this means a vector of flight conditions 
        % together with a scalar ndHe. And moreover, the fields of the
        % structure are elements
        for i = 1:n
            A                     = ndtsActions.(elements{i}).(frame);
            A.(char(AXDS.var))    = xvalues;
            fS{i}                 = A;
        end
    else
       % this means a vector of helicopters together with a scalar flight
       % condition which has been previously sliced and only the actions
       % components of a certain component has been selected using 
       % cosws2coswmf and coswmf_cos2swmf with a parameter string such as
       % actions.component.coordinatesystem
       fS = {ndtsActions};
       % Because for this case xvalues are redundant, they are included
       % into the ndtsActions structure we have overloaded the input
       % argument list and for this very particular case xvalues can be a
       % legend string 
       elementsLabels = xvalues;
    end
end

ax = plotCellOfStructures(fS,AXDS,zvars,elementsLabels,options);
if nargout == 1
   varargout{1} = ax;
end

function A = setNdTrimActionsVars


yvars   = {'CFx' 'CFy' 'CFz' ...
           'CMx' 'CMy' 'CMz' ...
           'CMFx' 'CMFy' 'CMFz' ...
           'CMtx' 'CMty' 'CMtz' ...
           };
ylabs   = {'C_{Fx} [-]' 'C_{Fy} [-]' 'C_{Fz} [-]' ...
           'C_{Mx} [-]' 'C_{My} [-]' 'C_{Mz} [-]' ...
           'C_{Mx}^F [-]' 'C_{My}^F [-]' 'C_{Mz}^F [-]' ...
           'C_{Mx}^{sum} [-]' 'C_{My}^{sum} [-]' 'C_{Mz}^{sum} [-]' ...
          };

yunits  = [1 1 1 ...
            1 1 1 ...
            1 1 1 ...
            1 1 1 ...
           ];



A = getaxds(yvars,ylabs,yunits);




function options = setActionsByElementsPlotOptions


options  = setHeroesPlotOptions;

% We override the mark field option
% to denote each component by using different markers
mark   = {'k-o','k-.x','k--*','k-s','k-.d','k--^','k-v'};

% 
frame = 'fuselage';

elements = {'mainRotor' 'tailRotor' ...
        'fuselage' 'verticalFin' ...
        'leftHTP' 'rightHTP' ...
        'weight'};
elementsLabels = {'mr' 'tr' 'f' 'vf' 'lht' 'rht' 'W'};

% Adding other fields
options.mark           = mark;
options.frame          = frame;
options.elements       = elements;
options.elementsLabels = elementsLabels;










