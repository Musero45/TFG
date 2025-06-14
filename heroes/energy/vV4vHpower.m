function [roc,gammaT]    = vV4vHpower(he,flightCondition,atmosphere,varargin)
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






% % % % % % % % % % %   The maximum rate of climb can be also computed for a velocity vector,
% % % % % % % % % % %   and for other engine maps
% % % % % % % % % % %   vspan = linspace(0,70,31);
% % % % % % % % % % %   roc1 = vMaxROC(vspan,1000,Z,he,a);
% % % % % % % % % % %   roc2 = vMaxROC(vspan,1000,Z,he,a,'powerEngineMap','fPmt');
% % % % % % % % % % %   plot(vspan,roc1,'r-o'); hold on
% % % % % % % % % % %   plot(vspan,roc2,'b-s')
% % % % % % % % % % %
% % % % % % % % % % %   Depending on the options, the maximum rate of climb can be computed 
% % % % % % % % % % %   with of without the assumption of excess power:
% % % % % % % % % % %   close all
% % % % % % % % % % %   vspan = linspace(0,70,31);
% % % % % % % % % % %   roc1 = vMaxROC(vspan,1000,Z,he,a);
% % % % % % % % % % %   roc2 = vMaxROC(vspan,1000,Z,he,a,'excessPower','yes');
% % % % % % % % % % %   plot(vspan,roc1,'m-d'); hold on
% % % % % % % % % % %   plot(vspan,roc2,'b-s')
% % % % % % % % % % %
% % % % % % % % % % %   TO BE DONE: MOVE FUNCTION TO OUTPUT A MATRIX WHEN VECTORS OF VELOCITIES
% % % % % % % % % % %   AND HEIGHT ARE INPUT. IT IS A LITTLE DIFFICULT BECAUSE HE2NDHE OUTPUTS
% % % % % % % % % % %   A NONDIMENSIONAL HELICOPTER INSTEAD OF A CELL OF NONDIMENSIONAL
% % % % % % % % % % %   HELICOPTERS WHEN A VECTOR OF HEIGHTS INPUTS. FOR THE MOMENT WHEN A
% % % % % % % % % % %   STUDY WITH HEIGHT A PARAMETER IS REQUIRED A OUTER LOOP IS REQUIRED
% % % % % % % % % % %
% % % % % % % % % % %

% setup options
options  = parseOptions(varargin,@setHeroesEnergyOptions);

% Get main variable
H         = flightCondition.H;

% Dimensions of the output power state object
n         = numel(H);
s         = size(H);


% Allocation of output variables
roc     = zeros(s);
gammaT  = zeros(s);


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
       Pa     = flightCondition.P;
       % override flight condition to avoid autorrotation evaluation
       flightCondition.P   = NaN(s);
    else
       error('vV4vH: wrong input option');
    end

    for i = 1:n
        % Slice flight condition data
        fCc       = getSliceFC(i,flightCondition);
        fCc.V     = fCc.Vh;
        fCc.gammaT= 0;
        PrH       = getEpowerState(he,fCc,atmosphere,options);
        roc(i)    = (Pa(i) - PrH.P)./fCc.GW;
        gammaT(i) = atan(roc(i)/fCc.Vh);
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
       Pa     = flightCondition.P;
       % override flight condition to avoid autorrotation evaluation
%        flightCondition.P   = NaN(s);
    else
       error('vV4vH: wrong input option');
    end
    flightCondition.P   = Pa;
    
    % This loop and the above one could be collapsed into a single loop
    for i = 1:n
        % Slice flight condition data
        fCc       = getSliceFC(i,flightCondition);
        PrH       = getEpowerState(he,fCc,atmosphere,options);
        roc(i)    = PrH.Vv;
        gammaT(i) = PrH.gammaT;
    end
end


% % % % % % % % % % % % % % Set constrained or unconstrained engine map due to transmission power
% % % % % % % % % % % % % % limitation
% % % % % % % % % % % % % if strcmp(options.constrainedEnginePower,'yes')
% % % % % % % % % % % % %    fPmstr  = strcat('fPa_',options.powerEngineMap);
% % % % % % % % % % % % %    fPm    = he.availablePower.(fPmstr);
% % % % % % % % % % % % % elseif strcmp(options.constrainedEnginePower,'no')
% % % % % % % % % % % % %    fPmstr  = strcat('fP',options.powerEngineMap);
% % % % % % % % % % % % %    fPm    = he.engine.(fPmstr);
% % % % % % % % % % % % % else
% % % % % % % % % % % % %    error('vMaxROC: wrong input option');
% % % % % % % % % % % % % end

% % % % % % % % % % % % % % % % % % % Compute the ROC depending on the model options
% % % % % % % % % % % % % % % % % % for j=1:n
% % % % % % % % % % % % % % % % % % % Pa is the available power of the engine at height H
% % % % % % % % % % % % % % % % % % % depending on the specified powerEngineMap option the corresponding
% % % % % % % % % % % % % % % % % % % engine map is selected to calculate the available power
% % % % % % % % % % % % % % % % % % 
% % % % % % % % % % % % % % % % % % Pa     = fPm(H(j));
% % % % % % % % % % % % % % % % % % 
% % % % % % % % % % % % % % % % % % % Define nondimensional helicopter
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % rho       = atmosphere.density(H(j));
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % ndHe      = he2ndHe(he,rho);
% % % % % % % % % % % % % % % % % % ndHe      = he2ndHe(he);
% % % % % % % % % % % % % % % % % % 
% % % % % % % % % % % % % % % % % % 
% % % % % % % % % % % % % % % % % % if strcmp(options.excessPower,'yes')
% % % % % % % % % % % % % % % % % % 
% % % % % % % % % % % % % % % % % % %Compute Roc for each V
% % % % % % % % % % % % % % % % % %   for i = 1:nv
% % % % % % % % % % % % % % % % % %      fc = struct('V',Vh(i),'gammaT',0,'H',H(j),'Z',Z);
% % % % % % % % % % % % % % % % % %      PrH  = getEpowerState(he,fc,atmosphere,options);
% % % % % % % % % % % % % % % % % %      
% % % % % % % % % % % % % % % % % %      roc(j,i)  = (Pa - PrH.P)./he.W;
% % % % % % % % % % % % % % % % % %      gammaT(j,i) = atan(roc(j,i)/Vh(i));
% % % % % % % % % % % % % % % % % %   end
% % % % % % % % % % % % % % % % % %   
% % % % % % % % % % % % % % % % % % else
% % % % % % % % % % % % % % % % % %   %adimensionalizers
% % % % % % % % % % % % % % % % % %   OR    = he.characteristic.OR;
% % % % % % % % % % % % % % % % % %   Pu    = he.characteristic.Pu(H(j));
% % % % % % % % % % % % % % % % % %   
% % % % % % % % % % % % % % % % % %   %power terms
% % % % % % % % % % % % % % % % % %   etaM  = he.transmission.etaM;
% % % % % % % % % % % % % % % % % %   Pamr  = Pa/etaM;
% % % % % % % % % % % % % % % % % %   CP    = Pamr/Pu;
% % % % % % % % % % % % % % % % % %   muH   = Vh/OR;
% % % % % % % % % % % % % % % % % %   Z_nd  = Z/he.mainRotor.R;
% % % % % % % % % % % % % % % % % % 
% % % % % % % % % % % % % % % % % %   %ndHe parameters
% % % % % % % % % % % % % % % % % %   K     = ndHe.mainRotor.K;
% % % % % % % % % % % % % % % % % %   sigma = ndHe.mainRotor.sigma;
% % % % % % % % % % % % % % % % % %   Cd0   = ndHe.mainRotor.cd0;
% % % % % % % % % % % % % % % % % %   kappa = ndHe.mainRotor.kappa;
% % % % % % % % % % % % % % % % % %   CW    = ndHe.CW;
% % % % % % % % % % % % % % % % % %   fS    = ndHe.fuselage.fS;
% % % % % % % % % % % % % % % % % % 
% % % % % % % % % % % % % % % % % %   % Set initial guess
% % % % % % % % % % % % % % % % % %   ROC0     = +10.4;
% % % % % % % % % % % % % % % % % %   lambdaI0 = -0.001;
% % % % % % % % % % % % % % % % % %   Xguess   = [ROC0;lambdaI0];
% % % % % % % % % % % % % % % % % %   
% % % % % % % % % % % % % % % % % %   %solve system for each V
% % % % % % % % % % % % % % % % % %   opt = optimset('Display','off');
% % % % % % % % % % % % % % % % % %   for i = 1:nv
% % % % % % % % % % % % % % % % % %       %system
% % % % % % % % % % % % % % % % % %       kG    = options.igeModel(Z_nd,muH(i));
% % % % % % % % % % % % % % % % % %       nlsE = @(X) energyEquationsRoc (CW,muH(i),X(1),atan(X(1)/muH(i)),X(2),...
% % % % % % % % % % % % % % % % % %           kappa,fS,sigma,Cd0,K,CP,kG,options);
% % % % % % % % % % % % % % % % % %       X    = fsolve(nlsE,Xguess,opt);
% % % % % % % % % % % % % % % % % %       Xguess   = [X(1);X(2)];
% % % % % % % % % % % % % % % % % %       
% % % % % % % % % % % % % % % % % %       %solutions
% % % % % % % % % % % % % % % % % %       roc(j,i) = X(1)*OR;
% % % % % % % % % % % % % % % % % %       gammaT(j,i)  = atan(X(1)*muH(i));
% % % % % % % % % % % % % % % % % %       lambdaI(j,i) = X(2);
% % % % % % % % % % % % % % % % % % 
% % % % % % % % % % % % % % % % % %   end
% % % % % % % % % % % % % % % % % % end
% % % % % % % % % % % % % % % % % % end
% % % % % % % % % % % % % % % % % % 
% % % % % % % % % % % % % % % % % % function F = energyEquationsRoc (CW,VhOR,ROCOR,gammaT,lambdaI,kappa,fS,sigma,...
% % % % % % % % % % % % % % % % % %                                     Cd0,K,CP,kG,options)
% % % % % % % % % % % % % % % % % % %energyEquations for ROC calculating, includes de gammaT muH and muV=ROC*OR
% % % % % % % % % % % % % % % % % % 
% % % % % % % % % % % % % % % % % % % Get induced velocity model
% % % % % % % % % % % % % % % % % % indVelModel = options.inducedVelocity; 
% % % % % % % % % % % % % % % % % % 
% % % % % % % % % % % % % % % % % % % Pass Vor and gammaT to mu terms
% % % % % % % % % % % % % % % % % % [mux,muWx,muy,muWy,muzp]  = VORgammaT2mu(((VhOR^2+ROCOR^2)^0.5),gammaT);
% % % % % % % % % % % % % % % % % % 
% % % % % % % % % % % % % % % % % % % First equation: induced velocity
% % % % % % % % % % % % % % % % % % F(1,1) = indVelModel(lambdaI,CW,mux,muWx,muy,muWy,muzp);
% % % % % % % % % % % % % % % % % % 
% % % % % % % % % % % % % % % % % % % second equation: power terms for main rotor
% % % % % % % % % % % % % % % % % % CPi   = - lambdaI.*CW.*kappa*kG;
% % % % % % % % % % % % % % % % % % CPf   =   fS/2*(((VhOR^2+ROCOR^2)^0.5)).^3;
% % % % % % % % % % % % % % % % % % CPcd0 =   sigma*Cd0/8*(1+K*(((VhOR^2+ROCOR^2)^0.5)*cos(gammaT)).^2);
% % % % % % % % % % % % % % % % % % CPg   =   ((VhOR^2+ROCOR^2)^0.5)*sin(gammaT)*CW;
% % % % % % % % % % % % % % % % % % 
% % % % % % % % % % % % % % % % % % F(2,1)     = CPi + CPf + CPcd0 + CPg - CP;
% % % % % % % % % % % % % % % % % % 
% % % % % % % % % % % % % % % % % % 
% % % % % % % % % % % % % % % % % % 
% % % % % % % % % % % % % % % % % % 
% % % % % % % % % % % % % % % % % % 
