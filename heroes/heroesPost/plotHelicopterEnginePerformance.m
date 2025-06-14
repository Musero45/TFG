function io = plotHelicopterEnginePerformance(ehe,hspan)
%PLOTHELICOPTERENGINEPERFORMANCE  Plots helicopter engine performance
%
%   PLOTHELICOPTERENGINEPERFORMANCE(E,HSPAN) plots the variation with 
%   altitude of the available engine power of an energy helicopter, E, for
%   the altitude values defined by the vector HSPAN. The available engine
%   power comes into two set of functions: constrained and unconstrained 
%   by transmission power engine maps. The constrained available engine
%   power maps are piecewise functions of the power with the altitude. For
%   altitudes at which the maximum transmission power is lower than engine 
%   power the control of the engine provides the maximum transmission
%   power. Altitudes at which the maximum transmission power is higher than 
%   engine power the control of the engine provides the maximum transmission
%   The unconstrained engine maps are directly the engine power variations 
%   with altitude, without taking into account maximum transmission power.
%
%   Example of usage: define an energy helicopter from a design requirement
%   data type and plot both the constrained and unconstrained by
%   transmission power availalble engine power maps for altitudes ranging
%   between 0 and 10000 meters
%   close all;
%   atm        = getISA;
%   Z          = NaN;
%   gammaT     = 0;
%   h          = linspace(0,10000,31);
%   numEngines = 2;
%   engine     = Arriel2C2(atm,numEngines);
%   dr         = kg4500DR;
%   heli       = desreq2stathe(dr,engine);
%   he         = stathe2ehe(atm,heli);
%   plotHelicopterEnginePerformance(he,h);
%
%   See also getExcessPower,
%
%   TODO
%
%
engine      = ehe.engine;
Pa          = ehe.availablePower;

% function handles of unconstrained available power maps
fPumc        = engine.fPmc;
fPude        = engine.fPde;
fPumu        = engine.fPmu;

% function handles of constrained available power maps
fPcmc        = Pa.fPa_mc;
fPcde        = Pa.fPa_de;
fPcmu        = Pa.fPa_mu;


% Obtain power vectors
Pumc         = fPumc(hspan);
Pude         = fPude(hspan);
Pumu         = fPumu(hspan);

Pcmc         = fPcmc(hspan);
Pcde         = fPcde(hspan);
Pcmu         = fPcmu(hspan);


hgcf   = getCurrentFigureNumber;
figure(hgcf+1)
str1 = strcat(ehe.id,'_unconstrained_power_map');
set(gcf,'Name',str1);
plot(hspan,Pumc,'r-'); hold on;
plot(hspan,Pude,'b--'); hold on;
plot(hspan,Pumu,'m-.'); hold on;
xlabel('h [m]'); ylabel('P [W]');
legend({'mc','de','mu'},'Location','Best')

figure(hgcf+2)
str2 = strcat(ehe.id,'_constrained_power_map');
set(gcf,'Name',str2);
plot(hspan,Pcmc,'r-'); hold on;
plot(hspan,Pcde,'b--'); hold on;
plot(hspan,Pcmu,'m-.'); hold on;
xlabel('h [m]'); ylabel('P [W]');
legend({'mc','de','mu'},'Location','Best')

io = 1;

