function P = getP(he,flightCondition,atm,varargin)
% TODO 
% -skip Z from the input arguments
% -use flight condition instead V,gammaT,h
% Get the energy power for a fC and he in parameters.
%
%   Example of usage:
%   Get the requierd power for an horizontal forward speed V=50m/s 
%   and altitude h = 1000 m for a superPuma helicopter with 3000 kg 
%   of mass fuel climbing at gammaT = 10 degrees
%   atm    = getISA;
%   he     = superPuma(atm);
%   gt     = 10*pi/180;
%   fC     = getFlightCondition(he,'V',50/cos(gt),'H',1000,'Mf',3000,'gammaT',gt);
%   P      = getP(he,fC,atm);
%
%   [For debugging pourposes the power is P =  1.883114879087181e+06]
%
%   Plot the variation of power with horizontal forward speed for a 
%   given fuel mass of 3000 kg, climb angle of 10 degrees, flight altitude 
%   1000 m. Consider an interval of horizontal forward speeds between 0 m/s
%   and 60 m/s.
%   nv     = 11;
%   vspan  = linspace(0,60,nv)./cos(gt);
%   H      = 1000*ones(1,nv);
%   gammaT = gt*ones(1,nv);
%   Mf     = 3000*ones(1,nv);
%   fCr    = getFlightCondition(he,'V',vspan,'H',H,'Mf',Mf,'gammaT',gammaT);
%   p      = getP(he,fCr,atm);
%   figure(1)
%   plot(vspan*3.6,p*1e-3,'b-o');
%   xlabel('V [km/h]');ylabel('P [kW]')
%
%   Plot the variation of power with forward speed and altitude.
%   Consider an interval of forward speed between 0 and 65 m/s, altitude 
%   between sea level and 1000 m with a fuel mass of 3000 kg snd climb
%   angle of 10 degrees.
%   nh     = 9;
%   hspan  = linspace(0,1000,nh);
%   [V,H]  = ndgrid(vspan,hspan);
%   Mf     = 300getP0*ones(nv,nh);
%   gammaT = gt*ones(nv,nh);
%   fCv    = getFlightCondition(he,'V',V,'H',H,'Mf',Mf,'gammaT',gammaT);
%   pvh    = getP(he,fCv,atm);
%   figure(2)
%   [D,g] = contour(V.*3.6,H*1e-3,pvh*1e-3);
%   set(g,'ShowText','on');
%   colormap cool
%   title('Power [kW]')
%   xlabel('V [km/h]');ylabel('H [km]')
%
%   See also setHeroesEnergyOptions, getEndurance, vMaxRange
%

% Setup options
options   = parseOptions(varargin,@setHeroesEnergyOptions);

% Dimensions of the output power
H         = flightCondition.H;
n         = numel(H);
s         = size(H);

% Allocate output
P         = zeros(s);

for i = 1:n
        % Slice flight condition data
        fC           = getSliceFC(i,flightCondition);

        %Non dimensional elements
% % % % % % % % % %         Hi       = fC.H;
% % % % % % % % % %         rhoi     = atm.density(Hi);
% % % % % % % % % %         Omegai   = fC.Omega;
% % % % % % % % % %         GWi      = fC.GW;
% % % % % % % % % %         ndheener = he2ndHe(he,rhoi,Omegai,GWi);
        ndheener = he2ndHe(he);
        ndfcener = fc2ndFC(fC,he,atm);

        %Get energy state
        ndEnSt   = getNdEpowerState(ndheener,ndfcener,options);
        EnSt     = ndEpowerState2dim(ndEnSt,he,fC.H,'eta');

        % Define output power
        P(i)     = EnSt.P;
end
