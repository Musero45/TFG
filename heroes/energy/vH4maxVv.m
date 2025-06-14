function [vHmaxRoc,maxRoc]    = vH4maxVv(he,fC,atmosphere,varargin)
% vMaxMaxROC computes the maximum velocity for maximum rate of climb for a
%            given power
%
%   Example of usage
%   Compute the maximum of the maximum rate of climb and the forward 
%   horizontal velocity of the SuperPuma helicopter at 1000 m.
%   a  = getISA;
%   he = superPuma(a);
%   [vHmaxRoc,maxRoc] = vMaxMaxROC(1000,he,a);
%
%   The function can also be used with a vector of available powers
%   hspan = linspace(1000,2000,5);
%   [vh,rocmax] = vMaxMaxROC(hspan,he,a);
%
%   Now it can be addded a graphic with the rate of climb
%   vspan = linspace(0,70,31);
%   roc1 = vMaxROC(vspan,1000,he,a);
%   roc2 = vMaxROC(vspan,2000,he,a);
%   plot(vspan,roc1,'r-p'); hold on;
%   plot(vspan,roc2,'b-p')
%   plot(vh,rocmax,'k p')
%
%   Now compare with the same result but using the approximation of 
%   excess power
%   vh1 = vMaxMaxROC(1000,he,a,'excessPower','yes');
%   rocmax1 = vMaxROC(vh1,1000,he,a,'excessPower','yes');
%   roca = vMaxROC(vspan,1000,he,a,'excessPower','yes');
%   plot(vh1,rocmax1,'k s'); hold on
%   plot(vspan,roca,'k-');
%   vh2 = vMaxMaxROC(2000,he,a,'excessPower','yes');
%   rocmax2 = vMaxROC(vh2,2000,he,a,'excessPower','yes');
%   rocb = vMaxROC(vspan,2000,he,a,'excessPower','yes');
%   plot(vh2,rocmax2,'g s')
%   plot(vspan,rocb,'g-')


% setup options
options  = parseOptions(varargin,@setHeroesEnergyOptions);

% Get main variable
H         = fC.H;

% Dimensions of the output power state object
n         = numel(H);
s         = size(H);

% Allocate of output variables
maxRoc   = zeros(s);
vHmaxRoc = zeros(s);


% Set initial guess
vGuess   = 400/3.6; %FIXME  
% vGuess   = options.vFzero;

% Compute the vertical velocity depending on the model options
if strcmp(options.excessPower,'yes')
    % Pa is the available power of the engine at height H
    % depending on the specified powerEngineMap option the corresponding
    % engine map is selected to calculate the available power
    % Set constrained or unconstrained engine map due to transmission power
    % limitation
    if strcmp(options.constrainedEnginePower,'yes')
       fPmstr  = strcat('fPa_',options.powerEngineMap);
       fPm    = he.availablePower.(fPmstr);
       % Get available power
       Pa     = fPm(H);
    elseif strcmp(options.constrainedEnginePower,'no')
       fPmstr  = strcat('fP',options.powerEngineMap);
       fPm    = he.engine.(fPmstr);
       % Get available power
       Pa     = fPm(H);
    elseif strcmp(options.constrainedEnginePower,'flightCondition')
       Pa     = fC.P;
       % override flight condition to avoid autorrotation evaluation
       fC.P   = NaN(s);
    else
       error('vMaxMaxROC: wrong input option');
    end


    for i = 1:n
        % Slice flight condition data
        fCc    = getSliceFC(i,fC);
        fCc.H  = H(i);
        vC     = vMaxEndurance(he,fCc,atmosphere);
        fCc.V  = vC;
        PC     = getEpowerState(he,fCc,atmosphere,options);
        maxRoc(i) = (Pa - PC.P)./fC.GW(i);
        vHmaxRoc(i) = vC;
    end
else
    % Pa is the available power of the engine at height H
    % depending on the specified powerEngineMap option the corresponding
    % engine map is selected to calculate the available power
    % Set constrained or unconstrained engine map due to transmission power
    % limitation
    if strcmp(options.constrainedEnginePower,'yes')
       fPmstr  = strcat('fPa_',options.powerEngineMap);
       fPm    = he.availablePower.(fPmstr);
       % Get available power
       Pa     = fPm(H);
    elseif strcmp(options.constrainedEnginePower,'no')
       fPmstr  = strcat('fP',options.powerEngineMap);
       fPm    = he.engine.(fPmstr);
       % Get available power
       Pa     = fPm(H);
    elseif strcmp(options.constrainedEnginePower,'flightCondition')
       Pa     = fC.P;
       % override flight condition to avoid autorrotation evaluation
%        fC.P   = NaN(s);
    else
       error('vMaxMaxROC: wrong input option');
    end
    fC.P   = Pa;

    % This loop and the above one could be collapsed into a single loop
    for i = 1:n
      % Slice flight condition data
      fCc    = getSliceFC(i,fC);
      fCc.H  = H(i);
      f2min  = @(Vh) getVv4Vh(Vh,he,fCc,atmosphere,options);
% % % % % % % % % % % %       f2min        = @(V) (-1)*vMaxROC(V,H(i),Z,he,atmosphere,options);
      ops          = optimset('TolX',1e-12,'Display','off');
      [vHmaxRoc(i,1),MinusMaxRoc]  = fminbnd(f2min,0,vGuess,ops);
      maxRoc(i,1) = -MinusMaxRoc;
    end
end


function Vv = getVv4Vh(Vh,he,fC,atmosphere,options)

fC.Vh   = Vh;
ps      = getEpowerState(he,fC,atmosphere,options);
Vv      = -ps.Vv;
