function io = energy02(mode)

% vMaxROC has dissapeared of heroes and energy02 is the enery test that
% uses massively function calls to vMaxROC. vMaxROC is deprecated and to
% compute 
close all

% FIXME: this tolerance is used to validate performance computations
% related to maximum range, maximum endurance and maximum forward
% velocities. This 2.5 m/s of tolerance is too much for a validation test
% but at this time (March 2014) we leave it as it is.
% TODO: investigate why there exist such a difference between velocities.
% First culprit is the default energy options, like induce velocity model
% and high speed assumption, see energy01 to set these options because it
% is likely that setting these options will improve the situation and we
% could decrease the tolerance value

% Define tolerance
TOL   = 2.5;

% Get ISA atmosphere
atm        = getISA;

% Define engine
numEngines = 2;
engine     = Allison250C28C(atm,numEngines);

% Get design requirements
dr         = cesarDR;

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



% Define flight condition
Z           = 1000;
h           = 0;
gammaTdeg   = 0;
gammaT      = deg2rad(gammaTdeg);
disp('energy02: he.W is deprecated. Next versions of heroes will avoid this')
GW          = he.W; % FIXME this should be defined by its own 
disp('energy02: he.Mf is deprecated. Next versions of heroes will avoid this')
Mf          = he.Mf;

fCini       = getFlightCondition(he,...
                                 'V',0,'gammaT',gammaT,...
                                 'H',h,'Z',Z,'GW',GW,'Mf',Mf);



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Speed calculations
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Vmax range
[vB,PB]   = vMaxRange(he,fCini,atm);
disp(['VmaxRange [m/s] = ',    num2str(vB), ' en P =', num2str(PB)]);

fB        = getFlightCondition(he,...
                                 'V',vB,'gammaT',gammaT,...
                                 'H',h,'Z',Z,'GW',GW,'Mf',Mf);


pB      = getP(he,fB,atm);
disp(['VmaxRange getP [m/s] = ',    num2str(vB), ' en P =', num2str(pB)]);

nh       = 31;
hspan    = linspace(0,2000,31);
GWi      = GW*ones(1,nh);
Mfi      = Mf*ones(1,nh);
fChspan  = getFlightCondition(he,'H',hspan,'GW',GWi,'Mf',Mfi);
VB       = vMaxRange(he,fChspan,atm);


figure(1)
plot(hspan,VB,'b-o'); hold on
xlabel('$H$ [m]'); ylabel('$V_{max range}$ [m/s]');
legend({'$V_{max range}$'})

%Vmax endurance
[vC,PC]    = vMaxEndurance(he,fCini,atm);
disp(['VmaxEndurance [m/s] = ',    num2str(vC), ' en P =', num2str(PC)]);



fC        = getFlightCondition(he,...
                                 'V',vC,'gammaT',gammaT,...
                                 'H',h,'Z',Z,'GW',GW,'Mf',Mf);

pC      = getP(he,fC,atm);
disp(['VmaxEndurance getP [m/s] = ',    num2str(vC), ' en P =', num2str(pC)]);

VC     = vMaxEndurance(he,fChspan,atm);

figure(2)
plot(hspan,VC,'b-o');
xlabel('$H$ [m]'); ylabel('$V_{max endurance}$ [m/s]');
legend({'$V_{max endurance}$'})

% Determinar la dependencia de la maxima autonomia con el peso de la
% aeronave t_max = f(W)
plotWeightSensitivity(he,atm,fCini);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Range calculations
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % % % % % % fCalc   = get1flightCondition(vB,gammaT,h,Z);
% % % % % % % s       = getRange(he,fCalc,atm);
s       = getRange(he,fB,atm); %????? this is the same as sB!!!!
disp(['Range [m] = ',    num2str(s)]);%?????

sB      = getRange(he,fB,atm);
sC      = getRange(he,fC,atm);
disp(['Range VmaxRange [m] = ',num2str(sB)]);
disp(['Range VmaxEndurance [m] = ',num2str(sC)]);

figure(3)
hspan = linspace(0,2000,nh);
% % % % % fChalc = get1flightCondition(50,gammaT,hspan,Z);
Vi     = 50*ones(1,nh);
fChalc = getFlightCondition(he,'V',Vi,'H',hspan,'GW',GWi,'Mf',Mfi);
sh = getRange(he,fChalc,atm);
plot(hspan,sh,'b-o');
xlabel('$H$ [m]'); ylabel('Range [m]');
legend({'Range'})

figure(4)
vspan = linspace(0,90,nh);
% % % % % % % % fCvalc = getFlightCondition(vspan,gammaT,0,Z);
fCvalc = getFlightCondition(he,'V',vspan,'GW',GWi,'Mf',Mfi);
sv = getRange(he,fCvalc,atm);
plot(vspan,sv,'b-o'); hold on
xlabel('$V$ [m/s]'); ylabel('Range [m]');
legend({'Range'})

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Endurance calculations
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % % % % % % % fCauton = get1flightCondition(vC,gammaT,h,Z);
% % % % % % % % s = getEndurance(he,fCauton,atm);
t = getEndurance(he,fC,atm); %????? this is the same as tC!!!!
disp(['Endurance [h] = ',    num2str(t/3600)]);

tB      = getEndurance(he,fB,atm);
tC      = getEndurance(he,fC,atm);
disp(['Endurance VmaxRange [h] = ',    num2str(tB/3600)]);
disp(['Endurance VmaxEndurance [h] = ',    num2str(tC/3600)]);

figure(5)
hspan = linspace(0,2000,31);
% % % % % % % % % fChauton = get1flightCondition(vC,gammaT,hspan,Z);
vCi      = vC*ones(1,nh);
fChauton = getFlightCondition(he,'V',vCi,'H',hspan,'GW',GWi,'Mf',Mfi);
sh = getEndurance(he,fChauton,atm);
plot(hspan,sh,'b-o');
xlabel('H [m]'); ylabel('Endurance [s]');
legend({'Endurance'})

figure(6)
vspan = linspace(0,70,31);
% % % % % % % % % % % fCvauton = get1flightCondition(vspan,gammaT,0,Z);
fCvauton = getFlightCondition(he,'V',vspan,'GW',GWi,'Mf',Mfi);
sv = getEndurance(he,fCvauton,atm);
plot(vspan,sv,'b-o'); hold on
xlabel('V [m/s]'); ylabel('Endurance [s]');
legend({'Endurance'})

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Ceiling
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ceiling1  = ceilingHoverEnergy(he,fCini,atm);
fCiniZ    = fCini;
fCiniZ.Z  = 2;
ceiling2  = ceilingHoverEnergy(he,fCiniZ,atm,'igeModel',@kGlefortHamann);
disp(['Ceiling OGE [m] = ',    num2str(ceiling1)]);
disp(['Ceiling IGE [m] = ',    num2str(ceiling2)]);

%Ceilings verifications
[h_Oge,h_Ige]   = techoMano(he,atm,2);
disp(['Ceiling hand OGE [m] = ',    num2str(h_Oge)]);
disp(['Ceiling hand IGE [m] = ',    num2str(h_Ige)]);

%plotKappaSensitivity to ceiling
plotKappaSensitivity(he,fCini,atm);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ROC
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
VH    = 50;
H     = 1000;
fcROC = getFlightCondition(he,...
                          'Vh',VH,'H',H,'GW',GW,...
                          'Mf',Mf);


roc1 = vV4vHpower(he,fcROC,atm);
fcROCZ = getFlightCondition(he,...
                          'Vh',VH,'H',H,'GW',GW,...
                          'Mf',Mf,'Z',2);
roc2 = vV4vHpower(he,fcROCZ,atm);
roc3 = vV4vHpower(he,fcROC,atm,'constrainedEnginePower','no');
roc4 = vV4vHpower(he,fcROC,atm,'excessPower','yes');






% % % % % % % % % % roc1 = vMaxROC(50,1000,Z,he,atm);
% % % % % % % % % % roc2 = vMaxROC(50,1000,2,he,atm);
% % % % % % % % % % roc3 = vMaxROC(50,1000,Z,he,atm,'constrainedEnginePower','no');
% % % % % % % % % % roc4 = vMaxROC(50,1000,Z,he,atm,'excessPower','yes');
disp(['Roc [m/s] (V=50 h=1000m) = ',    num2str(roc1)]);
disp(['Roc [m/s] (V=50 h=1000m Z=2) = ',    num2str(roc2)]);
disp(['Roc [m/s] (V=50 h=1000m unconstrained engine) = ',    num2str(roc3)]);
disp(['Roc [m/s] (V=50 h=1000m exc-pow) = ',    num2str(roc4)]);


nh    = 31;
hi    = linspace(0,7000,nh);
Vhi   = zeros(size(hi));
GWi   = GW*ones(size(hi));
Mfi   = Mf*ones(size(hi));
Zi    = 2*ones(size(hi));

fcROCi = getFlightCondition(he,...
                          'Vh',Vhi,'H',hi,'GW',GWi,...
                          'Mf',Mfi);
fcROCz = getFlightCondition(he,...
                          'Vh',Vhi,'H',hi,'GW',GWi,...
                          'Mf',Mfi,'Z',Zi);

roch1 = vV4vHpower(he,fcROCi,atm);
roch2 = vV4vHpower(he,fcROCz,atm);
roch3 = vV4vHpower(he,fcROCi,atm,'constrainedEnginePower','no');
roch4 = vV4vHpower(he,fcROCi,atm,'excessPower','yes');
roch5 = vV4vHpower(he,fcROCz,atm,'excessPower','yes');

figure(7)
plot(hi,roch1,'r-s'); hold on
plot(hi,roch2,'c-s');
plot(hi,roch3,'b-o');
plot(hi,roch4,'y-+');
plot(hi,roch5,'c-+');
axis([0 7000 0 25])
xlabel('$H$ [m]'); ylabel('$V_{max ROC}$ [m/s]');
legend({'ROC','ROC Z=2','ROC unconstrained engine','ROC exc-pow','ROC exc-pow Z=2'})


nv    = 31;
vj    = linspace(0,70,nv);
Hj    = 1000*ones(size(vj));
GWj   = GW*ones(size(vj));
Mfj   = Mf*ones(size(vj));
Zj    = 2*ones(size(vj));

fcROCj = getFlightCondition(he,...
                          'Vh',vj,'H',Hj,'GW',GWj,...
                          'Mf',Mfj);
fcROCy = getFlightCondition(he,...
                          'Vh',vj,'H',Hj,'GW',GWj,...
                          'Mf',Mfj,'Z',Zj);

rocv1 = vV4vHpower(he,fcROCj,atm);
rocv2 = vV4vHpower(he,fcROCy,atm);
rocv3 = vV4vHpower(he,fcROCj,atm,'constrainedEnginePower','no');
rocv4 = vV4vHpower(he,fcROCj,atm,'excessPower','yes');
rocv5 = vV4vHpower(he,fcROCy,atm,'excessPower','yes');


figure(8)
% % % % % % % % % % % vspan = linspace(0,70,31);
% % % % % % % % % % % rocv1 = vMaxROC(vspan,1000,Z,he,atm);
% % % % % % % % % % % rocv2 = vMaxROC(vspan,1000,2,he,atm);
% % % % % % % % % % % rocv3 = vMaxROC(vspan,1000,Z,he,atm,'constrainedEnginePower','no');
% % % % % % % % % % % rocv4 = vMaxROC(vspan,1000,Z,he,atm,'excessPower','yes');
% % % % % % % % % % % rocv5 = vMaxROC(vspan,1000,2,he,atm,'excessPower','yes');
plot(vspan,rocv1,'r-s'); hold on
plot(vspan,rocv2,'c-s');
plot(vspan,rocv3,'b-o');
plot(vspan,rocv4,'y-+');
plot(vspan,rocv5,'c-+');
xlabel('V [m/s]'); ylabel('$V_{max ROC}$ [m/s]');
legend({'ROC','ROC Z=2','ROC unconstrained engine','ROC exc-pow','ROC exc-pow Z=2'})

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% MaxROC
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fcROC1 = getFlightCondition(he,...
                          'Vh',NaN,'H',1000,'GW',GW,...
                          'Mf',Mf);
vh1    = vH4maxVv(he,fcROC1,atm);

fcROCa = getFlightCondition(he,...
                          'Vh',vh1,'H',H,'GW',GW,...
                          'Mf',Mf);
rocmax1 = vV4vHpower(he,fcROCa,atm);

roca    = vV4vHpower(he,fcROCj,atm);

figure(9)
plot(vh1,rocmax1,'k s'); hold on
plot(vspan,roca,'k-');

disp(['Max Roc [m/s] 1000m = ',    num2str(rocmax1)]);

fcROC2 = getFlightCondition(he,...
                          'Vh',NaN,'H',2000,'GW',GW,...
                          'Mf',Mf);
vh2    = vH4maxVv(he,fcROC2,atm);

% vh2 = vMaxMaxROC(2000,Z,he,atm);
fcROCb = getFlightCondition(he,...
                          'Vh',vh2,'H',2000,'GW',GW,...
                          'Mf',Mf);
rocmax2 = vV4vHpower(he,fcROCb,atm);
fcROCk  = fcROCj;
fcROCk.H = 2000*ones(size(vj));
% rocmax2 = vMaxROC(vh2,2000,Z,he,atm);
% rocb = vMaxROC(vspan,2000,Z,he,atm);
rocb    = vV4vHpower(he,fcROCk,atm);
plot(vh2,rocmax2,'g s')
plot(vspan,rocb,'g-')
disp(['Max Roc [m/s] 2000m = ',    num2str(rocmax2)]);


vh1    = vH4maxVv(he,fcROC1,atm,'excessPower','yes');

% vh1 = vMaxMaxROC(1000,Z,he,atm,'excessPower','yes');
fcROCa = getFlightCondition(he,...
                          'Vh',vh1,'H',H,'GW',GW,...
                          'Mf',Mf);
rocmax1 = vV4vHpower(he,fcROCa,atm,'excessPower','yes');
roca    = vV4vHpower(he,fcROCj,atm,'excessPower','yes');
% rocmax1 = vMaxROC(vh1,1000,Z,he,atm,'excessPower','yes');
% roca = vMaxROC(vspan,1000,Z,he,atm,'excessPower','yes');
plot(vh1,rocmax1,'k s'); hold on
plot(vspan,roca,'k--');
disp(['Max Roc [m/s] 1000m exc-pow = ',    num2str(rocmax1)]);

vh2    = vH4maxVv(he,fcROC2,atm,'excessPower','yes');
fcROCb = getFlightCondition(he,...
                          'Vh',vh2,'H',H,'GW',GW,...
                          'Mf',Mf);
rocmax2 = vV4vHpower(he,fcROCb,atm,'excessPower','yes');


H2j     = 2000*ones(size(vj));
fcROCj2 = getFlightCondition(he,...
                          'Vh',vj,'H',H2j,'GW',GWj,...
                          'Mf',Mfj);
rocb    = vV4vHpower(he,fcROCj2,atm,'excessPower','yes');

% % % % vh2 = vMaxMaxROC(2000,Z,he,atm,'excessPower','yes');
% % % % rocmax2 = vMaxROC(vh2,2000,Z,he,atm,'excessPower','yes');
% % % % rocb = vMaxROC(vspan,2000,Z,he,atm,'excessPower','yes');

plot(vh2,rocmax2,'g s')
plot(vspan,rocb,'g--')
disp(['Max Roc [m/s] 2000m exc-pow = ',    num2str(rocmax2)]);

xlabel('V [m/s]'); ylabel('$V_{max ROC}$ [m/s]');
legend({'MAXROC 1000m','ROC 1000m','MAXROC 2000m','ROC 2000m',...
    'MAXROC 1000m excpow','ROC 1000m excpow','MAXROC 2000m excpow','ROC 2000m excpow'})


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Determine max vel in cruise h=0

fC  = getFlightCondition(he);
% % % % % vA = vGivenPower(he,fC,atm,'powerEngineMap','fPmt');
vA = vGivenPower(he,fC,atm);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Avaible power pots 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure(10)
Hspan = linspace(0,3000,31);
fmt   = he.transmission.fPmt(Hspan);
fmc   = he.engine.fPmc(Hspan);
fde   = he.engine.fPde(Hspan);
fmu   = he.engine.fPmu(Hspan);
plot(Hspan,fmt,'r-'); hold on;
plot(Hspan,fmc,'b--'); 
plot(Hspan,fde,'m-.'); 
plot(Hspan,fmu,'k-o'); 
xlabel('H [m]'); ylabel('P [W]');
legend({'$P_{mt}$','$P_{mc}$','$P_{desp}$','$P_{mu}$'})


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Autorrotation
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fCat    = getFlightCondition(he,'P',0,'H',h,'Z',Z,'GW',GW,'Mf',Mf);
gTmV    = gammaTminV(he,fCat,atm);
gTmVv   = gammaTminVv(he,fCat,atm);
gTmgT   = gammaTminGammaT(he,fCat,atm);
disp(['gammaTminV = ',    num2str(rad2deg(gTmV))]);
disp(['gammaTminVv = ',    num2str(rad2deg(gTmVv))]);
disp(['gammaTminGammaT = ',    num2str(rad2deg(gTmgT))]);

% plotAutorrotationDiagram(1,he,fC,atm);

     
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Comparing speeds
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[vR,vE,vM] = vMaxMano(he,atm,GW);


if ((abs(vM-vA) > TOL)&&(abs(vR-vB) > TOL)&&(abs(vE-vC) > TOL))
    io    = 0;
else
    io    = 1;
end




function io = plotKappaSensitivity(he,fCini,atm)

nk     = 31;
h      = zeros(1,nk);
kappa  = linspace(1.0,1.30,nk);
he1    = he;

for i=1:nk
    he1.mainRotor.kappa = kappa(i);
    h(i)                = ceilingHoverEnergy(he1,fCini,atm);
end

figure(11)
plot(kappa,h); hold on;
fk   = @(x) interp1(kappa,h,x);
dfk1 = derivest(fk,he.mainRotor.kappa);
h0   = fk(he.mainRotor.kappa);
hh   = h0 + dfk1.*(kappa-he.mainRotor.kappa);
plot(kappa,hh,'r-.')
xlabel('$\kappa$ [-]'); ylabel('$H_{OGE}$ [m]'); 
legend({'$H_{OGE}(H)$',strcat('$d H_{OGE}/(d\kappa)$ = ',num2str(dfk1,'%6.0f'),'(en $\kappa$ = 1.15)')},0)


io = 1;


function [h_Oge,h_Ige]   = techoMano(he,atm,Z)

rho0  = atm.rho0;
ndHe  = he2ndHe(he);
R     = he.mainRotor.R;
area  = pi*R^2;
z     = Z/R;
kG    = kGlefortHamann(z,NaN);
kappa = he.mainRotor.kappa;
OR    = he.mainRotor.Omega*he.mainRotor.R;
etaM  = 1.2;
disp('energy02: he.W is deprecated. Next versions of heroes will avoid this')
Pi0_ige = he.W*sqrt(he.W/(2*rho0*area))*kappa*kG;
disp('energy02: he.W is deprecated. Next versions of heroes will avoid this')
Pi0_oge = he.W*sqrt(he.W/(2*rho0*area))*kappa;
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

vio   = sqrt(he.W/(2*rho0*area));
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


function io = plotWeightSensitivity(he,atm,fCini)

nw    = 31;
W0    = he.W;
disp('energy02: he.W is deprecated. Next versions of heroes will avoid this')
W       = W0*linspace(0.8,1.2,nw);
Mf      = fCini.Mf*ones(1,nw);

fC      = getFlightCondition(he,'GW',W,'Mf',Mf);
vC      = vMaxEndurance(he,fC,atm);
fC.V    = vC;
tC      = getEndurance(he,fC,atm);

% he1   = he;
% vC    = zeros(nw,1);
% tC    = zeros(nw,1);
% % % % % % fC    = getFlightCondition(he,'V',vC(1),'H',h);
% % % % % % % % % % for i=1:nw
% % % % % % % % % %     he1.W   = W(i);
% % % % % % % % % %     vC(i)   = vMaxEndurance(he1,fC,atm);
% % % % % % % % % %     fC      = get1cruise(vC(i),h);
% % % % % % % % % %     tC(i)   = getEndurance(he1,fC,atm);
% % % % % % % % % % 
% % % % % % % % % % end



figure(12)
plot(W,vC)
xlabel('$W$ [N]'); ylabel('$V_C$ [m/s]'); grid on;

figure(13)
plot(W,tC)
xlabel('$W$ [N]'); ylabel('$t_C$ [s]'); grid on;



io = 1;
