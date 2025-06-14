function range    = getRange(he,flightCondition,atmosphere,varargin)
%getRange  Computes the range of an helicopter for a given fuel mass
%
%   R = getRange(HE,FC,ATM) computes the range of an energy helicopter HE
%   for a given flight condition FC flying into an ISA atmosphere ATM and a
%   given mass fuel which is specified by the helicopter field Mf.
%
%   R = getRange(HE,FC,ATM) computes as above with default options 
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
%   Example of usage:
%   Get the range for an horizontal forward speed V=50m/s and altitude
%   h=1000m for a superPuma helicopter with 3000 kg of mass fuel
%   atm = getISA;
%   he = superPuma(atm);
%   Mf = 1000;
%   fC = getFlightCondition(he,'V',50,'H',1000,'Mf',3000);
%   s = getRange(he,fC,atm);
%
%   [For debugging pourposes the range is s = 1.407823598134671e+06]
%
%   Plot the variation of range for a fuel mass of 3000 kg 
%   with altitude considering sea level and 2000 m and forward speed 
%   of 50 m/s
%   nh    = 11;
%   hspan = linspace(0,2000,nh);  
%   V     = 50*ones(1,nh);
%   Mf    = 3000*ones(1,nh);
%   fCr   = getFlightCondition(he,'V',V,'H',hspan,'Mf',Mf);
%   sh    = getRange(he,fCr,atm);
%   figure(1)
%   plot(hspan*1e-3,sh*1e-3,'b-o');
%   xlabel('H [km]');ylabel('R [km]')
%
%   Plot the range variation of range with forward speed and altitude.
%   Consider an interval of forward speed between 40 and 85 m/s, altitude 
%   between sea level and 2000 m with a fuel mass of 3000 kg
%   nv    = 9;
%   vspan = linspace(40,85,nv);
%   [V,H] = ndgrid(vspan,hspan);
%   Mf    = 3000*ones(nv,nh);
%   fCv   = getFlightCondition(he,'V',V,'H',H,'Mf',Mf);
%   sv    = getRange(he,fCv,atm);
%   figure(2)
%   [D,g] = contour(V.*3.6,H*1e-3,sv*1e-3);
%   set(g,'ShowText','on');
%   set(g,'LevelList',linspace(1300,1600,11));
%   colormap cool
%   title('Range [km]')
%   xlabel('V [km/h]');ylabel('H [km]')
%
%   See also setHeroesEnergyOptions, getEndurance, vMaxRange
%
%   From:
%   http://stackoverflow.com/questions/758736/how-do-i-iterate-through-each-element-in-an-n-dimensional-matrix-in-matlab
%   We use linear indexing to access each element of the n-dimensional matrix
%   The result is, we can access each element in turn of a general n-d array 
%   using a single loop
%   TODO
%


options   = parseOptions(varargin,@setHeroesEnergyOptions);

Vh     = flightCondition.Vh;

% Dimensions of the output range
n      = numel(Vh);
s      = size(Vh);

% Fuel mass
Mf     = flightCondition.Mf;

% PSFC
PSFC   = he.engine.PSFC;

% Allocate output
range  = zeros(s);

for i=1:n
        % Slice flight condition data
        fC         = getSliceFC(i,flightCondition);

        % Get power for forward horizontal flight
        ePowerState = getEpowerState(he,fC,atmosphere,options);

        % Required power
        P       = ePowerState.P;

        % Horizontal Range
        range(i)  = Mf(i)*Vh(i)/(PSFC*P);
end
