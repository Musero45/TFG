function io = test_flightEnvelope(mode)
% This test shows how to plot the flight envelope of an energy helicopter.
% The following flight envelopes are computed and plotted
% - maximum continuous power out of ground effect at leveled forward flight
% - take-off power out of ground effect at leveled forward flight
% - maximum continuous power in-ground effect (Z03) at leveled forward flight
% - maximum continuous power out of ground effect at \gamma_T = 10 degrees
close all

% Degree to radian conversion factor
d2r   = pi/180;

% Get ISA atmosphere
atm        = getISA;


% Define engine
numEngines = 2;
engine     = Allison250C28C(atm,numEngines);

% Get design requirements
dr         = cesarDR;

% % Define engine
% numEngines = 1;
% engine     = CT58_140(atm,numEngines);
% 
% % Get design requirements
% dr         = rescue6000kgDR;


% Transform design requirements to statistical helicopter
heli       = desreq2stathe(dr,engine);

% Transform statistical helicopter to energy helicopter
he         = stathe2ehe(atm,heli);

% One problem of stathe2ehe is that the maximum transmission power is
% limitating most of the altitude envelope, for this example up to 10000
% and 11000 meters
% Therefore to obtain a nice flight envelope we set a maximum transmission
% power of 1e6 W and we override ehe data
Pmt                    = 620e3;
fPmt                   = @(h) Pmt*ones(size(h));
he.transmission.fPmt   = fPmt;
he.transmission.Pmt    = Pmt;

% Next we recompute available power
% Get available power taken into account transmission power limitation
availablePower = engine_transmission2availablePower(he.engine,he.transmission);
he.availablePower = availablePower;




%get flight condition wTFW and OmegaN
fc = getFlightCondition(he);

[v_mc_oge,h_mc_oge] = getFlightEnvelope(he,fc,atm);

% FIXME this flight envelope is the same than the previous one despite we
% are using a different engine map, maximum continuous and take off
% This same result is obtained using the 337 svn version which is the
% latest safety version of heroes
[v_de_oge,h_de_oge] = getFlightEnvelope(he,fc,atm,...
                                        'powerEngineMap','de');

fc.Z  = 3;
[v_mc_ige,h_mc_ige] = getFlightEnvelope(he,fc,atm,...
                                        'IGEmodel',@kGlefortHamann ...
                                        );


figure(1)
plot(v_mc_oge*3.6,h_mc_oge,'r-'); hold on;
plot(v_de_oge*3.6,h_de_oge,'b-'); hold on;
plot(v_mc_ige*3.6,h_mc_ige,'g-'); hold on;
xlabel('V [km/h]');ylabel('h [m]'); hold on;
legend({'mc OGE','de OGE','mc IGE (Z=3)'},'Location','Best')




io = 1;
