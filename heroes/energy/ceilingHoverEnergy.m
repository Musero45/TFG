function ceiling  = ceilingHoverEnergy(he,hoverfc,atmosphere,varargin)
%ceilingHoverEnergy  Computes ceiling at hovering
%
%   C = ceilingHoverEnergy(HE,FC,ATM) gets the ceiling, C, of an energy 
%   helicopter HE with a hovering flight condition, FC, in an ISA
%   atmosphere ATM. By default the engine map which is selected to obtain
%   the hover ceiling is the maximum continuous 'mc' map.
%
%   C = ceilingHoverEnergy(HE,FC,ATM,OPTIONS) computes as above with default 
%   options replaced by values set in OPTIONS. OPTIONS should be input 
%   in the form of sets of property value pairs. Default OPTIONS is 
%   a structure defined by setHeroesEnergyOptions with the following 
%   fields and values:
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
%   Examples of usage
%   Get the hover ceiling of a superPuma energy helicopter with a gross
%   weight of 73000 N, fuel mass of 1600 kg.
%   a      = getISA;
%   he     = superPuma(a);
%   GW     = 73e3;
%   Mf     = 1600;
%   fc     = getFlightCondition(he,'GW',GW,'Mf',Mf);
%   cOGE   = ceilingHoverEnergy(he,fc,a)
%
%   [For debugging pourposes the range is cOGE = 4.008801648246693e+03]
%
%   Now plot how the hover ceiling changes as the helicopter is 
%   hovering IGE between 5 and 20 meters above ground and compare the
%   previous ceiling with the IGE ceiling
%   nz     = 11;
%   Z      = linspace(5,30,nz)';
%   GW     = GW*ones(1,nz)';
%   Mf     = 1600*ones(1,nz)';
%   fc     = getFlightCondition(he,'GW',GW,'Mf',Mf,'Z',Z);
%   c      = ceilingHoverEnergy(he,fc,a,'igeModel',@kGlefortHamann);
%   plot(Z,c/1000); hold on
%   plot(Z,cOGE/1000*ones(1,nz),'r-'); hold on
%   xlabel('Z [m]');ylabel('Ceiling [km]')
%
%
%
%   See also setHeroesEnergyOptions
%
%   TODO


options       = parseOptions(varargin,setHeroesEnergyOptions);
ceiling       = ceilingEnergy(he,hoverfc,atmosphere,options);


