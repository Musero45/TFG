function io = test_hoverCeiling(mode)
% 
close all

atm   = getISA;
he    = superPuma(atm);



% 
Mf    = 1600;
GW    = 73500;
hMax  = 10000;
Hspan = linspace(0,hMax,31);

engine = he.engine;
Pa     = he.availablePower;

% Plot engine power maps
figure(1)
fmt   = he.transmission.fPmt(Hspan);
fmc   = engine.fPmc(Hspan);
fde   = engine.fPde(Hspan);
fmu   = engine.fPmu(Hspan);
plot(Hspan,fmt,'g-'); hold on;
plot(Hspan,fmc,'r-'); 
plot(Hspan,fde,'b--'); 
plot(Hspan,fmu,'m-.'); 
xlabel('$H$ [m]'); ylabel('$P$ [W]');
legend({'$P_{mt}$','$P_{mc}$','$P_{desp}$','$P_{mu}$'})


% Plot available power limited by transmission power
figure(2)
Pafmc   = Pa.fPa_mc(Hspan);
Pafde   = Pa.fPa_de(Hspan);
Pafmu   = Pa.fPa_mu(Hspan);
plot(Hspan,Pafmc,'r-'); hold on;
plot(Hspan,Pafde,'b--'); 
plot(Hspan,Pafmu,'m-.'); 
xlabel('H [m]'); ylabel('P [W]');
legend({'$P_{mc}$','$P_{desp}$','$P_{mu}$'})

% Compute hovering power
requiredPower     = zeros(size(Hspan));
% z0                = 0;
for i=1:length(Hspan)
    % Required power
% % % %     flightCondition = get1hoverFlightCondition(Hspan(i),z0);
    flightCondition = getFlightCondition(he,'H',Hspan(i),'GW',GW,'Mf',Mf);
    ePowerState     = getEpowerState(he,flightCondition,atm);

    requiredPower(i)   = he.transmission.etaM.*ePowerState.P;
end

figure(1)
plot(Hspan,requiredPower,'k--'); hold on;

figure(2)
plot(Hspan,requiredPower,'k--'); hold on;

% Compute hover ceiling (constrained which is default)
% Maximum continuum
% % % % fc0    = getLevelFC(0,NaN);
fc0    = getFlightCondition(he,'V',0,'GW',GW,'Mf',Mf);
c_mc   = my_ceilingHoverEnergy(he,fc0,atm);
t_mc   = ceilingEnergy(he,fc0,atm);
% t_mc is the ceiling computed using general power curve and it should be
% the same as c_mc
disp(strcat('Ceiling for mc c_mc(local)  =',num2str(t_mc)));
disp(strcat('Ceiling for mc t_mc(energy) =',num2str(c_mc)));
disp(strcat('Ceiling for mc error = ',num2str(abs(t_mc-c_mc))));
Pa_cmc = Pa.fPa_mc(c_mc);

% Take off
c_de   = my_ceilingHoverEnergy(he,fc0,atm,'powerEngineMap','de');
t_de   = ceilingEnergy(he,fc0,atm,'powerEngineMap','de');
% t_de is the ceiling computed using general power curve and it should be
% the same as c_mc
disp(strcat('Ceiling for mc c_mc(local)  =',num2str(t_de)));
disp(strcat('Ceiling for mc t_mc(energy) =',num2str(c_de)));
disp(strcat('Ceiling for de error =',num2str(abs(t_de-c_de))));
Pa_cde = Pa.fPa_de(c_de);

% Maximum urgency
c_mu   = my_ceilingHoverEnergy(he,fc0,atm,'powerEngineMap','mu');
t_mu= ceilingEnergy(he,fc0,atm,'powerEngineMap','mu');
% t_de is the ceiling computed using general power curve and it should be
% the same as c_mc
disp(strcat('Ceiling for mc c_mc(local)  =',num2str(t_mu)));
disp(strcat('Ceiling for mc t_mc(energy) =',num2str(c_mu)));
disp(strcat('Ceiling for mu error =',num2str(abs(t_mu-c_mu))));
Pa_cmu = Pa.fPa_mu(c_mu);


figure(1)
plot(c_mc,Pa_cmc,'r o'); hold on;
plot(c_de,Pa_cde,'b s'); hold on;
plot(c_mu,Pa_cmu,'m d'); hold on;

figure(2)
plot(c_mc,Pa_cmc,'r o'); hold on;
plot(c_de,Pa_cde,'b s'); hold on;
plot(c_mu,Pa_cmu,'m d'); hold on;


io = 1;




function ceiling  = my_ceilingHoverEnergy(he,fc,atmosphere,varargin)
% ceiling computes in axial flight the highest altitude for hovering whith
% the energy method
%
%   Example of usage
%   atmosphere  = getISA;
%   he = superPuma(atmosphere);
%
%   c = ceilingHoverEnergy(he,atmosphere);
%   c = ceilingHoverEnergy(he,atmosphere,'powerEngineMap','de');
%   c = ceilingHoverEnergy(he,atmosphere,'Z',3);
%


options          = parseOptions(varargin,setHeroesEnergyOptions);


initialHguess = [0,10000];
% Z             = fc.Z;
fCeiling      = @(H) getHoverCeilingEnergy(H,he,fc,atmosphere,options);
ceiling       = fzero(fCeiling,initialHguess);


function f = getHoverCeilingEnergy(H,he,fc,atmosphere,options)

f  = zeros(length(H),1);

% Set constrained or unconstrained engine map due to transmission power
% limitation
if strcmp(options.constrainedEnginePower,'yes')
   fPmstr  = strcat('fPa_',options.powerEngineMap);
   fPm    = he.availablePower.(fPmstr);
elseif strcmp(options.constrainedEnginePower,'no')
   fPmstr  = strcat('fP',options.powerEngineMap);
   fPm    = he.engine.(fPmstr);
else
   error('getCeilingEnergy: wrong input option');
end


for i=1:length(H)
    % Required power
    flightCondition = getFlightCondition(he,'H',H(i),...
                      'Z',fc.Z,'GW',fc.GW,'Mf',fc.Mf);
    ePowerState     = getEpowerState(he,flightCondition,atmosphere,options);

    % Available power
    Pa    = fPm(H(i));

    % equation
%     f(i,1) = Pa - he.transmission.etaM.*ePowerState.P;
% Bug detected by Sergio Nadal
    f(i,1) = Pa - ePowerState.P;
end

