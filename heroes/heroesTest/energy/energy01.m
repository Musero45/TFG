function io = energy01(mode)
% THIS FUNCTION HAS TO BE UPDATED TO THE NEW FORMAT OF ENERGY FUNCTIONS
close all
nametest   = 'energy01';

TOL   = 1e-4;




% Define environment
atm   = getISA;

% Select an energy-based helicopter
he    = superPuma(atm);
Mf    = 1600;
GW    = 73500;

%
Z      = 3;
h      = 0;

hMax  = 6000;
Hspan = linspace(0,hMax,31);
disp('-----------------------------------------------------------------')
i1      = plotHelicopterEnginePerformance(he,Hspan);

fc_oge  = getFlightCondition(he,'GW',GW,'Mf',Mf);
h_oge   = ceilingHoverEnergy(he,fc_oge,atm,...
                             'inducedVelocity',@Glauert, ....
                             'constrainedEnginePower','no');

fc_ige  = getFlightCondition(he,'GW',GW,'Mf',Mf,'Z',Z);
h_ige   = ceilingHoverEnergy(he,fc_ige,atm,...
                             'inducedVelocity',@Glauert, ....
                             'constrainedEnginePower','no',...
                             'IGEmodel',@kGlefortHamann);


%======================================================================
% Hover ceiling check
[h_Oge,h_Ige]   = techoMano(he,atm,GW,Mf,Z);

errorHoge  = abs(h_oge-h_Oge);
errorHige = abs(h_ige-h_Ige);
tolCeiling = 5;
i2         = dispErrorLog(errorHoge,tolCeiling,nametest,'OGE hover ceiling');
i3         = dispErrorLog(errorHige,tolCeiling,nametest,'IGE hover ceiling');




% Comparacion con las velocidades calculadas a mano
[vR,vE,vM] = vMaxMano(he,atm,GW);


% Define flight condition just for consistency we define
fc_ini   = getFlightCondition(he,'V',NaN,'GW',GW,'Mf',Mf);
% but the same result is obtained using the fc_oge flight condition

%======================================================================
% Maximum range check
[vB,pB]   = vMaxRange(he,fc_ini,atm,...
           'inducedVelocity',@Glauert, ....
           'forwardFlightApproximation','highSpeed');

fB        = getFlightCondition(he,'V',vB,'GW',GW,'Mf',Mf);
PB        = getP(he,fB,atm,...
           'inducedVelocity',@Glauert, ....
           'forwardFlightApproximation','highSpeed');
tB        = getEndurance(he,fB,atm,...
           'inducedVelocity',@Glauert, ....
           'forwardFlightApproximation','highSpeed');
sB        = getRange(he,fB,atm,...
           'inducedVelocity',@Glauert, ....
           'forwardFlightApproximation','highSpeed');

errorvB   = abs(vB - vR);
errorpB   = abs(pB - PB);
tolVelocity = 1;
tolPower = 100;

i4         = dispErrorLog(errorvB,tolVelocity,nametest,...
             'maximum range forward velocity');
i5         = dispErrorLog(errorpB,tolPower,nametest,...
             'maximum range forward power');


%======================================================================
% Maximum endurance check

[vC,pC]   = vMaxEndurance(he,fc_ini,atm,...
           'inducedVelocity',@Glauert, ....
           'forwardFlightApproximation','highSpeed');

fC        = getFlightCondition(he,'V',vC,'GW',GW,'Mf',Mf);
PC        = getP(he,fC,atm,...
           'inducedVelocity',@Glauert, ....
           'forwardFlightApproximation','highSpeed');

tC        = getEndurance(he,fC,atm,...
           'inducedVelocity',@Glauert, ....
           'forwardFlightApproximation','highSpeed');
sC        = getRange(he,fC,atm,...
           'inducedVelocity',@Glauert, ....
           'forwardFlightApproximation','highSpeed');


errorvC   = abs(vC - vE);
errorpC   = abs(pC - PC);

i6         = dispErrorLog(errorvC,tolVelocity,nametest,...
             'maximum endurance forward velocity');
i7         = dispErrorLog(errorpC,tolPower,nametest,...
             'maximum endurance forward power');

%======================================================================
% Maximum forward velocity at sea level
vA         = vGivenPower(he,fc_ini,atm,...
            'inducedVelocity',@Glauert, ....
            'forwardFlightApproximation','highSpeed');

errorvA    = abs(vA - vM);
i8         = dispErrorLog(errorvA,tolVelocity,nametest,...
             'maximum forward velocity');




%======================================================================
% Maximum Rate of Climb at sea level for maximum continuous power 
Pmt    = he.transmission.Pmt;
% eta    = he.transmission.etaM;
P_roc   = he.availablePower.fPa_mc(0);
fc_roc  = getFlightCondition(he,...
          'H',h,...
          'GW',GW,...
          'Mf',Mf,...
          'P',P_roc);

[vHmaxRoc,maxRoc]    = vH4maxVv(he,fc_roc,atm);
[vHmaxRoc1,maxRoc1]  = vH4maxVv(he,fc_ini,atm,...
                    'inducedVelocity',@Glauert, ....
                    'excessPower','yes');

% old code before overhauling
% [vHmaxRoc,maxRoc] = vMaxMaxROC(h,NaN,he,atm);
% [vHmaxRoc1,maxRoc1] = vMaxMaxROC(h,NaN,he,atm,...
%                     'inducedVelocity',@Glauert, ....
%                     'excessPower','yes');

roc1  = (Pmt - PC)./GW;

errorROC   = abs(maxRoc1 - roc1);
i9         = dispErrorLog(errorvA,tolVelocity,nametest,...
             'maximum ROC at sea level');

disp('-----------------------------------------------------------------')

% Determinar la dependencia de la maxima autonomia 
% con el peso de la aeronave t_max = f(W)
i10        = plotWeightSensitivity(he,atm,fc_ini);


i11        = plotKappaSensitivity(he,atm,fc_oge);


% This logical statement is set to 0 when some of the numerical validation
% tests are not passed.
if i2 == 0 || ...
   i3 == 0 || ...
   i4 == 0 || ...
   i5 == 0 || ...
   i6 == 0 || ...
   i7 == 0 || ...
   i8 == 0 || ...
   i9 == 0
   io         = i1*i2*i3*i4*i5*i6*i7*i8*i9*i10*i11;
else
   
   io         = i1*i2*i3*i4*i5*i6*i7*i8*i9*i10*i11 + 1;
end

function io = plotKappaSensitivity(he,atm,fc)

nk     = 30;
h      = zeros(1,nk);
kappa  = linspace(1.0,1.29,nk);
he1    = he;

% FIXME: now it seems that new energy (2014) says that for kappa = 1.3
% there is no available power enough to hovering at sea level. 
% CHECK THIS! For the moment being the last value of kappa is set to 1.29
for i=1:nk
    he1.mainRotor.kappa = kappa(i);
    h(i)                = ceilingHoverEnergy(he1,fc,atm,...
                          'constrainedEnginePower','no');
end

hgcf   = getCurrentFigureNumber;
figure(hgcf+1)
plot(kappa,h); hold on;
fk   = @(x) interp1(kappa,h,x);
dfk1 = derivest(fk,he.mainRotor.kappa);
h0   = fk(he.mainRotor.kappa);
hh   = h0 + dfk1.*(kappa-he.mainRotor.kappa);
plot(kappa,hh,'r-.')
xlabel('$\kappa$ [-]'); ylabel('$H_{OGE}$ [m]'); 
legend({'$H_{OGE}$(H)',strcat('d$ H_{OGE}$/(d$\kappa$) = ',...
        num2str(dfk1,'%6.0f'),'(en $\kappa$ = 1.15)')},0)


io = 1;


function [h_Oge,h_Ige]   = techoMano(he,atm,GW,Mf,Z)

rho0  = atm.rho0;
ndHe  = he2ndHe(he);
R     = he.mainRotor.R;
area  = pi*R^2;
z     = Z/R;
kG    = kGlefortHamann(z,NaN);
kappa = he.mainRotor.kappa;
OR    = he.mainRotor.Omega*he.mainRotor.R;
etaM  = 1.2;
Pi0_ige = GW*sqrt(GW/(2*rho0*area))*kappa*kG;
Pi0_oge = GW*sqrt(GW/(2*rho0*area))*kappa;
cq0   = ndHe.mainRotor.sigma*ndHe.mainRotor.cd0/8;
P00   = rho0*area*OR^3*cq0;
PM0   = he.engine.fPmc(0);
n     = he.engine.powerExponent;
f     = @(x) PM0.*x.^n - etaM*Pi0_oge*x.^(-1/2) - etaM*P00*x;
g     = @(x) PM0.*x.^n - etaM*Pi0_ige*x.^(-1/2) - etaM*P00*x;     

x_Oge = fzero(f,1);
x_Ige = fzero(g,1);
c     = 4.256;
Href  = 4.43e4;
h_Oge = Href*(1-x_Oge^(1/c));
h_Ige = Href*(1-x_Ige^(1/c));


function [vR,vE,vM]   = vMaxMano(he,atm,GW)

Pmt    = he.transmission.Pmt;
eta    = he.transmission.etaM;

rho0  = atm.rho0;
R     = he.mainRotor.R;
area  = pi*R^2;
Omega = he.mainRotor.Omega;
OR    = Omega*R;
ndHe  = he2ndHe(he);
CW    = GW/(rho0*area*OR^2);
fS    = ndHe.fuselage.fS;
CQ00  = ndHe.mainRotor.CQ00;
K     = ndHe.mainRotor.K;
kappa = ndHe.mainRotor.kappa;

vio   = sqrt(GW/(2*rho0*area));
Pio   = GW*vio;
Pi    = Pmt/eta/Pio;
A     = CQ00/(2*(vio/OR)^3);
B     = K*CW/2;

p     = [3*fS/4,  2*A*B,  0,     0,  -kappa];
q     = [  fS/2,  A*B,    0,    -A,  -2*kappa];
r     = [  fS/4,  A*B,    0,  A-Pi,  kappa];

rE    = getRealPositive(roots(p));
rR    = getRealPositive(roots(q));
rM    = getMaxRealPositive(roots(r));
vE    = rE*vio;
vR    = rR*vio;
vM    = rM*vio;


function io = plotWeightSensitivity(he,atm,fc)

nw    = 31;
W0    = fc.GW;
W     = W0*linspace(0.8,1.2,nw);
% he1   = he;
vC    = zeros(nw,1);
tC    = zeros(nw,1);

% Define flight condition
V     = NaN(nw,1);
H     = fc.H*ones(nw,1);
Mf    = fc.Mf*ones(nw,1);
% Z           = NaN;
% gammaT      = 0;
fCini       = getFlightCondition(he,'V',V,'H',H,'GW',W,'Mf',Mf);

for i=1:nw
%     he1.W   = W(i);
    fCi     = getSliceFC(i,fCini);

    vC(i)   = vMaxEndurance(he,fCi,atm,...
              'inducedVelocity',@Glauert, ....
              'forwardFlightApproximation','highSpeed');
%     fC      = get1cruise(vC(i),h);
    fC      = getFlightCondition(he,'V',vC(i),'GW',fc.GW,'Mf',fc.Mf);

    tC(i)   = getEndurance(he,fC,atm,...
              'inducedVelocity',@Glauert, ....
              'forwardFlightApproximation','highSpeed');

end


hgcf   = getCurrentFigureNumber;
figure(hgcf+1)
plot(W,vC)
xlabel('$W$ [N]'); ylabel('$V_C$ [m/s]'); grid on;

figure(hgcf+2)
plot(W,tC)
xlabel('$W$ [N]'); ylabel('$t_C$ [s]'); grid on;

io = 1;

function io   = dispErrorLog(errorValue,tol,nametest,checkname)
if errorValue < tol
   io   = 1;
   disp(strcat(nametest,checkname,' test passed'))
else
   io   = 0;
   disp(strcat(nametest,checkname,' test NOT passed'))
end
