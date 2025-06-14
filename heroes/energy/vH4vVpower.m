function [vH,gammaT]    = vH4vVpower(he,flightCondition,atmosphere,varargin)
% --WATCHOUT this is blatant rip-off of vV4vHPower.m
% 
% vMaxROC computes the velocity for maximum rate of climb
%
%
%   Example of usage
%   Compute the rate of climb of a SuperPuma helicopter at sea
%   level for a given available power of 3 MW. Compare this rate of climb
%   with the rate of climb obtained using the excess power assumption.
%   atm        = getISA;
%   he         = superPuma(atm);
%   nv         = 31;
%   VH         = linspace(0,100,nv)';
%   Hsl        = zeros(nv,1);
%   Pa         = 3.0e6*ones(nv,1);
%   fc         = getFlightCondition(he,'Vh',VH,'H',Hsl,'P',Pa);
%   [VVa,gTa]  = vMaxROC(he,fc,atm,...
%                'constrainedEnginePower','flightCondition');
%   [VVb,gTb]  = vMaxROC(he,fc,atm,...
%                'constrainedEnginePower','flightCondition',...
%                'excessPower','yes');
%   figure(1)
%   plot(VH,VVa,'b-.'); hold on;
%   plot(VH,VVb,'r-'); hold on;
%   xlabel('$V_H$ [m/s]');ylabel('$V_V$ [m/s]'); grid on;
%   legend({'Excess power = no','Excess power = yes'},'Location','Best')
%
%   Compute as above the rate of climb of a SuperPuma helicopter at sea
%   level but for this example use the available maximum continuous 
%   power at sea level instead of an imposed power of 3 MW. Compare this
%   rate of climb with the rate of climb obtained using the 

% . Compare this rate of climb
%   with the rate of climb obtained using the excess power assumption.






% setup options
options  = parseOptions(varargin,@setHeroesEnergyOptions);

% Get main variable
H         = flightCondition.H;

% Dimensions of the output power state object
n         = numel(H);
s         = size(H);


% Allocation of output variables
vH      = zeros(s);
gammaT  = zeros(s);


% We guess a reasonable horizontal velocity about 1-10 m/s
vGuess  = options.vFzero./100;

% Compute the vertical velocity depending on the model options
if strcmp(options.excessPower,'yes')
   error('vH4vVpower: for the moment being this option is not implemented')
%     % Pa is the available power of the engine at height H
%     % depending on the specified powerEngineMap option the corresponding
%     % engine map is selected to calculate the available power
%     % Set constrained or unconstrained engine map due to transmission power
%     % limitation
%     if strcmp(options.constrainedEnginePower,'yes')
%        fPmstr  = strcat('fPa_',options.powerEngineMap);
%        fPm    = he.availablePower.(fPmstr);
%        % Get available power
%        Pa     = fPm(H);
%     elseif strcmp(options.constrainedEnginePower,'no')
%        fPmstr  = strcat('fP',options.powerEngineMap);
%        fPm    = he.engine.(fPmstr);
%        % Get available power
%        Pa     = fPm(H);
%     elseif strcmp(options.constrainedEnginePower,'flightCondition')
%        Pa     = flightCondition.P;
%        % override flight condition to avoid autorrotation evaluation
%        flightCondition.P   = NaN(s);
%     else
%        error('vH4vVPower: wrong input option');
%     end
% 
%     for i = 1:n
%         % Slice flight condition data
%         fCc       = getSliceFC(i,flightCondition);
%         fCc.V     = fCc.Vh;
%         fCc.gammaT= 0;
%         PrH       = getEpowerState(he,fCc,atmosphere,options);
%         roc(i)    = (Pa(i) - PrH.P)./fCc.GW;
%         gammaT(i) = atan(roc(i)/fCc.Vh);
%     end
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
       Pa     = flightCondition.P;
       % override flight condition to avoid autorrotation evaluation
%        flightCondition.P   = NaN(s);
    else
       error('vH4vVPower: wrong input option');
    end
    flightCondition.P   = Pa;
    
    % This loop and the above one could be collapsed into a single loop
    for i = 1:n
        % Slice flight condition data
        fCc       = getSliceFC(i,flightCondition);
        myfun     = @(vH) solveVv(vH,he,fCc,atmosphere,options);
        vH(i)     = fzero(myfun,vGuess);
        gammaT(i) = atan(fCc.Vv/vH(i));
        % continuation
        vGuess    = vH(i);
    end
end



function F = solveVv(vH,he,fCc,atmosphere,options)


fCc.Vh    = vH;
PrH       = getEpowerState(he,fCc,atmosphere,options);
roc       = PrH.Vv;
F         = roc - fCc.Vv;


