function [vB,PB] = vMaxRange(he,fC,atmosphere,varargin)
%vMaxRange  Computes the velocity of maximum range for a
%           level forward flight
%
%   [vE,PE] = vMaxRange(HE,FC,ATM) returns the forward speed of a level
%   cruise for maximum range, vE, and the required power for this 
%   condition, PE, for a given helicopter, HE, an altitude defined 
%   by the flight condition, FC, and flying into an ISA amosphere ATM.
%
%   [vE,PE] = vMaxRange(HE,FC,ATM,OPTIONS) computes as above with 
%   default options replaced by values set in OPTIONS. OPTIONS should
%   be input in the form of sets of property value pairs. Default 
%   OPTIONS is a structure defined by setHeroesEnergyOptions with the 
%   following fields and values:
%                               Z: NaN
%                        igeModel: @kGoge
%                     excessPower: 'no'
%      forwardFlightApproximation: 'none'
%     fuselageVelocityCalculation: 'none'
%          constrainedEnginePower: 'yes'
%                  powerEngineMap: 'mc'
%                          hGuess: [0 12000]
%                          vGuess: 600
%                    tailrotor2cp: 'eta'
%                 inducedVelocity: @Glauert
%                 externalPLinPLR:'yes'
%
%   Example of usage
%   Compute the forward speed for maximum range of a Super Puma
%   helicopter at 500 m altitude with a gross weight of 73550 N and 
%   fuel mass of 1600 kg. 
%   atm     = getISA;
%   he      = superPuma(atm);
%   GW      = 73550;
%   Mf      = 1600;
%   fC      = getFlightCondition(he,'H',500,'GW',GW,'Mf',Mf);
%   [vA,PA] = vMaxRange(he,fC,atm)
%
%   [For debugging purposes the maximum velocity for 
%    given power of PA = 1.143386485344938e+06 is vA = 62.395326023937564]
%
%   Plot the variation of forward speed for maximum range and 
%   the corresponding required power of a SuperPuma helicopter for 
%   altitudes between sea level (SL) and 2000 m gross weight of 73550 N and 
%   fuel mass of 1600 kg.
%   nh      = 31;
%   hspan   = linspace(0,2000,nh);
%   fChspan = getFlightCondition(he,'H',hspan,'GW',GW*ones(1,nh),'Mf',Mf*ones(1,nh));
%   [VA,PA] = vMaxRange(he,fChspan,atm);
%   figure(1)
%   plot(hspan,VA*3.6,'b-o'); hold on
%   xlabel('$H$ [m]'); ylabel('$v_R$ [km/h]')
%   figure(2)
%   plot(hspan,PA*1e-6,'b-o'); hold on
%   xlabel('$H$ [m]'); ylabel('$P_R$ [MW]')
%
%   See also setHeroesEnergyOptions, vMaxRange
%
%   TODO

gammaT    = fC.gammaT;
H         = fC.H;
Z         = fC.Z;
% % % % % % % % % % % % % % % % Omega     = fC.Omega;

options   = parseOptions(varargin,@setHeroesEnergyOptions);
vGuess    = options.vFzero;


% Dimensions of the output power state object
n         = numel(H);
s         = size(H);

% Allocate of output variables
vB        = zeros(s);
PB        = zeros(s);

% Get nondimensional helicopter
ndheener = he2ndHe(he);
for i=1:n
    % Slice flight condition data
    fCi    = getSliceFC(i,fC);

% % % % % % % %     % Atmosphere elements
% % % % % % % %     rho      = atmosphere.density(H(i));
% % % % % % % %     ndheener = he2ndHe(he,rho,Omega);

    % System resolution
% % % % % % % %     f2min  = @(v) defineGoal(v,gammaT,H(i),Z,he,atmosphere,options);
    f2min  = @(v) defineGoal(v,he,fCi,atmosphere,options);
    ops    = optimset('TolX',1e-6,'Display','off');
    vB(i)  = fminbnd(f2min,0,vGuess,ops);

    % Obtain Power in vB
    fCi.V     = vB(i);
% % % % % % % % % % %     fCB       = getFlightCondition(he,'V',vB(i),'gammaT',gammaT,'H',H(i),'Z',Z);
% % % % % % % % % % %     ndfcenerB = fc2ndFC(fCB,he,atmosphere);
    ndfcenerB = fc2ndFC(fCi,he,atmosphere);

    tailrotorOpt = 'eta';
    ndEnStB = getNdEpowerState(ndheener,ndfcenerB,options);
    EnStB   = ndEpowerState2dim(ndEnStB,he,H(i),tailrotorOpt);

    PB(i) = EnStB.P;
end



function goal = defineGoal(V,he,fC,atmosphere,options)

% % % % % % % % % % fC     = getFlightCondition(he,'V',V,'gammaT',gammaT,'H',H,'Z',Z);
fC.V   = V;
ePs    = getEpowerState(he,fC,atmosphere,options);
P      = ePs.P;
goal   = P./V;


