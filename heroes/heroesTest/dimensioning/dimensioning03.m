function io = dimensioning03(mode)
close all

% This script shows how to define dinamically a vector of DR and how to
% plot some of the interpolation funcionts
% First load one DR (emory's project)
mydr = cesarDR;

% Now define a vector of input variables, for instance MTOW vector,
nmtow   = 11;
MTOW    = linspace(mydr.rand.MTOW*0.8,mydr.rand.MTOW*1.2,nmtow);

% Now, select one engine
atm               = getISA;
numEngines        = 2;
engine            = Allison250C28C(atm,numEngines);


% Get the reference dimensional helicopter, cesarDR,
myheli        = desreq2stathe(mydr,engine);

% Just make a copy of DR to work with it, without modifying the reference
% one
dr     = mydr;

% Now get a dimensional helicopter cell
heli   = cell(nmtow,1);

for i = 1:nmtow
    dr.rand.MTOW   = MTOW(i);
    heli{i}        = desreq2stathe(dr,engine);
end

% Once the cell of dimensional helicopters is defined, now just plot some 
% variables for instance, main rotor diameter. First get the vector of main
% rotor diameters
mrDiameter   = zeros(1,nmtow);
for i = 1:nmtow
    mrDiameter(i)   = heli{i}.MainRotor.D;
end


% Just set plot to produce thicker lines and bigger font sizes
setPlot
figure(1)
plot(MTOW,mrDiameter,'r-'); hold on;
plot(mydr.rand.MTOW,myheli.MainRotor.D,'b o'); hold on;
xlabel('MTOW [kg]'); ylabel('Diameter [m]');
legend('Interpolation Rand&Johnson','Reference value','Location','Best')


% Unset the plot defaults and recover the original ones
unsetPlot
io = 1;