%% Reproducing Padfield's classical helicopter Trim and Stabillity results
% This demo shows how to use trim and stability functions to obtain
% the classical results of Padfield presented in [1]
%
%
%

atm           = getISA;
Lynx          = rigidLynx(atm);
Bo105         = PadfieldBo105(atm);
Puma          = rigidPuma(atm);
he_i          = {Lynx,Bo105,Puma};
options       = setHeroesRigidOptions;


hsl           = 0;
rho           = atm.density(hsl);
ndHe_i        = rigidHe2ndHe(he_i,atm,hsl);



muWT          = [0; 0; 0];
kn2ms         = 0.514444;
vmax          = 160*kn2ms;
nv            = 31;
v_i           = linspace(0.0001,vmax,nv);
VORLynx       = v_i./(he_i{1}.mainRotor.R*he_i{1}.mainRotor.Omega);
VORBo105      = v_i./(he_i{2}.mainRotor.R*he_i{2}.mainRotor.Omega);
VORPuma       = v_i./(he_i{3}.mainRotor.R*he_i{3}.mainRotor.Omega);
fcLynx        = {'VOR',VORLynx,...
                 'betaf0',0,...
                 'wTOR',0,...
                 'cs',0,...
                 'vTOR',0};
fcBo105       = {'VOR',VORBo105,...
                 'betaf0',0,...
                 'wTOR',0,...
                 'cs',0,...
                 'vTOR',0};

fcPuma        = {'VOR',VORPuma,...
                 'betaf0',0,...
                 'wTOR',0,...
                 'cs',0,...
                 'vTOR',0};

FC            = {fcLynx,fcBo105,fcPuma};
ndts          = cell(3,1);
ndSs          = cell(3,1);
Ss            = cell(3,1);

for i = 1:3
    ndts{i}        = getNdHeTrimState(ndHe_i{i},muWT,FC{i},options);
    ndSs{i}        = getndHeLinearStabilityState(ndts{i},muWT,ndHe_i{i},options);
    Ss{i}          = ndHeSs2HeSs(ndSs{i},he_i{i},atm,hsl,options);
end


fldsi  = {'s1','s2','s3','s4','s5','s6','s7','s8','s9'};


% Figure 4.23(a) root locus of coupled Lynx
ssLynx_a      = Ss{1}.eigenSolution.eigenValTr;
ssLynx_a.V    = v_i;

axds          = getaxds({'V'},{'V [m/s]'},1);
plotStabilityEigenvalues(ssLynx_a,axds,[],...
                         'rootLociLabsFmt','ini2end');

% Figure 4.23(b) root locus of coupled Lynx
a=struct2cell(Ss{1}.eigenSolution.eigenValLOtr);
b=struct2cell(Ss{1}.eigenSolution.eigenValLAtr);
c={a{:},b{:}};
ssLynx_b     = cell2struct(c,fldsi,2);
ssLynx_b.V   = v_i;
plotStabilityEigenvalues(ssLynx_b,axds,[],...
                         'rootLociLabsFmt','ini2end');


% Figure 4.24(a) root locus of coupled Bo105
ssBo105_a     = Ss{2}.eigenSolution.eigenValTr;
ssBo105_a.V   = v_i;

plotStabilityEigenvalues(ssBo105_a,axds,[],...
                         'rootLociLabsFmt','ini2end');

% Figure 4.24(b) root locus of coupled Lynx
a=struct2cell(Ss{2}.eigenSolution.eigenValLOtr);
b=struct2cell(Ss{2}.eigenSolution.eigenValLAtr);
c={a{:},b{:}};
ssBo105_b     = cell2struct(c,fldsi,2);
ssBo105_b.V   = v_i;
plotStabilityEigenvalues(ssBo105_b,axds,[],...
                         'rootLociLabsFmt','ini2end');

% Figure 4.25(a) root locus of coupled Puma
ssPuma_a     = Ss{3}.eigenSolution.eigenValTr;
ssPuma_a.V   = v_i;

plotStabilityEigenvalues(ssPuma_a,axds,[],...
                         'rootLociLabsFmt','ini2end');


% Figure 4.25(b) root locus of coupled Puma
a=struct2cell(Ss{3}.eigenSolution.eigenValLOtr);
b=struct2cell(Ss{3}.eigenSolution.eigenValLAtr);
c={a{:},b{:}};
ssPuma_b     = cell2struct(c,fldsi,2);
ssPuma_b.V   = v_i;
plotStabilityEigenvalues(ssPuma_b,axds,[],...
                         'rootLociLabsFmt','ini2end');
%%
% As a final example, we are going to reproduce Figure 4.24(a), page 237,
% of reference [2]. In this figure the following modes are represented:
%
% * Phugoid which corresponds to the heroes mode 1
% * Dutch roll which corresponds to the heroes mode 3
% * Spiral subsidence which corresponds to the computed heroes mode 5
% * Heave subsidence which corresponds to the computed heroes mode 6
%

ssMap         = Ss.eigenSolution.eigenValTr;
ssMap.V       = V;
plotStabilityEigenvalues(ssMap,axds,[],...
                         'rootLociLabsFmt','ini2end');


modeleg = {'Phugoid','Dutch roll','Spiral subsidence','Heave subsidence'};
figure(100)
plot(real(ssMap.s1),imag(ssMap.s1),'b-s'); hold on;
plot(real(ssMap.s3),imag(ssMap.s3),'m-d'); hold on;
plot(real(ssMap.s5),imag(ssMap.s5),'g-^'); hold on;
plot(real(ssMap.s6),imag(ssMap.s6),'b-<'); hold on;
grid on
xlabel('Re (s_i) [1/s]')
ylabel('Im (s_i) [1/s]')
legend(modeleg,'Location','Best')
axis([-1.0 0 0 1])



% [2] G.D. Padfield. Helicopter Flight Dynamics. Blackwell Science, 1996.
