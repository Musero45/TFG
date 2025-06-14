function endurance    = getEndurance(he,flightCondition,atmosphere,varargin)
%getEndurance  Computes the endurance of an helicopter for a given fuel mass
%
%   E = getEndurance(HE,FC,ATM) computes the endurance, E, of an energy 
%   helicopter HE for a given flight condition FC flying into an 
%   ISA atmosphere ATM and a given mass fuel which is specified 
%   by the helicopter field Mf.
%
%   E = getEndurance(HE,FC,ATM,OPTIONS) computes as above with default options 
%   replaced by values set in OPTIONS. OPTIONS should be input in the 
%   form of sets of property value pairs. Default OPTIONS is a structure 
%   defined by setHeroesEnergyOptions with the following fields and values:
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
%
%   Examples of usage:
%   Get the endurance for an horizontal forward speed V = 50m/s
%   and altitude h = 500 m for a superPuma helicopter with 70000 N
%   of gross weight.
%   atm = getISA;
%   he  = superPuma(atm);
%   fC  = getFlightCondition(he,'V',50,'gammaT',0,'H',500,'GW',7e4);
%   e   = getEndurance(he,fC,atm);
%
%
%   [For debugging pourposes the range is s = 1.286734948818062e+04]
%
%   For a gross weight of 70000 N plot the variation of endurance with 
%   level forward speed considering forward speeds between 0 and 100 m/s
%   and altitude of 500 m.
%   nv       = 11;
%   vspan    = linspace(0,100,nv);
%   H        = 500*ones(1,nv);
%   GW       = 7e4*ones(1,nv);
%   fCvrange = getFlightCondition(he,'V',vspan,'H',H,'GW',GW);
%   ev       = getEndurance(he,fCvrange,atm);
%   figure(1)
%   plot(vspan*3.6,ev./60,'b-o'); hold on
%   xlabel('V [km/h]');ylabel('E [min]')
%
%   For a level cruise of altitude 500m, plot the variation of endurance
%   with forward speed and grossweight. Consider an interval of forward  
%   speeds between 25 and 70 m/s, gross weight between 65000 and 75000 N.
%   nv       = 11;
%   vspan    = linspace(25,70,nv);
%   nw       = 9;
%   wspan    = linspace(65e3,75e3,nw);
%   [V,GW]   = ndgrid(vspan,wspan);
%   H        = 500*ones(nv,nw);
%   fCvh     = getFlightCondition(he,'V',V,'H',H,'GW',GW);
%   evh      = getEndurance(he,fCvh,atm);
%   figure(2)
%   [D,g] = contour(V.*3.6,GW,evh./3600);
%   set(g,'ShowText','on');
%   colormap cool
%   title('Endurance [h]')
%   xlabel('V [km/h]');ylabel('H [km]')
%
%
%   See also setHeroesEnergyOptions, getEndurance, vMaxRange
%
%   TODO
%


options     = parseOptions(varargin,@setHeroesEnergyOptions);

% Fuel mass
Mf     = flightCondition.Mf;

% Dimensions of the output endurance
n      = numel(Mf);
s      = size(Mf);

% PSFC
PSFC = he.engine.PSFC;

% Allocate output
endurance  = zeros(s);

for i=1:n
        % Slice flight condition data
        fC           = getSliceFC(i,flightCondition);

        % Get power for required flight
        ePowerState  = getEpowerState(he,fC,atmosphere,options);

        % Required power
        P            = ePowerState.P;
        endurance(i) = Mf(i)/(PSFC*P);
end
